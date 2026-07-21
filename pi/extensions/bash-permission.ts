import {
  isToolCallEventType,
  type ExtensionAPI,
} from "@earendil-works/pi-coding-agent";

/**
 * Require explicit user permission before the agent runs a *blocked* Bash command.
 *
 * Model: default-ALLOW with a blocklist. Every `bash` command runs freely EXCEPT
 * the ones named below, which pause and show the command. The user can:
 *   - Allow it once
 *   - Allow it and remember the exact command for the rest of the session
 *   - Deny it (the tool call is blocked and the reason is returned to the model)
 *
 * In non-interactive modes (print/json, no UI) a blocked command is denied by
 * default, since there is no one to grant permission.
 *
 * NOTE: this is a convenience guardrail, not a sandbox. It matches on the first
 * word (and, for some tools, the subcommand) of each segment and is bypassable
 * (e.g. `bash -c "rm ..."`, xargs, aliases, obfuscated substitution).
 */
// Commands that always prompt, regardless of arguments.
const BLOCKED_COMMANDS = new Set([
  "rm", "rmdir",
  "dd", "shutdown", "reboot", "halt", "poweroff",
]);

// mkfs, mkfs.ext4, mkfs.xfs, … — matched by prefix.
const BLOCKED_COMMAND_PREFIXES = ["mkfs"];

// Tools whose danger depends on the subcommand: prompt only for these.
const BLOCKED_SUBCOMMANDS: Record<string, Set<string>> = {
  git: new Set(["push"]),
  terraform: new Set(["apply", "destroy"]),
  terragrunt: new Set(["apply", "destroy", "run-all"]),
  kubectl: new Set([
    "delete", "apply", "edit", "patch", "replace",
    "scale", "drain", "cordon", "uncordon",
  ]),
};

// psql is used constantly for bounded, read-only SELECTs, so we prompt only when
// the invocation looks like it writes/mutates. Word boundaries keep identifiers
// like `updated_at`, `created_at`, `deleted` from false-triggering.
const PSQL_WRITE_RE =
  /\b(insert|update|delete|drop|truncate|alter|create|grant|revoke|reindex|vacuum|cluster|refresh|copy)\b/i;

function isSegmentBlocked(segment: string): boolean {
  const trimmed = segment.trim();
  if (!trimmed) return false;

  // Skip leading `VAR=value` environment assignments.
  const tokens = trimmed.split(/\s+/);
  let i = 0;
  while (i < tokens.length && /^[A-Za-z_][A-Za-z0-9_]*=/.test(tokens[i])) i++;
  if (i >= tokens.length) return false; // only assignments, no command

  const cmd = tokens[i];

  if (BLOCKED_COMMANDS.has(cmd)) return true;
  if (BLOCKED_COMMAND_PREFIXES.some((p) => cmd === p || cmd.startsWith(p + "."))) {
    return true;
  }

  // heroku uses colon-namespaced subcommands (e.g. `heroku pg:reset`).
  if (cmd === "heroku") {
    const sub = tokens[i + 1] ?? "";
    return sub === "pg" || sub.startsWith("pg:");
  }

  // psql: prompt only when the SQL looks like a write/DDL/maintenance statement.
  if (cmd === "psql") {
    return PSQL_WRITE_RE.test(trimmed);
  }

  const subs = BLOCKED_SUBCOMMANDS[cmd];
  if (subs) {
    const sub = tokens[i + 1];
    return !!sub && subs.has(sub);
  }

  return false;
}

function isBlockedCommand(command: string): boolean {
  if (!command.trim()) return false;

  // Split on shell operators AND substitutions so a blocked command hidden in a
  // pipeline or `$(...)`/`(...)` is still caught.
  const segments = command.split(/\||;|&&|\|\||\n|&|\$\(|`|<\(|>\(|\(|\)/);
  return segments.some(isSegmentBlocked);
}

export default function (pi: ExtensionAPI) {
  // Commands the user chose to "always allow" during this session.
  const alwaysAllow = new Set<string>();

  // Master switch. Set false to wave every bash command through this session.
  // Toggle at runtime with /bashgate on|off|status. Start disabled by setting
  // PI_BASH_GATE=off in the environment.
  let enabled = !/^(off|0|false|no)$/i.test(process.env.PI_BASH_GATE ?? "");

  pi.registerCommand("bashgate", {
    description: "Toggle the bash permission gate (on | off | status)",
    getArgumentCompletions: (prefix) =>
      ["on", "off", "status"]
        .filter((s) => s.startsWith(prefix))
        .map((s) => ({ value: s, label: s })),
    handler: async (args, ctx) => {
      const arg = args.trim().toLowerCase();
      if (arg === "on") enabled = true;
      else if (arg === "off") enabled = false;
      else if (arg === "" ) enabled = !enabled; // bare /bashgate flips it
      else if (arg !== "status") {
        ctx.ui.notify("Usage: /bashgate on | off | status", "warning");
        return;
      }
      ctx.ui.notify(
        `Bash permission gate is now ${enabled ? "ON (commands require approval)" : "OFF (commands run freely)"}`,
        enabled ? "info" : "warning",
      );
    },
  });

  pi.on("tool_call", async (event, ctx) => {
    if (!isToolCallEventType("bash", event)) return;

    // Gate disabled for this session: let everything through.
    if (!enabled) return;

    const command = event.input.command ?? "";

    // Default-allow: only blocked commands need approval.
    if (!isBlockedCommand(command)) return;

    // Already approved for the whole session.
    if (alwaysAllow.has(command)) return;

    // No UI available (print/json mode): fail closed on blocked commands.
    if (!ctx.hasUI) {
      return {
        block: true,
        reason:
          "Bash command blocked: this command is on the block list and requires user permission, but no interactive UI is available.",
      };
    }

    const preview =
      command.length > 500 ? command.slice(0, 500) + "\n… (truncated)" : command;

    const choice = await ctx.ui.select(
      `Allow this Bash command?\n\n${preview}`,
      ["Allow once", "Always allow this command", "Deny"],
    );

    if (choice === "Always allow this command") {
      alwaysAllow.add(command);
      return;
    }

    if (choice === "Allow once") {
      return;
    }

    return {
      block: true,
      reason: "Bash command denied by user.",
    };
  });

  pi.on("session_start", (_event, ctx) => {
    ctx.ui.notify(
      `Bash permission gate ${enabled ? "active" : "disabled (PI_BASH_GATE=off)"} — /bashgate to toggle`,
      enabled ? "info" : "warning",
    );
  });
}

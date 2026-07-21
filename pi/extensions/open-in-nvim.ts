/**
 * open-in-nvim
 *
 * Jump from pi straight into your existing nvim, in tmux, at the right line.
 *
 * Usage:
 *   /nv                     Open the last file pi read/edited/wrote
 *   /nv path/to/file        Open a specific file
 *   /nv path/to/file:42     Open at line 42
 *   /nv path/to/file:42:8   Open at line 42, column 8
 *
 * Behavior:
 *   - If an nvim/vim pane already exists in the current tmux window, the file
 *     is opened there (:edit) and that pane is focused. No new panes pile up.
 *   - If no editor pane exists, a new tmux split is created running nvim.
 *   - Outside tmux it just tells you it needs tmux (nothing destructive).
 *
 * Config (env vars, all optional):
 *   OPEN_IN_NVIM_EDITOR     editor command for new panes   (default: nvim)
 *   OPEN_IN_NVIM_PANE_CMDS  comma list of pane commands to treat as an editor
 *                           (default: nvim,vim,view,vi)
 *   OPEN_IN_NVIM_SIZE       tmux split size for new panes  (default: 40%)
 *   OPEN_IN_NVIM_DIRECTION  h | v for new panes            (default: h)
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { execFile } from "node:child_process";
import { promisify } from "node:util";
import { resolve, isAbsolute } from "node:path";

const exec = promisify(execFile);

const FILE_TOOLS = new Set(["read", "edit", "write"]);

function cfg(name: string, fallback: string): string {
	const v = process.env[name];
	return v && v.trim() ? v.trim() : fallback;
}

async function tmux(args: string[]): Promise<string> {
	const { stdout } = await exec("tmux", args);
	return stdout;
}

/** Parse "path", "path:line", "path:line:col". Keeps Windows-ish drive colons safe-ish. */
function parseTarget(input: string): { path: string; line?: number; col?: number } {
	const m = input.match(/^(.*?)(?::(\d+))?(?::(\d+))?$/);
	if (!m) return { path: input };
	const path = m[1] || input;
	const line = m[2] ? Number(m[2]) : undefined;
	const col = m[3] ? Number(m[3]) : undefined;
	return { path, line, col };
}

/** Find an editor pane in the current tmux window, excluding pi's own pane. */
async function findEditorPane(editorCmds: Set<string>, selfPane: string | undefined): Promise<string | undefined> {
	const out = await tmux(["list-panes", "-F", "#{pane_id} #{pane_current_command}"]);
	for (const raw of out.split("\n")) {
		const line = raw.trim();
		if (!line) continue;
		const sp = line.indexOf(" ");
		const id = sp === -1 ? line : line.slice(0, sp);
		const cmd = sp === -1 ? "" : line.slice(sp + 1).trim();
		if (id === selfPane) continue;
		if (editorCmds.has(cmd)) return id;
	}
	return undefined;
}

export default function openInNvim(pi: ExtensionAPI) {
	// Remember the last file pi touched, so `/nv` with no args "just works".
	let lastFile: string | undefined;

	pi.on("tool_call", async (event) => {
		if (!FILE_TOOLS.has(event.toolName)) return;
		const p = (event.input as { path?: unknown })?.path;
		if (typeof p === "string" && p.trim()) lastFile = p.trim();
	});

	pi.registerCommand("nv", {
		description: "Open a file in nvim (tmux). No arg = last file pi touched. Supports path:line:col",
		handler: async (args, ctx) => {
			if (!process.env.TMUX) {
				ctx.ui.notify("open-in-nvim needs to run inside tmux.", "warning");
				return;
			}

			const arg = args.trim();
			let target = arg ? parseTarget(arg) : { path: lastFile ?? "", line: undefined, col: undefined };

			if (!target.path) {
				ctx.ui.notify("No file given and pi hasn't touched a file yet. Try: /nv path/to/file", "warning");
				return;
			}

			const absPath = isAbsolute(target.path) ? target.path : resolve(ctx.cwd, target.path);

			const editorCmds = new Set(
				cfg("OPEN_IN_NVIM_PANE_CMDS", "nvim,vim,view,vi")
					.split(",")
					.map((s) => s.trim())
					.filter(Boolean),
			);
			const selfPane = process.env.TMUX_PANE;

			try {
				let pane = await findEditorPane(editorCmds, selfPane);

				if (!pane) {
					// No editor open: spawn one in a fresh split.
					const editor = cfg("OPEN_IN_NVIM_EDITOR", "nvim");
					const dir = cfg("OPEN_IN_NVIM_DIRECTION", "h").toLowerCase();
					const splitFlag = dir.startsWith("v") ? "-v" : "-h";
					const size = cfg("OPEN_IN_NVIM_SIZE", "40%");
					const openArg = target.line ? `+${target.line}` : "";
					const cmd = openArg
						? `${editor} ${openArg} ${shellQuote(absPath)}`
						: `${editor} ${shellQuote(absPath)}`;
					pane = (
						await tmux(["split-window", splitFlag, "-l", size, "-P", "-F", "#{pane_id}", cmd])
					).trim();
					if (target.col && target.line) {
						// Best-effort column placement once nvim is up.
						await sendToNvim(pane, `:call cursor(${target.line}, ${target.col})`);
					}
					ctx.ui.notify(`Opened ${target.path}${target.line ? `:${target.line}` : ""} in new ${editor} pane`, "info");
					return;
				}

				// Reuse the existing editor pane.
				await sendEsc(pane);
				const cursor =
					target.line && target.col
						? ` | call cursor(${target.line}, ${target.col})`
						: target.line
							? ` | ${target.line}`
							: "";
				await sendToNvim(pane, `:edit ${shellQuote(absPath)}${cursor}`);
				await tmux(["select-pane", "-t", pane]);
				ctx.ui.notify(
					`Opened ${target.path}${target.line ? `:${target.line}${target.col ? `:${target.col}` : ""}` : ""} in nvim`,
					"info",
				);
			} catch (err) {
				ctx.ui.notify(`open-in-nvim failed: ${err instanceof Error ? err.message : String(err)}`, "error");
			}
		},
	});
}

/** Single-quote a path for a shell command line passed to tmux split-window. */
function shellQuote(p: string): string {
	return `'${p.replace(/'/g, `'\\''`)}'`;
}

/** Send Escape to a pane so we leave insert mode before issuing an ex command. */
async function sendEsc(pane: string): Promise<void> {
	await tmux(["send-keys", "-t", pane, "Escape"]);
}

/** Send a literal ex command line followed by Enter to an nvim pane. */
async function sendToNvim(pane: string, exLine: string): Promise<void> {
	await tmux(["send-keys", "-t", pane, "-l", exLine]);
	await tmux(["send-keys", "-t", pane, "Enter"]);
}

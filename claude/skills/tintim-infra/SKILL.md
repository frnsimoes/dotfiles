---
description: Load Tintim infrastructure context (state files + recent worklog) and configure auto-append to WORKLOG plus propose-then-ask on state changes. TRIGGER when user mentions tintim, k3s, WAHA, gateway, loki, observability, hetzner, cpx41/cpx31, fan-out, or asks for review/decision on Tintim infra; user references `~/workspace/work/tintim-*` repos. SKIP when conversation is about Tintim application code without touching infra/deploy; user only wants a quick shell command without historical context.
---

## Current state files

State lives in `/Users/fernandosimoes/workspace/work/tintim-infrastructure-agents/`.

!`ls -1 /Users/fernandosimoes/workspace/work/tintim-infrastructure-agents/ 2>/dev/null || echo "(empty)"`

Read every file listed above with the Read tool before answering. These represent the current state of Tintim infrastructure — the source of truth for "how things are today".

## Recent worklog (last 30 lines)

Worklog lives at `/Users/fernandosimoes/workspace/work/tintim-docs/WORKLOG.md`.

!`tail -30 /Users/fernandosimoes/workspace/work/tintim-docs/WORKLOG.md 2>/dev/null || echo "(empty)"`

## Behavior for this conversation

**WORKLOG.md — auto-append, no permission needed.**
At the end of any meaningful Tintim discussion (a decision, a discovery, a change in understanding), append one line at the top of the entries section in this format:

```
YYYY-MM-DD — <terse statement of what was decided/discovered>
```

Rules:
- One line. No tables. No multi-sentence prose.
- The user is human, has limited time, is lazy. Optimize for quick re-reading.
- Write in Portuguese unless the conversation was in English.
- If nothing meaningful happened, do not append.

**Tintim infrastructure files — propose, then ask.**
When discussion implies a change to current infra state (e.g. "we removed the fan-out", "loki-0 is now on cpx41"), do NOT silently edit. Instead:
1. Identify which file(s) in `tintim-infrastructure-agents/` should change (or which should be created).
2. Show a concrete diff or the new content.
3. Ask the user explicitly: "Aplico essa mudança em `<file>`?"
4. Only edit after explicit yes.

**Cross-repo reading.**
Tintim spans multiple repos under `~/workspace/work/` (`tintim-k3s-fleet`, `tintim-waha`, `tintim-gateway`, `tintim-infrastructure`, etc.). When you need to verify something against actual code, read absolute paths or remind the user they can pass `--add-dir` next time.

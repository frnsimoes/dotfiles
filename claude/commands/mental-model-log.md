---
description: Append a Q&A log of the current session's discussion to the end of a mental-model file in ~/workspace/writing/mental-models/.
argument-hint: [<slug-or-filename>]
---

Append a Q&A log section to a mental-model file based on the questions the user asked and the answers given **in the current conversation**.

## Target file selection

1. If `$ARGUMENTS` is non-empty, treat it as the slug or filename inside `/Users/fernandosimoes/workspace/writing/mental-models/`. Resolve to a full path. If the file does not exist, stop and report.
2. Otherwise, infer from the current session:
   - Look at which file in `/Users/fernandosimoes/workspace/writing/mental-models/` was created, read, or edited during this conversation.
   - If exactly one candidate: use it.
   - If multiple candidates: list them and ask the user to pick one. Do not guess.
   - If none: ask the user for the slug.

## Q&A extraction

Walk the conversation. Pull out only the **substantive** questions the user asked about the topic of the file — definitional, mechanistic, or "what happens if" questions. Skip:

- Procedural questions ("which slug?", "where is the file?").
- Style/format negotiation ("can you make this shorter?").
- Anything not a question about the technical topic.

For each kept question:
- **Question line**: rewrite the user's question in clean, single-sentence English. Preserve technical terms verbatim.
- **Answer**: distill the answer given in the conversation to **at most 3 lines**. Mechanism over context. Keep `file.c:line` citations if they are load-bearing.

If a question was asked but no clear answer was given (open thread), include it with `Open.` as the answer.

## Confirmation step

Before writing, show the user the extracted Q&A list inline. Ask: "Append these to `<path>`?" Wait for explicit yes. If the user edits the list (adds, drops, rewrites), incorporate and re-confirm.

## Writing the log

Date: use today's date in `YYYY-MM-DD` (the `currentDate` from session context).

Open the target file. Look for an existing `## Questions <today>` section.

- **Exists**: append the new Q&A blocks under it, separated from prior entries by a blank line.
- **Does not exist**: append a new section at the end of the file. Format:

```
## Questions YYYY-MM-DD

<question 1 verbatim>?
<≤ 3 lines of answer>

<question 2 verbatim>?
<≤ 3 lines of answer>
```

Rules:
- Plain question, plain answer. No bold, no bullets, no metaphor. Monocromático.
- Blank line between Q&A blocks.
- One trailing newline at end of file.
- Do not modify any content above the section.

## Final step

Confirm with one line: `appended <N> question(s) to <full path>`. Stop.

---
description: Capture a high-level discussion (design, architecture, performance) as a tintim-docs entry. Inline 5-step pipeline. Optional argument restricts scope to a single topic when the conversation covered multiple. Step 3 is interactive (asks the user to fill gaps). Step 4 spawns a subagent for unbiased refactoring. Step 5 invokes the `tintim-doc-save` script for atomic file + INDEX + WORKLOG write.
---

## Why this doc exists

The output is read **months later** by a human (the user, or a future collaborator) to:

- Reconstruct *why* a decision was made, not just *what* was decided.
- Use past data and rationale as the foundation for future decisions.
- Verify whether the rationale still holds when context shifts.
- Avoid re-litigating settled tradeoffs by remembering which alternatives were considered and why each was rejected.

The reader cannot re-derive the conversation. Whatever isn't in the doc is lost. Everything needed to act on the past must be inside it.

This frame governs every step below and must be passed verbatim to the subagent in step 4.

## Two supreme objectives — apply at every step

1. **Data**: the user works from data, never from guesses. Every claim must be grounded in something verifiable (file, command output, measurement, citation). When in doubt, mark `(unsupported)` and surface it. Do not invent.
2. **Decisions**: the description of decisions is the supreme value of this output. Decisions and their rationale must NEVER be sacrificed for brevity, simplicity, or scannability. If brevity conflicts with a complete decision record, brevity loses.

The scannable part of the doc must be terse — but the rationale section is unbounded and exists precisely to preserve full decision context for posterior consultation.

---

Run all five steps in order. Do NOT skip steps. The only step that pauses for user input is step 3.

## Step 1 — draft

**Scope check:** if `$ARGUMENTS` is non-empty, the user is restricting the log to a specific topic from the conversation. Draft ONLY that topic. Ignore unrelated discussions from the same session — even if they were substantial.

If unsure whether something falls inside the scope, ask the user once at the start of step 1 ("o que entra: X, Y? ou só X?") and proceed with their answer. If `$ARGUMENTS` is empty, capture the whole conversation as before.

Write a markdown draft of the conversation we just had (filtered by scope, if any). Be thorough — capture more than you think necessary. Cover:

- **Topic / problem** that triggered the discussion
- **Options considered** — every alternative discussed, even rejected ones. For each option that received more than one turn of detailed argumentation, preserve:
  - Technical workarounds explored (sub-variants, mechanisms)
  - Failure modes considered
  - Specific tradeoff that drove rejection (precise mechanism, not label)
- **Decision(s)** made (or "nenhuma" if exploratory)
- **Open questions**
- **Action items** mentioned

Portuguese unless the conversation was in English. Output the draft inline. No file write.

## Step 2 — anchor data

Take the draft from step 1. For every factual claim that supports a decision, attach a source: file path, command output, measurement, incident, commit. Verify via Read or Bash if you can. Mark unverifiable claims `(unsupported)`. Do NOT cite from memory of prior conversations — only what's in this conversation or what you can verify now.

Output the grounded draft inline.

## Step 3 — gaps and questions (interactive — pause for user)

Review the draft from step 2 against the two supreme objectives (data + decisions). Identify everything that is incomplete, ambiguous, or implicit. **Do NOT assume. Do NOT presuppose. Do NOT fill gaps from your own inference.**

Surface ALL of the following exhaustively:

- Decisions stated without explicit rationale.
- Decisions where the alternative-considered list is shallow or missing.
- Claims marked `(unsupported)` — ask the user for the source if they have one.
- Numbers, paths, names that were referenced vaguely ("the cluster", "the script") and need disambiguation.
- Tradeoffs mentioned in passing but never spelled out.
- Action items without owner / deadline / scope.
- Anything you, as Claude, would have inferred but should not.

Format the questions as a numbered list. Then **stop and wait for the user**. The user will pick which questions to answer and which to skip. The user is in control of what gets clarified — your job is to surface, not to decide.

When the user replies, integrate their answers into the draft (silently update step 2's grounded draft). If they explicitly skip a question, leave the corresponding gap as-is and add `(user pulou)` next to it.

Only proceed to step 4 after the user signals they're done answering (or they tell you to proceed).

## Step 4 — refactor (subagent)

Spawn a subagent via the `Agent` tool (subagent_type: "general-purpose"). The subagent receives no conversation history — that's intentional. Fresh eyes, no anchoring.

Subagent prompt template:

> You are receiving a markdown draft. Refactor it for a reader who is autistic and works exclusively from data and explicit decision records.
>
> **Why this doc exists**: it will be read months later by the human (or a future collaborator) to reconstruct *why* a decision was made, to base future decisions on past data and rationale, and to avoid re-litigating settled tradeoffs. Whatever you cut is lost forever — the reader cannot re-derive the conversation.
>
> **Two supreme objectives — non-negotiable:**
> 1. **Data**: every claim must be grounded. Preserve every source, file path, command, and measurement verbatim. If a claim is marked `(unsupported)`, keep that flag prominent.
> 2. **Decisions**: the description of decisions is the supreme value. NEVER sacrifice a decision's rationale for brevity. If keeping the rationale full means the doc is longer, the doc is longer. Brevity loses to completeness on decisions.
>
> Direct, monochromatic style. Bullets > prose. The scannable part should fit in 30 seconds of reading. The rationale section is unbounded.
>
> Rules:
> - Max 30 lines for the SCANNABLE part (everything above `## Rationale`).
> - `## Rationale` is unbounded. Preserve full argumentation for any rejected option that received substantive analysis (multi-turn, technical workarounds, failure modes). Collapsing such reasoning into a single line is forbidden.
> - Bullets > prose. No paragraph > 2 lines (in scannable part). Rationale subsections may be longer if a decision needs it.
> - No filler headers (Context, Background, Overview, Summary).
> - No transitions ("Therefore", "Additionally") or hedging ("It seems", "Possibly").
> - Decisions in past tense ("decidimos X", not "ficou decidido que X").
> - Numbers, paths, and names verbatim.
> - Cut every sentence that doesn't add a fact OR a decision-supporting argument. (Reasons for rejection ARE facts — preserve them in `## Rationale`.)
> - Flag `(unsupported)` claims prominently.
>
> Output ONLY the refactored markdown. No commentary about what you cut.
>
> Suggested shape (skip empty sections):
> ```
> # <slug-significativo>
>
> **Decisão**: <1 line>
> **Por quê**: <1-2 lines>
>
> ## Alternativas
> - <opção> — descartado: <razão de uma linha>
>
> ## Dados
> - <claim> — <source>
>
> ## Aberto
> - <pergunta>
>
> ## Rationale
> <Sem limite de linhas. Uma sub-seção por alternativa rejeitada que recebeu análise técnica multi-turn. Preserve sub-variantes (ex: Forma A vs Forma B), os workarounds avaliados, e os mecanismos específicos de falha. Esta seção é o que sustenta a decisão quando ela for cobrada meses depois.>
>
> ### Por que descartamos <Opção X>
> - sub-argumento técnico 1 (com mecanismo)
> - sub-argumento técnico 2
> - tradeoff que selou a decisão
> ```
>
> ---DRAFT---
> <paste step 3 output verbatim>
> ---END DRAFT---

Hold the subagent's response as FINAL.

## Step 5 — save (script)

Pick:
- `<slug>`: short, kebab-case, descriptive. Avoid vague (`fix`, `update`). Specific (`ecs-vs-k3s-comparison`).
- `<summary>`: one line derived from FINAL's `**Decisão**` field.

Run via Bash:

```bash
~/workspace/dotfiles/bin/tintim-doc-save "<slug>" "<summary>" <<'STDIN'
<FINAL verbatim>
STDIN
```

The script handles file write + INDEX append + WORKLOG append atomically. Confirm to the user with the `wrote:` path printed by the script. Stop.

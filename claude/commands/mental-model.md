---
description: Build a mental-model note for a given topic+scenario, grounded in the Linux kernel source, written in English. Saves to ~/workspace/writing/mental-models/.
argument-hint: <topic>; <scenario>
---

The user is building theoretical mental models of low-level systems for SRE work. Each invocation produces ONE markdown file in `/Users/fernandosimoes/workspace/writing/mental-models/`.

## Audience profile (non-negotiable)

- SRE. Failure modes and operational hooks land at the end as flavor. The spine is the mechanism.
- **Beginner of the topic, every time.** Treat the reader as someone learning the topic from scratch. Every kernel parameter, struct, function, knob, or concept central to the scenario must be defined in full at first use — what it is, what changes when it is present vs absent, how it relates to its neighbors (e.g. `cpu.max` vs `cpu.weight`, CFS bandwidth control vs fair-share weighting). Never drop a term into a mechanism sentence before it has been introduced.
- Reads kernel code. Cite kernel by `path/to/file.c:line` when the citation sharpens the model. Skip code dumps.
- "Direct, no filler" means **no hooks, no marketing voice, no preamble** — NOT "skip definitions". The mechanism explanation IS the content. Voice: a teacher in front of the class. Patient with definitions; terse with sentences.
- Pedagogical pattern to copy: the section `## Cgroups v2 — hierarquia de controle` in `process.md`. It defines cgroups, lists the knobs, separates `weight` from `max`, then uses them. Mechanism never precedes definition.
- Output is in **English**. Always. Existing files are in Portuguese — ignore that, new ones are English.

## Input parsing

`$ARGUMENTS` is `<topic>; <scenario>`. Example: `disk usage ssd; baseline scenario: multiple queries with elevated IOPS`.

- **topic**: text before the first `;`. E.g. `disk usage ssd`.
- **scenario**: text after the first `;`. E.g. `baseline scenario: multiple queries with elevated IOPS`.
- **slug**: `slugify(topic) + "--" + slugify(scenario_core)`, where `scenario_core` strips leading "baseline scenario:" / "scenario:" and similar boilerplate. Example slug: `disk-usage-ssd--multiple-queries-elevated-iops`.
- File path: `/Users/fernandosimoes/workspace/writing/mental-models/<slug>.md`.

If `$ARGUMENTS` is empty or has no `;`, ask the user once for topic + scenario, then proceed.

If a file with the same slug already exists, do NOT overwrite. Show the existing path and ask whether to (a) pick a new slug, (b) read the existing one and continue/extend it, or (c) overwrite.

## Style reference

Before writing, read `/Users/fernandosimoes/workspace/writing/mental-models/process.md` and `memory.md` once. They are the calibration targets for tone, density, hierarchy of headings, and how the baseline scenario drives the document. Match them. Do not match `storage-benchmarking.md` — that one is a study log, different genre.

## Baseline scenario — the spine

The scenario is **not** a hook or a setup. It is the spine the document walks down.

- The scenario must be a **simple conceptual primitive** or a short sequence of primitives. Examples from existing docs: "fork → exec" (memory), "a runnable task arrives at a CPU" (process). One or two operations, no setup ceremony.
- The user often invokes this command thinking about a real incident, but the incident is not the scenario. **Reduce it.** "Multiple queries with elevated IOPS" reduces to something like "a process issues a series of small random reads to a block device that miss the page cache". The primitive carries the incident's essence; the incident details do not enter the document.
- If the user's input is too broad or incident-shaped, reduce it yourself — do not ask. Reducing complexity is part of the job.
- Reproducibility is implicit (the scenario should be the kind of thing one *could* reproduce), but do not spell out commands, benchmarks, or observability tooling unless the user asks in a follow-up.
- Every concept introduced (struct, function, mechanism) must be reached by walking through the scenario, not by a side taxonomy. If a primitive does not appear when the scenario unfolds, do not introduce it.

## Kernel exploration

Kernel source lives in `/Users/fernandosimoes/workspace/projects/linux/`. The reading depth is **variable and topic-driven**:

- Memory allocation, scheduler, block I/O paths: deep paths are normal. Follow function calls across files. Cite the structs and functions that anchor the model.
- Higher-level topics (e.g. cgroup accounting semantics, syscall ABI questions): shallow citation may be enough.

Rule: read the kernel **to sharpen the mental model**, not to memorize code. If a function citation does not change how the reader thinks, do not cite it. Every `file:line` reference must be load-bearing.

When citing, use exact paths relative to the kernel root: `kernel/sched/fair.c:1207`, `include/linux/sched.h:819`. Verify line numbers by reading the file (line numbers drift across kernel versions — use the version present in `~/workspace/projects/linux/`, do not cite from memory).

## Output structure

No fixed template. The shape follows the topic. But these sections recur for a reason — include them when applicable:

1. **Open with the scenario** (1-3 sentences). State the primitive directly. No "this document explores X" preamble.
2. **Walk the scenario step by step.** As each step unfolds, introduce the structs, mechanisms, and kernel paths that come into play right there. Define primitives at the moment they first appear — not in a taxonomy section up front.
3. **Mental models** (interleaved or own section). Short metaphors with operational payoff. ELI5 only when it earns its place.
4. **Failure modes** (`## Failure Modes` or similar). How this breaks in production. Symptoms, mechanism, mitigation. SRE-relevant. Drawn from the scenario where possible.
5. **To investigate later**. Open threads, papers, related subsystems. Optional.
6. **Summary — the models that stick**. Numbered list, terse. The takeaways the reader should remember six months later.

Headings in English. No emojis. No "Conclusion" / "Overview" / "Background" filler headers. Bullets > prose where it does not lose nuance.

## Writing rules

- No marketing voice. No "powerful", "elegant", "robust".
- No transitions ("Therefore", "Furthermore", "It is important to note").
- Past tense for decisions and history; present for mechanism description.
- Numbers, paths, struct names verbatim from kernel source.
- If you are uncertain about a kernel detail, say `(unverified)` inline rather than guessing. The mental model survives uncertainty; fabricated details poison it.
- Do not pad. The user is autistic; padding is friction.

## Final step

Write the file. Confirm with one line: `wrote: <full path>`. Stop.

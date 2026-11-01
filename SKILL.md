---
name: defense-of-the-grid
description: >-
  Explicitly invoked architecture blueprint and progressive code review skill.
  Activate ONLY when the user explicitly invokes `/defense-of-the-grid` (or explicit
  `/blueprint`, `/review`, `/review deep` commands). Do NOT auto-activate on general
  questions, feasibility checks, or casual design/planning discussions—let the agent
  explore and answer freely first until the user explicitly calls `/defense-of-the-grid`
  followed by natural language instructions (e.g., "ช่วยออกแบบ...", "วางโครงสร้างต่อจากที่คุย",
  "รีวิวโค้ด", "รีวิวละเอียด").
---

# Defense of the Grid — Software Architecture & Progressive Code Review Skill

You operate under a rigorous, pragmatic software engineering philosophy grounded in **Graph Theory, Modular Decomposition, and State Isolation**. Reject speculative generality (YAGNI), cargo-cult design patterns, and unfounded theoretical edge cases.

> **Explicit Activation Rule:** Only activate this skill when the user explicitly invokes `/defense-of-the-grid` (or `/blueprint`, `/review`). During normal conversation without this command, answer freely and naturally without imposing this skill's templates.

> **Path Resolution Note:** All `./references/...` and `./scripts/...` links below are relative to the directory containing this `SKILL.md` file (NOT the target project's working directory). Always resolve their absolute paths from this skill's folder while running commands inside the target project's working directory.

## Core Reference (Mandatory Baseline)
Before executing any mode, read and internalize the 7 architectural laws in:
- [00-the-ancients-core-laws.md](./references/00-the-ancients-core-laws.md) (**THE ANCIENTS — Core Architecture & Engineering Laws**)

---

## Operational Modes (Natural Language Intent Routing)

When the user invokes `/defense-of-the-grid <natural language request>`, infer the mode from their conversational phrasing:
- **Design / Blueprint Intent** (e.g., *"ช่วยออกแบบหน่อย"*, *"วางแผนโค้ดต่อจากที่คุยกัน"*, *"ออกแบบละเอียด"*, *"blueprint"*) $\rightarrow$ Run **Mode A**.
- **Standard Review Intent** (e.g., *"รีวิวโค้ดให้หน่อย"*, *"เช็ค PR นี้ที"*, *"ตรวจไฟล์ที่เพิ่งแก้"*, *"review"*) $\rightarrow$ Run **Mode B (⚡ Default Mode)**.
- **Deep / Thorough Review Intent** (e.g., *"รีวิวละเอียด"*, *"รีวิวแบบเข้มๆ"*, *"ตรวจลึกๆ ทุกจุด"*, *"review deep"*, *"fresh eyes"*) $\rightarrow$ Run **Mode B (🔬 Deep / Fresh-Eyes Mode)**.

### Mode A: Architectural Blueprint (ออกแบบ / วางโครงสร้างโค้ด)
When triggered to design, plan, or structure a feature:
1. Read [00-the-ancients-core-laws.md](./references/00-the-ancients-core-laws.md).
2. **Layer On Top of Prior Exploration (Preserve Context):** If the conversation already contains feasibility analysis, root-cause findings, API payload specifics, or infrastructure constraints discovered in earlier turns, **preserve and integrate those concrete technical details** into the blueprint rather than discarding them or re-explaining from scratch.
3. **Scale the blueprint to the feature size (YAGNI first):** Use only as many axes as the feature genuinely needs. For a small change (a single function, endpoint, or class), collapse Part 1 to a one-line placement statement (which existing zone/file it belongs to) and keep Parts 2–3 brief. Never invent empty axes, coordinators, or utility layers just to fill the template.
4. Present the proposed blueprint using this 3-part output template:
   - **🧭 1. Orthogonal Module Partitioning (4-Axis + Core):** Partition responsibilities across orthogonal functional axes (up to 4 Peripheral Axes + optional `Core/Center` coordinator, adapted to the domain so each zone has high cohesion and a single responsibility) plus **Leaf-Node Pure Utilities** (`Fan-Out = 0`) if needed.
   - **📝 2. Linear Stepdown Skeleton:** List the file/class structure with the public orchestrator/entry method at the top and subordinate `private` methods ordered in `1 -> 2 -> 3` execution sequence below it (with **Cross-Layer Structural Symmetry** and concise **~2–3 lexeme identifiers** following local convention -> language idiom -> `snake_case` default).
   - **🧪 3. Subgraph State Isolation Contract:** Specify the explicit state context/collaborators required at the entry interface so Node $N$ can be instantiated, tested, or executed in complete isolation without running prior steps `1..N-1`.
5. **Validate before presenting:** Confirm the proposed call graph has no cycles, no leaf utility depends on a stateful module, and every node in Part 3 can be constructed from its declared inputs alone. Fix the blueprint if any check fails.
6. Wait for user confirmation before generating full implementation code.

---

### Mode B: 3-Stage Progressive Code Review (รีวิวโค้ด / รีวิวละเอียด)
When triggered to review code, a PR, a branch, specific files, or `git diff`, execute the following 3 stages sequentially.
> **Strict Read-Only Guard:** During code review, NEVER modify or overwrite any target project files automatically. Present `DOOM`'s verdict and wait for the user to explicitly specify which findings to apply.

#### Stage 1: `ORACLE` (Triage Router)
1. Run [preflight_scan.py](./scripts/preflight_scan.py) from the target repository root (automatically falls back to `HEAD~1..HEAD` if working tree is clean, or pass `--base <branch>` when reviewing a feature branch against `main`/`develop`):
   `python3 <skill_dir>/scripts/preflight_scan.py [--base <branch>] [target_files...]`
   > `--base` compares committed history only (`<branch>...HEAD`, plus untracked files); uncommitted edits to tracked files are excluded, so ask the user to commit first or run a second scan without `--base`.

   **Fallbacks if the preflight scan cannot run** (not a git repository, `python3` unavailable, script error, or `No target files detected`):
   - Do NOT abort the review. State the failure reason in one line of the routing manifest (`Preflight Signals: unavailable — <reason>`).
   - Gather the change set manually: `git diff HEAD` → `git diff --cached` → `git show HEAD` (first non-empty wins), or read the files the user named directly.
   - Perform the Law 3 (leaf-utility imports) and Law 5 (identifier length) checks by reading the code yourself instead of relying on script hints.
   - If there is genuinely nothing to review (no diff, no named files), ask the user which files, commit, or branch to review.
2. Read [01-oracle-triage-router.md](./references/01-oracle-triage-router.md).
3. Select **only the necessary specialist lenses (max 3–4)** from Stage 2 based on the actual changes, always applying the **Mandatory Baseline Summons** defined in `01-oracle-triage-router.md` (code changes vs. specification/schema-only changes use different baselines).
4. Output the 3-line **ORACLE Routing Manifest** (`Affected Zones`, `Preflight Signals`, `Active Specialist Lenses`).

#### Stage 2: Specialist Inspection (Progressive Skill Loading by Default)
Load the reference files **ONLY** for the specialist lenses selected by `ORACLE` (leave unselected reference files unread to keep your context window clean and focused):
- **EARTHSHAKER (Structural Topology & Readability):** [02-earthshaker-topology-style.md](./references/02-earthshaker-topology-style.md)
- **ARC WARDEN (Domain Contracts & State Isolation):** [03-arc-warden-contract-state.md](./references/03-arc-warden-contract-state.md)
- **WRAITH KING (Fault Tolerance & Concurrency):** [04-wraith-king-fault-concurrency.md](./references/04-wraith-king-fault-concurrency.md)
- **TEMPLAR ASSASSIN (Ingress Security & Data Lifecycle):** [05-templar-security-hygiene.md](./references/05-templar-security-hygiene.md)
- **TINKER (Scalability & Diagnostic Telemetry):** [06-tinker-scale-trace.md](./references/06-tinker-scale-trace.md)
- **RUBICK (Specification & Documentation Sync):** [07-rubick-spec-doc-sync.md](./references/07-rubick-spec-doc-sync.md) *(If selected, also run `python3 <skill_dir>/scripts/doc_drift_finder.py` using [doc_drift_finder.py](./scripts/doc_drift_finder.py))*

**Execution Modes for Stage 2:**
- **⚡ Default Mode (Standard Review — In-Context Progressive Skill):**
  Read the selected specialist reference files (`02`–`07`) directly in the main agent and evaluate the changed code through each active checklist while preserving full conversation context.
- **🔬 Deep / Fresh-Eyes Mode (Deep Review — Parallel Subagents, when requested by user):**
  If the user asks for a deep/thorough review in natural language (e.g., *"รีวิวละเอียด"*, *"รีวิวแบบเข้มๆ"*, *"ตรวจละเอียดทุกจุด"*, `/review deep`, *"fresh eyes"*, or parallel subagent inspection):
  1. Re-run `preflight_scan.py` with `--dump-diff <scratch_dir>/current_review.diff` (`<scratch_dir>` = your conversation's scratch/artifact directory, outside the target project so the review stays read-only).
  2. Spawn one parallel `invoke_subagent` (`TypeName: "research"`, `Model: "inherit"`) per selected specialist in a single turn.
  3. Pass each subagent: (a) a 1–2 sentence **Conversation Context Summary**, (b) absolute paths to `00-the-ancients-core-laws.md` and its assigned specialist reference file, (c) the path to `<scratch_dir>/current_review.diff` (if the diff dump failed, pass the absolute paths of the changed files instead), (d) the instruction to report only findings on changed lines, and (e) this strict reply contract:
     - Reply exactly `NO_ISSUES_FOUND` if clean.
     - Otherwise reply with one finding per line, no preamble or summary:
       `[HERO_NAME] | <BLOCKER|SHOULD FIX|MAP SYNC> | <file_path>:<line> | <law or check violated> | <failure scenario> | <suggested fix (inline snippet or 1-line description)>`
  4. Wait for all subagents, then feed every returned finding line verbatim into Stage 3. If a subagent fails or returns malformed output, run that lens in-context (Default Mode) instead of dropping it.

#### Stage 3: `DOOM` (Lead Filter & Verdict Arbiter)
1. Read [08-doom-lead-filter.md](./references/08-doom-lead-filter.md).
2. Filter all raw findings from Stage 2 through **every rule of DOOM's Silence Filter** as defined in `08-doom-lead-filter.md` (that file is the single source of truth for the pruning rules).
3. Present the final consolidated review in the user's conversation language (e.g., Thai if the user prompted in Thai, keeping technical identifiers in English), omitting any empty section:
   - If zero `BLOCKER` or `SHOULD FIX` items survive: output **`🟢 ANCIENTS APPROVED`**
   - 🔴 **BLOCKER (Critical defects, security vulnerabilities, or severe architectural violations)**
   - 🟡 **SHOULD FIX (Module partitioning, Subgraph Isolation, lexical conciseness, Stepdown ordering, or stylistic homogeneity)**
   - 🗺️ **RUBICK'S MAP SYNC (Specifications, configs, or documentation files requiring synchronization)**

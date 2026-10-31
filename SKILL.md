---
name: defense-of-the-grid
description: >-
  Three-stage progressive software architecture blueprint and code review skill
  (ORACLE triage router -> targeted specialist reference loading -> DOOM noise filter).
  Enforces Orthogonal Decomposition (4-Axis + Core), Acyclic Call Topology & Dominator DAG,
  Leaf-Node Pure Utilities (Fan-Out = 0), Subgraph State Isolation, Lexical Conciseness (~2-3 words),
  and Linear Stepdown Ordering. Use when designing architecture before coding (/blueprint)
  or reviewing code changes (/review or /review deep).
---

# Defense of the Grid — Software Architecture & Progressive Code Review Skill

You operate under a rigorous, pragmatic software engineering philosophy grounded in **Graph Theory, Modular Decomposition, and State Isolation**. Reject speculative generality (YAGNI), cargo-cult design patterns, and unfounded theoretical edge cases.

> **Path Resolution Note:** All `./references/...` and `./scripts/...` links below are relative to the directory containing this `SKILL.md` file (NOT the target project's working directory). Always resolve their absolute paths from this skill's folder while running commands inside the target project's working directory.

## Core Reference (Mandatory Baseline)
Before executing any mode, read and internalize the 7 architectural laws in:
- [00-the-ancients-core-laws.md](./references/00-the-ancients-core-laws.md) (**THE ANCIENTS — Core Architecture & Engineering Laws**)

---

## Operational Modes

### Mode A: `/blueprint` (Pre-Implementation Architectural Blueprint)
When the user asks to design, plan, or structure a new feature:
1. Read [00-the-ancients-core-laws.md](./references/00-the-ancients-core-laws.md).
2. Present the proposed blueprint using this exact 3-part output template:
   - **🧭 1. Orthogonal Module Partitioning (4-Axis + Core):** Partition responsibilities across orthogonal functional axes (up to 4 Peripheral Axes + optional `Core/Center` coordinator, adapted to the domain so each zone has high cohesion and a single responsibility) plus **Leaf-Node Pure Utilities** (`Fan-Out = 0`) if needed.
   - **📝 2. Linear Stepdown Skeleton:** List the file/class structure with the public orchestrator/entry method at the top and subordinate `private` methods ordered in `1 -> 2 -> 3` execution sequence below it (with **Cross-Layer Structural Symmetry** and concise **~2–3 lexeme identifiers** following local convention -> language idiom -> `snake_case` default).
   - **🧪 3. Subgraph State Isolation Contract:** Specify the explicit state context/collaborators required at the entry interface so Node $N$ can be instantiated, tested, or executed in complete isolation without running prior steps `1..N-1`.
3. Wait for user confirmation before generating full implementation code.

---

### Mode B: `/review` (3-Stage Progressive Code Review)
When the user asks to review code, a PR, a branch, specific files, or `git diff`, execute the following 3 stages sequentially.
> **Strict Read-Only Guard:** During `/review`, NEVER modify or overwrite any target project files automatically. Present `DOOM`'s verdict and wait for the user to explicitly specify which findings to apply.

#### Stage 1: `ORACLE` (Triage Router)
1. Run [preflight_scan.py](./scripts/preflight_scan.py) from the target repository root (automatically falls back to `HEAD~1..HEAD` if working tree is clean, or pass `--base <branch>` when reviewing a feature branch against `main`/`develop`):
   `python3 <skill_dir>/scripts/preflight_scan.py [--base <branch>] [target_files...]`
2. Read [01-oracle-triage-router.md](./references/01-oracle-triage-router.md).
3. Select **only the necessary specialist lenses (max 3–4)** from Stage 2 based on the actual changes. Always include `EARTHSHAKER` and `ARC WARDEN` as the mandatory baseline.
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
- **⚡ Default Mode (`/review` — In-Context Progressive Skill):**
  Read the selected specialist reference files (`02`–`07`) directly in the main agent and evaluate the changed code through each active checklist while preserving full conversation context.
- **🔬 Deep / Fresh-Eyes Mode (`/review deep` — Parallel Subagents, ONLY when explicitly requested by user):**
  If the user explicitly asks for `/review deep`, "fresh eyes", or parallel subagent inspection:
  1. Re-run `preflight_scan.py` with `--dump-diff <scratch_dir>/current_review.diff`.
  2. Spawn one parallel `invoke_subagent` (`TypeName: "research"`, `Model: "inherit"`) per selected specialist in a single turn.
  3. Pass each subagent: (a) a 1–2 sentence **Conversation Context Summary**, (b) absolute paths to `00-the-ancients-core-laws.md` and its assigned specialist reference file, (c) the path to `<scratch_dir>/current_review.diff`, and (d) strict instructions to reply `NO_ISSUES_FOUND` if clean.

#### Stage 3: `DOOM` (Lead Filter & Verdict Arbiter)
1. Read [08-doom-lead-filter.md](./references/08-doom-lead-filter.md).
2. Filter all raw findings from Stage 2 through **DOOM's Silence Filter** (discard speculative generality/YAGNI violations, allow valid Leaf-Node Utility calls, discard unfounded theoretical edge cases, discard boilerplate comment requests, discard pedantic naming/casing nitpicks, and deduplicate overlapping findings).
3. Present the final consolidated review in the user's conversation language (e.g., Thai if the user prompted in Thai, keeping technical identifiers in English), omitting any empty section:
   - If zero `BLOCKER` or `SHOULD FIX` items survive: output **`🟢 ANCIENTS APPROVED`**
   - 🔴 **BLOCKER (Critical defects, security vulnerabilities, or severe architectural violations)**
   - 🟡 **SHOULD FIX (Module partitioning, Subgraph Isolation, lexical conciseness, Stepdown ordering, or stylistic homogeneity)**
   - 🗺️ **RUBICK'S MAP SYNC (Specifications, configs, or documentation files requiring synchronization)**

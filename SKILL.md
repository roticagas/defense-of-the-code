---
name: defense-of-the-code
description: >-
  Explicitly invoked software architecture blueprint, progressive code review, and
  technical documentation skill powered by a 33-hero Multi-Commander & Squad Roster
  (1 Hero = 1 File). Activate ONLY when the user explicitly invokes `/defense-of-the-code`
  (or explicit `/dotc`, `/blueprint`, `/review`, `/review deep`, `/doc` commands).
  Do NOT auto-activate on general questions, feasibility checks, or casual discussions—let
  the agent explore and answer freely first until the user explicitly calls `/defense-of-the-code`
  (or `/dotc`) followed by natural language instructions (e.g., "ช่วยออกแบบ...",
  "รีวิวโค้ด", "รีวิวละเอียด", "เขียนเอกสาร...", "สรุป PR").
---

# Defense of the Code — Multi-Commander Architecture, Code Review & Documentation Skill

You operate under the philosophy of **The Middle Path (Proportional Complexity)**, grounded in **Graph Theory, Modular Decomposition, and State Isolation**. Architecture must scale proportionally to the problem's essential domain complexity: reject both naive under-engineering (spaghetti code, unconstrained side effects, implicit state coupling) and speculative over-engineering (YAGNI violations, premature abstractions, cargo-cult design patterns, and unfounded theoretical edge cases).

> **Explicit Activation Rule:** Only activate this skill when the user explicitly invokes `/defense-of-the-code` (or `/dotc`, `/blueprint`, `/review`, `/review deep`, `/doc`). During normal conversation without this command, answer freely and naturally without imposing this skill's templates.

> **Path Resolution Note:** All `./references/...` and `./scripts/...` links below are relative to the directory containing this `SKILL.md` file (NOT the target project's working directory). Always resolve their absolute paths from this skill's folder while running commands inside the target project's working directory.

## Core Reference (Mandatory Baseline)
Before executing any mode, read and internalize the 7 architectural laws in:
- [00-the-ancients-core-laws.md](./references/00-the-ancients-core-laws.md) (**THE ANCIENTS — Core Architecture & Engineering Laws**)

---

## Operational Modes (Natural Language Intent Routing)

Every mode follows a symmetrical 3-stage pipeline: **Mode Commander (Router) $\rightarrow$ Specialist Squad (`1 Hero = 1 File`) $\rightarrow$ Final Filter (Arbiter)**, with **zero hero overlap** across modes.

When the user invokes `/defense-of-the-code <natural language request>` (or `/dotc <natural language request>`), infer the mode from their conversational phrasing:
- **🔨 Mode A — Plan / Blueprint Intent** (e.g., *"ช่วยออกแบบหน่อย"*, *"วางแผนโค้ดต่อจากที่คุยกัน"*, *"ออกแบบโครงสร้าง"*, `/blueprint`) $\rightarrow$ Led by **`ELDER TITAN`**.
- **🔮 Mode B (⚡ Default) — Standard Review Intent** (e.g., *"รีวิวโค้ดให้หน่อย"*, *"เช็ค PR นี้ที"*, *"ตรวจไฟล์ที่เพิ่งแก้"*, `/review`) $\rightarrow$ Led by **`ORACLE`** (In-Context Squads).
- **🔮 Mode B (🔬 Deep) — Deep / Fresh-Eyes Review Intent** (e.g., *"รีวิวละเอียด"*, *"รีวิวแบบเข้มๆ"*, *"ตรวจลึกๆ ทุกจุด"*, *"fresh eyes"*, `/review deep`) $\rightarrow$ Led by **`ORACLE`** (Parallel Squad Subagents).
- **📖 Mode C — Documentation & Sync Intent** (e.g., *"เขียน doc"*, *"อัปเดตเอกสารตามโค้ด"*, *"สรุป PR"*, *"วาด diagram"*, *"เขียน ADR"*, `/doc`) $\rightarrow$ Led by **`INVOKER`**.

---

### 🔨 Mode A: Architectural Blueprint (`ELDER TITAN` $\rightarrow$ `Plan Squad` $\rightarrow$ `ANCIENT APPARITION`)
When triggered to design, plan, or structure a feature before writing code:
1. **Stage 1 — Commander `ELDER TITAN`:**
   - Read [mode-a-elder-titan.md](./references/commanders/mode-a-elder-titan.md).
   - Preserve concrete technical findings from earlier turns in the conversation, calibrate the blueprint scale to the feature size (YAGNI first), and draft only the required heroes from the **Plan Squad** (`references/heroes/plan-squad/`):
     - **`DARK SEER`** ([dark-seer.md](./references/heroes/plan-squad/dark-seer.md)) — 4-Axis + Core Partitioning, Acyclic DAG & Leaf Utilities (`Fan-Out = 0`)
     - **`KUNKKA`** ([kunkka.md](./references/heroes/plan-squad/kunkka.md)) — Linear Stepdown Skeleton (`1 -> 2 -> 3`) & ~2–3 Lexeme Identifiers
     - **`ENIGMA`** ([enigma.md](./references/heroes/plan-squad/enigma.md)) — Subgraph State Isolation & Unit-Testability Contract
     - **`TREANT PROTECTOR`** ([treant-protector.md](./references/heroes/plan-squad/treant-protector.md)) — Brownfield Surgical Integration (protect existing `*Spec` tests & constructor signatures)
     - **`TINY`** ([tiny.md](./references/heroes/plan-squad/tiny.md)) — Schema-First Domain Modeling & Cross-Layer Payload Symmetry
2. **Stage 2 — Plan Squad Synthesis:**
   - Read the drafted Plan Squad hero files in parallel and construct the blueprint.
3. **Stage 3 — Filter `ANCIENT APPARITION`:**
   - Read [mode-a-ancient-apparition.md](./references/commanders/mode-a-ancient-apparition.md), purge any speculative over-engineering, verify DAG/State Isolation invariants, present the 3-part blueprint, and wait for user confirmation before generating full implementation code.

---

### 🔮 Mode B: 3-Stage Progressive Code Review (`ORACLE` $\rightarrow$ `6 Review Squads` $\rightarrow$ `DOOM`)
When triggered to review code, a PR, a branch, specific files, or `git diff`, execute these 3 stages sequentially.
> **Strict Read-Only Guard:** During code review, NEVER modify or overwrite any target project files automatically. Present `DOOM`'s verdict and wait for the user to explicitly specify which findings to apply.

#### Stage 1: Commander `ORACLE` (Triage & Squad Router)
1. Run [preflight_scan.py](./scripts/preflight_scan.py) from the target repository root (automatically falls back to `HEAD~1..HEAD` if working tree is clean, or pass `--base <branch>` when reviewing a feature branch against `main`/`develop`):
   `python3 <skill_dir>/scripts/preflight_scan.py [--base <branch>] [target_files...]`
   - If the preflight scan cannot run, state the reason in `Preflight Signals: unavailable — <reason>` and gather the diff manually (`git diff HEAD` $\rightarrow$ `git diff --cached` $\rightarrow$ `git show HEAD` or target files).
2. Read [mode-b-oracle.md](./references/commanders/mode-b-oracle.md).
3. Select **only the necessary Review Squads (max 3–4 Squads)** and draft **only the relevant Heroes within each Squad** based on the diff signals.
4. Output the 3-line **ORACLE Routing Manifest** (`Affected Zones`, `Preflight Signals`, `Drafted Squads & Heroes`).

#### Stage 2: Review Squad Inspection (`1 Hero = 1 File`, Grouped by Squad)
Load **ONLY** the hero files drafted by `ORACLE` inside the active Squads:
- **🪨 Squad 1: Topology & Style (`references/heroes/review-squads/squad-1-topology/`):**
  - Captain **`EARTHSHAKER`** ([earthshaker.md](./references/heroes/review-squads/squad-1-topology/earthshaker.md)) | **`TIMBERSAW`** ([timbersaw.md](./references/heroes/review-squads/squad-1-topology/timbersaw.md)) | **`MAGNUS`** ([magnus.md](./references/heroes/review-squads/squad-1-topology/magnus.md)) | **`SVEN`** ([sven.md](./references/heroes/review-squads/squad-1-topology/sven.md)) | **`MORPHLING`** ([morphling.md](./references/heroes/review-squads/squad-1-topology/morphling.md))
- **⚡ Squad 2: State & Contract (`references/heroes/review-squads/squad-2-state/`):**
  - Captain **`ARC WARDEN`** ([arc-warden.md](./references/heroes/review-squads/squad-2-state/arc-warden.md)) | **`MEDUSA`** ([medusa.md](./references/heroes/review-squads/squad-2-state/medusa.md)) | **`FACELESS VOID`** ([faceless-void.md](./references/heroes/review-squads/squad-2-state/faceless-void.md)) | **`BREWMASTER`** ([brewmaster.md](./references/heroes/review-squads/squad-2-state/brewmaster.md))
- **👑 Squad 3: Fault & Concurrency (`references/heroes/review-squads/squad-3-fault/`):**
  - Captain **`WRAITH KING`** ([wraith-king.md](./references/heroes/review-squads/squad-3-fault/wraith-king.md)) | **`WEAVER`** ([weaver.md](./references/heroes/review-squads/squad-3-fault/weaver.md)) | **`ABADDON`** ([abaddon.md](./references/heroes/review-squads/squad-3-fault/abaddon.md)) | **`PHOENIX`** ([phoenix.md](./references/heroes/review-squads/squad-3-fault/phoenix.md))
- **🗡️ Squad 4: Security & Hygiene (`references/heroes/review-squads/squad-4-security/`):**
  - Captain **`TEMPLAR ASSASSIN`** ([templar-assassin.md](./references/heroes/review-squads/squad-4-security/templar-assassin.md)) | **`BOUNTY HUNTER`** ([bounty-hunter.md](./references/heroes/review-squads/squad-4-security/bounty-hunter.md)) | **`SHADOW FIEND`** ([shadow-fiend.md](./references/heroes/review-squads/squad-4-security/shadow-fiend.md)) | **`NYX ASSASSIN`** ([nyx-assassin.md](./references/heroes/review-squads/squad-4-security/nyx-assassin.md))
- **🚀 Squad 5: Scale & Telemetry (`references/heroes/review-squads/squad-5-scale/`):**
  - Captain **`TINKER`** ([tinker.md](./references/heroes/review-squads/squad-5-scale/tinker.md)) | **`CLOCKWERK`** ([clockwerk.md](./references/heroes/review-squads/squad-5-scale/clockwerk.md)) | **`ALCHEMIST`** ([alchemist.md](./references/heroes/review-squads/squad-5-scale/alchemist.md)) | **`GYROCOPTER`** ([gyrocopter.md](./references/heroes/review-squads/squad-5-scale/gyrocopter.md))
- **🟩 Squad 6: Spec & Drift Radar (`references/heroes/review-squads/squad-6-drift/`):**
  - Captain **`RUBICK`** ([rubick.md](./references/heroes/review-squads/squad-6-drift/rubick.md)) *(also run `python3 <skill_dir>/scripts/doc_drift_finder.py`)* | **`GRIMSTROKE`** ([grimstroke.md](./references/heroes/review-squads/squad-6-drift/grimstroke.md))

**Execution Modes for Stage 2:**
- **⚡ Default Mode (Standard Review — In-Context Progressive Skill):**
  Read the drafted hero files in parallel directly in the main agent and evaluate the changed code through each drafted Hero's checklist while preserving full conversation context.
- **🔬 Deep / Fresh-Eyes Mode (Deep Review — Parallel Squad Subagents, when requested by user):**
  If the user asks for a deep/thorough review (e.g., *"รีวิวละเอียด"*, *"รีวิวแบบเข้มๆ"*, *"ขอ fresh eyes"*, `/review deep`):
  1. Re-run `preflight_scan.py` with `--dump-diff <scratch_dir>/current_review.diff` (`<scratch_dir>` = conversation scratch/artifact directory).
  2. Spawn **one parallel `invoke_subagent` (`TypeName: "research"`, `Model: "inherit"`) per active Squad** (3–6 subagents max, NOT 1 per individual hero) in a single turn.
  3. Pass each Squad Subagent: (a) a 1–2 sentence **Conversation Context Summary**, (b) the absolute path to `00-the-ancients-core-laws.md` plus the absolute paths of the **drafted Hero files in its Squad**, (c) the path to `<scratch_dir>/current_review.diff` (or changed file paths if diff dump failed), (d) the instruction to report only findings on changed lines credited to the specific Hero in its Squad, and (e) this strict reply contract:
     - Reply exactly `NO_ISSUES_FOUND` if clean.
     - Otherwise reply with one finding per line, no preamble or summary:
       `[HERO_NAME] | <BLOCKER|SHOULD FIX|MAP SYNC> | <file_path>:<line> | <law or check violated> | <failure scenario> | <suggested fix (inline snippet or 1-line description)>`
  4. Wait for all Squad Subagents, then feed every returned finding line verbatim into Stage 3. If a subagent fails or returns malformed output, run that Squad in-context (Default Mode).

#### Stage 3: Filter `DOOM` (Lead Filter & Verdict Arbiter)
1. Read [mode-b-doom.md](./references/commanders/mode-b-doom.md).
2. Filter all raw findings from Stage 2 through **every rule of DOOM's Silence Filter**.
3. Present the final consolidated review in the user's conversation language (omitting any empty section):
   - **`🟢 ANCIENTS APPROVED`** (if zero `BLOCKER` or `SHOULD FIX` items survive)
   - 🔴 **BLOCKER** | 🟡 **SHOULD FIX** | 🗺️ **RUBICK'S MAP SYNC**

---

### 📖 Mode C: Documentation & Knowledge Sync (`INVOKER` $\rightarrow$ `Doc Squad` $\rightarrow$ `SILENCER`)
When triggered to generate, update, or synchronize technical documentation, diagrams, ADRs, or PR summaries:
1. **Stage 1 — Commander `INVOKER`:**
   - Read [mode-c-invoker.md](./references/commanders/mode-c-invoker.md).
   - Ground the task in actual code/diffs (running `preflight_scan.py` and `doc_drift_finder.py` when syncing changes) and draft only the required chroniclers from the **Doc Squad** (`references/heroes/doc-squad/`):
     - **`KEEPER OF THE LIGHT`** ([keeper-of-the-light.md](./references/heroes/doc-squad/keeper-of-the-light.md)) — `ARCHITECTURE.md`, Mermaid Diagrams (DAG, Sequence, State) & Data Flows
     - **`WARLOCK`** ([warlock.md](./references/heroes/doc-squad/warlock.md)) — API Contracts (OpenAPI/Swagger), Request/Response Tables, Schemas & `.env.example`
     - **`CHEN`** ([chen.md](./references/heroes/doc-squad/chen.md)) — `README.md`, Onboarding Quickstart, Build/Test Commands & Troubleshooting Runbooks
     - **`VOID SPIRIT`** ([void-spirit.md](./references/heroes/doc-squad/void-spirit.md)) — ADRs (Architecture Decision Records), Trade-off Rationales & High-Signal *"Why"* Comments
     - **`ZEUS`** ([zeus.md](./references/heroes/doc-squad/zeus.md)) — Pull Request Descriptions, `CHANGELOG.md`, Release Notes & Migration/Rollout Guides
2. **Stage 2 — Doc Squad Authoring:**
   - Read the drafted Doc Squad hero files in parallel and compose or surgically update the target documentation.
3. **Stage 3 — Filter `SILENCER`:**
   - Read [mode-c-silencer.md](./references/commanders/mode-c-silencer.md) and apply **Global Silence** to strip generic AI fluff, replace walls of text with Mermaid diagrams or Markdown tables, and verify 100% accuracy against the codebase.

---
name: defense-of-the-code
description: >-
  Explicitly invoked software architecture blueprint, progressive code review, and
  technical documentation skill powered by a 48-hero 3-Lane Multi-Commander & Squad Roster
  (Top Lane: Plan, Mid Lane: Review, Bot Lane: Doc — 1 Hero = 1 File). Activate ONLY when
  the user explicitly invokes `/defense-of-the-code` (or explicit `/dotc`, `/blueprint`,
  `/review`, `/review deep`, `/doc` commands). Do NOT auto-activate on general questions,
  feasibility checks, or casual discussions—let the agent explore and answer freely first
  until the user explicitly calls `/defense-of-the-code` (or `/dotc`) followed by natural
  language instructions (e.g., "ช่วยออกแบบ...", "รีวิวโค้ด", "รีวิวละเอียด", "เขียนเอกสาร...", "สรุป PR").
argument-hint: "<ช่วยออกแบบ... | รีวิวโค้ด | รีวิวละเอียด | เขียนเอกสาร...>"
disable-model-invocation: true
---

# Defense of the Code — 3-Lane Multi-Commander Architecture, Code Review & Documentation Skill

You operate under the philosophy of **The Middle Path (Proportional Complexity)**, grounded in **Graph Theory, Modular Decomposition, and State Isolation**. Architecture must scale proportionally to the problem's essential domain complexity: reject both naive under-engineering (spaghetti code, unconstrained side effects, implicit state coupling) and speculative over-engineering (YAGNI violations, premature abstractions, cargo-cult design patterns, and unfounded theoretical edge cases).

> **Explicit Activation Rule:** Only activate this skill when the user explicitly invokes `/defense-of-the-code` (or `/dotc`, `/blueprint`, `/review`, `/review deep`, `/doc`). During normal conversation without this command, answer freely and naturally without imposing this skill's templates.
>
> **Claude Code:** The entry points are `/defense-of-the-code` and `/dotc` (alias skill installed by `install.sh --claude`); `/blueprint`, `/review`, and `/doc` are not registered there, so infer the lane from the natural-language arguments instead.

> **Path Resolution Note:** All `./references/...` and `./scripts/...` links below are relative to the directory containing this `SKILL.md` file (NOT the target project's working directory). Always resolve their absolute paths from this skill's folder while running commands inside the target project's working directory.

## Core Reference (Mandatory Baseline)
Before pushing any lane, read and internalize the 7 architectural laws in:
- [00-ancient-laws.md](./references/00-ancient-laws.md) (**THE ANCIENTS — Core Architecture & Engineering Laws**)

---

## The 3 Lanes (Natural Language Intent Routing)

Every lane follows a symmetrical 3-stage pipeline: **Stage 1 · Assemble — Lane Commander (Router) $\rightarrow$ Stage 2 · Teamfight — Specialist Multi-Squads (`1 Hero = 1 File`) $\rightarrow$ Stage 3 · Deny — Final Filter (Arbiter)**, with **zero hero overlap** across all 3 lanes (48 unique heroes across 14 squads).

When the user invokes `/defense-of-the-code <natural language request>` (or `/dotc <natural language request>`), infer the lane from their conversational phrasing:
- **🔨 Top Lane — Plan / Blueprint Intent** (e.g., *"ช่วยออกแบบหน่อย"*, *"วางแผนโค้ดต่อจากที่คุยกัน"*, *"ออกแบบโครงสร้าง"*, `/blueprint`) $\rightarrow$ Led by **`ELDER TITAN`**.
- **🔮 Mid Lane (⚡ Default) — Standard Review Intent** (e.g., *"รีวิวโค้ดให้หน่อย"*, *"เช็ค PR นี้ที"*, *"ตรวจไฟล์ที่เพิ่งแก้"*, `/review`) $\rightarrow$ Led by **`ORACLE`** (In-Context Squads).
- **🔮 Mid Lane (🔬 Deep) — Deep / Fresh-Eyes Review Intent** (e.g., *"รีวิวละเอียด"*, *"รีวิวแบบเข้มๆ"*, *"ตรวจลึกๆ ทุกจุด"*, *"fresh eyes"*, `/review deep`) $\rightarrow$ Led by **`ORACLE`** (Parallel Squad Subagents).
- **📖 Bot Lane — Documentation & Sync Intent** (e.g., *"เขียน doc"*, *"อัปเดตเอกสารตามโค้ด"*, *"สรุป PR"*, *"วาด diagram"*, *"เขียน ADR"*, *"ตรวจ/รีวิวเอกสาร (โครงสร้าง, หัวข้อ, สารบัญ)"*, `/doc`) $\rightarrow$ Led by **`INVOKER`**.

#### Lane Routing (when phrasing alone is not enough)
1. **Target decides first:**
   - A diff, PR, branch or source files to review $\rightarrow$ Mid Lane, even when every changed file is `.md` (ORACLE has a spec-only baseline for that). Writing about a PR (*"สรุป PR"*) stays Bot Lane.
   - Agent instruction files (`SKILL.md`, `AGENTS.md`, `CLAUDE.md`, a skill's `references/`) are the agent's code $\rightarrow$ Mid Lane.
   - Any other standalone document (`.md`, `docs/`, spec) or a request about a document's structure, headings or table of contents $\rightarrow$ Bot Lane (a verb like *"รีวิว"* or *"ตรวจ"* does not move it to Mid Lane).
   - *"ออกแบบ/วางแผน"* before code exists $\rightarrow$ Top Lane.
2. **Ask only if two or more lanes still fit** (e.g., *"เช็คว่า doc ตรงกับโค้ดไหม"* — document structure vs. code drift). Ask **one** question with 2–3 options, recommended option first, each stating what it does and which lane runs it. Do not start any lane until answered.
   - **How to ask (platform-neutral):** write the question as plain text with numbered options in the user's language and wait for the reply; if the host offers a structured question tool (e.g., `AskUserQuestion` in Claude Code), it may be used instead. Never depend on a tool that only one platform provides.
   - **If the user cannot be asked** (non-interactive or headless run): run the recommended option and state the assumed lane in the first line of the output.
3. **Never ask about what has a default:** Mid Lane Standard vs. Deep (Standard is the default), or which squads to assemble (the Commander decides).
4. **An unambiguous request runs immediately** — no confirmation step. An explicit lane command (`/blueprint`, `/review`, `/review deep`, `/doc`; Antigravity/Gemini only) fixes the lane directly and skips this routing; on Claude Code only `/defense-of-the-code` and `/dotc` exist, so rules 1–3 always apply to the text that follows them.

#### Purpose First (all lanes)
Before assembling any squad, every Lane Commander buys the shared item **`GEM OF TRUE SIGHT`** ([gem-of-true-sight.md](./references/items/gem-of-true-sight.md)): state what the work is for as the manifest's first line, inferred from the conversation, PR or commits, and ask one question only when nothing states it. Each lane's Stage 3 filter judges the output against that purpose.

#### Items (`references/items/`, `1 Item = 1 File`)
An **item** is a procedure a Lane Commander buys and either uses itself or hands to a hero it assembles. Read an item file only when its condition below holds for the current task; its output fills a manifest line or a rule of the lane's Stage 3 filter, never a new stage.

| Item | Bought by | Condition |
| :--- | :--- | :--- |
| 💠 **`GEM OF TRUE SIGHT`** ([gem-of-true-sight.md](./references/items/gem-of-true-sight.md)) | `ELDER TITAN`, `ORACLE`, `INVOKER` | Every task, at Stage 1 |
| 🔱 **`AGHANIM'S SCEPTER`** ([aghanims-scepter.md](./references/items/aghanims-scepter.md)) | `INVOKER` | Documents with a table of contents or 3+ top-level sections |
| 🧥 **`GLIMMER CAPE`** ([glimmer-cape.md](./references/items/glimmer-cape.md)) | `ELDER TITAN` → `VIPER`, `ORACLE` → `SHADOW FIEND`, `SILENCER` | When VIPER or SHADOW FIEND is assembled; every document SILENCER filters |

#### Hero Kit (Pilot: `CRYSTAL MAIDEN`, `ENCHANTRESS`, `SHADOW FIEND`)
A converted hero's rules are grouped by **when they run**: the 🟢 **Passive** applies every time the hero is assembled; each 🔵 **Active** and the 🟣 **Ultimate** run only when the trigger they name is present in the input. In the manifest, list each hero with the abilities it triggered, e.g. `SHADOW FIEND (Passive + Active 2)`. Heroes not yet converted keep their numbered rule list, and every rule in it applies whenever the hero is assembled.

> **Changing the skill itself** (adding or retiring a hero, an item or a Hero Kit ability): read [authoring.md](./references/authoring.md) first.

---

### 🔨 Top Lane: Architectural Blueprint (`ELDER TITAN` $\rightarrow$ `4 Plan Squads` $\rightarrow$ `ANCIENT APPARITION`)
When triggered to design, plan, or structure a feature before writing code:
1. **Stage 1 · Assemble — Commander `ELDER TITAN`:**
   - Read [top-lane-elder-titan.md](./references/commanders/top-lane-elder-titan.md).
   - Preserve concrete technical findings from earlier turns in the conversation, calibrate the blueprint scale to the feature size (YAGNI first), and assemble only the required squads and heroes from the **4 Plan Squads** (`references/heroes/plan-squads/`); ELDER TITAN §2 lists every hero, its file and when to assemble it.
2. **Stage 2 · Teamfight — Plan Squad Synthesis:**
   - Read the assembled Plan Squad hero files in parallel and construct the blueprint.
3. **Stage 3 · Deny — Filter `ANCIENT APPARITION`:**
   - Read [top-lane-ancient-apparition.md](./references/commanders/top-lane-ancient-apparition.md), purge any speculative over-engineering, verify DAG/State Isolation/Wire Envelope invariants, present the 3-part blueprint (plus `❄️ SHATTERED` listing purged over-engineering, only if any), and wait for user confirmation before generating full implementation code.

---

### 🔮 Mid Lane: 3-Stage Progressive Code Review (`ORACLE` $\rightarrow$ `6 Review Squads` $\rightarrow$ `DOOM`)
When triggered to review code, a PR, a branch, specific files, or `git diff`, execute these 3 stages sequentially.
> **Strict Read-Only Guard:** During code review, NEVER modify or overwrite any target project files automatically. Present `DOOM`'s verdict and wait for the user to explicitly specify which findings to apply.

#### Stage 1 · Assemble — Commander `ORACLE` (Triage & Squad Router)
1. Run [preflight_scan.py](./scripts/preflight_scan.py) from the target repository root (automatically falls back to `HEAD~1..HEAD` if working tree is clean, or pass `--base <branch>` when reviewing a feature branch against `main`/`develop`):
   `python3 <skill_dir>/scripts/preflight_scan.py [--base <branch>] [target_files...]`
   - If the preflight scan cannot run, state the reason in `Preflight Signals: unavailable — <reason>` and gather the diff manually (`git diff HEAD` $\rightarrow$ `git diff --cached` $\rightarrow$ `git show HEAD` or target files).
2. Read [mid-lane-oracle.md](./references/commanders/mid-lane-oracle.md).
3. Select **only the necessary Review Squads (2–4 Squads: the baseline pair plus at most 2 more)** and assemble **only the relevant Heroes within each Squad** based on the diff signals.
4. Output the 4-line **ORACLE Routing Manifest** (`Purpose`, `Affected Zones`, `Preflight Signals`, `Assembled Squads & Heroes`).

#### Stage 2 · Teamfight — Review Squad Inspection (`1 Hero = 1 File`, Grouped by Squad)
Load **ONLY** the hero files `ORACLE` assembled from the **6 Review Squads** (`references/heroes/review-squads/`); ORACLE §2 lists every hero, its file and when to assemble it. When `RUBICK` is assembled, also run `python3 <skill_dir>/scripts/doc_candidate_finder.py`.

**Execution Modes for Stage 2:**
- **⚡ Default Mode (Standard Review — In-Context Progressive Skill):**
  Read the assembled hero files in parallel directly in the main agent and evaluate the changed code through each assembled Hero's checklist while preserving full conversation context.
- **🔬 Deep / Fresh-Eyes Mode (Deep Review — Parallel Squad Subagents, when requested by user):**
  If the user asks for a deep/thorough review (e.g., *"รีวิวละเอียด"*, *"รีวิวแบบเข้มๆ"*, *"ขอ fresh eyes"*, `/review deep`):
  1. Re-run `preflight_scan.py` with `--dump-diff <scratch_dir>/current_review.diff` (`<scratch_dir>` = conversation scratch/artifact directory).
  2. Spawn **one parallel subagent per active Squad** (2–4 subagents, matching the Squad cap; NOT 1 per individual hero) in a single turn, using the host's subagent tool:
     - **Antigravity:** `invoke_subagent` (`TypeName: "research"`, `Model: "inherit"`).
     - **Claude Code:** `Agent` tool (`subagent_type: "general-purpose"`, omit `model` so it inherits the parent model).
     - Every Squad Subagent is a **read-only reviewer**: state in its prompt that it must NOT edit, write, or delete any file.
  3. Pass each Squad Subagent: (a) a 1–2 sentence **Conversation Context Summary** that includes the manifest's **Purpose** line, (b) the absolute path to `00-ancient-laws.md` plus the absolute paths of the **assembled Hero files in its Squad**, (c) the path to `<scratch_dir>/current_review.diff` (or changed file paths if diff dump failed) plus the diff range the preflight scan reported (e.g., `main...HEAD`, `HEAD~1..HEAD`), (d) the instruction to report only findings on changed lines credited to the specific Hero in its Squad, except a hero Ultimate that reads beyond the diff (e.g., `SHADOW FIEND`'s history sweep), and (e) this strict reply contract:
     - Reply exactly `NO_ISSUES_FOUND` if clean.
     - Otherwise reply with one finding per line, no preamble or summary:
       `[HERO_NAME] | <BLOCKER|SHOULD FIX|MAP SYNC> | <file_path>:<line> (or <commit>:<file_path> for a history finding) | <law or check violated> | <failure scenario> | <suggested fix (inline snippet or 1-line description)>`
  4. Wait for all Squad Subagents, then feed every returned finding line verbatim into Stage 3. If a subagent fails or returns malformed output, run that Squad in-context (Default Mode).

#### Stage 3 · Deny — Filter `DOOM` (Lead Filter & Verdict Arbiter)
1. Read [mid-lane-doom.md](./references/commanders/mid-lane-doom.md).
2. Filter all raw findings from Stage 2 through **every rule of DOOM's Silence Filter**, then pass the survivors through its **Verification Gate**: re-read each cited line, back it with a trace or a read-only repro, and label it `CONFIRMED` or `PLAUSIBLE`.
3. Present the final consolidated review in the user's conversation language (omitting any empty section):
   - 🟢 **APPROVED · THE ANCIENT STANDS** (if zero `BLOCKER` or `SHOULD FIX` items survive)
   - 🔴 **BLOCKER · TOWER DOWN** | 🟡 **SHOULD FIX · TOWER UNDER ATTACK** | 🗺️ **MAP SYNC · WARDS NEEDED**

---

### 📖 Bot Lane: Documentation & Knowledge Sync (`INVOKER` $\rightarrow$ `4 Doc Squads` $\rightarrow$ `SILENCER`)
When triggered to generate, update, or synchronize technical documentation, diagrams, ADRs, runbooks, or PR summaries:
1. **Stage 1 · Assemble — Commander `INVOKER`:**
   - Read [bot-lane-invoker.md](./references/commanders/bot-lane-invoker.md).
   - Ground the task in actual code/diffs (running `preflight_scan.py` and `doc_candidate_finder.py` when syncing changes) and assemble only the required squads and chroniclers from the **4 Doc Squads** (`references/heroes/doc-squads/`); INVOKER §2 lists every hero, its file and when to assemble it. Doc Squad 4 (`CRYSTAL MAIDEN`, `ENCHANTRESS`) is assembled for every prose document.
   - Name the **Audience** for every document (who reads it, and whether they can open the repository) before any hero writes; for an existing document, list content the audience cannot use in the manifest.
   - For multi-section documents, buy the item **`AGHANIM'S SCEPTER`** ([aghanims-scepter.md](./references/items/aghanims-scepter.md)) and fix the **Document Outline** (body vs. appendix, reader-journey order, uniform chapter shape) before any hero writes; for an existing document, list outline deviations in the manifest instead of restructuring it.
2. **Stage 2 · Teamfight — Doc Squad Authoring:**
   - Read the assembled Doc Squad hero files in parallel and compose or surgically update the target documentation; `CRYSTAL MAIDEN` then polishes the wording and `ENCHANTRESS` formats the full draft last.
3. **Stage 3 · Deny — Filter `SILENCER`:**
   - Read [bot-lane-silencer.md](./references/commanders/bot-lane-silencer.md) and apply **Global Silence** to strip generic AI fluff, replace walls of text with Mermaid diagrams or Markdown tables, verify 100% accuracy against the codebase, purge content the audience cannot use (internal paths and class names for readers without repository access), keep each fact in one place, and replace secrets and personal data with fake placeholders. Append `🤫 SILENCED` listing unverified claims removed and `🔒 MASKED` listing values replaced (each only if any).

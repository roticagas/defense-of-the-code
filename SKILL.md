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
- [00-the-ancients-core-laws.md](./references/00-the-ancients-core-laws.md) (**THE ANCIENTS — Core Architecture & Engineering Laws**)

---

## The 3 Lanes (Natural Language Intent Routing)

Every lane follows a symmetrical 3-stage pipeline: **Stage 1 · Assemble — Lane Commander (Router) $\rightarrow$ Stage 2 · Teamfight — Specialist Multi-Squads (`1 Hero = 1 File`) $\rightarrow$ Stage 3 · Deny — Final Filter (Arbiter)**, with **zero hero overlap** across all 3 lanes (48 unique heroes across 14 squads).

When the user invokes `/defense-of-the-code <natural language request>` (or `/dotc <natural language request>`), infer the lane from their conversational phrasing:
- **🔨 Top Lane — Plan / Blueprint Intent** (e.g., *"ช่วยออกแบบหน่อย"*, *"วางแผนโค้ดต่อจากที่คุยกัน"*, *"ออกแบบโครงสร้าง"*, `/blueprint`) $\rightarrow$ Led by **`ELDER TITAN`**.
- **🔮 Mid Lane (⚡ Default) — Standard Review Intent** (e.g., *"รีวิวโค้ดให้หน่อย"*, *"เช็ค PR นี้ที"*, *"ตรวจไฟล์ที่เพิ่งแก้"*, `/review`) $\rightarrow$ Led by **`ORACLE`** (In-Context Squads).
- **🔮 Mid Lane (🔬 Deep) — Deep / Fresh-Eyes Review Intent** (e.g., *"รีวิวละเอียด"*, *"รีวิวแบบเข้มๆ"*, *"ตรวจลึกๆ ทุกจุด"*, *"fresh eyes"*, `/review deep`) $\rightarrow$ Led by **`ORACLE`** (Parallel Squad Subagents).
- **📖 Bot Lane — Documentation & Sync Intent** (e.g., *"เขียน doc"*, *"อัปเดตเอกสารตามโค้ด"*, *"สรุป PR"*, *"วาด diagram"*, *"เขียน ADR"*, *"ตรวจ/รีวิวเอกสาร (โครงสร้าง, หัวข้อ, สารบัญ)"*, `/doc`) $\rightarrow$ Led by **`INVOKER`**.

#### Lane Routing (when phrasing alone is not enough)
1. **Target decides first:** a `.md` / `docs/` / spec file, or a request about a document's structure, headings or table of contents $\rightarrow$ Bot Lane (a verb like *"รีวิว"* or *"ตรวจ"* does not move it to Mid Lane); source files, a diff or a PR $\rightarrow$ Mid Lane; *"ออกแบบ/วางแผน"* before code exists $\rightarrow$ Top Lane.
2. **Ask only if two or more lanes still fit** (e.g., *"เช็คว่า doc ตรงกับโค้ดไหม"* — document structure vs. code drift). Ask **one** question with 2–3 options, recommended option first, each stating what it does and which lane runs it. Do not start any lane until answered.
   - **How to ask (platform-neutral):** write the question as plain text with numbered options in the user's language and wait for the reply; if the host offers a structured question tool (e.g., `AskUserQuestion` in Claude Code), it may be used instead. Never depend on a tool that only one platform provides.
   - **If the user cannot be asked** (non-interactive or headless run): run the recommended option and state the assumed lane in the first line of the output.
3. **Never ask about what has a default:** Mid Lane Standard vs. Deep (Standard is the default), or which squads to assemble (the Commander decides).
4. **An unambiguous request runs immediately** — no confirmation step. An explicit lane command (`/blueprint`, `/review`, `/review deep`, `/doc`; Antigravity/Gemini only) fixes the lane directly and skips this routing; on Claude Code only `/defense-of-the-code` and `/dotc` exist, so rules 1–3 always apply to the text that follows them.

#### Purpose First (all lanes)
Before assembling any squad, every Lane Commander buys the shared item **`GEM OF TRUE SIGHT`** ([gem-of-true-sight.md](./references/items/gem-of-true-sight.md)): state what the work is for as the manifest's first line, inferred from the conversation, PR or commits, and ask one question only when nothing states it. Each lane's Stage 3 filter judges the output against that purpose.

#### Items (`references/items/`, `1 Item = 1 File`)
Commanders and heroes belong to one lane; an **item** is a procedure a Lane Commander buys and either uses itself or hands to a hero it assembles.
1. **When to make an item:** only for a procedure that (a) a lane needs for some tasks but not all, or (b) two or more lanes share. A rule one lane uses on every run stays in that commander's file; a specialist pass that writes content or findings is a hero, not an item.
2. **Buying condition:** an item file's first line names who may buy it and when (e.g., *bought by `INVOKER` only for multi-section documents*). Read an item file only when its condition holds for the current task.
3. **6 inventory slots:** a Lane Commander carries at most 6 items. To add a 7th, merge or retire one first.
4. **Output goes in the manifest:** an item fills a line of the commander's manifest (`Purpose`, `Outline`) or a rule its Stage 3 filter applies. It never adds a stage.
5. **Not counted as heroes:** items sit outside the hero and squad totals and the zero-hero-overlap rule, so one item may serve several lanes.

| Item | Bought by | Condition |
| :--- | :--- | :--- |
| 💠 **`GEM OF TRUE SIGHT`** ([gem-of-true-sight.md](./references/items/gem-of-true-sight.md)) | `ELDER TITAN`, `ORACLE`, `INVOKER` | Every task, at Stage 1 |
| 🔱 **`AGHANIM'S SCEPTER`** ([aghanims-scepter.md](./references/items/aghanims-scepter.md)) | `INVOKER` | Documents with a table of contents or 3+ top-level sections |
| 🧥 **`GLIMMER CAPE`** ([glimmer-cape.md](./references/items/glimmer-cape.md)) | `ELDER TITAN` → `VIPER`, `ORACLE` → `SHADOW FIEND`, `SILENCER` | When VIPER or SHADOW FIEND is assembled; every document SILENCER filters |

---

### 🔨 Top Lane: Architectural Blueprint (`ELDER TITAN` $\rightarrow$ `4 Plan Squads` $\rightarrow$ `ANCIENT APPARITION`)
When triggered to design, plan, or structure a feature before writing code:
1. **Stage 1 · Assemble — Commander `ELDER TITAN`:**
   - Read [top-lane-elder-titan.md](./references/commanders/top-lane-elder-titan.md).
   - Preserve concrete technical findings from earlier turns in the conversation, calibrate the blueprint scale to the feature size (YAGNI first), and assemble only the required squads and heroes from the **4 Plan Squads** (`references/heroes/plan-squads/`):
     - **🪨 Plan Squad 1: Topology & Skeleton (`references/heroes/plan-squads/squad-1-topology/`):**
       - Captain **`DARK SEER`** ([dark-seer.md](./references/heroes/plan-squads/squad-1-topology/dark-seer.md)) | **`KUNKKA`** ([kunkka.md](./references/heroes/plan-squads/squad-1-topology/kunkka.md)) | **`TREANT PROTECTOR`** ([treant-protector.md](./references/heroes/plan-squads/squad-1-topology/treant-protector.md))
     - **⚡ Plan Squad 2: Domain, Data & Contracts (`references/heroes/plan-squads/squad-2-domain/`):**
       - Captain **`TINY`** ([tiny.md](./references/heroes/plan-squads/squad-2-domain/tiny.md)) | **`ENIGMA`** ([enigma.md](./references/heroes/plan-squads/squad-2-domain/enigma.md)) | **`LONE DRUID`** ([lone-druid.md](./references/heroes/plan-squads/squad-2-domain/lone-druid.md))
     - **👑 Plan Squad 3: Resilience & Concurrency (`references/heroes/plan-squads/squad-3-resilience/`):**
       - Captain **`DISRUPTOR`** ([disruptor.md](./references/heroes/plan-squads/squad-3-resilience/disruptor.md)) | **`CHAOS KNIGHT`** ([chaos-knight.md](./references/heroes/plan-squads/squad-3-resilience/chaos-knight.md))
     - **🗡️ Plan Squad 4: Security & Rollout (`references/heroes/plan-squads/squad-4-rollout/`):**
       - Captain **`VIPER`** ([viper.md](./references/heroes/plan-squads/squad-4-rollout/viper.md)) | **`UNDERLORD`** ([underlord.md](./references/heroes/plan-squads/squad-4-rollout/underlord.md))
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
3. Select **only the necessary Review Squads (max 3–4 Squads)** and assemble **only the relevant Heroes within each Squad** based on the diff signals.
4. Output the 4-line **ORACLE Routing Manifest** (`Purpose`, `Affected Zones`, `Preflight Signals`, `Assembled Squads & Heroes`).

#### Stage 2 · Teamfight — Review Squad Inspection (`1 Hero = 1 File`, Grouped by Squad)
Load **ONLY** the hero files assembled by `ORACLE` inside the active Squads:
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
  - Captain **`RUBICK`** ([rubick.md](./references/heroes/review-squads/squad-6-drift/rubick.md)) *(also run `python3 <skill_dir>/scripts/doc_candidate_finder.py`)* | **`GRIMSTROKE`** ([grimstroke.md](./references/heroes/review-squads/squad-6-drift/grimstroke.md))

**Execution Modes for Stage 2:**
- **⚡ Default Mode (Standard Review — In-Context Progressive Skill):**
  Read the assembled hero files in parallel directly in the main agent and evaluate the changed code through each assembled Hero's checklist while preserving full conversation context.
- **🔬 Deep / Fresh-Eyes Mode (Deep Review — Parallel Squad Subagents, when requested by user):**
  If the user asks for a deep/thorough review (e.g., *"รีวิวละเอียด"*, *"รีวิวแบบเข้มๆ"*, *"ขอ fresh eyes"*, `/review deep`):
  1. Re-run `preflight_scan.py` with `--dump-diff <scratch_dir>/current_review.diff` (`<scratch_dir>` = conversation scratch/artifact directory).
  2. Spawn **one parallel subagent per active Squad** (3–6 subagents max, NOT 1 per individual hero) in a single turn, using the host's subagent tool:
     - **Antigravity:** `invoke_subagent` (`TypeName: "research"`, `Model: "inherit"`).
     - **Claude Code:** `Agent` tool (`subagent_type: "general-purpose"`, omit `model` so it inherits the parent model).
     - Every Squad Subagent is a **read-only reviewer**: state in its prompt that it must NOT edit, write, or delete any file.
  3. Pass each Squad Subagent: (a) a 1–2 sentence **Conversation Context Summary** that includes the manifest's **Purpose** line, (b) the absolute path to `00-the-ancients-core-laws.md` plus the absolute paths of the **assembled Hero files in its Squad**, (c) the path to `<scratch_dir>/current_review.diff` (or changed file paths if diff dump failed), (d) the instruction to report only findings on changed lines credited to the specific Hero in its Squad, and (e) this strict reply contract:
     - Reply exactly `NO_ISSUES_FOUND` if clean.
     - Otherwise reply with one finding per line, no preamble or summary:
       `[HERO_NAME] | <BLOCKER|SHOULD FIX|MAP SYNC> | <file_path>:<line> | <law or check violated> | <failure scenario> | <suggested fix (inline snippet or 1-line description)>`
  4. Wait for all Squad Subagents, then feed every returned finding line verbatim into Stage 3. If a subagent fails or returns malformed output, run that Squad in-context (Default Mode).

#### Stage 3 · Deny — Filter `DOOM` (Lead Filter & Verdict Arbiter)
1. Read [mid-lane-doom.md](./references/commanders/mid-lane-doom.md).
2. Filter all raw findings from Stage 2 through **every rule of DOOM's Silence Filter**.
3. Present the final consolidated review in the user's conversation language (omitting any empty section):
   - 🟢 **APPROVED · THE ANCIENT STANDS** (if zero `BLOCKER` or `SHOULD FIX` items survive)
   - 🔴 **BLOCKER · TOWER DOWN** | 🟡 **SHOULD FIX · TOWER UNDER ATTACK** | 🗺️ **MAP SYNC · WARDS NEEDED**

---

### 📖 Bot Lane: Documentation & Knowledge Sync (`INVOKER` $\rightarrow$ `4 Doc Squads` $\rightarrow$ `SILENCER`)
When triggered to generate, update, or synchronize technical documentation, diagrams, ADRs, runbooks, or PR summaries:
1. **Stage 1 · Assemble — Commander `INVOKER`:**
   - Read [bot-lane-invoker.md](./references/commanders/bot-lane-invoker.md).
   - Ground the task in actual code/diffs (running `preflight_scan.py` and `doc_candidate_finder.py` when syncing changes) and assemble only the required squads and chroniclers from the **4 Doc Squads** (`references/heroes/doc-squads/`):
     - **🏛️ Doc Squad 1: Architecture & Decisions (`references/heroes/doc-squads/squad-1-architecture/`):**
       - Captain **`KEEPER OF THE LIGHT`** ([keeper-of-the-light.md](./references/heroes/doc-squads/squad-1-architecture/keeper-of-the-light.md)) | **`VOID SPIRIT`** ([void-spirit.md](./references/heroes/doc-squads/squad-1-architecture/void-spirit.md))
     - **📜 Doc Squad 2: Contracts & Recipes (`references/heroes/doc-squads/squad-2-contracts/`):**
       - Captain **`WARLOCK`** ([warlock.md](./references/heroes/doc-squads/squad-2-contracts/warlock.md)) | **`SHADOW SHAMAN`** ([shadow-shaman.md](./references/heroes/doc-squads/squad-2-contracts/shadow-shaman.md))
     - **🛠️ Doc Squad 3: Operations & Release (`references/heroes/doc-squads/squad-3-operations/`):**
       - Captain **`CHEN`** ([chen.md](./references/heroes/doc-squads/squad-3-operations/chen.md)) | **`OMNIKNIGHT`** ([omniknight.md](./references/heroes/doc-squads/squad-3-operations/omniknight.md)) | **`ZEUS`** ([zeus.md](./references/heroes/doc-squads/squad-3-operations/zeus.md))
     - **💎 Doc Squad 4: Language & Presentation (`references/heroes/doc-squads/squad-4-polish/`):** assembled for every prose document
       - Captain **`CRYSTAL MAIDEN`** ([crystal-maiden.md](./references/heroes/doc-squads/squad-4-polish/crystal-maiden.md)) | **`ENCHANTRESS`** ([enchantress.md](./references/heroes/doc-squads/squad-4-polish/enchantress.md))
   - Name the **Audience** for every document (who reads it, and whether they can open the repository) before any hero writes; for an existing document, list content the audience cannot use in the manifest.
   - For multi-section documents, buy the item **`AGHANIM'S SCEPTER`** ([aghanims-scepter.md](./references/items/aghanims-scepter.md)) and fix the **Document Outline** (body vs. appendix, reader-journey order, uniform chapter shape) before any hero writes; for an existing document, list outline deviations in the manifest instead of restructuring it.
2. **Stage 2 · Teamfight — Doc Squad Authoring:**
   - Read the assembled Doc Squad hero files in parallel and compose or surgically update the target documentation; `CRYSTAL MAIDEN` then polishes the wording and `ENCHANTRESS` formats the full draft last.
3. **Stage 3 · Deny — Filter `SILENCER`:**
   - Read [bot-lane-silencer.md](./references/commanders/bot-lane-silencer.md) and apply **Global Silence** to strip generic AI fluff, replace walls of text with Mermaid diagrams or Markdown tables, verify 100% accuracy against the codebase, purge content the audience cannot use (internal paths and class names for readers without repository access), keep each fact in one place, and replace secrets and personal data with fake placeholders. Append `🤫 SILENCED` listing unverified claims removed and `🔒 MASKED` listing values replaced (each only if any).

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

## Lane Pipelines
Once the lane is fixed, read its Stage 1 commander file first. It holds the lane's whole pipeline (squads, execution modes, manifest) and hands the draft or findings to its Stage 3 filter.

| Lane | Stage 1 · Assemble (read first) | Stage 2 · Teamfight | Stage 3 · Deny |
| :--- | :--- | :--- | :--- |
| 🔨 **Top Lane — Architectural Blueprint** | `ELDER TITAN` ([plan-elder-titan.md](./references/commanders/plan-elder-titan.md)) | 4 Plan Squads (`references/heroes/plan-squads/`) | `ANCIENT APPARITION` ([plan-ancient-apparition.md](./references/commanders/plan-ancient-apparition.md)) |
| 🔮 **Mid Lane — Progressive Code Review** | `ORACLE` ([review-oracle.md](./references/commanders/review-oracle.md)) | 6 Review Squads (`references/heroes/review-squads/`), Default or Deep Mode | `DOOM` ([review-doom.md](./references/commanders/review-doom.md)) |
| 📖 **Bot Lane — Documentation & Knowledge Sync** | `INVOKER` ([doc-invoker.md](./references/commanders/doc-invoker.md)) | 4 Doc Squads (`references/heroes/doc-squads/`) | `SILENCER` ([doc-silencer.md](./references/commanders/doc-silencer.md)) |

> **Strict Read-Only Guard (Mid Lane):** During code review, NEVER modify or overwrite any target project files automatically. Present `DOOM`'s verdict and wait for the user to explicitly specify which findings to apply.
>
> **Confirmation Guard (Top Lane):** Present the validated blueprint and wait for user confirmation before writing full implementation code.

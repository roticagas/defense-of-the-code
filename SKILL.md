---
name: defense-of-the-grid
description: >-
  ระบบวางผังเมืองและตรวจรับโค้ดแบบ Multi-Agent 3 ขั้นตอน (ORACLE คัดกรอง -> 6 ขุนพล Subagents ตรวจแยกมิติแบบขนาน -> DOOM ปัดตกความเห็นขยะ)
  บังคับใช้กฎเข็มทิศ 4 ทิศ, เส้นกราฟห้ามกระโดดข้ามบล็อก (Dominator DAG), ข้อยกเว้นชั้นหินดาน (Bedrock Utility),
  การตัดตอนรันแยกเดี่ยว (Screen-20 Isolation), แนวทางตั้งชื่อกระชับ (~2-3 คำ) และเรียงโค้ดบนลงล่างแบบสมมาตร
  ใช้เมื่อต้องการวางโครงสร้างก่อนเขียนจริง (/blueprint) หรือตรวจรีวิวโค้ด (/review)
---

# Defense of the Grid — Dota Architecture & Multi-Agent Code Review

You operate under a strict, pragmatic software engineering philosophy modeled as **City Planning & Graph Theory**. Never suggest textbook over-engineering, cargo-cult design patterns, or speculative edge cases.

> **Path Resolution Note:** All `./references/...` and `./scripts/...` links below are relative to the directory containing this `SKILL.md` file (NOT the target project's working directory). Always resolve their absolute paths from this skill's folder while running commands inside the target project's working directory.

## Core Reference (Mandatory Baseline)
Before executing any mode, read and internalize the 7 core laws in:
- [00-the-ancients-core-laws.md](./references/00-the-ancients-core-laws.md) (**THE ANCIENTS — Core Architecture Laws**)

---

## Operational Modes

### Mode A: `/blueprint` (Pre-Coding City Planning)
When the user asks to design, plan, or write a new feature:
1. Read [00-the-ancients-core-laws.md](./references/00-the-ancients-core-laws.md).
2. Present the proposed blueprint using this exact 3-part output template:
   - **🧭 1. 4-Compass Zone Map:** Partition responsibilities across **North (Orchestrator)**, **West (Inbound)**, **East (Outbound)**, **South (Persistence)**, and **Bedrock Utility** (`Fan-Out = 0`).
   - **📝 2. Top-Down Narrative Skeleton:** List the file/class structure with the public orchestrator at the top and subordinate `private` methods ordered in `1 -> 2 -> 3` execution sequence below it (with **A-to-Z Cross-Layer Symmetry** and concise **~2–3 word `snake_case` names** where natural).
   - **🧪 3. Screen-20 Isolation Contract:** Specify the exact explicit `self`/state payload required at the entry point so this node/screen can be tested or executed in complete isolation without running steps 1–19.
3. Wait for user confirmation ("Eureka moment") before generating full implementation code.

---

### Mode B: `/review` (3-Stage Multi-Agent Code Review)
When the user asks to review code, a PR, specific files, or `git diff`, execute the following 3 stages sequentially:

#### Stage 1: `ORACLE` (Triage Router)
1. Run [preflight_scan.py](./scripts/preflight_scan.py) from the target repository root and save a unified diff snapshot to your scratch folder so read-only Stage 2 subagents can inspect the exact changes:
   `python3 <skill_dir>/scripts/preflight_scan.py --dump-diff <scratch_dir>/current_review.diff [target_files...]`
2. Read [01-oracle-triage-router.md](./references/01-oracle-triage-router.md).
3. Select **only the necessary specialists (max 3–4)** from Stage 2 based on the actual changes. Always include `EARTHSHAKER` and `ARC WARDEN` as the mandatory baseline.
4. Output the 3-line **ORACLE Routing Manifest** (`Changed Zones`, `Preflight Alerts`, `Summoned Squad`) before spawning subagents.

#### Stage 2: Parallel Specialist Subagents (`invoke_subagent`)
**Do NOT review all specialist angles yourself in a single thread.** Instead, spawn one parallel read-only subagent per summoned hero in **a single tool-call turn** using `invoke_subagent`:

- **Subagent Configuration:**
  - `TypeName`: `"research"`
  - `Model`: `"inherit"`
  - `Role`: `"<HERO_NAME> — <Specialty>"` (e.g., `"EARTHSHAKER — Topology & Style"`)
- **Hero Reference Mapping:**
  - **EARTHSHAKER (Topology & Style):** [02-earthshaker-topology-style.md](./references/02-earthshaker-topology-style.md)
  - **ARC WARDEN (Contract & State):** [03-arc-warden-contract-state.md](./references/03-arc-warden-contract-state.md)
  - **WRAITH KING (Fault & Concurrency):** [04-wraith-king-fault-concurrency.md](./references/04-wraith-king-fault-concurrency.md)
  - **TEMPLAR ASSASSIN (Security & Hygiene):** [05-templar-security-hygiene.md](./references/05-templar-security-hygiene.md)
  - **TINKER (Scale & Trace):** [06-tinker-scale-trace.md](./references/06-tinker-scale-trace.md)
  - **RUBICK (Spec & Doc Sync):** [07-rubick-spec-doc-sync.md](./references/07-rubick-spec-doc-sync.md) *(Before summoning RUBICK, run `python3 <skill_dir>/scripts/doc_drift_finder.py` using [doc_drift_finder.py](./scripts/doc_drift_finder.py) and pass its output in RUBICK's prompt)*
- **Prompt Template for Each Subagent:**
  Provide each subagent with:
  1. The exact absolute paths to [00-the-ancients-core-laws.md](./references/00-the-ancients-core-laws.md) and its assigned hero reference file (`02`–`07`), instructing it to read both files first.
  2. The absolute path to `<scratch_dir>/current_review.diff` (so the `research` subagent can read the exact added/modified lines via `read_file`), the list of target files & changed line ranges, and any relevant output from `preflight_scan.py` / `doc_drift_finder.py`.
  3. Strict boundary instruction:
     > *"Inspect ONLY the checks defined in your hero reference file, focusing on the changed lines in `current_review.diff` and their integration with surrounding code. Remember Law 5 (~3-word naming) is a soft guideline, not a rigid rule. For every real issue found, report: `[HERO_NAME] file_path:line — Severity (BLOCKER or SHOULD_FIX) — Concrete failure/violation and proposed fix`. If you find no genuine issues within your domain, reply `NO_ISSUES_FOUND`—never invent nitpicks or textbook pattern suggestions."*

Wait for all summoned specialist subagents to complete and return their findings.

#### Stage 3: `DOOM` (Lead Filter / The Judge)
1. Read [08-doom-lead-filter.md](./references/08-doom-lead-filter.md).
2. Collect all raw findings returned by the Stage 2 subagents and apply **DOOM's Silence Filter** (drop speculative ghost stories, drop cargo-cult pattern suggestions, allow Bedrock Utility cross-layer calls, drop redundant comment nagging, drop pedantic 4-word naming nitpicks, and deduplicate overlapping hits).
3. Present the final consolidated review in Thai (with technical identifiers in English), omitting any empty section:
   - If zero `BLOCKER` or `SHOULD FIX` items survive: output **`🟢 ANCIENTS APPROVED`**
   - 🔴 **BLOCKER (ต้องแก้ก่อนขึ้นระบบ — พังแน่ / ผิดกฎป้อมปราการขั้นร้ายแรง)**
   - 🟡 **SHOULD FIX (ควรเกลา — ผังเมือง 4 ทิศ / กฎหน้าจอ 20 / ชื่อกระชับ ~3 คำ / เรียงโค้ด Notepad++ / พรางตัว Git)**
   - 🗺️ **RUBICK'S MAP SYNC (ไฟล์เอกสาร / Spec / Config ที่ต้องอัปเดตตาม)**

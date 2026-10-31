---
name: defense-of-the-grid
description: >-
  ระบบวางผังเมืองและตรวจรับโค้ดแบบ Progressive Skill 3 ขั้นตอน (ORACLE คัดกรองเลือกคัมภีร์ -> โหลดเฉพาะมุมมองขุนพลที่เกี่ยวข้อง -> DOOM ปัดตกความเห็นขยะ)
  บังคับใช้กฎเข็มทิศ 4 ทิศ, เส้นกราฟห้ามกระโดดข้ามบล็อก (Dominator DAG), ข้อยกเว้นชั้นหินดาน (Bedrock Utility),
  การตัดตอนรันแยกเดี่ยว (Screen-20 Isolation), แนวทางตั้งชื่อกระชับ (~2-3 คำ) และเรียงโค้ดบนลงล่างแบบสมมาตร
  ใช้เมื่อต้องการวางโครงสร้างก่อนเขียนจริง (/blueprint) หรือตรวจรีวิวโค้ด (/review หรือ /review deep)
---

# Defense of the Grid — Dota Architecture & Code Review Skill

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
   - **📝 2. Top-Down Narrative Skeleton:** List the file/class structure with the public orchestrator at the top and subordinate `private` methods ordered in `1 -> 2 -> 3` execution sequence below it (with **A-to-Z Cross-Layer Symmetry** and concise **~2–3 word names** following the project's existing casing or language best practice, favoring `snake_case` when unconstrained).
   - **🧪 3. Screen-20 Isolation Contract:** Specify the exact explicit `self`/state payload required at the entry point so this node/screen can be tested or executed in complete isolation without running steps 1–19.
3. Wait for user confirmation ("Eureka moment") before generating full implementation code.

---

### Mode B: `/review` (3-Stage Progressive Code Review)
When the user asks to review code, a PR, specific files, or `git diff`, execute the following 3 stages sequentially:

#### Stage 1: `ORACLE` (Triage Router)
1. Run [preflight_scan.py](./scripts/preflight_scan.py) from the target repository root (automatically falls back to `HEAD~1..HEAD` if working tree is clean):
   `python3 <skill_dir>/scripts/preflight_scan.py [target_files...]`
2. Read [01-oracle-triage-router.md](./references/01-oracle-triage-router.md).
3. Select **only the necessary specialist lenses (max 3–4)** from Stage 2 based on the actual changes. Always include `EARTHSHAKER` and `ARC WARDEN` as the mandatory baseline.
4. Output the 3-line **ORACLE Routing Manifest** (`Changed Zones`, `Preflight Alerts`, `Summoned Squad`).

#### Stage 2: Specialist Inspection (Progressive Skill Loading by Default)
Load the reference files **ONLY** for the heroes summoned by `ORACLE` (leave unpicked hero files unread to keep your context sharp and focused):
- **EARTHSHAKER (Topology & Style):** [02-earthshaker-topology-style.md](./references/02-earthshaker-topology-style.md)
- **ARC WARDEN (Contract & State):** [03-arc-warden-contract-state.md](./references/03-arc-warden-contract-state.md)
- **WRAITH KING (Fault & Concurrency):** [04-wraith-king-fault-concurrency.md](./references/04-wraith-king-fault-concurrency.md)
- **TEMPLAR ASSASSIN (Security & Hygiene):** [05-templar-security-hygiene.md](./references/05-templar-security-hygiene.md)
- **TINKER (Scale & Trace):** [06-tinker-scale-trace.md](./references/06-tinker-scale-trace.md)
- **RUBICK (Spec & Doc Sync):** [07-rubick-spec-doc-sync.md](./references/07-rubick-spec-doc-sync.md) *(If summoned, also run `python3 <skill_dir>/scripts/doc_drift_finder.py` using [doc_drift_finder.py](./scripts/doc_drift_finder.py))*

**Execution Modes for Stage 2:**
- **⚡ Default Mode (`/review` — In-Context Progressive Skill):**
  Read the selected hero reference files (`02`–`07`) directly in the main agent and evaluate the changed code through each summoned hero's checklist while preserving full conversation context.
- **🔬 Deep / Fresh-Eyes Mode (`/review deep` — Parallel Subagents, ONLY when explicitly requested by user):**
  If the user explicitly asks for `/review deep`, "fresh eyes", or "แยก subagent":
  1. Re-run `preflight_scan.py` with `--dump-diff <scratch_dir>/current_review.diff`.
  2. Spawn one parallel `invoke_subagent` (`TypeName: "research"`, `Model: "inherit"`) per summoned hero in a single turn.
  3. Pass each subagent: (a) a 1–2 sentence **Conversation Context Summary**, (b) absolute paths to `00-the-ancients-core-laws.md` and its hero reference file, (c) the path to `<scratch_dir>/current_review.diff`, and (d) strict instructions to reply `NO_ISSUES_FOUND` if clean.

#### Stage 3: `DOOM` (Lead Filter / The Judge)
1. Read [08-doom-lead-filter.md](./references/08-doom-lead-filter.md).
2. Filter all raw findings from Stage 2 through **DOOM's Silence Filter** (drop speculative ghost stories, drop cargo-cult pattern suggestions, allow Bedrock Utility cross-layer calls, drop redundant comment nagging, drop pedantic 4-word/casing nitpicks, and deduplicate overlapping hits).
3. Present the final consolidated review in Thai (with technical identifiers in English), omitting any empty section:
   - If zero `BLOCKER` or `SHOULD FIX` items survive: output **`🟢 ANCIENTS APPROVED`**
   - 🔴 **BLOCKER (ต้องแก้ก่อนขึ้นระบบ — พังแน่ / ผิดกฎป้อมปราการขั้นร้ายแรง)**
   - 🟡 **SHOULD FIX (ควรเกลา — ผังเมือง 4 ทิศ / กฎหน้าจอ 20 / ชื่อกระชับ ~3 คำ / เรียงโค้ด Notepad++ / พรางตัว Git)**
   - 🗺️ **RUBICK'S MAP SYNC (ไฟล์เอกสาร / Spec / Config ที่ต้องอัปเดตตาม)**

# DIFFUSAL BLADE — Anti-Slop & High-Signal Catalog (Shared Item, bought by ELDER TITAN for Blueprints, DOOM for Review Reports, and INVOKER for CRYSTAL MAIDEN and SILENCER)

One shared catalog of AI slop and padding patterns so all three lanes purge fluff, over-explaining, and robotic phrasing. **ELDER TITAN** buys it when authoring blueprints, **DOOM** when filtering review findings, and **INVOKER** for **CRYSTAL MAIDEN** and **SILENCER** on every technical document.

## 1. Slop Antipattern Catalog

| Antipattern | Signal / Bad Pattern (AI Slop) | Clean High-Signal Pattern (Unslopped) |
| :--- | :--- | :--- |
| **Dual-Language Echoes** | Translating a phrase to Thai and immediately echoing the English term in parentheses (`ประกาศปลดระวาง (Sunset Notice)`, `ถูกยกเลิกการให้บริการ (Removed)`, `การเปลี่ยนผ่าน (Migration)`). | Pick the single natural technical term the team uses without redundant translation echo: `⚠️ Sunset Notice: Endpoint ต่อไปนี้ถูกยกเลิกใน v2`. |
| **Pedagogical Lecturing** | Tutoring basic CS/programming concepts engineers already know, explaining why a string cannot cast to an int, or pasting 36-character dummy UUIDs (`"a1b2c3d4-e5f6-7890-abcd-ef1234567890"`) into prose. | State the technical delta directly: `invoiceHdrId: int -> UUID (Breaking Change)`. |
| **Corporate Policy Fluff** | Empty administrative justifications and management buzzwords that carry zero technical constraints or caller actions (*"การรวมศูนย์มาตรฐาน API: ผลักดันการจัดการทั้งหมดเข้าสู่สถาปัตยกรรม v2"*, *"In order to provide enterprise-grade synergy..."*). | Delete completely. Document only observable behavior, technical constraints, and caller action items. |
| **Unnatural Literal Translation** | Translating established software terms into rigid, robotic Thai (*"เส้นทางบริการ"* for endpoint/route, *"สระการเชื่อมต่อ"* for connection pool, *"ลายเซ็นฟังก์ชัน"* for function signature). | Use industry-standard technical terms directly: `Endpoint`, `Connection Pool`, `Function Signature`. |
| **Throat-Clearing Intro/Outro** | Preamble paragraphs and summarizing conclusions (*"In modern distributed architectures, it is crucial to..."*, *"This document provides a comprehensive overview of..."*, *"In conclusion, these changes ensure..."*). | Delete completely. Start immediately with concrete system facts, tables, or architecture diagrams. |

## 2. How Each Lane Uses It

- **🔨 Top Lane (`ELDER TITAN` & `ANCIENT APPARITION`):** Keep architecture blueprints, ADR rationales, and schemas stripped of corporate buzzwords, throat-clearing preambles, and pedagogical tutorials. State module boundaries, contracts, and trade-offs directly.
- **🔮 Mid Lane (`DOOM`):** Keep review findings and blocker descriptions crisp, factual, and actionable. Point directly to file, line, and hazard without lecturing on basic programming principles or conversational filler.
- **📖 Bot Lane (`INVOKER` → `CRYSTAL MAIDEN` & `SILENCER`):** `CRYSTAL MAIDEN` purges catalog antipatterns while polishing draft prose. `SILENCER` enforces the catalog under Rule 1 as the final gate before presenting or writing any documentation.

## 3. The Unslop Rule: Signal Over Story

If a sentence or phrase does not specify:
1. **Observable behavior or contract** (what the system guarantees)
2. **Technical delta** (what specifically changed)
3. **Actionable caller instructions** (what the engineer or caller must do)

...and instead explains basic theory, tells a narrative backstory, or justifies administrative policy $\rightarrow$ **PURGE IT**.

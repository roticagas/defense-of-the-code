# TOME OF KNOWLEDGE — Post-Flight Talkback & Co-Evolution (Shared Item, bought by ANCIENT APPARITION, DOOM, and SILENCER at Stage 3)

**ANCIENT APPARITION** (Top Lane), **DOOM** (Mid Lane), and **SILENCER** (Bot Lane) buy this item at the end of Stage 3 when the task is non-trivial. Its goal is two-way engineering dialogue: surfacing blind spots, checking design intent, and sharing systemic takeaways so both the user and the codebase improve together across runs.

Skip this item entirely for trivial Surgical Edits, single-line fixes, or runs where nothing meaningful remains to discuss.

## 1. The Middle Path (High-Signal Dialogue Only)
1. **Zero Filler:** Never invent bullets to populate this section. If no real stress point, borderline intent, systemic pattern, or knowledge gap exists, **omit the entire section**.
2. **Concise & Distinct:** Limit to **1–3 concise bullets** in the **user's conversation language** (keeping technical terms and code identifiers in English). Never repeat findings or warnings already stated above.
3. **No Basic Lecturing (`DIFFUSAL BLADE` Applies):** Discuss architecture, trade-offs, design intent, and systemic patterns—never tutor basic syntax or textbook CS concepts.

## 2. How Each Lane Uses It (Stage 3 Output)
Append **`📘 TOME OF KNOWLEDGE · Post-Flight Talkback`** at the end of Stage 3's output, tailored to the lane:

- **🔨 Top Lane (`ANCIENT APPARITION`):**
  - **Stress Point:** The single weakest link or scaling/requirement boundary where the blueprint would break first if real-world assumptions shift.
  - **Open Question:** 1 concrete question to check with the user before writing implementation code (e.g., an edge-case behavior, fallback preference, or operational trade-off not covered at Pre-Flight).
- **🔮 Mid Lane (`DOOM`):**
  - **Intent Check:** Any borderline design choice (not severe enough for `BLOCKER`, or an unconventional pattern) where asking the author's intent prevents wrong assumptions (e.g., *"ตรง X ตั้งใจเลือก pattern นี้เพื่อรับ constraint Y อยู่หรือเปล่า?"*).
  - **Systemic Takeaway:** 1 codebase-level or architectural pattern worth noting from this diff (a recurring coupling, boundary trend, or reusable strength), inviting the user to align on whether to standardize or adjust it. *(Respects Strict Read-Only Guard: never edits files.)*
- **📖 Bot Lane (`SILENCER`):**
  - **Knowledge Gap (The Missing "Why"):** Beyond `❓ QUESTIONED` (which checks whether an existing section earns its place), pinpoint 1–2 undocumented business rules, magic thresholds, or implicit contracts in the code whose *rationale* could not be verified from source files alone—so the user can supply the "Why" to complete the document.

## 3. Whole-Repo Audit (`audit-all-lanes.md`)
When running the 3-Lane All-Lane Audit, run **`TOME OF KNOWLEDGE`** once at the end of the final report (after Part 3, instead of repeating it per phase) with **1–2 strategic discussion prompts** (where to prioritize fixes vs. which architectural debt to defer intentionally).

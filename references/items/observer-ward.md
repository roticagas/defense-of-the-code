# OBSERVER WARD — Pre-Flight Decision Fork & Assumption Check (Top Lane — Plan: Item, bought by ELDER TITAN)

**ELDER TITAN** buys this item at Stage 1 (after **`GEM OF TRUE SIGHT`** and scope calibration) when the blueprint scope is **Standard Feature** or **Large / Cross-Boundary Feature**, or whenever the user explicitly asks to discuss options first (*"คุยก่อน"*, *"discuss"*, *"sparring"*). Skip it for unambiguous **Surgical Edits** and for **Whole-Repo / Reverse Architecture Discovery** (`audit-all-lanes.md`).

Designing a full blueprint on top of an unverified constraint or the wrong side of an architectural fork wastes Stage 2 and Stage 3. One short decision check before assembling squads aligns the user and the architect on trade-offs first.

## 1. When to Stop & Ask (The Middle Path)

1. **Do NOT stop and ask when:**
   - Only one viable architectural path exists, or the codebase/conversation already dictates the pattern.
   - The choice is a trivial implementation detail or naming preference easily changed later.
   - The run is non-interactive or headless (in that case, state the chosen defaults and assumptions on the manifest's **Alignment** line marked `assumed`, and proceed).
2. **Stop and ask BEFORE Stage 2 (`Teamfight`) ONLY when at least one holds:**
   - **Architectural Fork:** 2 or more credible designs exist with meaningfully different trade-offs (e.g., sync vs. async processing, extending an existing collaborator vs. introducing a new module axis, strict vs. eventual consistency, backward-compatible vs. breaking wire contract).
   - **Unverified High-Impact Constraint:** A constraint absent from the codebase and conversation materially changes the blueprint (e.g., expected scale/latency budget, legacy caller compatibility, auth/tenant boundary, rollout window).
   - **Explicit Request:** The user asked to talk through options first (*"คุยก่อน"*, *"discuss"*, *"sparring"*).

## 2. Decision Card Format (1–3 Questions Max)

Keep the check high-signal and scannable in the **user's conversation language** (technical terms and code identifiers in English), stripped of filler (`DIFFUSAL BLADE` rules apply). Never ask vague open-ended questions (*"อยากให้ทำยังไงดี?"*); offer concrete options with trade-offs:

- Header: **`👁️ OBSERVER WARD · Pre-Flight Alignment`**
- **1 to 3 items maximum:**
  - **For an Architectural Fork:** state the fork in 1 line, list **A** vs **B** (each with 1-line behavior + trade-off), mark the recommended option `(แนะนำ)` / `(Recommended)`, and give a 1-line reason grounded in the codebase or context.
  - **For an Unverified High-Impact Constraint:** state your best assumption in 1 line and ask the user to confirm or correct it.
- End with a short reply hint (e.g., *"ตอบเป็นข้อ เช่น `1A, 2 ใช่` หรือพิมพ์ `ตามที่แนะนำ` เพื่อเข้า Stage 2 ต่อทันที"*).
- **Wait for the user's reply** before entering Stage 2 (`Teamfight`).

## 3. Carry Alignment Through
- **Manifest:** Record settled choices (or `no forks — codebase convention applied`) on the manifest's **Alignment** line.
- **Stage 2 & Stage 3:** Every assembled Plan hero designs to that alignment, and **`ANCIENT APPARITION`** verifies the final blueprint honors every confirmed decision and constraint.

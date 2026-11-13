# All-Lane Orchestrator — Whole-Repo Architecture & Health Audit

You coordinate the **All-Lane Whole-Repo Audit** pipeline across Top Lane, Mid Lane, and Bot Lane. This pipeline addresses the "Review Without Requirements" dilemma by first extracting the codebase's inferred architecture and system invariants before reviewing code and checking documentation drift.

```
Codebase / Target Directory
    │
    ▼
Phase 1 · Top Lane (ELDER TITAN & Plan Squads)
    └── Reverse Architecture Discovery: 4-Axis Topology, Dependency DAG, State Boundaries
    └── Output: System Invariants Baseline (The System's Purpose & Operational Rules)
    │
    ▼
Phase 2 · Mid Lane (ORACLE, Review Squads & DOOM)
    └── Architectural & Code Quality Audit against Phase 1 Invariants
    └── DOOM's Whole-Repo Silence Filter (waives untouched-line ban, prunes trivial nitpicks)
    └── Output: Verified BLOCKER & SHOULD FIX Findings
    │
    ▼
Phase 3 · Bot Lane (INVOKER, Doc Squads & SILENCER)
    └── Knowledge & Spec Drift Radar: Phase 1 Baseline + Phase 2 Findings vs. Existing Docs
    └── Output: Stale Docs, Undocumented Critical Invariants & Actionable Sync Plan
```

---

## 0. Preflight Scan
Run the scanner across the whole repository:
`python3 <skill_dir>/scripts/preflight_scan.py --all`
(or target a specific subsystem directory: `python3 <skill_dir>/scripts/preflight_scan.py <dir>`).
Record detected `[LAW-3 VIOLATION]` or `[CROSS-VERSION HAZARD SIGNAL]` warnings in the manifest.

---

## Phase 1 · Top Lane: Architecture & Invariant Discovery
Commander: **`ELDER TITAN`** ([plan-elder-titan.md](./plan-elder-titan.md))  
Assembled Squads: **Plan Squad 1** (`DARK SEER`, `KUNKKA`), **Plan Squad 2** (`TINY`, `ENIGMA`), and **Plan Squad 4** (`VIPER`).

Instead of planning a forward feature, ELDER TITAN performs **Reverse Architecture Discovery**:
1. **Purpose Check (`GEM OF TRUE SIGHT`):** Identify what the repository is built to do, its target audience, and primary execution model (CLI, HTTP API, event worker, library) from `README.md`, package manifests (`package.json`, `build.sbt`, `Cargo.toml`, `pyproject.toml`), and entry-point files.
2. **4-Axis Topology Mapping (Law 1 & Law 2):**
   - **Ingress:** Controllers, routes, CLI entry-points, queue listeners.
   - **Domain Core:** Pure domain entities, business calculations, state machines.
   - **Flow Orchestrator:** Application services, use-cases, workflow coordinators.
   - **Egress:** Database repositories, external HTTP/RPC clients, message producers.
   - **Leaf Utilities (Law 3):** Shared helpers (`util/`, `common/`); verify they do not import domain/state layers (`Fan-Out = 0`).
3. **State & Boundary Contracts (Law 4 & Law 7):**
   - Identify where state transitions occur, whether state is immutable, and where transactional boundaries are drawn.
   - Trace authentication/authorization Dominator Gatekeepers and tenant isolation layers.
4. **Phase 1 Synthesis Deliverable:** Output the **System Invariants Baseline** — a concise, numbered summary of architectural invariants that this codebase is supposed to uphold. This baseline serves as the explicit requirements ("โจทย์") for Phase 2 and Phase 3.

---

## Phase 2 · Mid Lane: Architectural & Code Quality Audit
Commander: **`ORACLE`** ([review-oracle.md](./review-oracle.md)) $\rightarrow$ Arbiter: **`DOOM`** ([review-doom.md](./review-doom.md))  
Assembled Squads: **Review Squad 1** (`EARTHSHAKER`), **Squad 2** (`ARC WARDEN`, `FACELESS VOID`), **Squad 3** (`WRAITH KING`, `WEAVER`), and **Squad 4** (`TEMPLAR ASSASSIN`, `SHADOW FIEND`).

Evaluate the codebase against the 7 Ancient Laws and the Phase 1 Invariants Baseline:
1. **Architecture & Topology Check (Squad 1):** Check for cyclic dependencies across modules, direct cross-axis coupling bypassing orchestrators, and utility fan-out leaks.
2. **State & Contract Check (Squad 2):** Check for shared mutable state hazards, unintended side effects, and boundary unwrapping risks (`Option.get`, unchecked nil/null dereferences).
3. **Fault & Concurrency Check (Squad 3):** Check for swallowed errors, unhandled async failures, missing timeouts/circuit breakers on egress calls, and missing DB rollback boundaries.
4. **Security & Hygiene Check (Squad 4):** Check for injection vulnerabilities, broken access controls (IDOR), hardcoded secrets/credentials, and unredacted PII in loggers.
5. **DOOM's Whole-Repo Silence Filter:**
   - **Waive Rule 6's untouched-line ban:** Code throughout the target scope is audited.
   - **High-Signal Filter:** DOOM ruthlessly drops trivial nitpicks (minor whitespace, 4-word identifier complaints on clean code, pedantic casing suggestions, and docstring boilerplate).
   - Only confirmed or plausible **Architectural Invariants (Laws 1–7)**, **Security Vulnerabilities**, and **Critical Resilience Defects** survive.

---

## Phase 3 · Bot Lane: Knowledge & Spec Drift Radar
Commander: **`INVOKER`** ([doc-invoker.md](./doc-invoker.md)) $\rightarrow$ Arbiter: **`SILENCER`** ([doc-silencer.md](./doc-silencer.md))  
Assembled Squads: **Doc Squad 1** (`KEEPER OF THE LIGHT`, `VOID SPIRIT`), **Doc Squad 2** (`WARLOCK`), and **Doc Squad 3** (`CHEN`).

Compare the Phase 1 Invariants Baseline and Phase 2 Audit Findings against existing project documentation:
1. **Doc Discovery:** Run `python3 <skill_dir>/scripts/doc_candidate_finder.py` to identify all existing documentation, specs, and configurations (`README.md`, `docs/`, `ADR`, OpenAPI/Swagger, `.env.example`).
2. **Drift & Gap Identification:**
   - **Stale Documentation:** Documented APIs, architecture flows, or environment variables that no longer match actual code behavior.
   - **Undocumented Critical Invariants:** High-risk domain rules, security requirements, or transactional invariants uncovered in Phase 1 & 2 that lack any documentation.
   - **Missing Operational Guides:** Missing onboarding setup steps, missing runbook alerts, or absent `.env.example` keys.
3. **Actionable Sync Plan:** Formulate exact file-by-file update recommendations and outline any new ADRs or Architecture sections needed.

---

## Final Output Structure
Present the complete Whole-Repo Audit report in the user's conversation language (technical terms and code identifiers in English), concise and direct (powered by **`DIFFUSAL BLADE`**):

```markdown
# 🏰 WHOLE-REPO ARCHITECTURE & HEALTH AUDIT

## 🗺️ Part 1 · As-Is Architecture & Invariants Baseline (Top Lane)
- **System Purpose & Execution Model:** [1–2 sentences]
- **4-Axis Topology Map:**
  - *Ingress:* [Key entry points]
  - *Domain Core:* [Entities and core business logic]
  - *Flow Orchestrator:* [Coordination services]
  - *Egress:* [Data persistence and external gateways]
  - *Leaf Utilities:* [Common/util modules and fan-out verification]
- **Core Invariants ("โจทย์ของระบบ"):**
  1. [Invariant 1 — e.g. Tenant isolation boundary]
  2. [Invariant 2 — e.g. Transaction atomicity contract]
  3. [Invariant 3 — e.g. Stateless leaf utility rule]

## ⚔️ Part 2 · Architectural & Code Health Audit (Mid Lane — DOOM Verdict)
### 🔴 BLOCKER (Critical Violations / Security Risks / Severe Architectural Faults)
- `[HERO]` `file_path:line` · `CONFIRMED`|`PLAUSIBLE` — Root cause scenario, violated invariant, and concrete fix.

### 🟡 SHOULD FIX (Topology Leaks / State Hazards / Fault Gaps)
- `[HERO]` `file_path:line` · `CONFIRMED`|`PLAUSIBLE` — Architectural smell, boundary risk, and suggested refactoring.
*(Omit any section that has zero surviving items. If none, output: 🟢 ALL ANCIENT LAWS SATISFIED)*

## 📖 Part 3 · Documentation & Knowledge Sync Radar (Bot Lane — SILENCER)
- **Stale Documentation:** [List of docs that describe obsolete code or config]
- **Undocumented Critical Invariants:** [List of critical rules with no documentation]
- **Action Plan:** [Exact files to update or create, e.g. ARCHITECTURE.md, ADR, or README sync]
```

# MANTA STYLE — Intra-Class Layering & Sibling Symmetry (Shared Item, bought by ELDER TITAN for KUNKKA/TINY and ORACLE for EARTHSHAKER/MAGNUS)

One shared structural standard for multi-flow classes (`UseCase`, `Service`, `Controller`) so blueprints and code reviews enforce clean intra-class layering, unified pipelines, and symmetric sibling methods. **ELDER TITAN** buys it when designing a multi-flow class or pipeline refactor; **ORACLE** buys it when reviewing a multi-flow class or pipeline refactor.

## 1. The Four Structural Rules

1. **Intra-Class Layering & Visibility Funnel (Proportional, Not Fixed-Count):**
   - Stratify the class top-to-bottom into clear abstraction layers separated by section banners (e.g., `Entry Points` $\rightarrow$ `Dispatch / Adapters` $\rightarrow$ `Core Pipeline` $\rightarrow$ `Helpers`, or however many layers the domain genuinely requires).
   - Narrow visibility as depth increases: keep `public` strictly for external entry points, `private[package]` for internal triggers/adapters/predicates that package tests verify directly, and `private` for the core pipeline and helpers.
2. **Pipeline Unification (Enum + Optional Overrides):**
   - When 2+ sibling flows execute the same underlying pipeline (differing only in action type, dispatch mode, or a few optional overrides), unify them into one parameterized `private` core pipeline driven by strongly typed enums (`DispatchType`, `EmailAction`) and `Option` overrides—never duplicate the pipeline across separate methods.
3. **Sibling Method Symmetry:**
   - Parallel methods at the same layer (e.g., `*IfNeeded` triggers or `should*` predicates) must share the same control-flow shape, error-handling boundary (e.g., outer `try/catch (NonFatal)` vs `Try`), and visibility level so readers never encounter gratuitous structural drift between siblings.
4. **Pure Model Predicates & Unwrap Once:**
   - Place single-model field checks (`valid*`, `has*`, `should*` with `Fan-Out = 0`) on the data model itself—keep gateway/I/O checks in the use case/service.
   - Validate and unwrap `Option` or raw inputs once at the entry/caller layer and pass the typed, validated value down; never re-unwrap or re-validate the same field in lower layers.

## 2. How Each Lane Uses It

- **🔨 Top Lane (`ELDER TITAN` $\rightarrow$ `KUNKKA`, `TINY`):**
  - `KUNKKA` structures the Part 2 skeleton into named intra-class layer banners with progressive visibility narrowing, collapses shared flows into one parameterized core, and mirrors sibling method shapes.
  - `TINY` places pure field predicates (`valid*`, `has*`) on the domain model (`Fan-Out = 0`) and ensures entry-validated values flow down without redundant unwrapping.
- **🔮 Mid Lane (`ORACLE` $\rightarrow$ `EARTHSHAKER`, `MAGNUS`):**
  - `EARTHSHAKER` flags duplicated multi-flow pipelines that should collapse into a parameterized core, redundant unwrapping in lower layers, and `public` internal methods that belong in `private[package]` or `private`.
  - `MAGNUS` flags asymmetric sibling methods in the same layer (mismatched `try/catch` placement, divergent control-flow shape, or methods placed in the wrong intra-class layer).

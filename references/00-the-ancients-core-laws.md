# THE ANCIENTS — Core Architecture & Engineering Laws

These 7 principles define the architectural invariants of the codebase. Every review and blueprint must enforce these principles while rejecting speculative over-engineering (YAGNI).

## Law 1: Orthogonal Decomposition (4-Axis + Core Partitioning)
- **Avoid Monolithic Services:** Partition module responsibilities along orthogonal functional axes (**up to 4 Peripheral Axes + 1 optional `Core/Center` Coordinator**).
- **High Cohesion, Single Axis of Responsibility:** What each axis represents adapts to the system's domain (e.g., flow orchestration, ingress, egress, persistence, or distinct sub-domains). Once partitioned, each zone must strictly operate within its own abstraction level without bleeding responsibilities into adjacent zones.

## Law 2: Acyclic Call Topology & Dominator Enforcement (Strict DAG)
- **Directed Acyclic Graph (DAG):** The dependency and call graph across modules must remain strictly acyclic. Circular dependencies (`A -> B -> A`) are forbidden.
- **Dominator Vertex Enforcement:** Higher-level modules must never bypass intermediate control layers (Dominator vertices) to invoke lower-level modules directly. Routing all cross-layer transitions through designated gatekeepers preserves a single choke point for policy enforcement, instrumentation, and test doubles.

## Law 3: Leaf-Node Pure Utilities (`Fan-Out = 0` Invariant)
- **Stateless Leaf Modules:** Pure, deterministic helper functions belong in the leaf utility layer (`util/`, `common/`).
- **Unrestricted Fan-In (`In-Degree ≥ 0`):** Any architectural zone may invoke leaf utilities directly without violating Law 2.
- **Zero Fan-Out (`Out-Degree = 0`):** Leaf utilities must remain 100% stateless and side-effect-free. They must NEVER import, reference, or invoke domain services, controllers, stateful managers, or persistence repositories.

## Law 4: Subgraph State Isolation & Explicit Context Injection
- **Zero Sequential Coupling:** No module, service, or UI view/controller may rely on hidden global singletons or implicit state mutated by prior execution steps (`Steps 1..N-1`).
- **Explicit Context Injection:** Every component must declare its required state context explicitly at its entry interface (e.g., constructor injection, explicit state parameters, or `self` context struct) so any arbitrary node $N$ in the execution graph can be instantiated, tested, or executed in complete isolation.

## Law 5: Lexical Conciseness (~2–3 Lexemes) & Idiomatic Casing Hierarchy
- **Lexical Conciseness Guideline:** Aim for function, method, and variable identifiers composed of **roughly 2 to 3 core lexemes (words)**. Treat >3 core words as a *Single-Responsibility smell detector* rather than a rigid cap: if an identifier is verbose because the function performs multiple tasks, decompose the function; if 4 words are required for domain precision (or test scenario descriptions), permit them.
- **Casing Priority Hierarchy (Strict Precedence):**
  1. **Local Module Convention First (Law 7):** Match the casing style already established in the target file or module.
  2. **Language / Ecosystem Idiom Second:** Follow the canonical style of the language and symbol kind (e.g., `camelCase` methods in Java/TS/JS/Dart/Go, `PascalCase` in C#/types, `snake_case` in Python/Rust/C/SQL).
  3. **Favor `snake_case` When Unconstrained:** Where the language or medium permits free choice (e.g., C, shell/scripts, SQL schemas, config keys), prefer `snake_case` for optimal visual word separation.

## Law 6: Linear Execution Ordering (Stepdown Rule) & Structural Symmetry
- **Top-Down Stepdown Rule:** Place the primary public entry/orchestrator method at the top of the file or class. Order all subordinate `private`/helper methods beneath it in the exact `1 -> 2 -> 3` chronological sequence in which they are invoked, enabling linear top-to-bottom reading without vertical jumping.
- **Cross-Layer Structural Symmetry:** When an upper layer maps, validates, or dispatches a set of fields/operations `A..Z` into a lower layer, the lower layer must declare and process `A..Z` in the exact same lexicographical or positional order so missing or orphaned elements are immediately apparent.

## Law 7: Contextual Stylistic Homogeneity
- **Seamless Local Integration:** Any newly added or modified method within an existing file must match the vocabulary, abstraction granularity, and error-handling conventions of its surrounding methods so the module reads as if authored by a single mind.

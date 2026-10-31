# THE ANCIENTS — Core Architecture & Philosophy Laws

These 7 laws represent the non-negotiable architectural DNA of the system. Every agent must enforce these rules while rejecting textbook ceremony.

## Law 1: The 4-Directional Compass (Service Zoning)
Never let the Service layer become a monolithic dumping ground. Partition logic into 4 clear directions:
- **⬆️ North (Orchestrator / Flow Control):** Directs execution flow only. Calls West, East, and South in sequence. Must NEVER contain low-level SQL/query building, string manipulation, or HTTP protocol formatting.
- **⬅️ West (Inbound / Driving Boundary):** Handles incoming requests, payload parsing, and boundary validation before entering the core flow.
- **➡️ East (Outbound / External Gateway):** Isolates all communication with external third-party APIs, payment/hardware gateways, or message queues.
- **⬇️ South (Foundation / Persistence):** Manages internal database repositories, schemas, and storage state.

## Law 2: Strict DAG & Dominator Nodes (No Layer Jumping)
- Treat the call graph as a strict **Directed Acyclic Graph (DAG)**. Circular dependencies between modules or layers are strictly forbidden.
- **Respect Dominator Nodes:** Upper layers must never bypass intermediate control blocks to call lower layers directly (even if bypassing looks shorter). Every call must pass through the designated middle gatekeeper so logging, interception, and mocking have a single choke point.

## Law 3: The Bedrock Utility Exception (Underground Infrastructure)
- Pure helper functions that do not fit directional business layers belong in the **Bedrock Utility** layer.
- **Unrestricted Fan-In:** Any layer (North, South, East, West) is explicitly permitted to call Bedrock Utilities directly without violating Law 2.
- **Zero Fan-Out (Strict Constraint):** Bedrock Utilities must be 100% stateless and pure. They must NEVER import, reference, or call any business service, domain state, or database repository (`Fan-Out = 0`).

## Law 4: Screen-20 Isolation & Explicit `self` (Subgraph Testability)
- Like passing an explicit `struct *self` pointer in C or spawning an independent clone, every module, service, or UI screen/controller must declare its required state explicitly at its entry point.
- **No Sequential Coupling:** Never rely on hidden global state or implicit side effects left behind by steps 1 through 19. Any engineer or test runner must be able to jump directly into Node/Screen 20, inject a mock state payload, and execute or TDD it in complete isolation.

## Law 5: The 3-Word Naming Rule & Visual Spacing
- Function, method, and variable names must express their complete intent in **at most 3 words** (favoring `snake_case` for visual word separation where permitted by the stack).
- If a function cannot be named accurately in 3 words or fewer, it is doing too much or sitting in the wrong directional zone—split it or move it.

## Law 6: Notepad++ Spatial Ergonomics (Top-Down & A-to-Z Symmetry)
- **Top-Down Narrative Flow:** Place the primary public orchestrator method at the very top of the file/class. Order all subordinate `private` methods beneath it in the exact `1 -> 2 -> 3` sequence in which they are called, allowing top-to-bottom reading without scrolling back and forth.
- **Cross-Layer A-to-Z Symmetry:** When an upper layer calls or maps items `A` through `Z` into a lower layer, the lower layer must declare and handle `A` through `Z` in the exact same order so missing or orphaned items are immediately visible to the naked eye.

## Law 7: Git-Blame Camouflage (Seamless Integration)
- Any newly added or modified method inside an existing file must adopt the exact vocabulary, abstraction granularity, and error-handling rhythm of its neighboring methods.
- **Success Criteria:** A reader inspecting the file without opening `git diff` or `git blame` must not be able to guess which method was recently bolted on.

# AGHANIM'S SCEPTER — Document Outline Upgrade (Bot Lane — Doc: Item, bought by INVOKER)

**INVOKER** buys this item only for a multi-section document: one with a table of contents or 3+ top-level sections (specs, handbooks, multi-chapter API docs). Single-purpose outputs (PR descriptions, `CHANGELOG.md` entries, a single ADR or runbook) never need it.

The heroes author sections in parallel and none of them owns the whole document, so INVOKER fixes the skeleton with these rules before any hero writes:
1. **Body vs. Appendix:** Material readers look up from several chapters rather than read in sequence (schema/object dictionaries, code lists, error catalogs, legacy or out-of-scope endpoints) moves to an appendix, and the body chapters link to it.
2. **Reader-Journey Order:** Order body chapters by the audience's (INVOKER §3) actual sequence (e.g., for an API consumer: Authentication & Standards → Endpoint Summary → each Action), not by implementation history or version.
3. **Uniform Chapter Shape & Clean Headings:** Chapters of the same kind share one sub-heading set (e.g., every endpoint chapter: `Overview` → `Request Definition` → `Response Definition`), and their titles follow one convention (all include `METHOD /path`, or none do). **No dual-language echoes in headings:** never name a heading with parenthesized translation echoes (e.g., `4. แนวทางการย้ายระบบ (Migration Guide)` ❌). Pick the single natural technical term or phrase the team uses: either Thai or English without parenthetical echo (e.g., `4. v1 Sunset & Migration` or `4. การย้ายระบบสู่ v2` ✔️).
4. **One Grouping Axis:** Group chapters by a single axis throughout (by function *or* by API version, never both). If the same title prefix repeats on 3+ chapters (e.g., `API Specification: ...`), promote it to one parent chapter and nest the rest beneath it.
5. **Coverage Matches Code:** Any endpoint summary or index lists exactly the routes found in code; endpoints intentionally left out are named in a one-line scope note.

**Existing documents:** When updating or syncing a document you did not author in this run, audit its outline against rules 1–5 and list each deviation in the manifest's **Outline** line (`<section> — <rule> — <proposed move>`). Do not restructure an existing document unless the user asks; edit only the affected sections (SILENCER rule 4).

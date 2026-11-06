# Authoring Rules — Changing the Skill Itself (Heroes, Items, Hero Kit)

Read this file only when adding, merging or retiring a hero, an item or a Hero Kit ability. A plan, review or documentation run never needs it; the runtime rules stay in `SKILL.md`.

## 1. Items (`references/items/`, `1 Item = 1 File`)
Commanders and heroes belong to one lane; an **item** is a procedure a Lane Commander buys and either uses itself or hands to a hero it assembles.
1. **When to make an item:** only for a procedure that (a) a lane needs for some tasks but not all, or (b) two or more lanes share. A rule one lane uses on every run stays in that commander's file; a specialist pass that writes content or findings is a hero, not an item.
2. **Buying condition:** an item file's first line names who may buy it and when (e.g., *bought by `INVOKER` only for multi-section documents*), and the item table in `SKILL.md` repeats it.
3. **6 inventory slots:** a Lane Commander carries at most 6 items. To add a 7th, merge or retire one first.
4. **Output goes in the manifest:** an item fills a line of the commander's manifest (`Purpose`, `Outline`) or a rule its Stage 3 filter applies. It never adds a stage.
5. **Not counted as heroes:** items sit outside the hero and squad totals and the zero-hero-overlap rule, so one item may serve several lanes.

## 2. Hero Kit (Passive / Active / Ultimate)
A hero's rules are grouped by **when they run**, so a Commander loads a hero for exactly the abilities the task triggers:
1. **🟢 Passive (exactly 1):** applies every time the hero is assembled.
2. **🔵 Active (1–3):** each names its trigger signal in the input (a diff pattern, a document feature) and runs only when that signal is present.
3. **🟣 Ultimate (0–1):** the hero's costliest move (runs a script, reads beyond the diff or the edited sections, or touches the whole document). It names its trigger and never runs otherwise.
4. **No filler:** never invent an ability to fill a slot; a hero without a real costly move has no Ultimate.
5. **Manifest:** the Commander lists each hero with the abilities it triggered, e.g. `SHADOW FIEND (Passive + Active 2)`.
6. **Shared → item:** when the same Passive appears on two or more heroes, move it into an item.

Heroes not yet converted keep their numbered rule list, and every rule in it applies whenever the hero is assembled.

## 3. Heroes & Squads
- **One source for each roster:** a lane's heroes, their files and when to assemble them are listed only in that lane's commander file (`plan-elder-titan.md` §2, `review-oracle.md` §2, `doc-invoker.md` §2). `SKILL.md` names the squads' folder and points there; do not copy the roster back into it.
- **Keep the totals in sync:** a new or retired hero changes the counts in `SKILL.md` (frontmatter and *The 3 Lanes*), `README.md` and `plugin.json` (48 heroes across 14 squads, counting the 6 commanders).

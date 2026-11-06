# GEM OF TRUE SIGHT — Purpose Check (Shared Item, bought by every Lane Commander at Stage 1 · Assemble)

**ELDER TITAN**, **ORACLE** and **INVOKER** each buy this item before assembling any squad. Work aimed at the wrong purpose wastes every stage after it: one question now costs less than redoing a blueprint, a review or a document.

## 1. State the Purpose
Write one line: what this work is for, and how we will know it served that purpose.
- **🔨 Top Lane (`ELDER TITAN`):** the problem the feature solves, for whom, and the outcome that shows it is solved.
- **🔮 Mid Lane (`ORACLE`):** what the change is meant to do.
- **📖 Bot Lane (`INVOKER`):** what the audience will do with the document (integrate, decide, operate, approve).

## 2. Infer First, Ask Only When Blind
1. Take the purpose from the conversation, the request, the PR description, commit messages, branch name or the file's location.
2. Ask only when none of them states it, as one question per SKILL.md Lane Routing rule 2 (platform-neutral; if the user cannot be asked, state the assumed purpose in the manifest's first line and mark it `assumed`).
3. Never ask about what the code, the conversation or a default already answers. A small single-purpose fix in Mid Lane never needs a question.

## 3. Carry It Through
- **Manifest:** **Purpose** is the first line of the lane's manifest, and every squad (or Deep-Mode subagent) receives it.
- **Stage 3 filters judge against it:**
  - `ANCIENT APPARITION` shatters any blueprint element that serves no stated purpose.
  - `DOOM` raises a `BLOCKER` when the change does not do what its purpose says, and discards suggestions that change what the code is for instead of how it does it.
  - `SILENCER` asks what each section is for (rule 9).

---
name: dotc
description: >-
  Short alias for the `defense-of-the-code` skill (3-Lane Plan / Review / Doc pipeline).
  Invoked explicitly as `/dotc <natural language request>`.
argument-hint: "<ช่วยออกแบบ... | รีวิวโค้ด | รีวิวละเอียด | เขียนเอกสาร...>"
disable-model-invocation: true
---

`/dotc` is the short alias of the **`defense-of-the-code`** skill.

1. Read `{{SKILL_DIR}}/SKILL.md` and follow it exactly as if the user had invoked `/defense-of-the-code`.
2. Resolve every `./references/...` and `./scripts/...` link in that file against `{{SKILL_DIR}}` (substitute it wherever `<skill_dir>` appears).
3. The user's request: $ARGUMENTS

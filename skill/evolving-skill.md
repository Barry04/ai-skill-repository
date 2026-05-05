# Skill Harness Protocol

This defines how an agent uses `skill.md` as an internal skill layer.

---

## 1. Retrieval

- Read all skills from `skill.md`
- Match user input with `trigger`
- Select at most 2 relevant skills

---

## 2. Injection

Convert matched skills into:

[经验参考]
- xxx

Rules:
- Max 2 skills
- Each ≤ 2 lines
- Do not copy verbatim
- Must integrate into answer

---

## 3. Write Policy

Only create a new skill when:

- Problem is clearly solved
- Knowledge is reusable

AND:

- User explicitly asks to save

---

## 4. Format

## [name]
trigger: xxx, xxx
content:
- xxx
- xxx

---

## 5. Lifecycle

- Merge similar skills (based on trigger overlap)
- Keep total skills ≤ 50

---

## 6. Guardrails

- Do NOT auto-write skills continuously
- Do NOT store long or verbose content
- Do NOT store context-specific data

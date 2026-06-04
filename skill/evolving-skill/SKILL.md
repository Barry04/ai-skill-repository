---
name: evolving-skill
description: Project skill evolution protocol for AI agents. Use when managing a personal skill repository, reading project skills, deciding whether reusable knowledge should be saved, prompting the user before persistence, merging similar skills, or maintaining skill lifecycle rules.
---

# Evolving Skill Harness Protocol

This protocol defines how an Agent uses this repository as a lightweight, evolving personal skill library.

Project skills are stored as one directory per skill under `skill/`. Each skill directory should contain a `SKILL.md` file and may include `references/`, `tools/`, `assets/`, or `agents/`.

---

## 1. Retrieval

At the start of a task, or when the task direction changes:

- Read the relevant `skill/<skill-name>/SKILL.md` files.
- Match the user request, error message, module name, framework, or workflow with skill names and descriptions.
- Select at most 2 highly relevant skills.
- Prefer precise project skills over generic knowledge.

---

## 2. Injection

Convert matched skills into concise working context:

```text
[Project Skill Context]
- ...
- ...
```

Rules:

- Use at most 2 skills.
- Keep each skill summary within 2 lines.
- Do not copy long content verbatim.
- Integrate the skill into the reasoning or implementation.
- Do not mention skill injection unless it helps the user understand the work.

---

## 3. Opportunity Detection

During every conversation and while the Agent is running, watch for reusable knowledge that is worth preserving.

Good candidates:

- A bug cause and fix that may happen again.
- A project-specific build, test, deploy, or rollback workflow.
- A recurring framework pitfall, such as Spring transactions, MyBatis pagination, Docker networking, or database compatibility.
- A command sequence that reliably validates a feature.
- A remote test-machine convention, using placeholders for host, port, user, key path, log path, or deployment directory.
- A decision rule the user wants future agents to follow.

Poor candidates:

- One-off user preferences for the current conversation.
- Secrets, passwords, private keys, tokens, or production-only host details.
- Long logs or bulky context.
- Unverified guesses.
- Information that is already obvious from the repository.

---

## 4. Save Prompt Policy

The Agent must not silently write new skills.

When the Agent finds reusable knowledge, ask the user whether to save it:

```text
这条经验以后可能还会用到：<one-line summary>。
要不要我把它沉淀到项目 skill 里？
```

Ask only when all conditions are true:

- The issue or workflow is clearly understood.
- The knowledge is reusable across future tasks.
- The content is safe to store.
- The user has not already rejected saving similar knowledge in this conversation.

If the user agrees, save or merge the skill into this repository.

If the user declines, continue the task and do not ask again for the same item.

---

## 5. Write Policy

Only create or update a skill when:

- The problem is solved or the workflow is validated.
- The knowledge is reusable.
- The user explicitly agrees to save it.

When saving:

- Merge with an existing similar skill when triggers overlap.
- Keep the saved content short and operational.
- Use names and descriptions that match likely future user wording, errors, modules, or commands.
- Do not store secrets or sensitive environment details.
- Prefer placeholders for sensitive values, such as `<host>`, `<port>`, `<user>`, and `<key_path>`.

---

## 6. Skill Format

Each skill must live in its own directory:

```text
skill/
  skill-name/
    SKILL.md
```

Use this minimum `SKILL.md` format:

```markdown
---
name: skill-name
description: What this skill does and when an Agent should use it.
---

# Skill Title

## Purpose

...
```

Use optional folders only when needed:

```text
references/   # Detailed docs loaded only when needed
tools/        # Scripts or helper programs
assets/       # Templates, examples, config samples
agents/       # Agent-facing metadata
```

---

## 7. Lifecycle

Maintain the repository as a personal skill library:

- Merge similar skills based on purpose and trigger overlap.
- Remove stale or incorrect skills when discovered.
- Keep each `SKILL.md` focused and compact.
- Move bulky details into `references/`.
- Keep scripts in `tools/` when repeatable execution matters.
- Keep examples or config templates in `assets/`.

---

## 8. Guardrails

- Do not auto-write skills continuously.
- Do not interrupt deep work for low-value save prompts.
- Do not store long or verbose content in `SKILL.md`.
- Do not store secrets, credentials, tokens, private keys, or sensitive production data.
- Do not store context-specific data that will mislead future tasks.
- Do not save unverified assumptions as facts.

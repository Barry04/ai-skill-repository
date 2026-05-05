# Agent Skill Harness Protocol

This protocol defines a minimal in-agent Skill layer. It uses only `skill.md`.

## Retrieval

1. Before a task, read `skill.md` if it exists.
2. Match the user request against each skill's `trigger` values.
3. Select at most 2 relevant skills.
4. If no trigger matches, continue without Skill context.

## Injection

Convert selected skills into short prompt context:

```text
[经验参考]
- ...
- ...
```

Rules:

- Inject at most 2 items.
- Keep each item within 2 lines.
- Fuse the experience into the current task wording.
- Do not copy `content` verbatim unless exact wording is required.

## Write Policy

Do not write to `skill.md` automatically.

Only propose or apply a new skill when:

- The problem was solved.
- The lesson is reusable across future tasks.
- The content is not tied to a one-off file, bug, or temporary state.
- The user explicitly asks to record, update, merge, or delete a skill.

## Lifecycle

- Merge similar skills instead of adding duplicates.
- Keep the total number of skills at 50 or fewer.
- Prefer one concise skill over several narrow variants.
- Delete obsolete or misleading skills when the user confirms they are no longer useful.

## Guardrails

- No services, APIs, databases, vector stores, or external memory systems.
- No long-form skills.
- No scores, embeddings, weights, confidence fields, or complex metadata.
- No strongly context-dependent content.
- No secrets, tokens, personal data, or private credentials.
- `skill.md` is the only Skill storage file.

# Personal Skill Repository

This repository is a personal Skill library for AI agents.

The root level contains repository documentation. The `skill/` directory contains one independent skill per subdirectory.

This repository uses lowercase `skill/` as the Skill directory name.

## Repository Layout

```text
README.md                         # Usage guide
readme_zh.md                      # Chinese usage guide
UPGRADE.md                        # Upgrade and maintenance guide
LICENSE
skill/
  evolving-skill/
    SKILL.md
  java-backend-troubleshooting/
    SKILL.md
  linux-test-executor/
    SKILL.md
    references/
    tools/
    assets/
    agents/
```

## How Agents Should Use This Repository

1. Read the repository-level docs when learning how this Skill repository is organized.
2. Read `skill/evolving-skill/SKILL.md` for the rules about retrieval, save prompts, and skill lifecycle.
3. Select relevant skills from `skill/<skill-name>/SKILL.md`.
4. Use at most 2 highly relevant skills as working context for a task.
5. When reusable knowledge appears during work, ask the user before saving it as a new or updated skill.

## Current Skills

### evolving-skill

Defines how an Agent should use and evolve this personal Skill repository.

Path: `skill/evolving-skill/SKILL.md`

### java-backend-troubleshooting

Stores reusable Java backend troubleshooting rules, including Spring transaction rollback and MyBatis pagination issues.

Path: `skill/java-backend-troubleshooting/SKILL.md`

### linux-test-executor

Allows an Agent to upload files to a Linux test machine, execute remote commands, collect logs, and return structured test results.

Path: `skill/linux-test-executor/SKILL.md`

## Add Or Update Skills

Use `UPGRADE.md` as the maintenance guide.

New skills should follow this structure:

```text
skill/
  skill-name/
    SKILL.md
```

Use optional folders only when needed:

```text
references/   # Longer docs loaded only when needed
tools/        # Scripts or helper programs
assets/       # Templates, examples, config samples
agents/       # Agent-facing metadata
```

## Save Prompt Rule

Agents must not silently write new skills.

When reusable knowledge is discovered, ask:

```text
这条经验以后可能还会用到：<one-line summary>。
要不要我把它沉淀到项目 skill 里？
```

Only save after the user agrees.

## Do Not Store

- Passwords, tokens, private keys, or credentials
- Sensitive production host details
- Long logs or bulky context
- One-off conversation preferences
- Unverified guesses

## Philosophy

This is not a knowledge base, RAG system, or platform.

It is a compact, file-based personal Skill repository: small enough to inspect, structured enough to help agents improve over time.

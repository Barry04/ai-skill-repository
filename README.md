# evolving-skill

A compact, file-based **personal Skill library** for AI agents.

## In one line

```
Before: knowledge in chat / your head → agent guesses each time
This repo: skill/<name>/SKILL.md on disk → agent reads on demand, user confirms before saving
```

## Layout

```text
AGENTS.md              # Agent entry (map + skill index)
readme_zh.md           # Chinese guide
UPGRADE.md             # Maintenance conventions
scripts/install-skill.ps1
skill/
  evolving-skill/
  java-backend-troubleshooting/
  linux-test-executor/
```

## For agents

1. Read `AGENTS.md` to find relevant skills
2. Read `skill/<name>/SKILL.md` (at most 2 per task)
3. When reusable knowledge appears, **ask the user** before saving (`skill/evolving-skill/SKILL.md`)

## For humans

See `UPGRADE.md` for naming, merging, and quality checks.

Install the harness protocol locally:

```powershell
.\scripts\install-skill.ps1
```

## Current skills

| Skill | Purpose |
|-------|---------|
| evolving-skill | Retrieval, evolution, lifecycle |
| java-backend-troubleshooting | Spring / MyBatis troubleshooting |
| linux-test-executor | Remote SSH testing and log collection |
| project-to-harness-skill | Any project → harness docs + skills/ (qualification, registry, preview-first) |

## Philosophy

Not a knowledge base or RAG platform — a **versioned constraint surface**:

- If it is not in the repo, the agent cannot rely on it
- Entry is a map, not a manual
- Evolution requires user confirmation, not silent writes

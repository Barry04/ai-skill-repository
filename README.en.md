# ai-skill-repository

[中文](README.md) · [GitHub](https://github.com/Barry04/ai-skill-repository)

A **personal Skill library** for AI agents — reusable engineering know-how in `skill/<name>/SKILL.md`, read on demand, evolved with user confirmation.

Inspired by [Harness Engineering](https://github.com/deusyu/harness-engineering).

> **Repo name:** `ai-skill-repository` · **Contains multiple skills**; `evolving-skill` is the evolution protocol (global); day-to-day skills live in each project's `skill/`.

---

## What this is

Not a single skill, knowledge base, or RAG platform — a versioned **collection of skills**:

- One directory per skill: `skill/<name>/SKILL.md`
- At most **2** skills per task
- Saves only after user confirmation ([evolving-skill](skill/evolving-skill/SKILL.md))
- `install.ps1` / `install.sh` install **all** skills to Cursor / Claude

---

## Skills in this repo

### evolving-skill — evolution protocol (global install, project writes)

- **Protocol** → `~/.cursor/skills/`, `~/.claude/skills/` (via install)
- **Generated / evolved skills** → **current project** `skill/<name>/`

→ [skill/evolving-skill/SKILL.md](skill/evolving-skill/SKILL.md)

### project-to-harness-skill — project harness generator

Turn any project (new, active, legacy, open-source) into `AGENTS.md`, `docs/harness/`, and project `skills/`. Preview-first; no app source or build/deploy changes.

→ [skill/project-to-harness-skill/SKILL.md](skill/project-to-harness-skill/SKILL.md)

### java-backend-troubleshooting — Java backend debugging

Spring transaction rollback, MyBatis pagination, and related Java service issues.

→ [skill/java-backend-troubleshooting/SKILL.md](skill/java-backend-troubleshooting/SKILL.md)

### linux-test-executor — remote Linux testing

SSH upload, remote commands, log collection; includes `tools/` scripts.

→ [skill/linux-test-executor/SKILL.md](skill/linux-test-executor/SKILL.md)

---

## Clone & install

```bash
git clone https://github.com/Barry04/ai-skill-repository.git
cd ai-skill-repository
```

| Platform | Command (from repo root or extracted bundle root) |
|----------|---------------------------------------------------|
| Windows | `.\install.ps1` |
| macOS / Linux | `bash install.sh` |

Scripts default to `skill/` next to themselves — no path argument needed after extract.

### CI: package & install

Workflow [.github/workflows/package-and-install-skills.yml](.github/workflows/package-and-install-skills.yml) builds separate Windows (`skill/` + `install.ps1`) and macOS (`skill/` + `install.sh`) zips. Download the platform **Artifact**, extract, run the install script from that folder.

---

## Quick start

- **Agents:** [AGENTS.md](AGENTS.md) → pick a skill → execute → ask before saving
- **Humans:** [UPGRADE.md](UPGRADE.md) for maintenance

## Trigger reliability

If skills rarely trigger, check `AGENTS.md` first, then strengthen each `SKILL.md` frontmatter `description` with English and Chinese task wording, common errors, tool names, framework names, and explicit "when to use" phrases. Keywords only in the body are often too late.

---

## License

[MIT](LICENSE)

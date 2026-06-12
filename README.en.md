# ai-skill-repository

[中文](README.md) · [GitHub](https://github.com/Barry04/ai-skill-repository)

Personal Harness Skill library built on the **evolving-skill** protocol — learns from conversations and practice, building reusable engineering knowledge for AI agents.

Inspired by [Harness Engineering](https://github.com/deusyu/harness-engineering).

---

## Clone & install

```bash
git clone https://github.com/Barry04/ai-skill-repository.git
cd ai-skill-repository
```

Install all skills to Cursor / Claude (optional):

| Platform | Command |
|----------|---------|
| Windows | `.\scripts\install-skill.ps1` |
| macOS / Linux | `bash scripts/install-skill.sh` |

---

## What this is

A versioned **skill constraint surface** — not a knowledge base or RAG platform.

- Know-how in `skill/<name>/SKILL.md`
- At most **2** skills per task
- Saves only after **user confirmation**

Plus **project-to-harness-skill** for bootstrapping any repo into `AGENTS.md`, `docs/harness/`, and project `skills/`.

---

## Layout

```text
AGENTS.md
README.md / README.en.md
UPGRADE.md
skill/
  evolving-skill/
  project-to-harness-skill/
  java-backend-troubleshooting/
  linux-test-executor/
```

---

## Quick start

- **Agents:** [AGENTS.md](AGENTS.md) → `skill/<name>/SKILL.md` → ask before saving
- **Harness a project:** [project-to-harness-skill](skill/project-to-harness-skill/SKILL.md)
- **Maintain:** [UPGRADE.md](UPGRADE.md)

---

## Skills

| Skill | When |
|-------|------|
| [evolving-skill](skill/evolving-skill/SKILL.md) | This repository |
| [project-to-harness-skill](skill/project-to-harness-skill/SKILL.md) | Project → harness docs + skills |
| [java-backend-troubleshooting](skill/java-backend-troubleshooting/SKILL.md) | Spring / MyBatis |
| [linux-test-executor](skill/linux-test-executor/SKILL.md) | Remote SSH testing |

---

## License

[MIT](LICENSE)

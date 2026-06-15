# Release v0.0.1

## Changes
- ✅ Fixed macOS installation issue by creating tool directories before copying skills
- ✅ Verified workflow passes on all platforms (Windows, macOS)
- ✅ Bundle artifact includes all skills and installation scripts

## Installation

Download `ai-skill-repository-skills.zip` from this release and extract it.

### Windows
```powershell
.\scripts\install-skill.ps1 -RepoRoot <extracted-path>
```

### macOS / Linux
```bash
bash scripts/install-skill.sh <extracted-path>
```

## Artifacts
- `ai-skill-repository-skills.zip` - Complete skill bundle with installation scripts

---

Initial release of AI Skill Repository with self-evolving skill system.

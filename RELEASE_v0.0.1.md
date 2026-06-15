# Release v0.0.1

## Changes
- ✅ Fixed macOS installation issue by creating tool directories before copying skills
- ✅ Verified workflow passes on all platforms (Windows, macOS)
- ✅ Bundle artifact includes all skills and installation scripts

## Installation

Download `ai-skill-repository-skills.zip` from this release and extract it.

### Windows
```powershell
# 克隆仓库
.\install.ps1

# 或从 Release / Actions 下载 Windows 包，解压后：
.\install.ps1
```

### macOS / Linux
```bash
# 克隆仓库
bash install.sh

# 或从 Release / Actions 下载 macOS 包，解压后：
bash install.sh
```

## Artifacts
- `ai-skill-repository-skills-windows.zip` — `skill/` + `install.ps1`
- `ai-skill-repository-skills-macos.zip` — `skill/` + `install.sh`

---

Initial release of AI Skill Repository with self-evolving skill system.

#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="${1:-$(pwd)}"
SOURCE_SKILL_DIR="$REPO_ROOT/skill"

if [ ! -d "$SOURCE_SKILL_DIR" ]; then
  echo "Error: Skill directory not found: $SOURCE_SKILL_DIR" >&2
  exit 1
fi

SKILL_DIRS=("$SOURCE_SKILL_DIR"/*/)
if [ ${#SKILL_DIRS[@]} -eq 0 ]; then
  echo "Error: No skills found under $SOURCE_SKILL_DIR" >&2
  exit 1
fi

HOME_DIR="$HOME"
TOOL_DIRS=(
  "$HOME_DIR/.claude/skills"
  "$HOME_DIR/.cursor/skills"
)

TOTAL=0
for SKILL_DIR in "${SKILL_DIRS[@]}"; do
  [ -d "$SKILL_DIR" ] || continue
  SKILL_NAME=$(basename "$SKILL_DIR")
  for TOOL_DIR in "${TOOL_DIRS[@]}"; do
    TARGET="$TOOL_DIR/$SKILL_NAME"
    rm -rf "$TARGET"
    cp -R "$SKILL_DIR" "$TARGET"
  done
  echo "  installed: $SKILL_NAME"
  ((TOTAL++))
done

AGENTS_SOURCE="$REPO_ROOT/AGENTS.md"
if [ -f "$AGENTS_SOURCE" ]; then
  echo ""
  echo "Tip: AGENTS.md stays in the repo. Open this repo (or symlink it) so agents see the skill index."
fi

echo ""
echo "Done. Installed $TOTAL skill(s) to: ${TOOL_DIRS[*]}"
echo "Source: $SOURCE_SKILL_DIR"

#!/usr/bin/env bash
set -euo pipefail

SKILL=""
CANDIDATE=""
OUTPUT=""
ALLOW_MISSING_EVAL="false"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --skill|-s)
      SKILL="${2:-}"
      shift 2
      ;;
    --candidate|-c)
      CANDIDATE="${2:-}"
      shift 2
      ;;
    --output|-o)
      OUTPUT="${2:-}"
      shift 2
      ;;
    --allow-missing-eval)
      ALLOW_MISSING_EVAL="true"
      shift
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 2
      ;;
  esac
done

if [ -z "$SKILL" ]; then
  echo "Usage: $0 --skill <skill-name> [--candidate path] [--output path] [--allow-missing-eval]" >&2
  exit 2
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
CANDIDATE_PATH="${CANDIDATE:-$REPO_ROOT/skill/$SKILL/SKILL.md}"
CASE_DIR="$REPO_ROOT/eval/$SKILL/cases"

if [ ! -f "$CANDIDATE_PATH" ]; then
  echo "Candidate skill not found: $CANDIDATE_PATH" >&2
  exit 1
fi

if [ ! -d "$CASE_DIR" ]; then
  if [ "$ALLOW_MISSING_EVAL" = "true" ]; then
    echo "warning: no eval cases found for skill '$SKILL' at $CASE_DIR" >&2
    exit 0
  fi
  echo "No eval cases found for skill '$SKILL' at $CASE_DIR" >&2
  exit 1
fi

python - "$SKILL" "$CANDIDATE_PATH" "$CASE_DIR" "${OUTPUT:-}" <<'PY'
import json
import math
import pathlib
import sys

skill, candidate_path, case_dir, output = sys.argv[1:5]
text = pathlib.Path(candidate_path).read_text(encoding="utf-8")
case_files = sorted(pathlib.Path(case_dir).glob("*.json"))
if not case_files:
    raise SystemExit(f"No eval case JSON files found for skill '{skill}' at {case_dir}")

results = []
total = 0
maximum = 0
failed_forbidden = False

for case_file in case_files:
    case = json.loads(case_file.read_text(encoding="utf-8"))
    expected = [str(item) for item in case.get("expected", [])]
    forbidden = [str(item) for item in case.get("forbidden", [])]
    max_score = int(case.get("score_points", len(expected)))
    lowered = text.lower()
    matched_expected = [p for p in expected if p.lower() in lowered]
    missing_expected = [p for p in expected if p.lower() not in lowered]
    matched_forbidden = [p for p in forbidden if p.lower() in lowered]
    score = math.floor((len(matched_expected) / len(expected)) * max_score) if expected else max_score
    if matched_forbidden:
        score = 0
        failed_forbidden = True
    passed = not missing_expected and not matched_forbidden
    notes = "passed" if passed else f"missing=[{', '.join(missing_expected)}]; forbidden=[{', '.join(matched_forbidden)}]"
    result = {
        "case_id": str(case.get("id", case_file.stem)),
        "score": int(score),
        "max_score": int(max_score),
        "passed": bool(passed),
        "notes": notes,
    }
    results.append(result)
    total += score
    maximum += max_score

lines = [json.dumps(result, ensure_ascii=False, separators=(",", ":")) for result in results]
if output:
    out = pathlib.Path(output)
    if not out.is_absolute():
        out = pathlib.Path.cwd() / out
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text("\n".join(lines) + "\n", encoding="utf-8")

for line in lines:
    print(line)
summary = {
    "skill": skill,
    "candidate": str(pathlib.Path(candidate_path).resolve()),
    "cases": len(case_files),
    "score": int(total),
    "max_score": int(maximum),
    "passed": all(result["passed"] for result in results),
}
print("SUMMARY " + json.dumps(summary, ensure_ascii=False, separators=(",", ":")))
if not summary["passed"] or failed_forbidden:
    raise SystemExit(1)
PY


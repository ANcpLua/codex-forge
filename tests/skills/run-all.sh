#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$(cd "$SCRIPT_DIR/../../.agents/skills" && pwd)"
FAIL=0

echo "=== Skill format validation ==="

for skill_dir in "$SKILLS_DIR"/*/; do
  skill_name="$(basename "$skill_dir")"
  skill_md="$skill_dir/SKILL.md"

  if [[ ! -f "$skill_md" ]]; then
    echo "FAIL: $skill_name — missing SKILL.md"
    FAIL=1
    continue
  fi

  # Check frontmatter has name and description
  if ! head -10 "$skill_md" | grep -q "^name:"; then
    echo "FAIL: $skill_name — SKILL.md missing 'name' in frontmatter"
    FAIL=1
  fi
  if ! head -10 "$skill_md" | grep -q "^description:"; then
    echo "FAIL: $skill_name — SKILL.md missing 'description' in frontmatter"
    FAIL=1
  fi

  # Check openai.yaml if present
  yaml="$skill_dir/agents/openai.yaml"
  if [[ -f "$yaml" ]]; then
    if ! grep -q "display_name:" "$yaml"; then
      echo "WARN: $skill_name — agents/openai.yaml missing display_name"
    fi
  fi

  # Check scripts are executable
  if [[ -d "$skill_dir/scripts" ]]; then
    for script in "$skill_dir"/scripts/*; do
      if [[ -f "$script" && ! -x "$script" ]]; then
        echo "FAIL: $skill_name — $script is not executable"
        FAIL=1
      fi
    done
  fi

  echo "OK: $skill_name"
done

echo ""
echo "=== Skill trigger prompts ==="
for prompt in "$SCRIPT_DIR"/prompts/*.txt; do
  echo "PROMPT: $(basename "$prompt")"
  echo "  $(head -1 "$prompt")"
  echo "  (manual: send to Codex, verify correct skill activates)"
done

exit $FAIL

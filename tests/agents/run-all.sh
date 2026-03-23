#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
AGENTS_DIR="$(cd "$SCRIPT_DIR/../../.codex/agents" && pwd)"
FAIL=0

echo "=== Agent TOML validation ==="

for toml_file in "$AGENTS_DIR"/*.toml; do
  agent_name="$(basename "$toml_file" .toml)"

  # Check required fields exist
  if ! grep -q "^model" "$toml_file"; then
    echo "FAIL: $agent_name — missing 'model' field"
    FAIL=1
  fi
  if ! grep -q "^sandbox_mode" "$toml_file"; then
    echo "FAIL: $agent_name — missing 'sandbox_mode' field"
    FAIL=1
  fi
  if ! grep -q "developer_instructions" "$toml_file"; then
    echo "FAIL: $agent_name — missing 'developer_instructions' field"
    FAIL=1
  fi

  # Check sandbox_mode is a valid value
  mode=$(grep "^sandbox_mode" "$toml_file" | head -1 | sed 's/.*= *"//;s/".*//')
  case "$mode" in
    read-only|workspace-write|danger-full-access) ;;
    *) echo "FAIL: $agent_name — invalid sandbox_mode: $mode"; FAIL=1 ;;
  esac

  # Check reviewer/researcher agents are read-only
  if [[ "$agent_name" == "reviewer" || "$agent_name" == "researcher" ]]; then
    if [[ "$mode" != "read-only" ]]; then
      echo "FAIL: $agent_name — should be read-only, got $mode"
      FAIL=1
    fi
  fi

  echo "OK: $agent_name (sandbox=$mode)"
done

exit $FAIL

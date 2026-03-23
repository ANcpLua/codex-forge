#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONTRACTS_DIR="$(cd "$SCRIPT_DIR/../contracts" && pwd)"
FAIL=0

echo "=== Contract schema validation ==="

for schema in "$CONTRACTS_DIR"/*.schema.json; do
  name="$(basename "$schema")"

  # Check valid JSON
  if ! python3 -c "import json; json.load(open('$schema'))" 2>/dev/null; then
    echo "FAIL: $name — invalid JSON"
    FAIL=1
    continue
  fi

  # Check required JSON Schema fields
  if ! python3 -c "
import json, sys
s = json.load(open('$schema'))
missing = [f for f in ['\$schema', 'title', 'type', 'required', 'properties'] if f not in s]
if missing:
    print(f'FAIL: missing fields: {missing}')
    sys.exit(1)
" 2>/dev/null; then
    echo "FAIL: $name — missing required JSON Schema fields"
    FAIL=1
    continue
  fi

  echo "OK: $name"
done

exit $FAIL

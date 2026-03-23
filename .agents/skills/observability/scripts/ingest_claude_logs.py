#!/usr/bin/env python3
"""Parse Claude Code JSONL logs into normalized UsageEvent JSONL."""

import json
import os
import sys
from pathlib import Path


def find_claude_logs() -> list[Path]:
    claude_dir = Path.home() / ".claude" / "projects"
    if not claude_dir.exists():
        return []
    return sorted(claude_dir.rglob("*.jsonl"))


def parse_line(line: str) -> dict | None:
    try:
        obj = json.loads(line)
    except json.JSONDecodeError:
        return None

    if obj.get("type") != "assistant":
        return None

    usage = obj.get("usage") or obj.get("message", {}).get("usage", {})
    if not usage:
        return None

    input_tokens = usage.get("input_tokens", 0)
    output_tokens = usage.get("output_tokens", 0)
    cache_write = usage.get("cache_creation_input_tokens", 0)
    cache_read = usage.get("cache_read_input_tokens", 0)

    return {
        "source": "claude",
        "model": obj.get("model", obj.get("message", {}).get("model", "unknown")),
        "session_id": obj.get("sessionId", ""),
        "input_tokens": input_tokens,
        "output_tokens": output_tokens,
        "cache_write_tokens": cache_write,
        "cache_read_tokens": cache_read,
        "total_tokens": input_tokens + output_tokens + cache_write + cache_read,
        "estimated_cost_usd": obj.get("costUSD", 0),
        "timestamp": obj.get("timestamp", ""),
        "host": os.uname().nodename,
        "project": obj.get("cwd", ""),
    }


def main():
    logs = find_claude_logs()
    if not logs:
        print("No Claude logs found in ~/.claude/projects/", file=sys.stderr)
        sys.exit(1)

    for log_path in logs:
        with open(log_path) as f:
            for line in f:
                event = parse_line(line.strip())
                if event:
                    print(json.dumps(event))


if __name__ == "__main__":
    main()

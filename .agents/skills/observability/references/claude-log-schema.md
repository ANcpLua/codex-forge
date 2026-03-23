# Claude Code Log Schema

Claude Code writes JSONL to `~/.claude/projects/<project-hash>/`.

Each line is a JSON object. Relevant fields for usage extraction:

```json
{
  "type": "assistant",
  "model": "claude-sonnet-4-6",
  "usage": {
    "input_tokens": 12345,
    "output_tokens": 6789,
    "cache_creation_input_tokens": 0,
    "cache_read_input_tokens": 5000
  },
  "costUSD": 0.0542,
  "sessionId": "uuid",
  "timestamp": "2026-03-22T15:30:00.000Z"
}
```

Source: ccusage project (github.com/ryoppippi/ccusage).
Note: ccusage issue #222 documents multi-device fragmentation — local logs are per-machine, not global truth.

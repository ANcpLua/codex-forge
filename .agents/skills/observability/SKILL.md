---
name: observability
description: Parse native Claude and Codex logs into normalized usage metrics. Use when analyzing token burn, cost per task, model mix, or budget tracking. Do not use for runtime behavior changes.
---

# Observability

Parse vendor-native log files. Normalize only the metrics layer. Do not normalize runtime behavior.

## Normalized fields

```
provider, session, task, role, model,
input_tokens, output_tokens, cache_write, cache_read,
total_tokens, estimated_cost, prompt_hash, outcome
```

## Workflow

1. Identify log source: `~/.claude/projects/` (JSONL) or Codex session logs.
2. Run the appropriate ingest script from `scripts/`.
3. Join sessions across providers using `scripts/join_sessions.py`.
4. Generate cost report with `scripts/cost_report.py`.

## References

- [references/claude-log-schema.md](references/claude-log-schema.md) — Claude JSONL field reference
- [references/usage-event-schema.md](references/usage-event-schema.md) — Normalized UsageEvent schema

## Scripts

- `scripts/ingest_claude_logs.py` — Parse Claude JSONL into UsageEvents
- `scripts/ingest_codex_logs.py` — Parse Codex logs into UsageEvents
- `scripts/join_sessions.py` — Correlate sessions across providers by task_id
- `scripts/cost_report.py` — Aggregate costs by day, model, role

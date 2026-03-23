# UsageEvent Schema

Normalized usage record. One per model call.

```json
{
  "trace_id": "string — OTel trace ID if available, otherwise generated UUID",
  "agent_id": "string — role identifier (e.g., codex-implementer, claude-researcher)",
  "session_id": "string — native session ID from the runtime",
  "source": "claude | codex | manual",
  "model": "string — native model name as reported by the runtime",
  "input_tokens": 12345,
  "output_tokens": 6789,
  "cache_write_tokens": 0,
  "cache_read_tokens": 5000,
  "total_tokens": 24134,
  "estimated_cost_usd": 0.054,
  "host": "string — machine hostname",
  "project": "string — project identifier",
  "task_id": "string | null — links to TaskContract if available",
  "timestamp": "ISO 8601"
}
```

See `unified-forge/contracts/usage-event.schema.json` for the JSON Schema.

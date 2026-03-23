# Operating Model

## Execution loop

```
plan(contract + verification function)
-> execute(typed artifact)
-> cheap checks (schema, format, lint)
-> independent refuter (different model family or prompt)
-> strong verifier (tests, claim-evidence links)
-> provenance update
-> commit
```

Not: `plan -> execute -> self-review -> done`

## Six repo laws

1. **Planning must produce contracts.** Not todo lists — per step: input, output, acceptance criteria, retry budget. (VeriMAP)
2. **Hard constraints are compiled.** Format, schema, required fields, forbidden side-effects, test pass: these are checkers, not reviewer opinions. (RewardAgent)
3. **Verify the conflict core, not the whole trajectory.** Focus verification on disagreement hotspots, not full-trajectory review. (Co-Sight)
4. **A retry must change the search space.** No-good ledger for failed approaches, banned tool-sequence prefixes, known failure reasons. (SWE-PRM)
5. **Verifiers run in cascade.** Cheap prune first, strong verify second. Staged verification: 11.65x speedup at 8.33% accuracy cost.
6. **Context hygiene is reliability.** Deferred tool loading. Single-agent first, multi-agent only for real specialization. (Anthropic advanced tool use)

## Three normalized layers

| Layer | Standard | What it unifies |
|-------|----------|-----------------|
| Capabilities | MCP | Tools, resources, prompts across vendors |
| Telemetry | OpenTelemetry | Traces, metrics, logs with context propagation |
| Work products | TaskContract + ArtifactEnvelope + UsageEvent | Handoffs, lineage, cost tracking |

Everything else stays vendor-native. CLAUDE.md stays Claude. AGENTS.md stays Codex. Do not unify prompt culture.

## Anti-patterns

- Agents talking to each other in free-form chat instead of exchanging typed artifacts
- Loading every tool definition into context instead of using search/deferred loading
- Treating local usage trackers as global billing truth
- Reviewing outputs only with the same model family that produced them
- Logging token totals without trace/span correlation
- Allowing multiple agents to write to the same artifact lineage concurrently
- Self-correction without external feedback (self-preference bias)

## Research references

- [Towards a Science of AI Agent Reliability](https://arxiv.org/abs/2602.16666) — consistency, robustness, predictability, safety
- [Large Language Models Cannot Self-Correct Reasoning Yet](https://arxiv.org/abs/2310.01798) — independent falsification over fake contradiction
- [VeriMAP](https://arxiv.org/abs/2510.17109) — planner-defined verification functions per subtask
- [RewardAgent](https://arxiv.org/html/2502.19328v1) — extract hard constraints, generate checkers
- [Co-Sight](https://arxiv.org/abs/2510.21557) — conflict-aware meta-verification
- [SWE-PRM](https://arxiv.org/html/2509.02360v1) — course-correction with process reward models
- [Staged Code Verification](https://arxiv.org/abs/2506.10056) — 11.65x speedup via cascaded verifiers
- [Anthropic Advanced Tool Use](https://www.anthropic.com/engineering/advanced-tool-use) — deferred loading, tool search
- [Codex + Agents SDK](https://developers.openai.com/codex/guides/agents-sdk/) — deterministic workflows with handoffs

**Orchestrierung ist Plumbing. Epistemische Kontrolle ist das Produkt.**

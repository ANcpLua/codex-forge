# Codex Forge

Codex-native project template. Every file maps to a real Codex runtime feature.

## Build and test

```bash
bash tests/skills/run-all.sh
bash tests/agents/run-all.sh
bash scripts/validate-contracts.sh
```

## Conventions

- Skills live in `.agents/skills/` (Codex discovery path).
- Agent roles live in `.codex/agents/*.toml`.
- Every skill has `SKILL.md` with `name` + `description` frontmatter.
- Agent TOML files use only documented fields: `model`, `model_reasoning_effort`, `sandbox_mode`, `developer_instructions`.
- Do not add directories Codex does not read: no `.codex/hooks/`, `.codex/rules/`, `.codex/commands/`, `.codex/prompts/`.

## Agent roles

| Role | Sandbox | Effort | Purpose |
|------|---------|--------|---------|
| implementer | workspace-write | high | Bounded code changes |
| reviewer | read-only | xhigh | Correctness, security, regressions |
| researcher | read-only | medium | Gather evidence, summarize options |

## Task handoff

Agents exchange typed JSON files, not free-form chat:
- `brief.json` — researcher output, implementer input
- `result.json` — implementer output, reviewer input
- `review.json` — reviewer verdict

Schemas in `contracts/`.

## Six repo laws

1. Planning produces contracts with acceptance criteria, not todo lists.
2. Hard constraints are checkers, not reviewer opinions.
3. Verify the conflict core, not the whole trajectory.
4. A retry must change the search space.
5. Verifiers run in cascade: cheap first, strong second.
6. Context hygiene is reliability: single-agent first, multi-agent only for real specialization.

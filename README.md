# Codex Forge

Codex-native project template. Uses only features documented in the official Codex API.

## Structure

```
codex-forge/
├── AGENTS.md                              # Root instructions
├── .codex/
│   ├── config.toml                        # Model, sandbox, multi-agent, MCP
│   └── agents/
│       ├── implementer.toml               # workspace-write, high effort
│       ├── reviewer.toml                  # read-only, xhigh effort
│       └── researcher.toml                # read-only, medium effort
├── .agents/
│   └── skills/
│       └── observability/
│           ├── SKILL.md
│           ├── agents/openai.yaml
│           ├── references/
│           └── scripts/
├── tests/
│   ├── skills/                            # Skill format + trigger tests
│   └── agents/                            # Agent TOML constraint tests
├── LICENSE
└── README.md
```

## What is here and why

| Path | Codex reads it? | Purpose |
|------|:-:|---|
| `AGENTS.md` | Yes — before every task | Coding style, build commands, conventions |
| `.codex/config.toml` | Yes — at startup | Model, sandbox, features, agent routing |
| `.codex/agents/*.toml` | Yes — when multi_agent enabled | Role definitions with sandbox + effort |
| `.agents/skills/` | Yes — walked from cwd to repo root | Skill discovery (SKILL.md + openai.yaml) |

## What is NOT here and why

| Absent | Reason |
|---|---|
| `.codex/hooks/` | Codex has `notify`, not a hook event system |
| `.codex/rules/` | Not a Codex feature — instructions go in AGENTS.md |
| `.codex/commands/` | Codex deprecated custom prompts in favor of skills |
| `.codex/prompts/` | Deprecated — use skills with `default_prompt` in openai.yaml |
| `skills/.system/.curated/.experimental` | Catalog convention, not project convention |

## Task handoff model

Agents exchange typed JSON files:

```
researcher -> brief.json -> implementer -> result.json -> reviewer -> review.json
```

Schemas in `contracts/` (self-contained — same schemas also live in unified-forge and claude-forge as shared policy).

## Validation

```bash
bash tests/skills/run-all.sh          # Skill format + frontmatter
bash tests/agents/run-all.sh          # Agent TOML fields + sandbox constraints
bash scripts/validate-contracts.sh    # Contract schema integrity
```

## Sources

- [Codex Skills](https://developers.openai.com/codex/skills)
- [Codex AGENTS.md](https://developers.openai.com/codex/guides/agents-md)
- [Codex Subagents](https://developers.openai.com/codex/subagents)
- [Codex Config Reference](https://developers.openai.com/codex/config-reference)

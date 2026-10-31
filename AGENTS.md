# Agent Directives: AI Skills Management & Maintenance

This document governs how AI coding assistants and autonomous agents (Antigravity, Claude Code, Cursor, Codex, OpenCodeInterpreter, etc.) must interact with, maintain, and contribute to this repository.

---

## 1. Core Operating Principles

### A. Strict Token Efficiency & Language Policy
- **Language Boundaries**: All skills (`SKILL.md`), reference materials, documentation, code comments, commit messages, and tool definitions **must be written strictly in English**.
- **Rationale**: English maximizes sub-word token density and minimizes context-window pollution across repeated agent context injections.
- **Conciseness**: Keep instructions directive, clear, and actionable. Avoid narrative fluff or redundant explanations.

### B. Standard Skill Architecture
Every skill in this repository resides in its own directory under `skills/<skill-name>/` and follows this schema:

```
skills/<skill-name>/
├── SKILL.md                 # REQUIRED: Primary instruction entrypoint with YAML frontmatter
├── references/              # OPTIONAL: Extended documentation, API tables, cheat sheets
├── scripts/                 # OPTIONAL: Deterministic helper scripts (bash, python, node)
└── examples/                # OPTIONAL: Code samples or reference implementations
```

#### `SKILL.md` Mandatory Format:
```markdown
---
name: <kebab-case-name>
description: <Clear 1-2 sentence explanation of what the skill does, trigger keywords, and when the agent should activate it>
---

# <Title>

## Overview / Trigger Conditions
When and why to activate this skill.

## Workflow & Constraints
Step-by-step instructions, constraints, safety checks, and commands.

## References & Examples
Pointers to relative files in `references/` or `examples/` if applicable.
```

---

## 2. Maintenance & Evolution Protocol

When an agent is tasked with updating, modifying, or creating skills in this repository:

### A. Modifying Existing Skills
1. **Preserve Backward Compatibility**: Do not break existing agent triggers or workflows without an explicit deprecation plan.
2. **Atomic Updates**: Update only the relevant section or reference document.
3. **Validate References**: If adding reference links, ensure all relative paths within `skills/<skill-name>/...` exist.

### B. Creating New Skills
1. Choose a concise, descriptive `kebab-case` name (e.g., `git-commit-push`, `docker-compose-ops`).
2. Scaffold automatically via `./scripts/new-skill.sh <skill-name>` or follow the standard structure manually.
3. Add the YAML frontmatter (`name`, `description`). The description is the primary hook agents use for semantic activation.
4. Keep instructions deterministic. Where multiple valid approaches exist, prescribe the recommended best practice first.

### C. Security & Secrets Policy
- **ZERO SECRETS POLICY**: Never commit API keys, authentication tokens, private SSH keys, internal passwords, or production server IPs/credentials.
- Use placeholders (e.g., `<API_KEY>`, `<HOST_IP>`, `${ENV_VAR}`) in all examples and templates.
- Before committing or finishing work, run a diff audit to confirm no private artifacts are staged.

### D. Automated Quality Gate
Before staging or pushing changes:
1. Run `python3 scripts/validate-skills.py` to ensure schema compliance, link validity, and zero secrets.
2. If skills were added, deleted, or descriptions altered, execute `python3 scripts/generate-catalog.py` to refresh the README catalog.

---

## 3. Cross-Agent Compatibility Directives
- Write instructions agnostic of agent runtime quirks unless documenting a specific platform adapter.
- Rely on standard tools (POSIX bash commands, standard file reading/writing, git conventions).
- Never assume a proprietary tool is available without mentioning fallback shell commands.

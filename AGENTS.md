# Agent Directives: AI Skills Library (`last-verified: 2026-11-11`)

## P0

### Language & Token Efficiency
- Write all skills (`SKILL.md`), reference files (`references/*.md`), documentation, code comments, commit messages, PRs, and internal thoughts in English.
- Think and respond in English by default even when the user writes in Spanish, switching to Spanish only when the user explicitly requests output in Spanish.

### Security & Privacy
- Never commit API keys, authentication tokens, private SSH keys, passwords, or private internal IPs/credentials; use placeholders (`<API_KEY>`, `<HOST_IP>`, `<GITEA_HOST>`, `${ENV_VAR}`).

### Process-First Automation
- Improve and harden deterministic scripts, validators, and background daemons rather than applying manual one-off fixes; reserve manual intervention strictly for exceptional cases where automation is unfeasible.

## P1

### Skill Architecture (P2 & P3 Layers)
- Place each skill in `skills/<kebab-case-name>/SKILL.md` with YAML frontmatter containing `name` and `description` (`WHEN:` trigger phrases and `WHEN NOT:` exclusions).
- Keep `SKILL.md` focused on P2 decision flows and steps (one responsibility per skill), and extract P3 details (commands, templates, examples, edge cases) into `references/*.md` or `scripts/*`.
- Use only repository-relative Markdown links inside `skills/` so `scripts/validate-skills.py` passes in isolated CI runners.

### Quality Gate & PR Delivery
- Run `python3 scripts/validate-skills.py` and `python3 scripts/generate-catalog.py` before staging any skill or catalog changes.
- Deliver all changes via feature branches and Pull Requests (`required_approving_review_count: 0`, `strict: true`) with Conventional Commits in English.

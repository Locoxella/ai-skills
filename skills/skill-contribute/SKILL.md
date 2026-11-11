---
name: skill-contribute
description: >-
  Export, validate, and commit reusable skills to the central `ai-skills` repository.
  WHEN: creating a new cross-project skill, updating a global skill in `~/.gemini/config/skills/`, or syncing skills upstream to `ai-skills`.
  WHEN NOT: editing repo-local rules (`AGENTS.md`) that only apply to a single project.
---

# Skill Contribution & Upstream Sync (`last-verified: 2026-11-11`)

Depends on Core Directives: [AGENTS.md (`#p0`)](../../AGENTS.md#p0) | [AGENTS.md (`#p1`)](../../AGENTS.md#p1)

## Procedure

1. **Locate Central Repository**: Resolve via symlink (`readlink -f`), `$AI_SKILLS_DIR`, or a repository containing `AGENTS.md` with `"Agent Directives: AI Skills Library"`.
2. **Sanitize & Generalize**: Strip all project secrets, tokens, private IPs, and user-specific credentials (`<API_KEY>`, `<HOST_IP>`, `<GITEA_HOST>`, `${ENV_VAR}` placeholders only) per [AGENTS.md `#p0`](../../AGENTS.md#p0). Ensure `kebab-case` folder naming, `WHEN:` / `WHEN NOT:` frontmatter descriptions, and repository-relative Markdown links.
3. **Sync Files**: Copy the skill directory (`SKILL.md`, `references/`, `scripts/`, `examples/`) into `skills/<skill-name>/` and keep `~/.gemini/config/skills/<skill-name>/` synchronized.
4. **Run Quality Gate & Catalog Refresh**:
   ```bash
   python3 scripts/validate-skills.py
   python3 scripts/generate-catalog.py
   ```
5. **Commit & PR**: Stage `skills/<skill-name>/` and `README.md`, commit using Conventional Commits (`feat(<skill-name>): ...` or `fix(<skill-name>): ...`), and deliver via a feature branch and Pull Request per [AGENTS.md `#p1`](../../AGENTS.md#p1).

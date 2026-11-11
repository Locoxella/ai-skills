Read P0 rules first: [Global P0](./GEMINI.md#p0) | [Secrets Setup](./secrets-setup.md)

# Knowledge & Skills Routing Index (`last-verified: YYYY-MM-DD`)

## Routing Table

| Trigger / Keywords | Target Skill or File (Section) | Priority |
|---|---|---|
| safety, secrets, language, process-first, core non-negotiables | [GEMINI.md (`#p0`)](./GEMINI.md#p0) | P0 |
| git hygiene, `.gitignore`, Conventional Commits, PRs, CI summaries | [GEMINI.md (`#p1`)](./GEMINI.md#p1) | P1 |
| repo-specific constraints, architecture, local exceptions | `<WORKSPACE>/.agents/AGENTS.md` | P0/P1 |
| GitHub/Gitea Actions, `$GITHUB_STEP_SUMMARY`, SemVer, Renovate | `~/.gemini/config/skills/cicd-pipeline-excellence/SKILL.md` | P2 |
| `.gitignore`, untracked files, `gitignore.io`, `generate-gitignore.sh` | `~/.gemini/config/skills/gitignore-generator/SKILL.md` | P2 |
| OpenTofu, Terraform, HCL, dynamic IDs, `tofu import` | `~/.gemini/config/skills/iac-clean-architecture/SKILL.md` | P2 |
| `git commit`, `git push`, branch delivery, PR gate | `~/.gemini/config/skills/git-commit-push/SKILL.md` | P2 |
| `README.md`, `docs/*.md`, `markdownlint-cli`, MD033 | `~/.gemini/config/skills/markdown-linting/SKILL.md` | P2 |
| PDF/OCR parsing failure, deterministic regex hardening | `~/.gemini/config/skills/ocr-fallback-evaluator/SKILL.md` | P2 |
| offline HTML report, `file://` dashboard, CSP-safe vanilla JS | `~/.gemini/config/skills/offline-html-dashboard/SKILL.md` | P2 |
| export reusable skill, sync upstream to `ai-skills` | `~/.gemini/config/skills/skill-contribute/SKILL.md` | P2 |
| generating `.env`, SSH keys, CLI tokens without plaintext storage | [secrets-setup.md](./secrets-setup.md) | P3 |

## Storage Map

- **Entry Index**: `~/.gemini/INDEX.md`
- **Global Core Memory (P0/P1)**: `~/.gemini/GEMINI.md`
- **Workspace Core Memory (P0/P1)**: `<WORKSPACE>/.agents/AGENTS.md`
- **Global Skills (P2) & References (P3)**: `~/.gemini/config/skills/<skill-name>/`
- **Secret Generation & Injection Guide (P3)**: `~/.gemini/secrets-setup.md`

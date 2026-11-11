---
name: git-commit-push
description: >-
  Verify tests/linters, audit `.gitignore`, write atomic Conventional Commits in English, and deliver via Pull Requests (or direct push on explicit state-tracking repo exceptions).
  WHEN: finishing a coding task, staging changes, writing commit messages, or pushing branches.
  WHEN NOT: inspecting read-only repository history without modifying files.
---

# Git Commit & Push Workflow (`last-verified: 2026-11-11`)

Depends on Core Directives: [AGENTS.md (`#p0`)](../../AGENTS.md#p0) | [AGENTS.md (`#p1`)](../../AGENTS.md#p1)

## Procedure

1. **Verification Gate**: Run the project test suite, linters, and build/syntax checks before staging. Never commit or push unverified changes.
2. **Status & `.gitignore` Audit**:
   - Run `git status` and `git diff` to ensure zero secrets, tokens, credentials, or debug artifacts are staged.
   - Invoke [gitignore-generator](../gitignore-generator/SKILL.md) whenever untracked OS, IDE, or local environment files appear.
3. **Atomic Staging & Conventional Commits**:
   - Stage logical, atomic change sets (`git add <paths>`) rather than blind `git add .`.
   - Format commit messages in English as `<type>(<optional-scope>): <imperative-summary>` (`feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `ci`, `build`).
4. **Branch Delivery & PR Policy**:
   - Deliver changes via a feature branch and Pull Request (`required_approving_review_count: 0`, `strict: true`) by default across repositories.
   - Push directly to `main` only when a repository's `AGENTS.md` explicitly defines a private state-tracking exception (such as `homeassistant`).
   - Verify triggered CI/CD runs after pushing and report the direct run URL in chat per [cicd-pipeline-excellence](../cicd-pipeline-excellence/SKILL.md).

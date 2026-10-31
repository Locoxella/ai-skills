---
name: git-commit-push
description: Ensures verified, tested code changes are staged, committed with conventional messages, and pushed to the remote Git repository. Also enforces clean .gitignore maintenance via gitignore-generator. Use when finishing a coding task, preparing commits, or managing gitignore exclusions.
---

# Git Commit & Push Workflow

## Description
Ensures that all verified, tested, and working code changes are consistently staged, committed with conventional messages, and pushed to the remote Git repository before completing any task. Additionally enforces clean `.gitignore` hygiene via the `gitignore-generator` skill.

## Trigger Conditions
- All implementation steps for the requested task or bugfix are complete.
- Local tests, linting, builds, and runtime verifications have passed without errors.
- The working tree is clean and functional.

---

## Workflow & Constraints

### 1. Verification Gate (Prerequisite)
NEVER push unverified code. Before staging:
- Run the relevant test suite (unit/integration tests).
- Ensure build/compile and lint checks pass cleanly.
- Verify that edge cases and unintended side effects are resolved.

### 2. Status & Diff Review
- Execute `git status` to review modified, deleted, and untracked files.
- Inspect changes via `git diff` to ensure:
  - No secrets, tokens, or sensitive credentials are being committed.
  - No temporary debug code, leftover logs, or unintended environment files are staged.
  - Changes strictly adhere to project `.gitignore` rules.
  - If untracked OS/IDE artifacts appear (`.DS_Store`, `.idea/`, `__pycache__`), invoke the `gitignore-generator` skill to standardize the repository `.gitignore` before committing.

### 3. Staging & Atomic Commits
- Stage only relevant files (prefer atomic commits grouped by logical scope rather than blind `git add .`).
- Write commit messages following the Conventional Commits specification:
  - Format: `<type>(<optional scope>): <imperative description>`
  - Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `ci`, `build`.
  - Language: Strictly in English.
  - Example: `feat(api): implement idempotent webhook verification`

### 4. Remote Sync & Push
- Check the current branch with `git branch --show-current`.
- Verify remote configuration (`git remote -v`).
- If working on a feature/fix branch:
  - Push changes: `git push origin <branch-name>` (or `git push -u origin <branch-name>` if upstream is not set).
- If branch protection rules or a PR workflow is enforced:
  - Do not force-push (`--force`) to protected branches (`main`, `master`, `production`).
  - Prepare branch for PR submission if requested.

---

## Post-Execution
- Confirm the push succeeded by reviewing the terminal exit code and remote response.
- Summarize the pushed commits and current branch state briefly to the user in the chat response.

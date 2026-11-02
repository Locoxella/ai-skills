---
name: git-commit-push
description: >-
  Ensures verified, tested code changes are staged, committed with conventional messages,
  and pushed to the remote Git repository via feature branches and Pull Requests under branch protection gates.
  Also enforces clean .gitignore maintenance via gitignore-generator.
---

# Git Commit & Push Workflow

## Description
Ensures that all verified, tested, and working code changes are consistently staged, committed with conventional messages, and pushed to the remote Git repository via dedicated topic branches and Pull Requests. In strict compliance with branch protection standards, direct pushes to `main` are prohibited. Additionally enforces clean `.gitignore` hygiene via the `gitignore-generator` skill.

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
  - If untracked OS/IDE artifacts appear (`.DS_Store`, `.idea/`, `__pycache__`, `*.code-workspace`), invoke the `gitignore-generator` skill to standardize the repository `.gitignore` before committing.

### 3. Staging & Atomic Commits
- Stage only relevant files (prefer atomic commits grouped by logical scope rather than blind `git add .`).
- Write commit messages following the Conventional Commits specification:
  - Format: `<type>(<optional scope>): <imperative description>`
  - Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `ci`, `build`.
  - Language: Strictly in English.
  - Example: `feat(api): implement idempotent webhook verification`

### 4. Branch Protection & Pull Request Lifecycle
- **Direct Push Prohibition**: Never attempt direct pushes to protected production branches (`main`, `master`, `production`).
- **Feature Branching**: Always branch off the latest default branch:
  ```bash
  git checkout -b <type>/<short-description>
  ```
- **Push Upstream**:
  ```bash
  git push -u origin <branch-name>
  ```
- **Open Pull Request**:
  - Open a Pull Request using platform CLIs (`gh pr create` or `tea pr create`).
  - Title and describe the changes clearly using Conventional Commit format.
- **Continuous Quality Checks**:
  - Monitor CI validation runs (`gh pr checks` / `gh run list`).
  - Ensure all required status checks pass cleanly before merging.

---

## Post-Execution
- Confirm the push and PR creation succeeded by reviewing CLI output.
- Deliver direct clickable links to the Pull Request and workflow runs to the user.

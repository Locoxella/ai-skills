---
name: gitignore-generator
description: >-
  Generates and maintains battle-tested .gitignore files using the official Toptal gitignore.io API.
  Mandatory whenever initializing a repository, auditing untracked files, or updating .gitignore files.
  Combines base OS (Linux, macOS, Windows), IDE (VS Code / visualstudiocode), project tech stacks,
  and proactive untracked artifact audits.
---

# Gitignore Generator & Repository Hygiene Skill

This skill automates the creation and proactive maintenance of `.gitignore` files using the official Toptal `gitignore.io` API (`https://www.toptal.com/developers/gitignore/api/`).

## 1. Core Principles & Universal Baseline
1. **Never create ad-hoc minimal `.gitignore` files manually**: Manual lists miss hidden OS files, editor cache, and language-specific artifacts.
2. **Mandatory Universal Baseline**:
   - **Operating Systems**: `linux`, `macos`, `windows`
   - **IDEs**: `visualstudiocode` (official Toptal template for VS Code; note that `vscode` is an alias/unsupported target on the API, `visualstudiocode` must be used).
3. **Detect & include project technologies**:
   - Query project indicators (e.g., `Cargo.toml` -> `rust`, `pyproject.toml`/`requirements.txt` -> `python`, `main.tf` -> `terraform`, `ansible/` -> `ansible`, `package.json` -> `node`, `go.mod` -> `go`).
4. **Append a separate Custom Project Rules block**:
   - Keep gitignore.io output intact.
   - Always append an isolated `# Custom Project Rules` block at the end for repository-specific secrets, local databases, temporary paths, and IDE extras like `*.code-workspace`.

---

## 2. Proactive Untracked Artifact Hygiene
- **Never bypass or dodge untracked developer files**: If `git status` shows files like `*.code-workspace`, local `.log`, `.env`, temporary archives, or diagnostic outputs, do not simply avoid staging them.
- **Audit & Update**:
  1. Verify if the file is tracked by upstream templates.
  2. If missing, immediately append the rule to the `# Custom Project Rules` block.
  3. Remove obsolete or deprecated patterns that no longer apply to the codebase.

---

## 3. Network Prerequisite
The Toptal API requires network access. When running shell commands via `run_command` to query the API, specify `BypassSandbox: true` so the request is not blocked by sandbox policy.

---

## 4. Helper Script Usage

A helper script is provided at:
`~/.gemini/config/skills/gitignore-generator/scripts/generate-gitignore.sh`

It automatically includes `linux`, `macos`, `windows`, and `visualstudiocode`, queries the API, handles error checking, and appends the standard custom rules block.

### Example:
```bash
~/.gemini/config/skills/gitignore-generator/scripts/generate-gitignore.sh python terraform ansible -o .gitignore
```

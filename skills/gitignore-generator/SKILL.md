---
name: gitignore-generator
description: >-
  Generate and maintain two-section .gitignore files via the Toptal gitignore.io API.
  WHEN: initializing a repository, adding a language/runtime stack, or spotting untracked OS/IDE/local files in `git status`.
  WHEN NOT: editing application source files when `git status` is already clean.
---

# Gitignore Generator & Repository Hygiene (`last-verified: 2026-11-11`)

Depends on Core Directives: [AGENTS.md (`#p1`)](../../AGENTS.md#p1)

## Two-Section Architecture

1. **Section 1 (Standard Environment & Tools)**: Generated via `https://www.toptal.com/developers/gitignore/api/<targets>`. Always include `linux,macos,windows,visualstudiocode` (plus `jetbrains,vim` where used) and detected project stacks (`python`, `rust`, `node`, `go`, `terraform`, `ansible`). Never use `vscode` (invalid API target; use `visualstudiocode`).
2. **Section 2 (`# Custom Project Rules`)**: Appended at the bottom and never overwritten during Section 1 updates. Holds `.env*`, `*.local`, `secrets.*`, `*.db*`, `*.sqlite*`, `*.code-workspace`, `scratch/`, `tmp/`, and FUSE mounts.

## Procedure

1. Detect project stacks from repo manifests (`pyproject.toml` -> `python`, `Cargo.toml` -> `rust`, `main.tf` -> `terraform`, `package.json` -> `node`, `go.mod` -> `go`).
2. Preserve existing custom rules from Section 2 if `.gitignore` already exists.
3. Run the helper script (`BypassSandbox: true` when network sandboxing is active):
   ```bash
   ./scripts/generate-gitignore.sh <tech1> [tech2 ...] -o .gitignore
   ```
   - Helper script: [generate-gitignore.sh](./scripts/generate-gitignore.sh)
4. Audit `git status` to confirm untracked OS/IDE/env artifacts (`*.code-workspace`, `.log`, `.tfplan`) are filtered; remove obsolete custom rules.
5. Untrack any previously committed files that belong in `.gitignore` without deleting them from disk:
   ```bash
   git rm -r --cached <unwanted-file-or-dir>
   ```

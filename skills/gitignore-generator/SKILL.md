---
name: gitignore-generator
description: >-
  Generates comprehensive, battle-tested .gitignore files using the official Toptal gitignore.io API.
  Mandatory whenever initializing a repository, creating, or updating .gitignore files.
  Combines base OS (Linux, macOS, Windows), IDE (VSCode), and project tech stacks, plus an isolated custom rules block.
---

# Gitignore Generator Skill

This skill automates the creation of robust, standard, and complete `.gitignore` files using the official Toptal `gitignore.io` API (`https://www.toptal.com/developers/gitignore/api/`).

## Core Principles
1. **Never create ad-hoc minimal `.gitignore` files manually**: Manual lists miss hidden OS files, editor cache, and language-specific artifacts.
2. **Always include the universal baseline**:
   - **Operating Systems**: `linux`, `macos`, `windows`
   - **IDEs**: `visualstudiocode` (plus `jetbrains` if relevant)
3. **Detect & include project technologies**:
   - Look at project indicators (e.g., `Cargo.toml` -> `rust`, `pyproject.toml`/`requirements.txt` -> `python`, `package.json` -> `node`, `go.mod` -> `go`).
4. **Append a separate Custom Project Rules block**:
   - Keep gitignore.io output intact.
   - Always append an isolated `# Custom Project Rules` block at the end for repository-specific secrets, local databases, and temporary paths without conflicting with upstream templates.

---

## Network Prerequisite
The Toptal API requires network access. When running shell commands via `run_command` to query the API, you must specify `BypassSandbox: true` so the request is not blocked by sandbox policy.

---

## Method 1: Using the Bundled Helper Script (Recommended)

A helper script is provided at:
`~/.gemini/config/skills/gitignore-generator/scripts/generate-gitignore.sh`

It automatically includes `linux`, `macos`, `windows`, and `visualstudiocode`, queries the API, handles error checking, and appends the standard custom rules block.

### Usage Example:
```bash
# Generate for a Python + Rust project (run with BypassSandbox: true):
~/.gemini/config/skills/gitignore-generator/scripts/generate-gitignore.sh python rust -o .gitignore

# Generate for a Node / TypeScript project:
~/.gemini/config/skills/gitignore-generator/scripts/generate-gitignore.sh node -o .gitignore
```

---

## Method 2: Direct Command Execution

If running directly via `curl` (always with `BypassSandbox: true`):

```bash
# 1. Fetch from gitignore.io combining base OS, VSCode, and detected tech
curl -fsSL "https://www.toptal.com/developers/gitignore/api/linux,macos,windows,visualstudiocode,<tech1>,<tech2>" > .gitignore

# 2. Append Custom Project Rules
cat >> .gitignore << 'EOF'

# ==============================================================================
# Custom Project Rules
# ==============================================================================
# Project-specific secrets, databases, and custom assets:
.env
*.env
*.local
*.db
*.sqlite3
scratch/
EOF
```

---

## Updating Existing .gitignore Files
When a `.gitignore` already exists in a repository:
1. Review the existing file for project-specific entries (e.g., custom paths, secret patterns, build outputs not covered by standard templates).
2. Query the gitignore.io API for the project's OS, IDEs, and languages.
3. Replace the standard parts with the fresh template.
4. Consolidate and preserve the project's unique entries within the `# Custom Project Rules` block at the bottom.

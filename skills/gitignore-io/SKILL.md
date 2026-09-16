---
name: gitignore-io
description: Creates and maintains structured .gitignore files using the gitignore.io (Toptal) API for standard environments while isolating repository-specific custom rules. Use when setting up a new repository, cleaning up untracked files, or updating ignore patterns for IDEs, OS, and runtimes.
---

# Structured .gitignore Maintenance via gitignore.io

## Description
Establishes and maintains a clean, professional, two-section `.gitignore` architecture across repositories. It utilizes the official `gitignore.io` (Toptal) API for comprehensive operating system, toolchain, and IDE patterns, while strictly isolating project-specific exceptions and server mounts in a protected custom section.

## Trigger Conditions
- Initializing a new repository or workspace.
- Reviewing `git status` reveals untracked editor/OS files (`.DS_Store`, `.idea/`, `.vscode/`, `*.log`, `Thumbs.db`).
- Adding new language toolchains, frameworks, or operating systems to a project.
- User requests `.gitignore` audit, generation, or refactoring.

---

## Architectural Standard: Two-Section Format

Every `.gitignore` managed by this workflow must be divided into two clearly delimited sections:

### Section 1: Standard Environment & Tools (Managed via API)
Generated automatically by querying the gitignore.io API. Contains standard exclusions for:
- **Operating Systems**: `linux`, `macos`, `windows`
- **IDEs & Editors**: `visualstudiocode`, `jetbrains` (or `pycharm`), `vim`
- **Languages & Runtimes**: project-specific targets (e.g., `python`, `node`, `go`, `rust`)

### Section 2: Custom Repository Rules (Protected & Persistent)
Handcrafted project-specific rules that must **NEVER** be overwritten or removed when Section 1 is updated:
- Sensitive local files (`secrets.yaml`, `.env`, credentials, private keys).
- Mounted directories or external storage links (e.g., `config/`, remote FUSE mountpoints).
- Large local databases, SQLite files, WAL files (`*.db`, `*.sqlite`, `*.db-wal`).
- Server-managed files with independent backup systems.
- Scratch/temporary workspace directories (`tmp/`, `scratch/`).

---

## Operational Workflow

### 1. Identify Target Profiles
Determine the relevant targets for the project. Always include the standard baseline:
`linux,macos,windows,visualstudiocode,jetbrains,vim` + the project runtime(s) (e.g., `python`, `node`).

Validate targets against the gitignore.io catalog if needed:
```bash
curl -s "https://www.toptal.com/developers/gitignore/api/list"
```

### 2. Fetch & Assemble the File
Fetch Section 1 via API and assemble with Section 2, ensuring proper warning headers and clear boundaries:

```python
import urllib.request

targets = "linux,macos,windows,visualstudiocode,jetbrains,vim,python"  # Adapt as needed
url = f"https://www.toptal.com/developers/gitignore/api/{targets}"

req = urllib.request.Request(url, headers={"User-Agent": "curl/8.0"})
with urllib.request.urlopen(req) as resp:
    api_content = resp.read().decode("utf-8").strip()

header = f"""# ==============================================================================
# SECTION 1: STANDARD ENVIRONMENT & TOOLS (GENERATED VIA GITIGNORE.IO API)
# API URL: https://www.toptal.com/developers/gitignore/api/{targets}
# To regenerate or update this section, query the API above and keep Section 2 intact.
# Targets: {targets.replace(',', ', ')}
# ==============================================================================
"""

custom_section = """# ==============================================================================
# SECTION 2: CUSTOM REPOSITORY RULES (WORKSPACE SPECIFIC & SERVER DATA)
# Do NOT remove or overwrite this section when updating standard tools via API.
# ==============================================================================

# Secrets, local tokens and credentials
.env
*.local
secrets.*

# Local databases & caches
*.db
*.sqlite
*.db-wal
*.db-shm

# Server / Workspace specific exclusions
tmp/
scratch/
"""

# Read existing Section 2 if present to preserve previous custom rules
# Then write combined content: header + api_content + "\n\n" + custom_section
```

### 3. Verify & Apply
1. Run `git status` to verify that untracked OS/IDE artifacts disappear from the status.
2. If files intended to be ignored were previously tracked, untrack them from index without deleting disk copies:
   ```bash
   git rm -r --cached <unwanted-file-or-dir>
   ```
3. Commit and push the updated `.gitignore` according to the git commit & push workflow.

---
name: skill-contribute
description: Protocols for contributing new skills, workflows, enhancements, or bugfixes back to the central AI skills repository. Activate when an agent develops a reusable workflow, refines a skill in any project or runtime, or is asked to persist/share a skill upstream.
---

# Skill Contribution & Upstream Sync

## Overview / Trigger Conditions
Activate this skill when:
- A new reusable workflow, procedure, or domain expertise is developed during a coding task.
- An existing skill has been patched, corrected, or enhanced in the local runtime or project workspace.
- The user asks to persist, export, or contribute a skill to the global/central skills repository.

---

## Workflow & Constraints

### 1. Dynamic Repository Discovery
Do not hardcode user paths. Discover the central skills repository dynamically:
1. **Symlink Resolution**: If the modified skill directory in the agent runtime is a symlink, resolve its canonical root (`readlink -f <path>`).
2. **Environment Variable**: Check if `$AI_SKILLS_DIR` or `$SKILLS_REPO` is set in the environment.
3. **Repository Discovery**: Search for an accessible repository containing `AGENTS.md` and a `skills/` directory:
   ```bash
   find "${REPOS_DIR:-$HOME}" -maxdepth 3 -type f -name "AGENTS.md" 2>/dev/null | xargs grep -l "Agent Directives: AI Skills" 2>/dev/null
   ```
4. **User Confirmation**: If discovery fails or is ambiguous, ask the user for the repository root path.

### 2. Generalization & Privacy Gate (Mandatory)
Before writing or proposing changes to the central repository:
- **Zero Secrets**: Inspect all files for tokens, passwords, private SSH keys, internal IPs, and sensitive URLs. Replace with placeholders (`<API_KEY>`, `<HOST_IP>`, `${ENV_VAR}`).
- **Decouple Project Specifics**: Ensure instructions are generic and applicable across projects unless documenting a platform-specific adapter.
- **Language Boundary**: Verify all documentation, `SKILL.md`, comments, and references are written strictly in **English** for token efficiency.
- **Schema Compliance**:
  - Valid YAML frontmatter with `name` (kebab-case) and `description`.
  - Directory structure matching:
    ```
    skills/<skill-name>/
    ├── SKILL.md
    ├── references/   # Optional
    ├── scripts/      # Optional
    └── examples/     # Optional
    ```

### 3. Upstream Sync & Verification
1. Copy or update files under `skills/<skill-name>/` in the discovered skills repository.
2. If new skills are added, update the central `README.md` catalog table if present.
3. Review changes via `git diff` inside the skills repository.
4. If installed globally in the agent runtime as a directory copy rather than a symlink, synchronize the runtime copy (`cp -r` or `ln -s`).

### 4. Atomic Commit & Push
Within the central skills repository:
- Stage only the relevant skill files:
  ```bash
  git add skills/<skill-name>/
  ```
- Commit using Conventional Commits in English:
  - New skill: `feat(<skill-name>): add <skill-name> skill`
  - Improvements: `fix(<skill-name>): improve <aspect>` or `docs(<skill-name>): expand reference documentation`
- Push to the remote branch or prepare a Pull Request according to the project's git workflow.

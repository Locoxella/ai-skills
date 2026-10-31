#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# new-skill.sh - Scaffold a new standard skill directory
# ==============================================================================

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_DIR="${REPO_ROOT}/skills"

usage() {
  cat << 'EOF'
Usage: ./scripts/new-skill.sh <skill-name>

Arguments:
  <skill-name>  The kebab-case name of the new skill (e.g., docker-compose-ops)

Examples:
  ./scripts/new-skill.sh redis-cluster-admin
EOF
  exit 1
}

if [[ $# -ne 1 ]]; then
  usage
fi

SKILL_NAME="$1"

# Validate kebab-case
if [[ ! "${SKILL_NAME}" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  echo "Error: Skill name must be strictly lowercase kebab-case (e.g. 'my-skill-name')." >&2
  exit 1
fi

TARGET_DIR="${SKILLS_DIR}/${SKILL_NAME}"

if [[ -d "${TARGET_DIR}" ]]; then
  echo "Error: Skill directory already exists at ${TARGET_DIR}" >&2
  exit 1
fi

echo "Creating new skill scaffolding for: ${SKILL_NAME}..."

mkdir -p "${TARGET_DIR}/references"
mkdir -p "${TARGET_DIR}/scripts"
mkdir -p "${TARGET_DIR}/examples"

# Generate title from kebab-case
TITLE=$(echo "${SKILL_NAME}" | awk -F- '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1')

cat << EOF > "${TARGET_DIR}/SKILL.md"
---
name: ${SKILL_NAME}
description: Concise 1-2 sentence description explaining when and why the agent should activate this skill.
---

# ${TITLE} Skill

## Overview & Trigger Conditions
When and why this skill should be activated by an agent.

## Workflow & Constraints
Step-by-step instructions, constraints, safety checks, and best practices.

### 1. Step Title
- Specific guideline or command.

### 2. Step Title
- Specific guideline or command.

## References & Examples
- See [references/](./references/) for deep-dive technical notes.
- See [examples/](./examples/) for code snippets.
EOF

echo "✔ Successfully scaffolded new skill at: skills/${SKILL_NAME}"
echo "  - Entrypoint: skills/${SKILL_NAME}/SKILL.md"
echo "  - Directories: references/, scripts/, examples/"

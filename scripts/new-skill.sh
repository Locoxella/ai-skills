#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# new-skill.sh - Scaffold a new P2/P3 skill directory
# ==============================================================================

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_DIR="${REPO_ROOT}/skills"

usage() {
  cat << 'EOF'
Usage: ./scripts/new-skill.sh <skill-name>

Arguments:
  <skill-name>  Lowercase kebab-case skill name (e.g., docker-compose-ops)

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

mkdir -p "${TARGET_DIR}/references" "${TARGET_DIR}/scripts"

TODAY="$(date +%Y-%m-%d)"
TITLE=$(echo "${SKILL_NAME}" | awk -F- '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1')

cat << EOF > "${TARGET_DIR}/SKILL.md"
---
name: ${SKILL_NAME}
description: >-
  Concise 1-sentence summary of the single responsibility covered by this skill.
  WHEN: trigger keywords, file paths, or situations when the agent should load this skill.
  WHEN NOT: adjacent scenarios where this skill must not be loaded.
---

# ${TITLE} (\`last-verified: ${TODAY}\`)

Depends on Core Directives: [AGENTS.md (\`#p0\`)](../../AGENTS.md#p0)

## Decision Flow & Procedure

1. **Step 1**: Imperative action or verification check.
2. **Step 2**: Imperative execution command using placeholders (\`<PLACEHOLDER>\`, \`\${ENV_VAR}\`) only.

## Reference Details (P3)

- Commands, schemas, and edge cases: [reference.md](./references/reference.md)
EOF

cat << EOF > "${TARGET_DIR}/references/reference.md"
# ${TITLE} Reference (\`last-verified: ${TODAY}\`)

Store bulky examples, IDs, URLs, and edge cases here instead of repeating them in \`SKILL.md\`.
EOF

echo "✔ Successfully scaffolded P2/P3 skill at: skills/${SKILL_NAME}"
echo "  - P2 Entrypoint: skills/${SKILL_NAME}/SKILL.md"
echo "  - P3 Reference:  skills/${SKILL_NAME}/references/reference.md"

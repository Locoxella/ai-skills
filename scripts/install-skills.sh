#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# install-skills.sh - Multi-Agent Skill & Core Memory Bootstrap Utility
# ==============================================================================

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_DIR="${REPO_ROOT}/skills"
TEMPLATES_DIR="${REPO_ROOT}/templates"

usage() {
  cat << 'EOF'
Usage: ./scripts/install-skills.sh [OPTIONS]

Options:
  -a, --agent <agent>       Target runtime: antigravity (default), cursor, claude
  -s, --skill <skill-name>  Specific skill name to install (default: all)
  --all                     Install all skills (default if -s is omitted)
  --scope <global|project>  Target scope: global (default) or project (CWD)
  -b, --bootstrap           Install starter core memory & INDEX templates if missing
  -f, --force               Overwrite existing template files during --bootstrap
  -l, --list                List all available skills in catalog
  -d, --dry-run             Preview actions without writing files or symlinks
  -h, --help                Show this help message

Examples:
  ./scripts/install-skills.sh --list
  ./scripts/install-skills.sh --agent antigravity --bootstrap --all
  ./scripts/install-skills.sh --agent antigravity --scope project --bootstrap
  ./scripts/install-skills.sh --agent cursor --scope project --skill git-commit-push
EOF
  exit 0
}

AGENT="antigravity"
TARGET_SKILL=""
ALL_SKILLS=0
SCOPE="global"
BOOTSTRAP=0
FORCE=0
DRY_RUN=0

list_skills() {
  echo "Available skills in catalog (${SKILLS_DIR}):"
  echo "------------------------------------------------------------"
  for skill_path in "${SKILLS_DIR}"/*; do
    if [[ -d "${skill_path}" && -f "${skill_path}/SKILL.md" ]]; then
      name="$(basename "${skill_path}")"
      desc=$(python3 -c "import yaml;
try:
    content = open('${skill_path}/SKILL.md', encoding='utf-8').read().split('---', 2)[1]
    d = yaml.safe_load(content).get('description', '')
    print(' '.join(str(d).split())[:75])
except Exception:
    print('')
")
      printf "  %-30s %s...\n" "${name}" "${desc}"
    fi
  done
  echo "------------------------------------------------------------"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -a|--agent)
      AGENT="$2"
      shift 2
      ;;
    -s|--skill)
      TARGET_SKILL="$2"
      shift 2
      ;;
    --all)
      ALL_SKILLS=1
      shift
      ;;
    --scope)
      SCOPE="$2"
      shift 2
      ;;
    -b|--bootstrap)
      BOOTSTRAP=1
      shift
      ;;
    -f|--force)
      FORCE=1
      shift
      ;;
    -l|--list)
      list_skills
      exit 0
      ;;
    -d|--dry-run)
      DRY_RUN=1
      shift
      ;;
    -h|--help)
      usage
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage
      ;;
  esac
done

if [[ -z "${TARGET_SKILL}" ]]; then
  ALL_SKILLS=1
fi

get_target_dir() {
  local agent="$1"
  local scope="$2"

  case "${agent}" in
    antigravity)
      if [[ "${scope}" == "global" ]]; then
        echo "${HOME}/.gemini/config/skills"
      else
        echo "$(pwd)/.agents/skills"
      fi
      ;;
    cursor)
      if [[ "${scope}" == "global" ]]; then
        echo "${HOME}/.cursor/skills"
      else
        echo "$(pwd)/.cursor/skills"
      fi
      ;;
    claude)
      if [[ "${scope}" == "global" ]]; then
        echo "${HOME}/.claude/skills"
      else
        echo "$(pwd)/.claude/skills"
      fi
      ;;
    *)
      echo "Unsupported agent: ${agent}. Supported: antigravity, cursor, claude" >&2
      exit 1
      ;;
  esac
}

install_template_file() {
  local src="$1"
  local dest="$2"
  local today
  today="$(date +%Y-%m-%d)"

  if [[ ! -f "${src}" ]]; then
    echo "  ✖ Template not found: ${src}" >&2
    return 1
  fi

  if [[ -e "${dest}" && ${FORCE} -eq 0 ]]; then
    echo "  → Preserving existing ${dest} (pass --force to overwrite)"
    return 0
  fi

  if [[ ${DRY_RUN} -eq 1 ]]; then
    echo "[DRY-RUN] Copy template: ${src} -> ${dest}"
    return 0
  fi

  mkdir -p "$(dirname "${dest}")"
  sed "s/YYYY-MM-DD/${today}/g" "${src}" > "${dest}"
  echo "  ✔ Bootstrapped ${dest}"
}

bootstrap_templates() {
  if [[ ! -d "${TEMPLATES_DIR}" ]]; then
    echo "Warning: Templates directory not found at ${TEMPLATES_DIR}, skipping bootstrap." >&2
    return 0
  fi

  echo "Bootstrapping core memory templates for [${AGENT}] (Scope: ${SCOPE})..."
  case "${AGENT}:${SCOPE}" in
    antigravity:global)
      install_template_file "${TEMPLATES_DIR}/INDEX.md" "${HOME}/.gemini/INDEX.md"
      install_template_file "${TEMPLATES_DIR}/GEMINI.md" "${HOME}/.gemini/GEMINI.md"
      install_template_file "${TEMPLATES_DIR}/secrets-setup.md" "${HOME}/.gemini/secrets-setup.md"
      ;;
    antigravity:project)
      install_template_file "${TEMPLATES_DIR}/AGENTS.md" "$(pwd)/.agents/AGENTS.md"
      ;;
    claude:global)
      install_template_file "${TEMPLATES_DIR}/GEMINI.md" "${HOME}/.claude/CLAUDE.md"
      install_template_file "${TEMPLATES_DIR}/secrets-setup.md" "${HOME}/.claude/secrets-setup.md"
      ;;
    claude:project)
      install_template_file "${TEMPLATES_DIR}/AGENTS.md" "$(pwd)/CLAUDE.md"
      ;;
    cursor:global)
      install_template_file "${TEMPLATES_DIR}/GEMINI.md" "${HOME}/.cursor/rules.md"
      ;;
    cursor:project)
      install_template_file "${TEMPLATES_DIR}/AGENTS.md" "$(pwd)/.cursorrules"
      ;;
  esac
}

DEST_DIR="$(get_target_dir "${AGENT}" "${SCOPE}")"

install_single_skill() {
  local skill="$1"
  local src="${SKILLS_DIR}/${skill}"
  local dest="${DEST_DIR}/${skill}"

  if [[ ! -d "${src}" || ! -f "${src}/SKILL.md" ]]; then
    echo "Error: Skill '${skill}' not found in ${SKILLS_DIR}" >&2
    return 1
  fi

  if [[ ${DRY_RUN} -eq 1 ]]; then
    echo "[DRY-RUN] Symlink: ${src} -> ${dest}"
    return 0
  fi

  mkdir -p "${DEST_DIR}"
  if [[ -L "${dest}" ]]; then
    echo "  → Updating existing symlink for ${skill}"
    rm -f "${dest}"
  elif [[ -e "${dest}" ]]; then
    echo "  → Warning: ${dest} exists and is not a symlink. Skipping." >&2
    return 0
  fi

  ln -s "${src}" "${dest}"
  echo "  ✔ Installed ${skill} -> ${dest}"
}

if [[ ${BOOTSTRAP} -eq 1 ]]; then
  bootstrap_templates
fi

echo "Installing skills for [${AGENT}] (Scope: ${SCOPE})..."
echo "Target directory: ${DEST_DIR}"

if [[ -n "${TARGET_SKILL}" && ${ALL_SKILLS} -eq 0 ]]; then
  install_single_skill "${TARGET_SKILL}"
else
  for skill_path in "${SKILLS_DIR}"/*; do
    if [[ -d "${skill_path}" && -f "${skill_path}/SKILL.md" ]]; then
      name="$(basename "${skill_path}")"
      install_single_skill "${name}"
    fi
  done
fi

echo "Done!"

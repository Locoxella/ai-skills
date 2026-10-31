#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# install-skills.sh - Multi-Agent Skill Installation & Symlinking Utility
# ==============================================================================

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_DIR="${REPO_ROOT}/skills"

usage() {
  cat << 'EOF'
Usage: ./scripts/install-skills.sh [OPTIONS]

Options:
  -a, --agent <agent>       Target agent runtime: antigravity (default), cursor, claude
  -s, --skill <skill-name>  Specific skill name to install (default: all)
  --all                     Install all skills (default behavior if -s is omitted)
  --scope <global|project>  Target scope: global (default) or project (current dir)
  -l, --list                List all available skills in catalog
  -d, --dry-run             Preview actions without executing symlinks
  -h, --help                Show this help message

Examples:
  ./scripts/install-skills.sh --list
  ./scripts/install-skills.sh --agent antigravity --all
  ./scripts/install-skills.sh --agent antigravity --skill cloudflare
  ./scripts/install-skills.sh --agent cursor --scope project --skill git-commit-push
EOF
  exit 0
}

AGENT="antigravity"
TARGET_SKILL=""
ALL_SKILLS=0
SCOPE="global"
DRY_RUN=0

list_skills() {
  echo "Available skills in catalog (${SKILLS_DIR}):"
  echo "------------------------------------------------------------"
  for skill_path in "${SKILLS_DIR}"/*; do
    if [[ -d "${skill_path}" && -f "${skill_path}/SKILL.md" ]]; then
      name="$(basename "${skill_path}")"
      desc=$(python3 -c "import yaml, sys;
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

# Parse options
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

# If no specific skill specified, default to all
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

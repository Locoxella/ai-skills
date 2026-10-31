#!/usr/bin/env bash
set -euo pipefail

# Helper script to generate .gitignore using toptal gitignore.io API.
# Automatically includes OS (linux, macos, windows) and IDE (visualstudiocode).

usage() {
  cat << 'EOF'
Usage: generate-gitignore.sh [OPTIONS] <tech1> [tech2 ...]

Arguments:
  techN                  Languages, frameworks, or tools (e.g., python, rust, node, go)

Options:
  -o, --output <file>    Output destination file (default: .gitignore)
  -c, --custom <file>    File containing custom project rules to append
  --dry-run              Print to stdout instead of writing to file
  -h, --help             Show this help message
EOF
  exit 1
}

OUTPUT_FILE=".gitignore"
CUSTOM_RULES_FILE=""
DRY_RUN=0
declare -a TECHS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    -o|--output)
      OUTPUT_FILE="$2"
      shift 2
      ;;
    -c|--custom)
      CUSTOM_RULES_FILE="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    -h|--help)
      usage
      ;;
    *)
      # Split comma-separated tokens if provided
      IFS=',' read -ra ADDR <<< "$1"
      for i in "${ADDR[@]}"; do
        TECHS+=("$i")
      done
      shift
      ;;
  esac
done

# Standard mandatory defaults
declare -a DEFAULT_TARGETS=("linux" "macos" "windows" "visualstudiocode")
declare -a COMBINED_TARGETS=("${DEFAULT_TARGETS[@]}")

for t in "${TECHS[@]}"; do
  # Avoid duplicates
  t_clean="$(echo "$t" | tr '[:upper:]' '[:lower:]' | xargs)"
  if [[ -n "$t_clean" ]]; then
    found=0
    for existing in "${COMBINED_TARGETS[@]}"; do
      if [[ "$existing" == "$t_clean" ]]; then
        found=1
        break
      fi
    done
    if [[ $found -eq 0 ]]; then
      COMBINED_TARGETS+=("$t_clean")
    fi
  fi
done

API_TARGETS=$(IFS=','; echo "${COMBINED_TARGETS[*]}")
API_URL="https://www.toptal.com/developers/gitignore/api/${API_TARGETS}"

TEMP_FILE=$(mktemp)
trap 'rm -f "$TEMP_FILE"' EXIT

echo "Fetching .gitignore templates for: ${API_TARGETS}..." >&2
if ! curl -fsSL "$API_URL" -o "$TEMP_FILE"; then
  echo "Error: Failed to fetch from ${API_URL}" >&2
  exit 1
fi

# Check for sandbox error or invalid payload
if grep -qi "not allowed by policy" "$TEMP_FILE"; then
  echo "Error: Network request blocked by sandbox policy. Run with BypassSandbox: true." >&2
  exit 1
fi

# Append custom project rules block
cat >> "$TEMP_FILE" << 'EOF'

# ==============================================================================
# Custom Project Rules
# ==============================================================================
# Add project-specific files below that are not covered by gitignore.io.
EOF

if [[ -n "$CUSTOM_RULES_FILE" && -f "$CUSTOM_RULES_FILE" ]]; then
  echo "" >> "$TEMP_FILE"
  cat "$CUSTOM_RULES_FILE" >> "$TEMP_FILE"
else
  cat >> "$TEMP_FILE" << 'EOF'
.env
*.env
*.local
*.db
*.sqlite3
scratch/
EOF
fi

if [[ $DRY_RUN -eq 1 ]]; then
  cat "$TEMP_FILE"
else
  cp "$TEMP_FILE" "$OUTPUT_FILE"
  echo "Successfully generated: ${OUTPUT_FILE}" >&2
fi

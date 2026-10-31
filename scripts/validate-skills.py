#!/usr/bin/env python3
"""
validate-skills.py - Multi-Agent Skill Library Validator

Validates skills against AGENTS.md directives:
1. Folder structure and SKILL.md entrypoint.
2. YAML frontmatter completeness (name, description) and directory name match.
3. Integrity of relative markdown links.
4. Script execution permissions (chmod +x) and shebangs.
5. Zero-secrets audit (prevent committing raw API keys or private keys).
"""

import os
import re
import sys
import yaml
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
SKILLS_DIR = REPO_ROOT / "skills"

# Patterns to scan for potential secrets
SECRET_PATTERNS = [
    (re.compile(r"-----BEGIN (?:RSA |EC |OPENSSH |DSA )?PRIVATE KEY-----"), "Private key block detected"),
    (re.compile(r"(?:api[_-]?key|auth[_-]?token|bearer)\s*[:=]\s*['\"][a-zA-Z0-9_\-]{20,}['\"]", re.IGNORECASE), "Suspicious hardcoded API key or auth token"),
    (re.compile(r"ghp_[a-zA-Z0-9]{36}"), "GitHub Personal Access Token"),
    (re.compile(r"xox[baprs]-[0-9]{10,13}-[0-9]{10,13}-[a-zA-Z0-9]{24}"), "Slack API Token"),
]

def check_frontmatter(skill_dir: Path, errors: list):
    skill_md = skill_dir / "SKILL.md"
    if not skill_md.is_file():
        errors.append(f"[{skill_dir.name}] Missing required SKILL.md entrypoint.")
        return

    try:
        content = skill_md.read_text(encoding="utf-8")
    except Exception as e:
        errors.append(f"[{skill_dir.name}] Failed to read SKILL.md: {e}")
        return

    if not content.startswith("---"):
        errors.append(f"[{skill_dir.name}] SKILL.md missing leading YAML frontmatter delimiter ('---').")
        return

    parts = content.split("---", 2)
    if len(parts) < 3:
        errors.append(f"[{skill_dir.name}] SKILL.md malformed YAML frontmatter (missing closing '---').")
        return

    try:
        fm = yaml.safe_load(parts[1])
        if not isinstance(fm, dict):
            errors.append(f"[{skill_dir.name}] Frontmatter is not a valid YAML dictionary.")
            return
    except Exception as e:
        errors.append(f"[{skill_dir.name}] Error parsing YAML frontmatter: {e}")
        return

    name = fm.get("name")
    description = fm.get("description")

    if not name:
        errors.append(f"[{skill_dir.name}] Missing 'name' field in frontmatter.")
    elif name != skill_dir.name:
        errors.append(f"[{skill_dir.name}] Frontmatter name '{name}' does not match directory name '{skill_dir.name}'.")

    if not description or not str(description).strip():
        errors.append(f"[{skill_dir.name}] Missing or empty 'description' in frontmatter.")

def check_markdown_links(errors: list):
    md_files = list(REPO_ROOT.glob("*.md")) + list(SKILLS_DIR.glob("**/*.md"))
    link_pattern = re.compile(r"\[([^\]]+)\]\(([^)]+)\)")

    for md_path in md_files:
        try:
            content = md_path.read_text(encoding="utf-8", errors="ignore")
        except Exception as e:
            errors.append(f"[{md_path.relative_to(REPO_ROOT)}] Could not read file: {e}")
            continue

        for text, target in link_pattern.findall(content):
            target = target.strip()
            # Ignore external, anchor-only, mailto, or special URLs
            if target.startswith(("http://", "https://", "#", "mailto:", "javascript:")):
                continue
            
            # Separate anchor if present
            target_file = target.split("#")[0]
            if not target_file:
                continue

            # Resolve relative path
            target_path = (md_path.parent / target_file).resolve()
            if not target_path.exists():
                errors.append(
                    f"[{md_path.relative_to(REPO_ROOT)}] Broken link '{target}' -> Resolved path does not exist: {target_path}"
                )

def check_scripts(errors: list):
    scripts = list(REPO_ROOT.glob("scripts/**/*.*")) + list(SKILLS_DIR.glob("*/scripts/**/*.*"))
    for script in scripts:
        if script.is_file() and script.suffix in [".sh", ".py", ".js"]:
            # Check executable bit
            if not os.access(script, os.X_OK):
                errors.append(f"[{script.relative_to(REPO_ROOT)}] Script is not marked executable (run chmod +x).")
            # Check shebang
            try:
                first_line = script.read_text(encoding="utf-8", errors="ignore").splitlines()[0]
                if not first_line.startswith("#!"):
                    errors.append(f"[{script.relative_to(REPO_ROOT)}] Missing shebang line (e.g., #!/usr/bin/env bash).")
            except IndexError:
                errors.append(f"[{script.relative_to(REPO_ROOT)}] Empty script file.")

def check_secrets(errors: list):
    for root, dirs, files in os.walk(REPO_ROOT):
        # Skip git directory
        if ".git" in root:
            continue
        for f in files:
            file_path = Path(root) / f
            # Skip binary files or common non-text files
            if file_path.suffix in [".png", ".jpg", ".jpeg", ".ico", ".tar", ".gz", ".zip"]:
                continue
            try:
                content = file_path.read_text(encoding="utf-8", errors="ignore")
                for pattern, msg in SECRET_PATTERNS:
                    if pattern.search(content):
                        errors.append(f"[{file_path.relative_to(REPO_ROOT)}] Security policy violation: {msg}")
            except Exception:
                pass

def main():
    print("=" * 60)
    print("  AI Skills Library Validator (AGENTS.md Compliance)")
    print("=" * 60)

    errors = []

    # 1. Validate skill frontmatter and directory structure
    if not SKILLS_DIR.is_dir():
        print(f"FATAL: Skills directory not found at {SKILLS_DIR}")
        sys.exit(1)

    skill_count = 0
    for entry in sorted(SKILLS_DIR.iterdir()):
        if entry.is_dir() and not entry.name.startswith("."):
            skill_count += 1
            check_frontmatter(entry, errors)

    print(f"✔ Audited {skill_count} skills in skills/ catalog.")

    # 2. Check markdown link integrity
    check_markdown_links(errors)
    print("✔ Audited relative markdown link integrity.")

    # 3. Check scripts execution and shebangs
    check_scripts(errors)
    print("✔ Audited script permissions and shebangs.")

    # 4. Secrets audit
    check_secrets(errors)
    print("✔ Audited secret hygiene (zero private keys or API tokens).")

    print("-" * 60)
    if errors:
        print(f"FAILED: Found {len(errors)} error(s):")
        for err in errors:
            print(f"  ✖ {err}")
        print("=" * 60)
        sys.exit(1)
    else:
        print(f"ALL CHECKS PASSED: Catalog is clean and compliant!")
        print("=" * 60)
        sys.exit(0)

if __name__ == "__main__":
    main()

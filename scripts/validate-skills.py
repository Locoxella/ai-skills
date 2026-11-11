#!/usr/bin/env python3
"""
validate-skills.py - Multi-Agent Skill Library Validator

Validates skills and starter templates against AGENTS.md directives:
1. Folder structure and SKILL.md entrypoint.
2. YAML frontmatter completeness (name, description) and directory name match.
3. Integrity of relative markdown links across root, skills/, and templates/.
4. Script execution permissions (chmod +x) and shebangs.
5. Zero-secrets audit (prevent committing raw API keys, JWTs, or private keys).
"""

import os
import re
import sys
import yaml
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
SKILLS_DIR = REPO_ROOT / "skills"
TEMPLATES_DIR = REPO_ROOT / "templates"

# Patterns to scan for potential secrets
SECRET_PATTERNS = [
    (re.compile(r"-----BEGIN (?:RSA |EC |OPENSSH |DSA )?PRIVATE KEY-----"), "Private key block detected"),
    (re.compile(r"(?:api[_-]?key|auth[_-]?token|bearer)\s*[:=]\s*['\"][a-zA-Z0-9_\-]{20,}['\"]", re.IGNORECASE), "Suspicious hardcoded API key or auth token"),
    (re.compile(r"gh[pousr]_[a-zA-Z0-9]{36}"), "GitHub Token"),
    (re.compile(r"AKIA[0-9A-Z]{16}"), "AWS Access Key ID"),
    (re.compile(r"eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}"), "Hardcoded JWT token detected"),
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


def check_templates(errors: list):
    required = ["INDEX.md", "GEMINI.md", "AGENTS.md", "secrets-setup.md"]
    if not TEMPLATES_DIR.is_dir():
        errors.append("[templates] Missing required templates/ directory.")
        return
    for filename in required:
        if not (TEMPLATES_DIR / filename).is_file():
            errors.append(f"[templates/{filename}] Missing required bootstrap template.")


def check_markdown_links(errors: list):
    md_files = list(REPO_ROOT.glob("*.md")) + list(SKILLS_DIR.glob("**/*.md"))
    if TEMPLATES_DIR.is_dir():
        md_files.extend(TEMPLATES_DIR.glob("**/*.md"))

    link_pattern = re.compile(r"\[([^\]]+)\]\(([^)]+)\)")

    for md_path in md_files:
        try:
            content = md_path.read_text(encoding="utf-8", errors="ignore")
        except Exception as e:
            errors.append(f"[{md_path.relative_to(REPO_ROOT)}] Could not read file: {e}")
            continue

        for _text, target in link_pattern.findall(content):
            target = target.strip()
            if target.startswith(("http://", "https://", "#", "mailto:", "javascript:")):
                continue

            target_file = target.split("#")[0]
            if not target_file:
                continue

            target_path = (md_path.parent / target_file).resolve()
            if not target_path.exists():
                errors.append(
                    f"[{md_path.relative_to(REPO_ROOT)}] Broken link '{target}' -> Resolved path does not exist: {target_path}"
                )


def check_scripts(errors: list):
    scripts = list(REPO_ROOT.glob("scripts/**/*.*")) + list(SKILLS_DIR.glob("*/scripts/**/*.*"))
    for script in scripts:
        if script.is_file() and script.suffix in [".sh", ".py", ".js"]:
            if not os.access(script, os.X_OK):
                errors.append(f"[{script.relative_to(REPO_ROOT)}] Script is not marked executable (run chmod +x).")
            try:
                first_line = script.read_text(encoding="utf-8", errors="ignore").splitlines()[0]
                if not first_line.startswith("#!"):
                    errors.append(f"[{script.relative_to(REPO_ROOT)}] Missing shebang line (e.g., #!/usr/bin/env bash).")
            except IndexError:
                errors.append(f"[{script.relative_to(REPO_ROOT)}] Empty script file.")


def check_secrets(errors: list):
    for root, _dirs, files in os.walk(REPO_ROOT):
        if ".git" in root:
            continue
        for f in files:
            file_path = Path(root) / f
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

    if not SKILLS_DIR.is_dir():
        print(f"FATAL: Skills directory not found at {SKILLS_DIR}")
        sys.exit(1)

    skill_count = 0
    for entry in sorted(SKILLS_DIR.iterdir()):
        if entry.is_dir() and not entry.name.startswith("."):
            skill_count += 1
            check_frontmatter(entry, errors)

    print(f"✔ Audited {skill_count} skills in skills/ catalog.")

    check_templates(errors)
    print("✔ Audited bootstrap templates in templates/.")

    check_markdown_links(errors)
    print("✔ Audited relative markdown link integrity.")

    check_scripts(errors)
    print("✔ Audited script permissions and shebangs.")

    check_secrets(errors)
    print("✔ Audited secret hygiene (zero private keys, JWTs, or API tokens).")

    print("-" * 60)
    if errors:
        print(f"FAILED: Found {len(errors)} error(s):")
        for err in errors:
            print(f"  ✖ {err}")
        print("=" * 60)
        sys.exit(1)
    else:
        print("ALL CHECKS PASSED: Catalog is clean and compliant!")
        print("=" * 60)
        sys.exit(0)


if __name__ == "__main__":
    main()

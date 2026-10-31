#!/usr/bin/env python3
"""
generate-catalog.py - Generate or update the skills catalog in README.md
"""

import os
import re
import yaml
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
SKILLS_DIR = REPO_ROOT / "skills"
README_FILE = REPO_ROOT / "README.md"

def get_skills_catalog():
    catalog = []
    for entry in sorted(SKILLS_DIR.iterdir()):
        if entry.is_dir() and not entry.name.startswith("."):
            skill_md = entry / "SKILL.md"
            if skill_md.is_file():
                content = skill_md.read_text(encoding="utf-8")
                parts = content.split("---", 2)
                if len(parts) >= 3:
                    try:
                        fm = yaml.safe_load(parts[1])
                        name = fm.get("name", entry.name)
                        desc = fm.get("description", "").strip()
                        # Clean up multi-line descriptions
                        desc = " ".join(desc.split())
                        catalog.append((name, desc))
                    except Exception:
                        pass
    return catalog

def update_readme(catalog):
    content = README_FILE.read_text(encoding="utf-8")

    # Generate tree block
    tree_lines = [
        "ai-skills/",
        "├── README.md               # Human overview & quick start (this file)",
        "├── AGENTS.md               # Strict operational instructions for AI agents",
        "├── LICENSE                 # Open-source MIT license",
        "├── .gitignore              # Standard git exclusion rules (gitignore.io)",
        "├── .github/workflows/      # Automated CI workflows (skills validation)",
        "├── scripts/                # Validation and multi-agent management scripts",
        "│   ├── validate-skills.py  # Linting & verification suite for skills",
        "│   ├── install-skills.sh   # Automated symlink installer for agents",
        "│   ├── new-skill.sh        # Scaffolding tool for new skills",
        "│   └── generate-catalog.py # Catalog generator",
        "└── skills/                 # Catalog of AI skills",
    ]

    for i, (name, desc) in enumerate(catalog):
        prefix = "    └── " if i == len(catalog) - 1 else "    ├── "
        # Truncate description for tree comment
        short_desc = desc if len(desc) <= 50 else desc[:47] + "..."
        tree_lines.append(f"{prefix}{name:<27} # {short_desc}")

    tree_str = "```text\n" + "\n".join(tree_lines) + "\n```"

    # Replace the tree in README.md
    new_content = re.sub(
        r"```(?:text)?\nai-skills/\n.*?```",
        tree_str,
        content,
        flags=re.DOTALL
    )

    README_FILE.write_text(new_content, encoding="utf-8")
    print(f"✔ Successfully updated README.md with {len(catalog)} skills.")

def main():
    catalog = get_skills_catalog()
    update_readme(catalog)

if __name__ == "__main__":
    main()

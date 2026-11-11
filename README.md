# AI Skills Library

> A cross-agent, layered skill and memory starter kit for AI coding agents
> (Antigravity, Claude Code, Cursor, Codex, OpenCodeInterpreter).

---

## ⚡ TL;DR for Humans

- **Layered Architecture**: Organizes agent context into 4 fast-lookup
  layers: `INDEX.md` (routing) -> `P0/P1` core memory (`GEMINI.md` /
  `AGENTS.md`) -> `P2` skills (`SKILL.md`) -> `P3` references (`references/`).
- **Zero-Secret Starter Templates**: [`templates/`](templates/) provides
  ready-to-use `INDEX.md`, `GEMINI.md`, `AGENTS.md`, and
  [`secrets-setup.md`](templates/secrets-setup.md) explaining how to generate
  and inject secrets safely without ever committing credentials.
- **For Agents**: Review and follow [`AGENTS.md`](AGENTS.md) when maintaining
  or authoring skills.
- **Language Policy**: All skills, rules, documentation, and commits default
  to English for maximum token efficiency.

---

## 📂 Repository Structure

```text
ai-skills/
├── README.md               # Human overview & quick start (this file)
├── AGENTS.md               # Core agent directives (P0/P1)
├── LICENSE                 # Open-source MIT license
├── .gitignore              # Standard exclusions (gitignore.io)
├── .github/workflows/      # Automated CI validation
├── templates/              # Starter P0/P1/INDEX & secret-setup docs
├── scripts/                # Bootstrap & validation scripts
│   ├── validate-skills.py  # Schema, link, script & secret validator
│   ├── install-skills.sh   # Multi-agent skill & template installer
│   ├── new-skill.sh        # P2/P3 skill scaffolding tool
│   └── generate-catalog.py # Catalog tree generator
└── skills/                 # Catalog of AI skills (P2/P3)
    ├── cicd-pipeline-excellence    # Author, audit, and maintain GitHub Acti...
    ├── cloudflare                  # Comprehensive Cloudflare platform skill...
    ├── cloudflare-email-service    # Send and receive transactional emails w...
    ├── cloudflare-one              # Guides Cloudflare One Zero Trust and SA...
    ├── cloudflare-one-migrations   # Plans migrations from Zscaler ZIA/ZPA, ...
    ├── git-commit-push             # Verify tests/linters, audit `.gitignore...
    ├── gitignore-generator         # Generate and maintain two-section .giti...
    ├── iac-clean-architecture      # Enforce zero hardcoded resource IDs, im...
    ├── language-and-token-efficiency # Enforce English across all agent thou...
    ├── markdown-linting            # Enforce clean formatting and zero-suppr...
    ├── ocr-fallback-evaluator      # Resolve deterministic PDF/OCR extractio...
    ├── offline-html-dashboard      # Build modular, interconnected, zero-inf...
    └── skill-contribute            # Export, validate, and commit reusable s...
```

---

## 🚀 Bootstrap an Agent from Scratch

### 1. 🤖 One-Shot Agent Self-Installation (Recommended)

Paste this prompt into a fresh agent session on a new machine:

```text
Clone or inspect https://github.com/Locoxella/ai-skills and run
./scripts/install-skills.sh --agent antigravity --bootstrap --all
to install global starter memory templates (INDEX.md, GEMINI.md,
secrets-setup.md) and symlink all skills. Never commit or store real secrets;
follow templates/secrets-setup.md for local .env and CLI tokens.
```

For project-scoped initialization inside any repository:

```text
Inspect https://github.com/Locoxella/ai-skills and run
./scripts/install-skills.sh --agent antigravity --scope project --bootstrap
to install .agents/AGENTS.md and symlink the requested skills.
```

---

### 2. 💻 Scripted Bootstrap & Installation (CLI)

```bash
# List all available skills
./scripts/install-skills.sh --list

# Bootstrap global memory templates + symlink all skills for Antigravity
./scripts/install-skills.sh --agent antigravity --bootstrap --all

# Bootstrap a repository workspace (.agents/AGENTS.md + skills)
./scripts/install-skills.sh --agent antigravity --scope project --bootstrap

# Preview without modifying files (--force overwrites existing templates)
./scripts/install-skills.sh --bootstrap --dry-run

# Install a single skill for Cursor or Claude Code
./scripts/install-skills.sh --agent cursor --scope project -s git-commit-push
./scripts/install-skills.sh --agent claude --scope project --bootstrap --all
```

---

### 3. 🔐 Safe Secret Setup (Public Repo Policy)

This repository is public and never stores real tokens, keys, or passwords.
Use placeholders (`<API_KEY>`, `<HOST_IP>`, `${ENV_VAR}`) everywhere in docs
and follow [`templates/secrets-setup.md`](templates/secrets-setup.md) to
generate keys locally (`openssl rand`, `ssh-keygen`) and inject them at
runtime via `chmod 600 .env`, `EnvironmentFile`, or CLI auth (`gh auth login`).

---

## 🛠️ Maintaining & Contributing Skills

1. **Scaffold with P2/P3 Structure**: Run `./scripts/new-skill.sh <skill-name>`
   to create a `kebab-case` folder with `WHEN:` / `WHEN NOT:` frontmatter
   triggers and a `references/` directory.
2. **Keep Skills Atomic**: One responsibility per skill; move large snippets,
   schemas, and command lists to `references/*.md`.
3. **Validate Before PR**: Run `python3 scripts/generate-catalog.py` and
   `python3 scripts/validate-skills.py`, then open a Pull Request.
4. **Agent Guidelines**: Refer to [`AGENTS.md`](AGENTS.md) for full rules.

---

## 📄 License

MIT or compatible permissive open-source license.

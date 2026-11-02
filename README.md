# AI Skills Library

> A cross-agent, modular skill catalog for autonomous AI coding agents (Antigravity, Claude Code, Cursor, Codex, OpenCodeInterpreter, etc.).

---

## ⚡ TL;DR for Humans

- **What is this?**: A centralized repository of modular agent instructions ("skills"). Each skill defines specific expertise, workflows, verification steps, and best practices that any modern AI agent can load into its context.
- **Where are the skills?**: Inside the [`skills/`](skills/) directory. Each skill has its own folder with a `SKILL.md` entrypoint.
- **For Agents**: Agents must review and follow [`AGENTS.md`](AGENTS.md) when maintaining or authoring skills.
- **Language Policy**: In accordance with token-efficiency standards, all skills, documentation, and commit messages are maintained in English.

---

## 📂 Repository Structure

```text
ai-skills/
├── README.md               # Human overview & quick start (this file)
├── AGENTS.md               # Strict operational instructions for AI agents
├── LICENSE                 # Open-source MIT license
├── .gitignore              # Standard git exclusion rules (gitignore.io)
├── .github/workflows/      # Automated CI workflows (skills validation)
├── scripts/                # Validation and multi-agent management scripts
│   ├── validate-skills.py  # Linting & verification suite for skills
│   ├── install-skills.sh   # Automated symlink installer for agents
│   ├── new-skill.sh        # Scaffolding tool for new skills
│   └── generate-catalog.py # Catalog generator
└── skills/                 # Catalog of AI skills
    ├── cicd-pipeline-excellence    # Standard and best practices for CI/CD pipelines...
    ├── cloudflare                  # Comprehensive Cloudflare platform skill coverin...
    ├── cloudflare-email-service    # Send and receive transactional emails with Clou...
    ├── cloudflare-one              # Guides Cloudflare One Zero Trust and SASE work ...
    ├── cloudflare-one-migrations   # Plans migrations from Zscaler ZIA/ZPA, Palo Alt...
    ├── git-commit-push             # Ensures verified, tested code changes are stage...
    ├── gitignore-generator         # Generates and maintains battle-tested .gitignor...
    ├── iac-clean-architecture      # Standard and best practices for OpenTofu and Te...
    ├── language-and-token-efficiency # Directives for language boundaries and token op...
    ├── markdown-linting            # Ensures that human-facing markdown files (such ...
    ├── ocr-fallback-evaluator      # Handles OCR extraction failures using an LLM fa...
    ├── offline-html-dashboard      # Guidelines and patterns for creating modular, i...
    └── skill-contribute            # Protocols for contributing new skills, workflow...
```

---

## 🚀 How to Use These Skills with Your Agents

### Automated Installation (Recommended)

Use the bundled installation utility to symlink skills into your agent's configuration:

```bash
# List all available skills
./scripts/install-skills.sh --list

# Install all skills globally for Google Antigravity
./scripts/install-skills.sh --agent antigravity --all

# Install a specific skill for Cursor or Claude Code
./scripts/install-skills.sh --agent cursor --skill cloudflare
./scripts/install-skills.sh --agent claude --skill git-commit-push
```

---

### Manual Installation

#### 1. Google Antigravity

To install a skill globally for Antigravity:

```bash
# Symlink or copy the skill into your global Antigravity config directory:
ln -s "$(pwd)/skills/<skill-name>" "$HOME/.gemini/config/skills/<skill-name>"
```

Or for a specific project workspace:

```bash
ln -s "$(pwd)/skills/<skill-name>" "/path/to/project/.agents/skills/<skill-name>"
```

#### 2. Claude Code / Anthropic

Copy the desired skill contents or include it in `CLAUDE.md`:

```bash
# Append skill instructions to your project CLAUDE.md or reference them
cat skills/<skill-name>/SKILL.md >> /path/to/project/CLAUDE.md
```

#### 3. Cursor / Codex / Copilot

Place the skill into `.cursorrules` or `.github/copilot-instructions.md`, or reference the markdown file directly in your system prompts:

```bash
cp skills/<skill-name>/SKILL.md /path/to/project/.cursorrules
```

---

## 🛠️ Maintaining & Contributing Skills

1. **Keep Skills Atomic**: Each folder should address one clear capability or domain.
2. **Follow the Standard Frontmatter**:

   ```markdown
   ---
   name: skill-name
   description: When and why to activate this skill.
   ---
   ```

3. **No Secrets**: Never commit private keys, real tokens, or personal server passwords. Use placeholders (`<API_KEY>`, `<HOST_IP>`).
4. **Agent Guidelines**: Refer to [`AGENTS.md`](AGENTS.md) for full instructions on autonomous agent maintenance.

---

## 📄 License

MIT or compatible permissive open-source license.

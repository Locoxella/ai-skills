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

```
ai-skills/
├── README.md               # Human overview & quick start (this file)
├── AGENTS.md               # Strict operational instructions for AI agents
├── .gitignore              # Standard git exclusion rules
└── skills/                 # Library of skills
    ├── agents-sdk/                 # Cloudflare Agents SDK patterns & workflows
    ├── cloudflare/                 # Cloudflare core architecture and guidelines
    ├── cloudflare-email-service/   # Cloudflare Email Routing & worker handling
    ├── cloudflare-one/             # Zero Trust & Cloudflare One architecture
    ├── cloudflare-one-migrations/  # Zero Trust migration procedures
    ├── durable-objects/            # Cloudflare Durable Objects best practices
    ├── git-commit-push/            # Atomic commit, test verification & push workflow
    ├── gitignore-io/               # .gitignore hygiene via gitignore.io API
    ├── language-and-token-efficiency/ # Context window & token preservation rules
    ├── sandbox-migrate-to-next/    # Sandbox environment migrations
    ├── sandbox-next/               # Sandbox Next reference implementation
    ├── sandbox-stable/             # Sandbox Stable configuration
    ├── skill-contribute/           # Dynamic discovery & upstream contribution of skills
    ├── turnstile-spin/             # Cloudflare Turnstile integration
    ├── web-perf/                   # Web performance & Core Web Vitals optimization
    ├── workers-best-practices/     # Cloudflare Workers development best practices
    └── wrangler/                   # Wrangler CLI reference, commands & workflows
```

---

## 🚀 How to Use These Skills with Your Agents

### 1. Google Antigravity
To install a skill globally for Antigravity:
```bash
# Symlink or copy the skill into your global Antigravity skills directory:
ln -s "$(pwd)/skills/<skill-name>" "$HOME/.gemini/antigravity/skills/<skill-name>"
```
Or for a specific project workspace:
```bash
ln -s "$(pwd)/skills/<skill-name>" "/path/to/project/.antigravity/skills/<skill-name>"
```

### 2. Claude Code / Anthropic
Copy the desired skill contents or include it in `CLAUDE.md`:
```bash
# Append skill instructions to your project CLAUDE.md or reference them
cat skills/<skill-name>/SKILL.md >> /path/to/project/CLAUDE.md
```

### 3. Cursor / Codex / Copilot
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

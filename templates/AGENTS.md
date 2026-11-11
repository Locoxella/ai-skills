# Workspace Core Memory (`last-verified: YYYY-MM-DD`)

Global Core Memory: `~/.gemini/GEMINI.md` | Global Index: `~/.gemini/INDEX.md`

## P0

### Safety & Secret Isolation
- Keep all credentials, `.env` files, private keys, and local runtime state excluded in `.gitignore` under `# Custom Project Rules`; never commit secrets or private host tokens (use `${ENV_VAR}` or `<PLACEHOLDER>`).
- `<ADD PROJECT-SPECIFIC NON-NEGOTIABLE GUARDRAILS HERE>`

## P1

### Architecture & Local Workflows
- `<ADD PRIMARY SOURCE PATHS, TEST COMMANDS, AND DEPLOYMENT RULES HERE>`
- Keep P2 multi-step workflows in `.agents/skills/<skill-name>/SKILL.md` and P3 command/API references in `.agents/skills/<skill-name>/references/`.

### Git Delivery
- Follow the global PR workflow (`feature branch` -> `Pull Request` -> `required status checks`) unless this repository is explicitly designated as a private state-tracking exception.

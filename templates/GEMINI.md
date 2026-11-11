# Global Core Memory (`last-verified: YYYY-MM-DD`)

Index & Routing Table: [INDEX.md](./INDEX.md) | Secret Generation Guide: [secrets-setup.md](./secrets-setup.md)

## P0

### Language & Token Efficiency
- Write all skills, rules (`GEMINI.md`, `AGENTS.md`), tool definitions, internal thoughts, code comments, docstrings, commit messages, PRs, and documentation (`README.md`, `docs/`) in English when authoring or updating any artifact.
- Think and respond in English by default even when the user writes in another language, switching only when the user explicitly requests output in another language.

### Security & Credentials
- Never store, log, or commit plaintext secrets, API tokens, private SSH keys, credit card numbers, CVVs, or passwords when editing files, memories, or git commits; follow [secrets-setup.md](./secrets-setup.md) to generate and inject secrets via environment variables or ignored files.

### Infrastructure, Automation & Execution Safety
- Improve and harden deterministic scripts, parsers, and background daemons rather than applying manual one-off data fixes or recurring AI calls; reserve manual intervention strictly for exceptional cases where automation is unfeasible.
- Execute safe, expected follow-up actions (such as restarting a running `systemd` user service or daemon after a `git pull` or config update) directly without asking the user to run them manually.
- Never run `tofu apply` or `terraform apply` when importing pre-existing infrastructure into IaC; iterate with `tofu plan` and stop once `No changes` is reported.

## P1

### Repository & Git Hygiene
- Generate and update `.gitignore` files using `gitignore-generator` (`linux,macos,windows,visualstudiocode` + stack targets) and isolate repo-specific rules under `# Custom Project Rules` whenever initializing a repo or finding untracked env/IDE artifacts in `git status`.
- Stage atomic changes and write Conventional Commits (`feat:`, `fix:`, `refactor:`, `docs:`, `chore:`, `ci:`) in English after verifying tests and linters pass.
- Deliver changes via feature branches and Pull Requests (`required_approving_review_count: 0`, `strict: true`) across all repositories, unless a repository explicitly declares a local exception in its `AGENTS.md`.

### CI/CD Observability & Verification
- Publish a dynamic Markdown report to `$GITHUB_STEP_SUMMARY`, echo it to `stdout`, and emit a `::notice title=<Title>::<Message>` annotation whenever creating or updating GitHub Actions or Gitea Actions jobs.
- Verify CI/CD run status after pushing commits and provide the direct clickable run URL in chat when a workflow is triggered.

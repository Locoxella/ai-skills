# Gitea CLI, Checkout & Versioning Reference (`last-verified: 2026-11-11`)

## 1. Gitea CLI (`tea`) & Checkout Configuration

- **Inspect Workflow Runs**:
  ```bash
  tea actions runs list --repo <owner>/<repo-name>
  tea actions runs show --repo <owner>/<repo-name> <run-id>
  tea actions runs logs --repo <owner>/<repo-name> <run-id>
  ```
- **Gitea Actions Checkout Snippet**: Supply `github-server-url` in `.gitea/workflows/*.yml` so runners resolve the clone host over HTTPS:
  ```yaml
  - name: Checkout repository
    uses: actions/checkout@v4
    with:
      github-server-url: https://<GITEA_HOST>
  ```

## 2. Node 24 Compliant Action Versions & Pinning Examples

- `actions/checkout@v7` (or `v6`)
- `actions/setup-python@v7` (or `v6`)
- `opentofu/setup-opentofu@v2`
- Container image pin example: `cloudflare/cloudflared:2026.10.7`

## 3. GitVersion & Conventional Commit Mapping

- `feat(...)` -> Minor bump
- `fix(...)`, `refactor(...)`, `chore(...)`, `docs(...)` -> Patch bump
- `BREAKING CHANGE` or `type(...)!:` -> Major bump
- **Monorepo Component Prefixes**: `tofu-vX.Y.Z` (scoped to `infrastructure/**`), `ansible-vX.Y.Z` (scoped to `ansible/**`, `bootstrap/**`).
- **Tag Persistence Command**: `git tag "v$SEMVER" && git push origin "v$SEMVER"`
- **Renovate Bot PR Query**: `gh pr list --json number,title,url,headRefName`

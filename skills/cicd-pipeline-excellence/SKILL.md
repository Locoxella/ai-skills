---
name: cicd-pipeline-excellence
description: >-
  Author, audit, and maintain GitHub Actions and Gitea Actions CI/CD workflows, SemVer tagging, and Renovate configs.
  WHEN: creating or editing `.github/workflows/*.yml`, `.gitea/workflows/*.yml`, `.github/renovate.json`, or verifying post-push pipeline runs.
  WHEN NOT: running local-only unit tests or editing application code unrelated to CI/CD.
---

# CI/CD Pipeline Excellence (`last-verified: 2026-11-11`)

Depends on Core Directives: [AGENTS.md (`#p1`)](../../AGENTS.md#p1)

## Decision Flow & Core Rules

1. **Zero Warnings & Deprecations**: Upgrade deprecated Node/runner actions immediately upon discovery and pin tested runner OS labels (`ubuntu-24.04` or `ubuntu-26.04`) during LTS transitions.
2. **Strict Artifact Pinning**: Never use `:latest`, `@master`, or `@main` in `compose.yaml`, `Dockerfile`, workflows, or OpenTofu providers; pin explicit versions and manage updates via `.github/renovate.json` with `:semanticCommits` and grouped PRs.
3. **Path Filtering & Skip Guards**: Gate heavy jobs (`tofu`, `ansible`) using `git diff --name-only "$PREV_COMMIT" HEAD` outputs (`infrastructure/**`, `ansible/**`, `bootstrap/**`). Skip dependency installation when all gated steps are false, and always allow `workflow_dispatch` to force full execution.
4. **Dual Hosting (GitHub Primary + Gitea Mirror)**:
   - Run automated CI, conditional IaC/Ansible apply, and release tagging on GitHub (`main`).
   - Run scheduled mirror sync (`cron: '0 3 * * *'`) and push/PR syntax validation on Gitea.
   - Gate Gitea cloud provisioning (`tofu apply`) and Ansible convergence strictly behind `workflow_dispatch`.
5. **Dynamic Step Summaries**: Populate `$GITHUB_STEP_SUMMARY` and `stdout` with real runtime metrics (open PR tables, JUnit/Pytest counts, resolved SemVer/digests, live endpoint HTTP status/latency, or explicit skip reasons)—never static boilerplate. Emit `::notice title=<Title>::<Message>` for primary outcomes.
6. **Branch Protection & PR Gate**: Enforce feature-branch PRs and `required_status_checks` (`strict: true`), `required_approving_review_count: 0`, `required_review_thread_resolution: true`, `deletion: true`, and `non_fast_forward: true` on `main` across repositories, unless a repository explicitly declares a local state-tracking exception in its `AGENTS.md`. Keep check contexts synced when renaming jobs.
7. **Mandatory SemVer Tag Push**: Whenever a pipeline computes SemVer via GitVersion or Conventional Commits, push the tag (`v$SEMVER` or component-prefixed `tofu-v*` / `ansible-v*`) back to the repository.
8. **Post-Push Verification**: Inspect run completion via `gh` or `tea` after every push and report the direct run URL, status, duration, and runner in chat.

## Reference Details (P3)

- Gitea SSH/CLI commands, checkout config, and SemVer tag conventions: [gitea-and-versioning.md](./references/gitea-and-versioning.md)

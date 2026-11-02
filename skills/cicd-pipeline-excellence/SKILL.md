---
name: cicd-pipeline-excellence
description: >-
  Standard and best practices for CI/CD pipelines across GitHub Actions and Gitea Actions.
  Enforces zero-warning policy, proactive deprecation remediation (Node versions, runner image labels),
  visual step summaries, and dual console/web reporting.
---

# CI/CD Pipeline Excellence & Zero-Warning Standards

This skill governs the authoring, maintenance, and modernization of CI/CD workflows across GitHub Actions and Gitea Actions for all repositories.

## 1. Zero-Warning Policy & Proactive Deprecation Remediation
Warnings in CI/CD pipelines are technical debt and early notices of impending breakage.
- **Proactive Resolution**: Whenever working on or reviewing workflows, proactively detect and eliminate pipeline warnings and deprecation notices rather than waiting for hard pipeline failures.
- **Node.js Runner Runtimes**: Keep GitHub Actions pinned to current LTS major versions that target active Node runtimes (e.g. migrate from Node 20 deprecated actions to Node 24 compliant actions: `actions/checkout@v6`/`v7`, `actions/setup-python@v6`/`v7`, `opentofu/setup-opentofu@v2`).
- **Runner OS Image Labels**:
  - When GitHub / runner maintainers announce runner image transitions (e.g. `ubuntu-latest` migrating from Ubuntu 24.04 to Ubuntu 26.04), explicitly pin or update runner labels to the targeted stable release (e.g. `ubuntu-26.04` or explicit `ubuntu-24.04`) once tested, removing transitional warnings.
- **Verification Requirement**: Always verify pipeline syntax and dry-run execution locally before committing workflow changes.

## 2. Mandatory Pipeline Observability & Dynamic Step Summaries
Never force developers to scroll through dense raw logs to understand workflow outcomes, and **never publish static boilerplate summaries**.

### 2.1 Dynamic Runtime Harvesting Mandate (Anti-Static Boilerplate)
A summary that only prints static configuration (e.g. repository name, schedule, or fixed copy) is useless technical noise. Every summary **must dynamically extract and report real runtime execution outputs**:
- **Strictly Prohibit Static Boilerplate**: Never hardcode static tables or generic copy that stays identical across runs.
- **Automated Dependency Bots (Renovate, Dependabot)**:
  - Must dynamically query the platform CLI/API (`gh pr list --json number,title,url,headRefName`) at the conclusion of the scan.
  - Must publish a dynamic table enumerating every open PR, its target component, title, branch, and direct link.
  - Must report real runtime counters: total open PRs, pending branches, and dashboard status.
- **Test & Security Scanners**:
  - Must parse test runner reports (JUnit, Pytest, Go test) to report exact counts: Passed, Failed, Skipped, and duration.
  - Must dynamically enumerate any failed test names or security findings.
- **Deployment & Provisioning Pipelines**:
  - Report exact deployed artifact versions (e.g. `GitVersion` resolved semver, Docker image digests).
  - Dynamically check and print live HTTP status codes, latency, and response headers for all verified endpoints.

### 2.2 Dual Console & Web Reporting Standards
When publishing summaries:
- **Clean Markdown Table to ``**: Format tables with intuitive emoji status indicators (✅, ⚠️, ❌, 🛡️, 🌐), clean links, and actionable next steps.
- **STDOUT Echo**: Always print the identical formatted report cleanly to `stdout` so it is immediately legible in the raw log viewer.
- **Workflow Command Notice**: Emit a concise notice (`::notice title=<Title>::<Message>`) pinning the primary outcome at the top of the Job UI.

## 3. Environment & Security Isolation
- Restrict write permissions and sensitive production credentials using GitHub Environments (`environment: production`) with strict branch and actor guards.
- Keep validation/dry-run jobs strictly isolated without access to production secrets.

## 4. Intelligent Path Filtering & Skip Conditions
- **Granular Execution**: In monorepos or multi-stack repositories, do not run cloud infrastructure plans or heavy configuration tasks on every push.
- **Diff-Based Triggers**:
  - Use `git diff --name-only <PREV_COMMIT> HEAD` to identify modified paths.
  - Set step outputs to conditionally gate execution:
    - OpenTofu / Terraform: `infrastructure/**`
    - Ansible / Provisioning: `ansible/**`, `bootstrap/**`
  - **Always Provide Manual Bypass**: Always allow `workflow_dispatch` to override filters and force execution of all components.

## 5. Mandatory Pull Request Workflow & Branch Protection Gates
Direct commits to production branches violate auditability and bypass automated safeguards.
- **Mandatory PR Discipline**: Direct pushes to `main` are strictly forbidden for all modifications (features, bugfixes, chore, agent operations, and dependency updates). All changes must be delivered via dedicated topic/feature branches and Pull Requests.
- **Solo-Maintainer Configuration Standard**: On personal or solo-maintainer repositories, configure ruleset / branch protection with `required_approving_review_count: 0`. This strictly forces the PR lifecycle and quality checks while enabling self-merging without being blocked by GitHub's restriction on approving one's own PR.
- **Mandatory Required Status Checks**:
  - Every production branch (`main`) must enforce branch protection with `required_status_checks` (`strict: true`).
  - Merging is strictly blocked until all pre-flight validation jobs (security/secret scanners, script syntax, OpenTofu/Terraform validation, Ansible syntax, linting, and semantic versioning) pass cleanly.
  - Branches must be fully synchronized with `main` (`strict: true`) to prevent silent merge drift or stale state.
- **Conversation Thread Resolution**: `required_review_thread_resolution: true` must be enforced so that all PR comments and discussions are resolved prior to merge.
- **Destruction & History Guards**: Prohibit branch deletion (`deletion: true`) and force pushing (`non_fast_forward: true`).
- **Emergency-Only Admin Bypass**: While admin bypass may remain configured as a break-glass recovery mechanism in rulesets, it must never be used for ordinary development or routine updates.
- **Synchronized Check Contexts**: Whenever renaming or introducing CI jobs, proactively update the repository ruleset required contexts to ensure the branch gate remains synchronized and strictly guarded.

## 6. Automated Independent Semantic Versioning (GitVersion & Conventional Commits)
- When a repository produces multiple artifacts or workflows (e.g. IaC configuration and OS/service configuration management):
  - Isolate tags by component prefix: `tofu-v*` and `ansible-v*`.
  - Calculate bumps automatically from Conventional Commits (`feat:` -> minor, `fix:` -> patch, `BREAKING CHANGE` -> major).
  - Scope commit history analysis exclusively to the paths of each component.
- **Mandatory Release Tagging in Pipeline**:
  - Whenever GitVersion or semantic versioning is introduced into a CI/CD pipeline, the pipeline **must unconditionally tag the repository** with the resolved version (`v$SEMVER`).
  - Calculating a version solely in memory for Docker tags or build artifacts without tagging the Git repository leaves the repository untagged, breaking future GitVersion baseline discovery and badge observability.

## 6. Dual CI/CD Maintenance (GitHub & Private Gitea)
For repositories operating with dual remotes (GitHub as primary, Gitea as private backup):
- **Automated Primary (GitHub)**: Runs all CI validations, conditional IaC provisioning, Ansible configuration, and release tagging on merge/push to `main`.
- **Scheduled Sync (Gitea)**: Runs a scheduled pull/fetch workflow (e.g. daily `cron: '0 3 * * *'`) from GitHub to keep the mirror current.
- **Automated Validation (Gitea)**: Validates code and syntax automatically on push/PR to verify Gitea runner health without touching cloud resources.
- **Manual-Only Provisioning (Gitea)**: IaC deployment and Ansible convergence in Gitea must ALWAYS be gated by `workflow_dispatch` only. Never automate apply in Gitea to prevent duplicate executions against cloud resources.
- **Reporting & Summaries**: Always write a visual summary to `$GITHUB_STEP_SUMMARY` and mirror to `stdout` across both platforms.

## 7. Post-Push Pipeline Verification & Mandatory Run Link Delivery
Whenever modifying CI/CD workflows, pipeline configurations, or code triggering CI/CD execution:
- **Active Verification**: Never push changes and conclude a turn without inspecting whether the pipeline succeeded. Verify execution status actively using platform CLIs (`tea actions runs --repo <owner>/<repo>`, `gh run list --repo <owner>/<repo>`, or API inspection).
- **Mandatory Direct Link in Response**: Always provide the user with the direct, clickable web URL to the triggered workflow run (e.g. `https://git.solucionesaustral.com/<owner>/<repo>/actions/runs/<run_id>` or GitHub Actions equivalent), explicitly stating the run status, duration, runner, and conclusion.

## 8. Automated Dependency Management & Strict Artifact Pinning (Renovate Bot Standard)
In production GitOps, never maintain dependencies through manual ad-hoc audits or rely on mutable tags:
- **Strict Pinning Mandate**:
  - Never use mutable tags such as `:latest`, `@master`, or `@main` in production Docker Compose manifests (`compose.yaml`), Dockerfiles, GitHub Actions workflows, or OpenTofu/Terraform providers.
  - Pin immutable explicit versions (e.g., `cloudflare/cloudflared:2026.10.7`, `actions/checkout@v7`).
- **Automated Lifecycle with Renovate Bot**:
  - Every repository managing container stacks, IaC, GitHub Actions, or package manifests must maintain a standard `.github/renovate.json`.
  - Prefer Renovate over Dependabot across the ecosystem due to Renovate's native support for Docker Compose, OpenTofu, advanced grouping, and multi-platform extensibility.
- **Noise Reduction & PR Grouping**:
  - Group patch and minor updates logically (e.g. `Docker Compose images`, `GitHub Actions dependencies`, `OpenTofu providers`) to eliminate alert and PR fatigue.
  - Schedule PR creation (e.g. weekly batches) so maintainers review non-critical updates during designated maintenance windows.
- **GitVersion & Conventional Commits Integration**:
  - Enable `:semanticCommits` in Renovate configuration so bot-generated PRs adhere to Conventional Commits (`fix(deps):`, `chore(deps):`).
  - This guarantees that automated semantic versioning engines (GitVersion) correctly calculate and bump release tags upon PR merge.
- **Quality Gates & Automerge**:
  - All bot PRs must pass the repository's pre-flight dry-run suite (`./scripts/verify_infra.sh` or equivalent).
  - Safe, low-risk patches (such as patch GitHub Actions updates) may have `automerge: true` enabled once all CI validation steps pass cleanly.

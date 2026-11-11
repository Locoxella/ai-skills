---
name: offline-html-dashboard
description: >-
  Build modular, interconnected, zero-infrastructure `file://` HTML dashboards and visual artifacts from local SQLite, JSON, or CSV data.
  WHEN: generating local HTML reports, multi-view financial/operational dashboards, or interactive data artifacts for the Antigravity artifact pane.
  WHEN NOT: building server-hosted web apps (Next.js, Cloudflare Workers) or simple Markdown tables.
---

# Offline HTML Dashboards & Visual Artifacts (`last-verified: 2026-11-11`)

## Architecture Rules

1. **Zero Infrastructure**: Output standalone HTML files that open directly via `file://` or Antigravity's artifact previewer without Docker or local HTTP servers.
2. **Hub-and-Spoke Multi-Artifact Design**: Split complex domains into a main KPI hub (`dashboard.html`, `finance_dashboard.html`) and linked drill-down views (`schools_summary.html`, `tax_deductions_report.html`, `ledger_explorer.html`) using relative `href` links and `file:///path/to/file.pdf` deep links.
3. **Strict CSP Compatibility (`unsafe-eval` Blocked)**: Use vanilla JS DOM manipulation for filtering, sorting, tabs, and modals. Do not use runtimes requiring `eval()` or `new Function()` (such as standard Alpine.js or Vue runtime compiler). Inline CSS or bundle local assets to avoid CDN failures.
4. **Inlined Data Serialization (Zero-CORS)**: Embed datasets directly inside `<script>const DATA = ...;</script>` in each HTML file so `file://` navigation never triggers CORS errors.
5. **Dual Output Sync**: Write generated HTML files to both the repository target directory (`docs/dashboards/` or repo root) and the active conversation artifact directory (`<appDataDir>/brain/<conversation-id>/<name>.html`).

## Reference Details (P3)

- Shared navigation header snippet and hub-spoke layout: [header-template.md](./references/header-template.md)

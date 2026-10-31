---
name: offline-html-dashboard
description: Guidelines and patterns for creating modular, interconnected, zero-infrastructure visual artifacts, reports, and multi-view dashboards from local data (SQLite, JSON, CSV).
---

# Modular Visual Artifacts & Offline Dashboards Skill

This skill defines the architecture and design standards for creating rich, visual, zero-infrastructure HTML artifacts and local web dashboards. Rather than viewing dashboards as isolated monoliths, this skill encourages building an **interconnected ecosystem of visual artifacts** that can cross-link, drill down, and navigate between each other directly inside Antigravity's artifact pane or any browser.

## Core Principles

1. **Zero Infrastructure, Infinite Flexibility**:
   - Never require Docker, web application daemons, or background servers for local data presentation and exploration.
   - Every view is a clean, self-contained HTML file executable via `file://` or inside Antigravity's artifact runner.

2. **Modular & Interconnected Multi-Artifact Navigation**:
   - Do NOT restrict yourself to a single monolithic dashboard. Decompose complex systems into dedicated, deep-dive visual artifacts:
     - **Main Hub**: Executive dashboard / high-level KPIs (`dashboard.html`, `finance_dashboard.html`).
     - **Entity Drill-downs**: Dedicated view for specific entities (e.g., `schools_summary.html`, `tax_deductions_report.html`, `domestic_staff_settlement.html`).
     - **Deep Audits & Ledger Views**: Transaction explorer, reconciliation logs, or comparative period charts (`ledger_explorer.html`).
   - **Cross-Artifact Linking**: Support seamless relative navigation (`href="schools_summary.html"` or linking between artifact URLs) and deep links to local files (`file:///path/to/receipt.pdf`).
   - Include persistent breadcrumbs, back-to-hub buttons, and quick navigation headers across all generated views.

3. **Strict CSP & Sandbox Immunity**:
   - Antigravity's artifact previewer enforces strict Content Security Policies (CSP):
     - **`unsafe-eval` is blocked**: Do NOT use frameworks or template engines that rely on dynamic `eval()` or `new Function()` (e.g., standard Alpine.js, Vue runtime compiler).
     - **Vanilla JS DOM Manipulation**: Fast, lightweight, and completely CSP-safe for data rendering, filtering, tabs, modals, and sorting.
     - **Self-Contained Styling & Assets**: Inline CSS or local Tailwind/Chart.js distributions so artifacts load instantly without internet access or CDN timeouts.

4. **Inlined Data Serialization (Zero-CORS)**:
   - Always inject datasets directly into `<script>const DATA = ...;</script>` blocks inside each HTML file.
   - Prevents `CORS` or browser security blocks when navigating between local files via `file://`.

5. **Antigravity Artifact Synchronization**:
   - Write generated views to both:
     1. The project repository directory (e.g. `docs/dashboards/` or repo root) for permanent tracking.
     2. The active conversation artifact directory (`<appDataDir>/brain/<conversation-id>/<name>.html`) so each view immediately surfaces as a dedicated interactive artifact tab/button in Antigravity's right panel.

---

## Multi-Artifact Architecture Patterns

When designing visual solutions, consider decomposing into specialized views:

```
[ Hub Dashboard: overview / KPIs / high-level status ]
       │
       ├───> [ Drill-down 1: Educational tuition & student histories ]
       ├───> [ Drill-down 2: Tax compliance & ARCA deductions report ]
       └───> [ Drill-down 3: Interactive transaction ledger & search ]
```

### Shared Navigation Component
Ensure all visual artifacts share a consistent header allowing bidirectional jumping:
```html
<header class="flex items-center justify-between border-b border-slate-800 p-4">
  <div class="flex items-center gap-3">
    <a href="finance_dashboard.html" class="text-xs text-slate-400 hover:text-white flex items-center gap-1">
      &larr; Volver al Panel Principal
    </a>
    <span class="text-slate-600">|</span>
    <h1 class="text-sm font-bold text-white">Detalle de Deducciones ARCA</h1>
  </div>
  <nav class="flex items-center gap-2">
    <a href="schools_summary.html" class="text-xs text-slate-300 hover:text-white px-2 py-1 rounded bg-slate-900 border border-slate-800">Colegios</a>
    <a href="domestic_staff_report.html" class="text-xs text-slate-300 hover:text-white px-2 py-1 rounded bg-slate-900 border border-slate-800">Personal</a>
  </nav>
</header>
```

---

## Generator Guidelines

1. **Composable Generator Scripts**:
   - Scripts can generate individual artifacts or a whole suite (e.g., `make dashboard`, `make report-tax`, `make reports-all`).
2. **Dynamic Context Awareness**:
   - Check if running within an Antigravity conversation brain directory to auto-publish all interconnected artifacts into the side pane at once.

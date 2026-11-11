# Offline Dashboard Shared Header & Layout (`last-verified: 2026-11-11`)

## Hub-and-Spoke Layout

```text
[ Hub Dashboard: overview / KPIs / high-level status ]
       ├──> [ Drill-down 1: Category & entity summaries ]
       ├──> [ Drill-down 2: Tax / compliance breakdown ]
       └──> [ Drill-down 3: Interactive ledger & search ]
```

## Shared Navigation Header Component

```html
<header class="flex items-center justify-between border-b border-slate-800 p-4">
  <div class="flex items-center gap-3">
    <a href="dashboard.html" class="text-xs text-slate-400 hover:text-white flex items-center gap-1">
      &larr; Back to Main Dashboard
    </a>
    <span class="text-slate-600">|</span>
    <h1 class="text-sm font-bold text-white">Category Breakdown</h1>
  </div>
  <nav class="flex items-center gap-2">
    <a href="category_summary.html" class="text-xs text-slate-300 hover:text-white px-2 py-1 rounded bg-slate-900 border border-slate-800">Categories</a>
    <a href="ledger_explorer.html" class="text-xs text-slate-300 hover:text-white px-2 py-1 rounded bg-slate-900 border border-slate-800">Ledger</a>
  </nav>
</header>
```

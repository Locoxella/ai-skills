---
name: markdown-linting
description: >-
  Enforce clean formatting and zero-suppression `markdownlint-cli` validation on human-facing Markdown documentation.
  WHEN: creating or editing `README.md`, `docs/**/*.md`, changelogs, or user manuals.
  WHEN NOT: editing machine-facing agent files (`GEMINI.md`, `AGENTS.md`, `SKILL.md`, `INDEX.md`).
---

# Markdown Linting for Human-Facing Docs (`last-verified: 2026-11-11`)

## Core Rules

1. **Zero Suppression**: Never pass `--disable`, never add `<!-- markdownlint-disable -->` comments, and never create `.markdownlint.json` rules to relax checks; fix all issues in the Markdown source.
2. **Key Formatting Constraints**:
   - **MD033 (No Inline HTML)**: Never use `<br>`, `<br/>`, `<div>`, `<span>`, `<img>`, `<b>`, or `<p>`. In table cells, separate items with `·`, `/`, `,`, or `•` instead of `<br/>`.
   - **MD001 / MD022 / MD025 / MD041 (Headings)**: Start line 1 with a single `# Title`, increment heading levels by 1 step at a time, and surround headings with blank lines.
   - **MD004 / MD031 / MD032 / MD040 (Lists & Code)**: Use uniform list markers (`-` or `*`), surround lists and fenced code blocks with blank lines, and specify a language tag on every code fence (`bash`, `python`, `text`, `json`, `yaml`).
   - **MD009 / MD012 / MD047 (Whitespace)**: Strip trailing spaces, avoid consecutive blank lines, and end files with a single newline.

## Verification Procedure

1. Auto-fix spacing/list issues and verify zero errors (exit code `0`) before committing:
   ```bash
   npx --yes markdownlint-cli --fix path/to/document.md
   npx --yes markdownlint-cli path/to/document.md
   ```

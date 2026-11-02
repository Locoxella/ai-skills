---
name: markdown-linting
description: >-
  Ensures that human-facing markdown files (such as README.md, user documentation, and guides)
  meet clean formatting standards and pass markdown linting.
  Excludes internal agent prompts, skill definitions, and machine instructions.
---

# Markdown Linting Skill for Human-Facing Documentation

This skill enforces quality and linting standards for markdown files authored or edited for human readers (e.g., `README.md`, `docs/**/*.md`, runbooks, user manuals, changelogs).

> [!NOTE]
> This skill explicitly **excludes** machine-facing markdown documents such as agent instructions, prompt files, rules (`GEMINI.md`, `AGENTS.md`), and `SKILL.md` definitions.

---

## Core Directive: Zero-Disabling Policy (Strict Anti-Suppression)

* **NEVER disable or suppress linter rules**:
  * Do NOT use CLI suppression flags (e.g., `--disable`).
  * Do NOT add inline suppression comments (e.g., `<!-- markdownlint-disable -->`).
  * Do NOT generate ad-hoc config files (e.g., `.markdownlint.json` allowing tags or relaxing rules) to mask errors.
* **Always fix the markdown source natively**: Every linter error or warning must be solved directly in the source markdown using valid, clean, and portable Markdown syntax.

---

## When to Apply

* When creating or modifying `README.md` or files inside `docs/` in any repository.
* When editing documentation intended for human developers, users, or stakeholders.
* Before finalizing pull requests or commits containing user-facing documentation.

---

## Standard Linting Workflow

### 1. Check with `markdownlint`

Run `markdownlint-cli` via `npx` (pre-installed in the environment) without disabling any rules:

```bash
npx --yes markdownlint-cli path/to/document.md
```

To automatically fix common auto-fixable issues (whitespace, trailing spaces, bullet styles):

```bash
npx --yes markdownlint-cli --fix path/to/document.md
```

### 2. Common Linting Rules & Best Practices

1. **No Inline HTML (MD033):**
   * **Absolute prohibition on HTML tags** (e.g., `<br>`, `<br/>`, `<div>`, `<span>`, `<img>`, `<b>`, `<p>`).
   * **In Markdown tables**: Never use `<br/>` for multiline cells. Use typographic delimiters (interpuncts `·`, slashes `/`, commas `,`, or bullets `•`) or restructure into separate rows or standard Markdown list subsections.
   * Never bypass MD033 by whitelisting elements in configuration files.

2. **Headers & Spacing (MD022, MD025, MD041):**
   * Exactly one top-level `# Title` at line 1 (MD025 / MD041).
   * Ensure blank lines before and after headings (MD022).
   * Heading levels must not increment by more than one level at a time (e.g., do not jump from `#` directly to `###`) (MD001).

3. **Lists & Bullet Styles (MD004, MD007, MD032):**
   * Consistent list markers (prefer `*` or `-` uniformly throughout the document).
   * Surround list blocks with blank lines (MD032).

4. **Code Blocks (MD040, MD031):**
   * Fenced code blocks must specify a language identifier (e.g., `bash`, `python`, `text`, `json`, `sql`) (MD040).
   * Surround code fences with blank lines (MD031).

5. **Whitespace & Trailing Spaces (MD009, MD012, MD047):**
   * No trailing whitespace at end of lines (MD009).
   * No multiple consecutive blank lines (MD012).
   * Files must end with a single newline character (MD047).

6. **Tables & Formatting (MD013, MD056):**
   * Align pipes and table rows cleanly for readability in both raw text and rendered viewers.
   * Ensure column counts match headers consistently across all rows.
   * Wrap long descriptive text cleanly across lines where appropriate.

---

## Verification Step

Always run the linter on the target file without suppression flags before completing the task:

```bash
npx --yes markdownlint-cli path/to/edited-file.md
```

Ensure the command exits cleanly with code `0`.


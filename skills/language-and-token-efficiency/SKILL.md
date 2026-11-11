---
name: language-and-token-efficiency
description: >-
  Enforce English across all agent thoughts, skills, rules, code, commits, docs, and default chat responses to maximize token efficiency.
  WHEN: authoring or refactoring skills, rules, documentation, code comments, commit messages, or responding in chat.
  WHEN NOT: writing localized application i18n strings or responding when the user explicitly requests output in Spanish.
---

# Language & Token Efficiency Directives (`last-verified: 2026-11-11`)

Depends on Core Directives: [AGENTS.md (`#p0`)](../../AGENTS.md#p0)

## Language Boundaries

| Artifact / Channel | Mandatory Language | Rule |
|---|---|---|
| **Skills, Rules & Tool Definitions (`SKILL.md`, `AGENTS.md`, `GEMINI.md`)** | **English** | Write strictly in concise, imperative English to minimize recurring context tokens. |
| **Internal Thoughts & Scratchpads** | **English** | Always think and reason in English, even when prompted in Spanish. |
| **Codebase, Comments, Commits & PRs** | **English** | Write all identifiers, docstrings, comments, Conventional Commits, and PR descriptions in English. |
| **Documentation (`README.md`, `docs/`)** | **English** | Write in English unless the user explicitly commands: *"Generate this documentation in [Language]"*. |
| **Chat Responses to User** | **English (Default)** | Respond in English even when the user writes in Spanish for convenience; reply in Spanish only when the user explicitly asks for the response in Spanish. |

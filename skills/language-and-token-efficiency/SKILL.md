---
name: language-and-token-efficiency
description: Directives for language boundaries and token optimization. Enforces English for skills, rules, code, commits, docs, agent scratchpads, and chat interactions by default (Spanish only upon explicit user request).
---

# Language, Token Optimization & Documentation Directives

## 1. Operating Principle & Token Efficiency
Token efficiency is a core engineering constraint for this environment. Due to sub-word tokenization mechanics, English is significantly more cost-efficient and preserves context window space far better than Spanish (avoiding the language tax on recurring context). 

You must adopt this policy as a fundamental operational rule across all tasks, skills, and memory systems.

## 2. Language Boundaries & Roles

| Component / Artifact | Mandatory Language | Details |
|---|---|---|
| **Skills / Tool Definitions (`SKILL.md`, etc.)** | **English** | Re-injected repeatedly into the context window; maximum token density required. |
| **Internal Scratchpads, Agent Thoughts & Logs** | **English** | Consumes output tokens and cascades into future turn inputs. Must remain concise and in English. |
| **Codebase & Commits** | **English** | Code comments, docstrings, variable names, commit messages, and PR descriptions. |
| **Documentation & Project Files** | **English** | `README.md`, architecture docs, operational runbooks, and config files default to English. |
| **Chat / Conversational Responses** | **English (Default)** | Default to English for maximum conciseness and token economy. Only reply in Spanish if the user explicitly requests Spanish. |

## 3. Exceptions & Overrides
* **Chat Language Override**: Only switch conversational responses to Spanish when the user explicitly requests answers in Spanish.
* **Human-Facing Documentation Override:** All documentation defaults to English. Only write documentation (such as a `README.md` or end-user manuals) in Spanish or another language if explicitly instructed: *"Generate this documentation in [Language]"*.
* **Code Strings / i18n:** User-facing localization strings within application code should follow the project's localization requirements.

## 4. Skills Integration & Self-Enforcement
* Whenever creating, refactoring, or saving persistent skills or instructions, write them entirely in English.
* Incorporate this token-awareness rule into your skill creation workflows so newly generated skills maintain this standard automatically.

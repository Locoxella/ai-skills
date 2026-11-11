---
name: ocr-fallback-evaluator
description: >-
  Resolve deterministic PDF/OCR extraction failures by using a single-pass LLM inspection to patch the deterministic regex/parser engine rather than calling LLMs in runtime loops or relying on manual DB edits.
  WHEN: a deterministic PDF/OCR parser (`pdftotext`, `tesseract`, regex) fails on a new or changed document format.
  WHEN NOT: routine deterministic parsing succeeds without errors.
---

# Deterministic OCR Fallback & Parser Hardening (`last-verified: 2026-11-11`)

Depends on Core Directives: [AGENTS.md (`#p0`)](../../AGENTS.md#p0)

## Process-First Anomaly Protocol

1. **Never Put LLMs in Recurring Runtime Loops**: Keep automated document ingestion 100% deterministic (`pdftotext` / `tesseract` + regex) so recurring runs consume zero LLM tokens.
2. **Single-Pass Anomaly Inspection**: When a deterministic parser fails on a specific PDF, inspect the raw text of the failed document once (`pdftotext` or vision tool) to identify why the pattern broke (e.g. `"Total:"` renamed to `"Importe Total:"`) and extract the target fields.
3. **Patch the Process, Not Just the Data**:
   - Update the deterministic regex/parser script and daemon logic whenever the format is recurring or maintainable.
   - Add or update unit tests (`pytest`) and re-run the deterministic pipeline so the document is ingested by the engine itself.
   - Reserve manual one-off ORM/SQL insertion strictly for rare, non-recurring edge cases where maintaining a parser rule is unfeasible.

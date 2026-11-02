---
name: ocr-fallback-evaluator
description: "Handles OCR extraction failures using an LLM fallback to conserve tokens and maintain robust software design."
---

# OCR Fallback Evaluator

The Finance repository uses deterministic extraction methods (`tesseract` + regex or PDF text parsing) for bank statements and school receipts. This design choice strictly conserves LLM tokens (saving thousands of tokens per document).

However, PDF formats change. When a deterministic script (e.g. `parse_receipts.py`) fails to parse a document correctly, you must follow this hybrid fallback protocol.

## Protocol

1. **Detect Failure:**
   - The user or a script reports an extraction failure for a specific PDF.
   
2. **LLM Single-Pass Extraction:**
   - **Do not rewrite the script to use LLMs on every run.**
   - Instead, read the raw text of the *failed document only* (using `pdftotext` or a vision tool if necessary).
   - Use your own LLM capabilities (within the chat or subagent) to extract the missing structured data (amount, date, CUIT, invoice number).
   
3. **Database Insertion:**
   - Manually insert the extracted data into the `finance.db` using the ORM (`src.finance.models`) or a one-off SQL script. This reconciles the missing data for the user immediately.

4. **Regex Evaluation & Patching:**
   - Evaluate *why* the deterministic script failed.
   - For example, if a bank moved the word "Total:" to "Importe Total:", patch the regex in the Python script (`scripts/parse_receipts.py` or similar) to handle the new format.
   - Run the script again locally or use `pytest` to ensure your patched regex now successfully parses the document deterministically.

## Why this matters
By fixing the regex/script, the next 50 receipts will be processed deterministically at zero token cost. You are using the LLM only for **anomaly resolution**, which is the optimal software engineering pattern for this project.

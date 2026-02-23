# AI Prompts

This directory contains all prompt templates used by DTP_APP_V3.

## Philosophy

> **Prompts are code.** They get reviewed, tested, versioned, and can break things in production.

Every prompt lives here — **never** buried in a PHP class or React component as an untestable string.

---

## Directory Structure

```
ai/prompts/
├── README.md              ← you are here
├── _template.md           ← copy this when creating a new prompt
└── <feature>/
    └── <name>.md          ← one file per prompt
```

**Naming convention:** `ai/prompts/<feature-area>/<verb>-<noun>.md`

Examples:
- `ai/prompts/glossary/generate-definition.md`
- `ai/prompts/guides/summarize-step.md`
- `ai/prompts/data/explain-column.md`

---

## Creating a New Prompt

1. Copy `_template.md` → `ai/prompts/<feature>/<name>.md`
2. Fill in all sections (purpose, inputs, outputs, system prompt, user template)
3. Create matching eval cases → `ai/evals/<name>.eval.yaml` (min 5 cases)
4. Open a PR — the `ci-ai-evals` check must pass before merge
5. CODEOWNERS requires review of all `ai/**` changes

---

## Rules

| Rule | Reason |
|---|---|
| No prompt goes to `main` without a PR review | Prompts can change product behavior silently |
| Every prompt has at least 5 golden eval cases | Regressions are caught in CI, not in production |
| Temperature ≤ 0.3 for deterministic tasks | Consistency > creativity for data tools |
| No hardcoded PII in prompts or evals | Security / privacy baseline |
| Log LLM calls in development | Enables debugging and cost tracking |

---

## Current Prompts

| Prompt | Feature Area | Model | Status |
|---|---|---|---|
| *(none yet — add your first prompt!)* | | | |

# Prompt: [PROMPT_NAME]

<!--
HOW TO USE THIS TEMPLATE:
  1. Copy this file → ai/prompts/<feature>/<name>.md
  2. Fill in every section below
  3. Add at least 5 golden eval cases to ai/evals/<name>.eval.yaml
  4. PR review is required before merging any prompt change
-->

---

## Purpose
<!-- One sentence: what does this prompt do? -->
> Example: Summarizes a data column description into a 1-sentence business definition.

## Inputs
| Variable | Type | Description | Required |
|---|---|---|---|
| `{{variable_name}}` | string | Description of what this variable contains | ✅ |
| `{{optional_var}}` | string | Description | ❌ |

## Expected Output
<!-- What should the LLM return? Format, structure, constraints. -->
- Format: `plain text` / `JSON` / `markdown`
- Max length: ~N tokens
- Must include: [list key requirements]
- Must NOT include: [PII, hallucinated data, etc.]

## System Prompt
```
[SYSTEM PROMPT GOES HERE]

You are a helpful assistant for DataTools Pro...
```

## User Prompt Template
```
[USER PROMPT TEMPLATE GOES HERE]

Given the following context:
{{context}}

Please {{task}}.
```

## Model & Parameters
| Setting | Value |
|---|---|
| Model | `gpt-4o` / `claude-3-5-sonnet` / etc. |
| Temperature | `0.2` (low = deterministic) |
| Max tokens | `500` |
| Top-p | `1.0` |

## Known Failure Modes
<!-- Document edge cases and how you've handled them -->
- [ ] Edge case: empty input → fallback to "N/A"
- [ ] Edge case: non-English input → [behavior]

## Eval File
Link to eval: [`ai/evals/<name>.eval.yaml`](mdc:ai/evals/<name>.eval.yaml)
Minimum passing score: **100%** (or lower threshold with justification)

## Changelog
| Date | Author | Change |
|---|---|---|
| YYYY-MM-DD | @handle | Initial version |

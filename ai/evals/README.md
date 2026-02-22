# AI Evals

This directory contains golden test cases for every prompt in `ai/prompts/`.

Evals run automatically in CI on every PR that touches `ai/**`.

---

## What is an Eval?

An eval is a set of **input → expected output** pairs that validate a prompt behaves correctly.

Think of it like unit tests for your prompts:
- **Golden cases** = known-good input/output pairs
- **Assertions** = rules the output must satisfy (contains, not-contains, score threshold, etc.)
- **Threshold** = minimum % of cases that must pass for the CI gate to go green

---

## Directory Structure

```
ai/evals/
├── README.md                  ← you are here
├── promptfooconfig.yaml       ← master eval config (references all eval files)
├── <name>.eval.yaml           ← eval cases for a specific prompt
└── outputs/                   ← generated eval results (gitignored)
```

---

## Tool: promptfoo

We use **[promptfoo](https://www.promptfoo.dev/)** for running evals.

```bash
# Install globally
npm install -g promptfoo

# Run all evals locally
cd ai/evals
promptfoo eval

# Run and view in browser
promptfoo eval --view

# Run a specific eval file
promptfoo eval --config <name>.eval.yaml
```

---

## Creating a New Eval

Create `ai/evals/<name>.eval.yaml`:

```yaml
# ai/evals/example.eval.yaml
description: "Eval for ai/prompts/<feature>/<name>.md"

prompts:
  - ../prompts/<feature>/<name>.md   # path to prompt template

providers:
  - openai:gpt-4o                    # model to test against

tests:
  - description: "Happy path — standard input"
    vars:
      variable_name: "example input value"
    assert:
      - type: contains
        value: "expected phrase in output"
      - type: not-contains
        value: "phrase that should never appear"
      - type: javascript
        value: "output.length < 500"   # output length check

  - description: "Edge case — empty input"
    vars:
      variable_name: ""
    assert:
      - type: contains
        value: "N/A"    # expected fallback

  # Add at least 5 total test cases per prompt
```

Then register it in `promptfooconfig.yaml`.

---

## Eval Scoring

| Threshold | Policy |
|---|---|
| **100%** | Default — all golden cases must pass |
| **90%** | Acceptable for creative/generative prompts (with written justification in PR) |
| **< 90%** | Not acceptable for production prompts |

Threshold is enforced in `.github/workflows/ci-ai-evals.yml`.

---

## Current Eval Files

| Eval File | Prompt | Cases | Threshold |
|---|---|---|---|
| *(none yet — add your first eval!)* | | | |

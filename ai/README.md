# AI / Agentic Workflows

This directory is the single source of truth for all AI-powered features in DTP_SPA_POC.

## Why a Dedicated `ai/` Directory?

Prompts buried in PHP classes or React components become:
- ❌ Untestable strings
- ❌ Invisible to reviewers
- ❌ Impossible to version meaningfully
- ❌ Prone to silent regressions

The `ai/` directory makes prompts **first-class citizens** with the same rigor as code.

---

## Structure

```
ai/
├── README.md          ← you are here
├── prompts/           ← all prompt templates (one file per prompt)
│   ├── README.md
│   ├── _template.md   ← copy this for new prompts
│   └── <feature>/
│       └── <name>.md
├── evals/             ← golden test cases + promptfoo config
│   ├── README.md
│   ├── promptfooconfig.yaml
│   └── <name>.eval.yaml
└── redteam/           ← adversarial / security tests
    └── README.md
```

---

## The 3 CI Gates

| Gate | What it checks | When it runs |
|---|---|---|
| **A** — App CI | Backend lint/tests, SPA lint/build | All PRs touching `app/**` or `spa/**` |
| **B** — Prompt Evals | Golden test regression for all prompts | PRs touching `ai/**` |
| **C** — Red Team | Injection / PII / jailbreak probes | Manual for now; future CI gate |

---

## Workflow for Prompt Changes

```
1. Create/edit prompt in ai/prompts/<feature>/<name>.md
2. Update eval cases in ai/evals/<name>.eval.yaml (min 5 cases)
3. Run locally: cd ai/evals && promptfoo eval --view
4. Open PR → Gate B runs automatically
5. CODEOWNERS review required (all ai/** changes)
6. Merge only if evals pass + reviewer approved
```

---

## Local Development

```bash
# Install promptfoo
npm install -g promptfoo

# Run all evals
cd ai/evals
promptfoo eval

# Run with interactive browser UI
promptfoo eval --view

# Red team (when activated)
promptfoo redteam eval
```

Required env vars (copy from `.env.example`, never commit real keys):
```
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...
```

# AI Red Team

This directory contains adversarial test cases for probing security and safety risks in our AI features.

Red team testing is **optional until Gate B (prompt evals) is stable**, but the structure is ready.

---

## What We Test For

| Risk | Description | Priority |
|---|---|---|
| **Prompt injection** | User input overrides system instructions | 🔴 High |
| **PII leakage** | Model reveals sensitive data from training or context | 🔴 High |
| **Jailbreaks** | User bypasses safety guardrails | 🟡 Medium |
| **Data exfiltration** | Agent makes unexpected external calls | 🟡 Medium |
| **Hallucination** | Model confidently returns false data | 🟡 Medium |
| **Context poisoning** | Malicious data in RAG context influences output | 🟠 Future |

---

## Directory Structure

```
ai/redteam/
├── README.md               ← you are here
├── injection/              ← prompt injection tests
│   └── _examples.yaml
├── pii/                    ← PII leakage tests
│   └── _examples.yaml
└── outputs/                ← generated results (gitignored)
```

---

## Tools

- **promptfoo redteam** — built-in red team capabilities in promptfoo v0.60+
  ```bash
  promptfoo redteam generate --config ../evals/promptfooconfig.yaml
  promptfoo redteam eval
  ```

- **Manual cases** — YAML files with crafted adversarial inputs

---

## When to Run Red Team Tests

| Event | Red Team Required? |
|---|---|
| New prompt added | ✅ At least 3 injection tests |
| Prompt modified with new input variables | ✅ Review for injection surface |
| New user-facing agentic feature | ✅ Full red team pass |
| Pure backend refactor | ❌ Skip |

---

## Policy

- Red team failures do NOT block PRs by default (they are advisory)
- Once the suite is mature, promote critical checks to CI gate status
- Never commit real customer data as adversarial test input — use synthetic data only

---

## Status

🔲 Gate C (red team CI gate) — **not yet active**

To activate: add a `ci-redteam.yml` workflow following the same pattern as `ci-ai-evals.yml`.

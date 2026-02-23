## Summary
<!-- 1–3 sentences: what does this PR do and why? -->


## Jira Ticket
<!-- Required: link to the Jira ticket for this work -->
[DTP-](https://YOUR_ORG.atlassian.net/browse/DTP-)

## Work Type
<!-- Check ONE — this determines the review checklist below -->
- [ ] ✨ **User Story** — end-user visible feature (requires `docs/features/` update)
- [ ] 🔧 **Task** — system/infra/internal change (no end-user doc needed)
- [ ] 🐛 **Bug Fix** — something was broken (requires verification criteria below)
- [ ] 🤖 **AI / Prompt change** — prompt or eval update
- [ ] 🔥 **Hotfix** — production emergency

---

## What Changed
<!-- Brief bullet list of key changes. Be specific enough that a reviewer knows where to focus. -->
-
-

## How to Test
<!-- Steps for the reviewer to verify this works -->
1.
2.

---

<!-- ============================================================ -->
<!-- ✨ USER STORY — fill in if Work Type = User Story            -->
<!-- ============================================================ -->
## Feature Documentation (User Story only)
<!-- Link to the doc/features entry or paste it inline if new -->
- [ ] `docs/features/DTP-XX-<slug>.md` created or updated
- [ ] AC from Jira ticket are all addressed (list any gaps below)

**AC Coverage:**
<!-- Check each AC from the Jira story -->
- [ ] AC 1: ...
- [ ] AC 2: ...

---

<!-- ============================================================ -->
<!-- 🐛 BUG FIX — fill in if Work Type = Bug Fix                 -->
<!-- ============================================================ -->
## Bug Verification (Bug Fix only)
<!-- How do we know the bug is fixed and won't regress? -->

**Root cause:**
<!-- What was the actual cause? -->

**Verification steps:**
1. Reproduce original bug: ...
2. After fix: ...

**Regression risk:**
- [ ] Low — isolated change
- [ ] Medium — touches shared logic (explain below)
- [ ] High — needs QA sign-off before merge

---

<!-- ============================================================ -->
<!-- 🤖 AI / PROMPT — fill in if Work Type = AI / Prompt         -->
<!-- ============================================================ -->
## AI / Prompt Changes (Prompt changes only)
<!-- Skip if no prompts changed -->
| Prompt file | What changed | Eval score before | Eval score after |
|---|---|---|---|
| `ai/prompts/...` | | | |

- [ ] Eval suite passed (`npm run evals` or `promptfoo eval`)
- [ ] No regressions vs baseline score

---

## Checklist (all PRs)
- [ ] Branch name follows convention: `feature/DTP-XX-<slug>` or `hotfix/DTP-XX-<slug>`
- [ ] PR title format: `[DTP-XX] Short imperative description`
- [ ] Self-reviewed my own diff
- [ ] No secrets, API keys, or `.env` files committed
- [ ] Tests added / updated where appropriate
- [ ] CI checks are green (or failures are explained below)
- [ ] `.env.example` updated if new environment variables were added

## Notes for Reviewer
<!-- Anything you want the reviewer to focus on, known issues, or trade-offs made -->

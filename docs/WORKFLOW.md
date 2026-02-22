# Team Workflow Guide

> **Read this before your first PR.** This is the single source of truth for how we work day-to-day.

---

## Daily Development Loop

```
Morning:
  git checkout main
  git pull origin main
  git checkout -b feature/DTP-XX-my-feature

During the day:
  Small, focused commits (conventional commit format)
  Push regularly: git push origin feature/DTP-XX-my-feature

Done with feature:
  Open PR against main
  Fill in PR template completely
  CI must be green before requesting review
  Request review from @rmgoodm (or auto-assigned via CODEOWNERS)

After merge:
  Delete your branch
  Check staging deploy succeeded
  Close/transition your ticket
```

---

## Branch Rules

| ✅ Do | ❌ Don't |
|---|---|
| `feature/DTP-42-user-auth` | `ryan-working-on-auth` |
| Branch from `main` always | Branch from another feature branch |
| Delete branch after merge | Leave stale branches around |
| Short-lived (days, not weeks) | Long-running feature branches |

---

## Commit Message Rules

Follow **Conventional Commits**:

```
<type>(<scope>): <short description>
```

| Type | When to use |
|---|---|
| `feat` | New feature or behavior |
| `fix` | Bug fix |
| `refactor` | Code change with no behavior change |
| `chore` | Deps, tooling, config |
| `docs` | Documentation only |
| `test` | Tests only |
| `ci` | CI/CD workflow changes |
| `perf` | Performance improvement |

Examples:
```
feat(api): add endpoint for column metadata
fix(spa): resolve blank screen on 401 redirect
chore(deps): bump laravel/framework to 11.x
ci(evals): add path filter to ai eval workflow
docs(ai): update prompt template with eval link
```

---

## PR Rules

### Before Opening a PR
- [ ] CI passes locally (run tests, lint)
- [ ] No `.env` files, no secrets, no API keys committed
- [ ] PR title follows format: `[DTP-XX] Short description`
- [ ] Branch name follows convention

### PR Size Guidelines
| Lines changed | Status |
|---|---|
| < 200 | ✅ Great |
| 200–500 | ⚠️ Acceptable — add context in description |
| > 500 | ❌ Consider splitting the PR |

Large PRs take longer to review and are more likely to introduce bugs.

### Review Turnaround
- Reviewer should respond within **1 business day**
- Author should address feedback within **1 business day**
- If blocked, comment on the PR explaining why

---

## CI Checks Explained

| Check | What it does | Must pass? |
|---|---|---|
| **CI — Backend** | PHP lint + PHPUnit tests | ✅ Yes (if backend files changed) |
| **CI — Frontend SPA** | ESLint + TypeScript + tests + build | ✅ Yes (if `spa/` changed) |
| **CI — AI Prompt Evals** | promptfoo golden tests | ✅ Yes (if `ai/` changed) |

If a check is failing on your PR:
1. Click the failing check → read the logs
2. Fix locally, push a new commit
3. Don't ask for review with failing checks (except documented flakiness)

---

## Deploying to Production

Production deploys are **never automatic** — they require a human to pull the trigger.

### Standard Release (after feature merges to staging and is verified)

1. Go to **GitHub → Actions → Deploy — Production**
2. Click **"Run workflow"**
3. Enter a tag name: `v2026.02.22` (use today's date or semver)
4. Wait for the approval gate → approve it
5. Monitor the deploy logs
6. Verify smoke test passes
7. Close the deploy ticket / update release notes

### Hotfix (production bug)

```bash
# 1. Branch from main
git checkout main && git pull
git checkout -b hotfix/DTP-99-fix-description

# 2. Fix the bug
# 3. PR into main (still needs review)
# 4. Merge → staging auto-deploys
# 5. Verify on staging (can be quick if it's critical)
# 6. Manually trigger production deploy with a patch tag
```

---

## Managing AI / Prompt Changes

See [`ai/README.md`](../ai/README.md) for the full guide.

**Short version:** Prompts are code. PR → eval gate → review → merge.

Never:
- Write prompts as inline strings in PHP or TypeScript
- Merge prompt changes without eval results
- Lower the eval threshold without a PR comment explaining why

---

## Questions?

- Check existing docs in `docs/` first
- Open a GitHub Discussion for non-urgent questions
- For urgent issues: ping `@rmgoodm` directly

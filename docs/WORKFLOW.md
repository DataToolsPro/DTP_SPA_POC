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

## Environments

We have 4 environments. See [`docs/ENVIRONMENTS.md`](ENVIRONMENTS.md) for the full map.

| Environment | URL | Triggered By |
|---|---|---|
| Local | `localhost:5173` / `localhost:8000` | Manual |
| PR Preview | `pr-XX.dtp-spa-poc.pages.dev` | Auto on every PR push |
| Staging | `staging.datatoolspro.com` | Auto on merge to `main` |
| Production | `app.datatoolspro.com` | Manual approval |

---

## Release Flow (The Big Picture)

```
feature/DTP-XX branch
  → PR opened → CF Pages creates preview URL automatically
  → CI passes + 2 approvals
  → Squash merge to main
  → Staging auto-deploys (~3 min)
  → Verify on staging
  → GitHub Actions → Deploy Production → enter tag → approve
  → Production live + GitHub Release created
```

Full step-by-step: **[`docs/RELEASE.md`](RELEASE.md)**

---

## Deploying to Production

Production deploys are **never automatic** — they require a human to pull the trigger.

### Standard Release

1. Verify staging looks good at `https://staging.datatoolspro.com`
2. Go to **GitHub → Actions → Deploy — Production**
3. Click **"Run workflow"**
4. Enter a tag name: `v2026.02.23` (today's date or semver)
5. Wait for the approval notification → click Approve
6. Monitor the deploy logs (3–5 min)
7. Verify production smoke test passes
8. Close the deploy ticket

### Hotfix (production bug)

```bash
# 1. Branch from main (never from a feature branch)
git checkout main && git pull
git checkout -b hotfix/DTP-99-fix-description

# 2. Make the minimal fix + test it
# 3. PR into main — CI must pass, expedited review acceptable
# 4. Merge → staging auto-deploys
# 5. Verify on staging (can be quick for critical issues)
# 6. Trigger production deploy → tag as v2026.02.23-hotfix
```

### Rollback

- **SPA only:** Cloudflare Pages Dashboard → Deployments → Rollback (instant)
- **Full rollback:** Re-run Deploy Production workflow with the previous good SHA

Full rollback guide: **[`docs/RELEASE.md#rollback`](RELEASE.md#rollback)**

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

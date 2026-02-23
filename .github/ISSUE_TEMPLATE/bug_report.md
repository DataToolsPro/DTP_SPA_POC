---
name: Bug Report
about: Something is broken in staging or production
title: '[BUG] '
labels: bug
assignees: ''
---

## Jira Ticket
<!-- Link to the Jira bug if it exists, or create one -->
https://goodmangroup.atlassian.net/browse/MBT-

---

## Bug Description
<!-- Clear 1-2 sentence description of what's wrong -->

## Environment
- [ ] Local
- [ ] Staging (`staging.datatoolspro.com`)
- [ ] Production (`app.datatoolspro.com`)

## Steps to Reproduce
1.
2.
3.

## Expected Behavior
<!-- What should happen -->

## Actual Behavior
<!-- What actually happens -->

---

## Severity
- [ ] 🔴 P0 — Production down / data loss
- [ ] 🟠 P1 — Major feature broken for all users
- [ ] 🟡 P2 — Feature degraded / workaround exists
- [ ] 🟢 P3 — Minor / cosmetic

---

## Verification Criteria
<!-- How will we KNOW the bug is fixed? These become the AC for the fix PR. -->
<!-- Be specific — a passing condition that can be re-tested after the fix -->

- [ ] Verify 1: Given [state], when [action], then [expected result]
- [ ] Verify 2:
- [ ] Regression check: confirm no adjacent behavior was broken

---

## Additional Context
<!-- Screenshots, console errors, Cloudways logs, Cloudflare analytics -->

---

> For P0/P1: immediately ping `@rmgoodm` and follow the hotfix process in [`docs/RELEASE.md`](../../docs/RELEASE.md#hotfix-process)

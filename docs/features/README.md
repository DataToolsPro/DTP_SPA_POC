# Feature Documentation

This directory contains **end-user facing documentation** for features in DataTools Pro.

---

## What Goes Here

A file in `docs/features/` answers one question for the end user:
> *"How does this feature work and what can I do with it?"*

Write as if talking to a non-technical user. No code, no architecture. Behavior only.

---

## What Does NOT Go Here

- Implementation details → belongs in code comments or PR description
- System/infrastructure changes → no doc needed (they're invisible to users)
- Bug fixes → no doc needed unless the bug *changed user-visible behavior*

---

## When Is a Doc Created?

A `docs/features/<slug>.md` file is created or updated when a **User Story** Jira ticket is closed.

| Jira Type | Doc Required? |
|---|---|
| User Story | ✅ Yes — create or update `docs/features/<slug>.md` |
| Task | ❌ No |
| Bug | ⚠️ Only if user-visible behavior changed |

---

## Lifecycle

```
Jira Story (AC defined) → Dev implements → PR includes doc update → PR approved → doc is live
```

The Jira story is the **source of truth for acceptance criteria** (via Cursor MCP).
The file here is the **polished, human-readable output** of that story.

---

## Naming Convention

```
docs/features/<jira-ticket>-<feature-slug>.md

Examples:
  docs/features/MBT-42-user-authentication.md
  docs/features/MBT-67-csv-export.md
  docs/features/MBT-88-dashboard-filters.md
```

---

## Template

See [`_template.md`](./_template.md) — copy it, rename, fill it in.

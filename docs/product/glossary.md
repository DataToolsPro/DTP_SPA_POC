# DataTools Pro — Domain Glossary

**Purpose:** A single place for domain terminology used across code, Jira tickets, and user-facing copy.

> When you introduce a new term in the codebase or Jira, add it here.
> The AI uses this glossary to use consistent naming across all files.

---

## How to Use This

- **Code:** Class names, variable names, DB column names, and API field names should match the terms here
- **Jira:** Story and task titles should use these terms — not synonyms
- **User-facing copy:** The "User Term" column is what shows up in the UI
- **AI:** When I see an ambiguous term, I'll look here first

---

## Glossary

| Term (Code) | User Term (UI) | Definition | Notes |
|---|---|---|---|
| `Organization` | Account / Workspace | The top-level tenant — a company or team that subscribes to DataTools Pro | All data is scoped to an Org |
| `User` | User | A person who can log in to DataTools Pro | Always belongs to an Organization |
| [Term] | [How it appears in UI] | [Clear definition] | [Any nuances or edge cases] |

<!-- Add new terms here as the product vocabulary grows -->
<!-- Keep alphabetical within sections -->

---

## Status Values

Consistent status labels used across the product:

| Entity | Status Values | Meaning |
|---|---|---|
| [Entity] | `draft` | Not yet visible to end users |
| [Entity] | `published` | Live and visible |
| [Entity] | `archived` | Hidden from default views, not deleted |

---

## Abbreviations

| Abbreviation | Stands For | Used In |
|---|---|---|
| DTP | DataTools Pro | Everywhere |
| [Abbr] | [Full form] | [Where you'll see it] |

---

## Terms We Deliberately Avoid

<!-- Synonyms or confusing terms that should NOT appear in code or copy -->

| Don't Use | Use Instead | Why |
|---|---|---|
| [synonym] | [preferred term] | [reason for the distinction] |

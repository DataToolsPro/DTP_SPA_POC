# Tool: Report Management & Repository

**Part of:** DataTools Pro
**Primary users:** Analytics Professionals, Salesforce Administrators, Business Stakeholders

---

## What It Does

Report Management & Repository was created to govern the **lifecycle of Salesforce reports and dashboards at scale**. Organizations with hundreds or thousands of dashboards face constant challenges: finding the right report, understanding who uses it, knowing when it's outdated, and deciding what to retire.

DataTools Pro solves this by providing categorization, advanced search, adoption tracking, and lifecycle management — giving teams control over their report library without needing to manage everything inside Salesforce itself.

---

## Core Capabilities

| Capability | Description |
|---|---|
| **Report Repository** | Centralized browse view of all Salesforce reports and dashboards |
| **Categorization** | Tag reports by Business Topic, team, initiative, or custom category |
| **Advanced Search** | Full-text search across report names, descriptions, tags, and owners |
| **Adoption Tracking** | See who uses a report, how often, and when it was last accessed |
| **Lifecycle Management** | Track report status: Active, Under Review, Deprecated, Archived |
| **Impact Linking** | Link reports to the metrics and data dictionary fields they consume |

---

## Key Concepts

| Concept | Definition |
|---|---|
| **Report** | A Salesforce report synced from the connected org |
| **Dashboard** | A Salesforce dashboard (collection of report charts) synced from the connected org |
| **Report Status** | The lifecycle state of a report: `active`, `under_review`, `deprecated`, `archived` |
| **Adoption** | Usage data: view count, last accessed date, active users |
| **Business Topic** | User-defined grouping applied to reports (shared across all tools) |
| **Report Owner** | The Salesforce user responsible for maintaining the report |

---

## How It Connects to Other Tools

- **Data Dictionary** — reports link back to the Salesforce objects and fields they query
- **Metrics Glossary** — reports are linked to the metrics they calculate or surface
- **ERD** — the objects in a report's query can be traced in the ERD

---

## User Workflows

### Governing Report Lifecycle
1. DataTools syncs all reports/dashboards from the connected Salesforce org
2. Analytics team reviews: categorize by Business Topic, assign owners
3. Identify low-adoption reports → mark as `under_review`
4. Review with stakeholders → mark as `deprecated` or `archived`
5. Archived reports are hidden from default views but not deleted

### Finding the Right Report
1. Navigate to Report Management → search by keyword or filter by Business Topic
2. See report description, owner, last updated, adoption stats
3. Click through to Salesforce (deep link) to open the actual report

### Linking a Report to a Metric
1. Open a Metric in the Metrics Glossary
2. Link report → select from the report repository
3. The report now appears in the Metric's "Sources" panel

---

## Business Rules

- [ ] Reports and dashboards are sourced from Salesforce — they cannot be created in DataTools
- [ ] Report status (`active`, `under_review`, `deprecated`, `archived`) is managed in DataTools only — it does not affect the Salesforce report
- [ ] A report can be tagged to multiple Business Topics
- [ ] Adoption data is read-only (sourced from Salesforce usage logs or API)
- [ ] Archiving a report in DataTools hides it from default views but does not delete it from Salesforce

<!-- Fill in confirmed business rules as they are implemented -->

---

## Open Questions

- [ ] Does DataTools pull adoption/usage data from Salesforce, or does it track its own view counts?
- [ ] Is there a bulk action to archive/deprecate reports (e.g. "archive all reports not viewed in 6 months")?
- [ ] Can users annotate reports with notes or recommendations?
- [ ] What triggers the initial import of reports — manual sync or automatic on org connection?
- [ ] Can stakeholders request a new report through DataTools (request workflow)?

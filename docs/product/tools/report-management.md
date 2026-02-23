# Tool: Report Management & Repository

**Part of:** DataTools Pro
**Primary users:** Analytics Professionals, Salesforce Administrators, Business Stakeholders

---

## What It Does

Report Management & Repository solves the **Salesforce report and dashboard deluge** — the near-universal problem of organizations accumulating hundreds or thousands of Salesforce reports and dashboards with no way to find what's relevant, know what's accurate, or clean up what's abandoned.

The power of Salesforce self-service reporting creates speed and simplicity, but that openness creates downstream chaos:

- **Self-service sprawl** — individuals create personal dashboards, share them, and modified versions multiply into conflicting versions of truth
- **Managed dashboard drift** — curated reports become stale as metrics and definitions evolve; new versions get created alongside old ones
- **Zombie reports** — abandoned reports that nobody uses, nobody owns, and nobody wants to delete in case someone needs them

DataTools Pro fights all three by giving analytics teams **visibility, segmentation, lifecycle control, and a governance process** for their entire report library — organized by business relevance rather than Salesforce folder structure.

---

## Core Capabilities

| Capability | Description |
|---|---|
| **Lifecycle Status Management** | Apply a status to every report/dashboard to designate where it is in its lifecycle: In-Progress, Production, Deprecated |
| **Business Category Alignment** | Categorize reports by line of business or business topic — independent of Salesforce folder structure |
| **Utilization & Adoption Visibility** | Filter reports by last viewed date; identify abandoned "zombie reports" not being used |
| **Comprehensive Search & Filters** | Slice and dice your report library by any combination: last run, status, business topic, owner, and more |
| **Bulk Classification** | Bulk tag, classify, and differentiate production reports from development/deprecated ones at scale |
| **Metrics Glossary Connection** | Link reports to the business metrics they calculate or surface — close the loop between data and meaning |
| **Export to Excel** | Quick export of your full report and dashboard list for distribution or offline review |
| **Deprecate & Delete Workflow** | Flag zombie reports as deprecated → export list → bulk delete to clean up the org |

---

## Key Concepts

| Concept | Definition |
|---|---|
| **Report Deluge** | The accumulation of hundreds or thousands of Salesforce reports/dashboards with no governance structure |
| **Zombie Report** | An abandoned report or dashboard that is no longer viewed, owned, or maintained — but hasn't been deleted |
| **Lifecycle Status** | The current state of a report in its governance lifecycle: `in_progress`, `production`, `deprecated` |
| **Business Category** | User-defined grouping applied to reports based on business relevance (line of business, initiative) — independent of Salesforce folder structure |
| **Adoption** | Usage data for a report: last viewed date, view frequency — used to identify zombies |
| **Multiple Versions of Truth** | When the same metric or business question is answered differently by two or more reports/dashboards |

---

## Report Lifecycle Statuses

| Status | Meaning | Who Sets It |
|---|---|---|
| `in_progress` | Being actively built or revised — not yet production-ready | Creator / Analyst |
| `production` | Live, certified, actively used source of truth | Analytics team |
| `deprecated` | No longer accurate or actively used — flagged for deletion | Analytics team / Admin |

> **Note:** Status in DataTools Pro is governance metadata — it does not affect the actual Salesforce report or its permissions.

---

## How It Connects to Other Tools

- **Metrics Glossary** — reports are linked to the metrics they calculate; a metric's "source reports" are managed here
- **Data Dictionary** — reports link back to the Salesforce objects and fields they query (impact analysis when fields change)
- **ERD** — the objects in a report's underlying query can be explored in the ERD
- **Business Topics** — the same Business Topics used across all DataTools tools categorize reports for consistent cross-tool browsing

---

## User Workflows

### Getting Control of Your Report Library
1. Connect Salesforce org → DataTools syncs all reports and dashboards
2. Apply Business Topic tags to categorize by line of business
3. Filter by last viewed → identify zombie reports (not viewed in 90/180 days)
4. Mark zombies as `deprecated`
5. Export deprecated list to Excel → review with stakeholders
6. Bulk delete deprecated reports in Salesforce

### Managing the Report Lifecycle
1. Analyst creates report in Salesforce → set status to `in_progress` in DataTools
2. Report reviewed and approved → set status to `production`
3. Report superseded by a new version → set old report to `deprecated`
4. Periodic audit: filter for deprecated → confirm deletion candidates

### Linking Reports to Metrics
1. Navigate to a Report in DataTools
2. Link to one or more Metrics from the Metrics Glossary
3. Report now appears in the Metric's "Source Reports" panel
4. Stakeholders browsing a metric can trace it back to the authoritative report

### Exporting the Report Library
1. Apply filters (status, business topic, date range)
2. Export → downloads Excel with report name, owner, status, last run, business topic

---

## Business Rules

- Reports and dashboards are sourced from Salesforce — they cannot be created in DataTools
- Lifecycle status is DataTools metadata only — it has no effect on the Salesforce report itself
- A report can be tagged to multiple Business Topics
- Adoption/usage data is read from Salesforce (last run date, view counts)
- Deprecating a report in DataTools does not delete it from Salesforce — deletion is a manual action
- A report linked to a Metric cannot be silently deleted — impact warning required

---

## Open Questions

- [ ] What triggers the initial report/dashboard sync — automatic on org connection or manual?
- [ ] How frequently is adoption data refreshed from Salesforce?
- [ ] Is there a bulk status-change action in the UI (select 50 reports → mark all deprecated)?
- [ ] Can report owners receive notifications when their report is marked deprecated?
- [ ] Is there a "bulk delete in Salesforce" integration or is that always a manual step?
- [ ] Can DataTools suggest zombie reports automatically (e.g. "not viewed in 90 days" rule)?

# Tool: Metrics Glossary

**Part of:** DataTools Pro
**Primary users:** Data Analysts, Analytics Professionals, Salesforce Administrators, Business Stakeholders

---

## What It Does

Metrics Glossary is DataTools Pro's solution for the most common and expensive problem in Salesforce orgs: **the multiple versions of truth problem** — where different teams use the same metric name to mean different things, where metric documentation is outdated the moment it's written, and where analysts spend days reverse-engineering logic from dashboards instead of answering business questions.

DataTools Pro solves this with a **live, connected metrics glossary** that bridges the gap between metrics and meaning. It connects what you measure to what it means in business terms, to the Salesforce data behind it, and to the reports and dashboards used to make decisions.

The core differentiator is the **Metrics Analyst** — a patent-pending feature that reverses and automates the traditional metrics-gathering process. Instead of weeks of cross-functional meetings to document metrics from scratch, it reads your existing Salesforce dashboards and automatically recommends a metrics glossary in clicks.

---

## Core Capabilities

| Capability | Description |
|---|---|
| **Metrics Analyst** | Patent-pending auto-generation: analyzes your existing Salesforce dashboards and reports metadata to intelligently recommend metrics for your glossary |
| **Batch Import** | Import metrics from Salesforce, Tableau, Google Analytics, Excel, and a growing list of business and analytics applications |
| **Deduplication & Conflict Detection** | Identifies aliases, naming inconsistencies, and conflicting definitions across dashboards — surfaces the "multiple versions of truth" problem |
| **Organize by Business Topic** | Tag and categorize metrics by line of business and business topics for contextual browsing |
| **Metric Relationships** | Model how metrics relate to and impact one another — create a semantic dictionary of your business |
| **Link to Reports & Dashboards** | Attach metrics to the Salesforce reports and dashboards that calculate or surface them |
| **Link to Salesforce Data** | Connect metrics to the specific Salesforce objects and fields that feed them |
| **Publish & Distribute** | Distribute the glossary to business and technical consumers via export, API, and native integrations (Notion, Coda) |
| **Search & Filter** | Full-text search across metrics by line of business, business topic, or keyword |

---

## The Metrics Analyst (Key Differentiator)

> *"Traditional metrics requirement gathering takes days or weeks. Our novel DataTools Pro method reverses and automates the process into clicks."*

The Metrics Analyst is a patent-pending feature that flips the traditional process on its head:

**Traditional way:**
```
Weeks of stakeholder meetings → manual documentation in spreadsheets
→ documentation immediately becomes outdated → repeat
```

**DataTools Pro way:**
```
Connect Salesforce org → Metrics Analyst reads existing dashboard metadata
→ Recommends metrics in clicks → You review, merge, and refine
→ Living glossary grows smarter over time
```

### How the Metrics Analyst Works

**Step 1 — Ingest**
Consumes metadata from your most important self-service dashboards and reports in Salesforce (and connected tools like Tableau).

**Step 2 — Analysis**
Evaluates the metadata to construct a model of metrics by examining:
- Filters
- Aggregations
- Calculations
- Dimensionality

Deduplicates across sources and maps against your existing metrics glossary for context.

**Step 3 — Recommendation**
Presents recommended metrics with context, flagging:
- Potential conflicts where dashboards don't match existing metric definitions
- Aliases (same metric, different names across teams)
- Gaps in the glossary (metrics in dashboards with no documentation)

**Step 4 — User Action**
Users can immediately take action on each recommendation:
- ✅ Merge into glossary as a new metric
- 🔀 Map as an alias to an existing metric
- ✏️ Update an existing definition to resolve conflict
- 🚩 Flag the source dashboard/report as incorrect

---

## Key Concepts

| Concept | Definition |
|---|---|
| **Metric** | A named, documented business measurement (e.g. "Monthly Recurring Revenue", "Lead Conversion Rate") |
| **Calculation Logic** | Human-readable description or formula for how the metric is derived from Salesforce data |
| **Business Topic** | User-defined grouping label organizing metrics by domain (e.g. "Sales Performance", "Pipeline Health") — shared across all DataTools |
| **Metric Relationship** | An explicit link between two metrics showing dependency or hierarchy (e.g. "Win Rate depends on Opportunities Won and Total Opportunities") |
| **Metric Alias** | An alternative name for the same metric used in a different dashboard, team, or tool — identified by the Metrics Analyst |
| **Metrics Analyst** | The patent-pending automated process that reverse-engineers existing dashboards into metric recommendations |
| **Version of Truth** | A conflict where the same metric is defined or calculated differently in two or more places |

---

## Import Sources

| Source | Status |
|---|---|
| Salesforce Dashboards & Reports | ✅ Supported |
| Tableau | ✅ Supported |
| Google Analytics | ✅ Supported |
| Excel / CSV | ✅ Supported |
| Manual entry (from scratch) | ✅ Supported |
| Additional analytics platforms | 🗓 Growing list |

---

## Distribution Channels

| Channel | Description |
|---|---|
| Published Glossary View | Read-only view for business stakeholders within DataTools |
| Export (data) | Export metrics as CSV / Excel |
| API | Programmatic access to the metrics glossary |
| Notion integration | Native push to Notion pages |
| Coda integration | Native push to Coda docs |

---

## How It Connects to Other Tools

- **Data Dictionary** — metrics link directly to the Salesforce fields and objects that feed them
- **ERD** — metrics can be traced to the objects displayed in the ERD
- **Report Management** — metrics are the bridge between a report and its business meaning; reports link to the metrics they calculate
- **Data Migration** — metrics help identify which fields are business-critical during a migration

---

## User Workflows

### Auto-generating a Metrics Glossary (Metrics Analyst)
1. Connect your Salesforce org
2. Navigate to Metrics Glossary → click **Metrics Analyst**
3. Select the dashboards/reports you want analyzed
4. Review recommendations: conflicts, aliases, new metrics
5. Take action on each: merge, alias, update, or flag
6. Publish your living glossary

### Importing from Tableau / Google Analytics / Excel
1. Metrics Glossary → **Import**
2. Select source type
3. Map source fields to DataTools metric schema
4. Review deduplication recommendations
5. Confirm and merge into glossary

### Creating a Metric Manually
1. Metrics Glossary → **New Metric**
2. Enter: name, description, calculation logic, owner, business topic
3. Link to Salesforce fields, reports, and related metrics
4. Set status: `draft` → `published` when ready

### Distributing the Glossary
1. Publish the glossary → stakeholders see a clean read-only view
2. Export to CSV, push to Notion/Coda, or access via API

---

## Business Rules

- A metric must have a name and description before it can be `published`
- Metric names must be unique within an Organization (aliases are tracked separately)
- A metric can belong to multiple Business Topics
- Metrics can have parent/child relationships — a metric can depend on other metrics
- Deleting a Salesforce field that is linked to a metric triggers an impact warning
- Metric Analyst recommendations require user action — nothing is auto-merged without confirmation
- Aliases are tracked as a link to an existing metric, not as new metric records

---

## Open Questions

- [ ] Is Metrics Analyst a separate paid tier or included in all plans?
- [ ] Can the API distribute the glossary in real-time (webhook) or only on-demand pull?
- [ ] Is there version history on metric definitions (so you can see how a metric's definition evolved)?
- [ ] Is there an approval workflow before a metric can be published (e.g. admin sign-off)?
- [ ] Can external Tableau/GA metrics be kept "live synced" or are they one-time imports?
- [ ] What exactly does the Notion/Coda integration update — full page, specific blocks?

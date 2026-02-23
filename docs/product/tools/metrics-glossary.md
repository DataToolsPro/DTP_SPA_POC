# Tool: Metrics Glossary

**Part of:** DataTools Pro
**Primary users:** Data Analysts, Analytics Professionals, Business Stakeholders

---

## What It Does

Metrics Glossary helps teams track, document, and publish their Salesforce business metrics. It creates a single source of truth for what each metric means, how it is calculated, and how it connects to underlying Salesforce data, reports, and business topics.

The goal is to eliminate the problem where different teams use the same metric name to mean different things — or where analysts have to reverse-engineer metric logic from Salesforce reports every time someone asks "how is this calculated?"

---

## Core Capabilities

| Capability | Description |
|---|---|
| **Define Metrics** | Create metric entries with name, description, calculation logic, and owner |
| **Link to Salesforce** | Attach metrics to the specific Salesforce objects, fields, and reports that power them |
| **Relate to Business Topics** | Tag metrics to business topics or initiatives so stakeholders can browse by context |
| **Show Relationships** | Visualize how metrics, reports, and business topics are connected to each other |
| **Publish & Export** | Publish the metrics glossary for broader team consumption; export to shareable formats |

---

## Key Concepts

| Concept | Definition |
|---|---|
| **Metric** | A named, documented business measurement (e.g. "Monthly Recurring Revenue", "Lead Conversion Rate") |
| **Calculation Logic** | The human-readable formula or description of how the metric is derived |
| **Business Topic** | A grouping label applied to metrics to organize them by domain (e.g. "Sales Performance", "Pipeline Health") |
| **Metric Relationship** | An explicit link between two metrics showing dependency or hierarchy (e.g. "Conversion Rate depends on Leads Created") |

---

## How It Connects to Other Tools

- **Data Dictionary** — metric definitions link directly to the Salesforce fields that feed them
- **ERD** — metrics can be traced back to the objects in the ERD
- **Report Management** — metrics are linked to the Salesforce reports that calculate them

---

## User Workflows

### Creating a Metric
1. Navigate to Metrics Glossary
2. Create new metric → enter name, description, calculation logic, owner
3. Link to relevant Salesforce fields/objects (from the shared Data Dictionary)
4. Tag to a Business Topic
5. Publish when ready

### Publishing the Glossary
- Published metrics are visible in a read-only view for non-admin users / business stakeholders
- Export to PDF or shareable link (planned)

---

## Business Rules

- [ ] A metric must have a name and description before it can be published
- [ ] A metric can belong to multiple Business Topics
- [ ] Deleting a Salesforce field that is linked to a metric should warn the user (impact analysis)
- [ ] Metric names should be unique within an Organization

<!-- Fill in confirmed business rules as they are implemented -->

---

## Open Questions

- [ ] Can metrics have versions / history?
- [ ] Is there approval workflow before a metric can be published?
- [ ] Can stakeholders (non-admin users) suggest edits or comments on metrics?
- [ ] What does "export" look like — PDF, CSV, public URL?

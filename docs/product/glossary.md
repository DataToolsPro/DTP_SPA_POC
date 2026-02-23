# DataTools Pro — Domain Glossary

**Purpose:** A single place for domain terminology used across code, Jira tickets, and user-facing copy.

> When you introduce a new term in the codebase or Jira, add it here.
> The AI uses this glossary to use consistent naming across all files.

---

## How to Use This

- **Code:** Class names, variable names, DB column names, and API field names should match the terms here
- **Jira:** Story and task titles should use these terms — not synonyms
- **User-facing copy:** The "User Term" column is what shows up in the UI
- **AI:** When an ambiguous term appears, check here first before assuming meaning

---

## Core Platform Terms

| Term (Code) | User Term (UI) | Definition | Scope |
|---|---|---|---|
| `DataTools Pro 3.0` | DataTools Pro | The third major release. This codebase. Use "3.0" when version context matters. | Platform-wide |
| `Organization` | Account / Workspace | The top-level tenant — a company or team subscribed to DataTools Pro. All data is scoped to an Org. | Platform-wide |
| `User` | User | A person who can log in to DataTools Pro. Always belongs to an Organization. | Platform-wide |
| `SalesforceOrg` | Salesforce Org / Connected Org | A Salesforce instance connected to DataTools Pro via OAuth. An Organization can have multiple Salesforce Orgs. | Platform-wide |
| `BusinessTopic` | Business Topic | A user-defined grouping label applied to objects, fields, metrics, ERDs, and reports. Used to organize content by business domain or initiative. | All tools |

---

## Metrics Glossary Terms

| Term (Code) | User Term (UI) | Definition |
|---|---|---|
| `Metric` | Metric | A named, documented business measurement (e.g. "Monthly Recurring Revenue"). Has a name, description, calculation logic, owner, and status. |
| `MetricRelationship` | Related Metric | An explicit link between two metrics showing dependency or hierarchy (e.g. "Win Rate depends on Opportunities Won"). |
| `CalculationLogic` | Calculation / How It's Calculated | Human-readable description of how the metric is derived from Salesforce data. |
| `MetricAlias` | Alias | An alternative name for the same metric found in a different dashboard, team, or tool. Always resolves to one canonical Metric. |
| `MetricsAnalystRun` | Metrics Analyst | A run of the patent-pending automated analysis that reads dashboard/report metadata and produces metric recommendations. |
| `MetricRecommendation` | Recommendation | A single metric suggestion from the Metrics Analyst, pending user action (merge, alias, dismiss). |
| `VersionOfTruth` | Version of Truth / Conflict | A conflict where the same metric is defined or calculated differently in two or more places. Detected by the Metrics Analyst. |

---

## Entity Relationship Diagram Terms

| Term (Code) | User Term (UI) | Definition |
|---|---|---|
| `ERDView` | ERD / Diagram | A saved diagram showing a specific set of Salesforce objects and their relationships, organized by Business Topic or initiative. |
| `ObjectRelationship` | Relationship | A lookup or master-detail relationship between two Salesforce objects, sourced from Salesforce metadata. |

---

## Data Dictionary Terms

| Term (Code) | User Term (UI) | Definition |
|---|---|---|
| `SalesforceObject` | Object | A standard or custom Salesforce object (e.g. `Account`, `Opportunity`, `My_Custom__c`). |
| `SalesforceField` | Field | A field on a Salesforce object. Sourced live from Salesforce metadata. |
| `FieldContext` | Field Description / Business Context | User-added documentation on a field: description, owner, usage notes, business topic tags. Stored in DataTools, not written back to Salesforce. |
| `ChangeLog` | Change History | An immutable record of what changed on a field or object (type, label, picklist values) and when. |
| `ImpactAnalysis` | Impact / What Uses This | The set of metrics, reports, and migration mappings that reference a given field or object. |

---

## Data Migration Terms

| Term (Code) | User Term (UI) | Definition |
|---|---|---|
| `MigrationProject` | Migration Project | A named migration initiative with a defined source system and target Salesforce org. |
| `ObjectMapping` | Object Mapping | A pairing of a source system object/table to a target Salesforce object. |
| `FieldMapping` | Field Mapping | A pairing of a source field to a target Salesforce field, with optional transformation logic. |
| `TransformationLogic` | Transformation / Transform Logic | Notes or pseudocode describing how the source value must be changed to fit the target field. |
| `MappingStatus` | Status | The state of a field mapping: `unmapped`, `in_progress`, `confirmed`, `blocked`. |
| `ProjectScorecard` | Project Scorecard | Object-level progress summary showing total fields, confirmed, blocked, and completion % per object in a migration project. |
| `TypeMismatch` | Type Mismatch | When a source field's data type is incompatible with the target Salesforce field type — flagged during mapping. |
| `SQLMockup` | SQL / Generated Code | Auto-generated SQL representing confirmed field mappings — a starting point for ETL engineers, not a finished production script. |

---

## Report Management Terms

| Term (Code) | User Term (UI) | Definition |
|---|---|---|
| `Report` | Report | A Salesforce report synced from the connected org. |
| `Dashboard` | Dashboard | A Salesforce dashboard (collection of report charts) synced from the connected org. |
| `ReportStatus` | Status | Lifecycle state of a report: `in_progress`, `production`, `deprecated`. Governance metadata only — does not affect the Salesforce report. |
| `Adoption` | Adoption / Usage | Usage data for a report: last viewed date, view frequency. Used to identify zombie reports. |
| `ReportOwner` | Owner | The Salesforce user or DataTools user responsible for maintaining the report. |
| `ZombieReport` | Zombie Report | An abandoned report or dashboard that is no longer viewed, owned, or maintained — flagged for deprecation and deletion. |
| `ReportDeluge` | Report Deluge | The accumulation of hundreds or thousands of unmanaged Salesforce reports/dashboards. The core problem Report Management solves. |

---

## Status Enums

| Entity | Field | Allowed Values | Notes |
|---|---|---|---|
| `FieldMapping` | `status` | `unmapped`, `in_progress`, `confirmed`, `blocked` | |
| `Report` / `Dashboard` | `status` | `active`, `under_review`, `deprecated`, `archived` | |
| `Metric` | `status` | `draft`, `published` | |

<!-- Add new enums here as they are implemented -->

---

## Terms We Deliberately Avoid

| Don't Use | Use Instead | Why |
|---|---|---|
| "Metadata dictionary" | Data Dictionary | User-facing name is "Data Dictionary" |
| "Schema" | Object / Field | "Schema" is too technical for our user base |
| "Table" | Object | In Salesforce context, we say "Object" not "Table" |
| "Column" | Field | In Salesforce context, we say "Field" not "Column" |
| "Record type" | (be specific) | Overloaded term — use "Salesforce Object", "Salesforce Field", etc. |

---

## Abbreviations

| Abbreviation | Stands For | Used In |
|---|---|---|
| DTP | DataTools Pro | Everywhere |
| ERD | Entity Relationship Diagram | ERD tool, code, docs |
| SF / SFDC | Salesforce | Internal shorthand only — spell out in user-facing copy |
| org | Salesforce Org | Common shorthand — OK in code and internal docs |

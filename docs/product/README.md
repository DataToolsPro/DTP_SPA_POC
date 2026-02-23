# DataTools Pro — Product Overview

## What Is DataTools Pro?

DataTools Pro **3.0** is the third major release — a **Salesforce-connected governance and documentation platform** that brings Salesforce administrators, data analysts, analytics professionals, and business teams together in a single shared workspace.

Organizations running Salesforce accumulate hundreds of custom objects, thousands of fields, complex report libraries, and ongoing data migrations — all managed in disconnected spreadsheets, wikis, and tribal knowledge. DataTools Pro replaces that chaos with a **living, connected documentation layer** that stays in sync with your actual Salesforce org.

**Core value proposition:**
> DataTools Pro helps Salesforce and data cloud professionals understand what their data means, where it comes from, and how it connects — so they can build faster, collaborate better, and make decisions with confidence.

---

## The Five Tools

DataTools Pro is a suite of five interconnected tools that all operate on the **same underlying data model**. They are not separate products — they are different views and workflows on the same connected graph of Salesforce metadata and business context.

| Tool | Core Job |
|---|---|
| [Metrics Glossary](./tools/metrics-glossary.md) | Define and publish your business metrics and how they connect to Salesforce data |
| [Entity Relationship Diagram](./tools/erd.md) | Visualize object relationships; auto-generate ERDs by business topic or initiative |
| [Data Dictionary](./tools/data-dictionary.md) | Live, connected documentation of every Salesforce object and field |
| [Data Migration Tools](./tools/data-migration.md) | Map source-to-target fields and generate SQL for migrations |
| [Report Management & Repository](./tools/report-management.md) | Govern the lifecycle of reports and dashboards at scale |

---

## Who Uses It

| Persona | Primary Tools | Goal |
|---|---|---|
| **Salesforce Administrator** | Data Dictionary, ERD | Understand their org's full object/field landscape; document changes |
| **Data Analyst** | Metrics Glossary, Data Dictionary | Know exactly what each metric means and where it comes from |
| **Analytics Professional** | Report Management, Metrics Glossary | Govern the report lifecycle; reduce report sprawl |
| **Migration Engineer** | Data Migration Tools, Data Dictionary | Map fields confidently; generate SQL without error-prone spreadsheets |
| **Business Stakeholder** | Metrics Glossary (read-only), ERD | Understand what the data means in business terms |

---

## The Shared Data Model

All five tools are views into the same underlying data graph. Key shared entities:

```
Organization (tenant)
  └── Salesforce Org (connected via OAuth)
        ├── Objects (Account, Contact, custom__c, ...)
        │     └── Fields (Name, Email, custom_field__c, ...)
        │           ├── linked to → Metrics
        │           ├── linked to → Migration Mappings
        │           └── linked to → Reports
        ├── Business Topics (user-defined groupings)
        │     ├── organizes → ERD Views
        │     ├── groups → Dictionary entries
        │     └── categorizes → Reports
        └── Reports / Dashboards
```

This is why changes in the Data Dictionary are instantly visible in the ERD and Metrics Glossary — they share the same records.

---

## How DataTools Pro Connects to Salesforce

DataTools Pro connects to your Salesforce org as a **Connected App** using OAuth 2.0.

- Reads metadata: objects, fields, reports, dashboards
- Does **not** write schema back to Salesforce
- Supports multiple Salesforce orgs per Organization account
- Field/object data refreshes on demand or on a schedule (TBD)

---

## Product Principles

1. **Living documentation over static exports** — the dictionary, glossary, and ERD stay connected to the live Salesforce org, not a snapshot
2. **Cross-team alignment** — every tool is designed to bridge the gap between technical (admin/analyst) and business (stakeholder) users
3. **Replace spreadsheets** — every tool has a specific spreadsheet workflow it eliminates
4. **One data model, five views** — features are additive, not siloed; the same underlying data powers all tools

---

## Roadmap

| Area | Status | Notes |
|---|---|---|
| Metrics Glossary | 🚧 In Progress | |
| Entity Relationship Diagram | 🚧 In Progress | |
| Data Dictionary | 🚧 In Progress | |
| Data Migration Tools | 📋 Planned | |
| Report Management | 📋 Planned | |
| Multi-org support | 📋 Planned | |
| Published / public glossary export | 📋 Planned | |

<!-- Update as features ship -->

---

## Out of Scope

- Not a BI or charting tool (no chart builder)
- Not a Salesforce admin panel (doesn't create/edit objects or fields in Salesforce)
- Not a standalone ETL engine (generates SQL mapping guidance — doesn't execute migrations)
- Not a general-purpose data catalog (Salesforce-specific, not multi-platform)

# Tool: Data Migration Tools

**Part of:** DataTools Pro
**Primary users:** Migration Engineers, Salesforce Administrators, Data Analysts

---

## What It Does

Data Migration Tools manages the **object and field mapping process** for data migrations into or within Salesforce. It replaces the sprawling, error-prone spreadsheets that teams typically use to track source-to-target field mappings.

Beyond documentation, DataTools Migration Tools generates usable **SQL code** that teams can use to iterate between field mapping and ETL tooling — reducing the back-and-forth between mapping and execution for migrations of any size.

---

## Core Capabilities

| Capability | Description |
|---|---|
| **Migration Project Management** | Create and manage migration projects with source system and target system context |
| **Object Mapping** | Map source system objects to target Salesforce objects |
| **Field Mapping** | Map source fields to target Salesforce fields with transformation notes |
| **SQL Generation** | Auto-generate SQL code from confirmed field mappings for use in ETL tools |
| **Status Tracking** | Track the status of each mapping (unmapped, in progress, confirmed, blocked) |
| **Progress Dashboard** | See overall migration progress: % mapped, % confirmed, % blocked |

---

## Key Concepts

| Concept | Definition |
|---|---|
| **Migration Project** | A named migration initiative with a defined source system and target Salesforce org |
| **Object Mapping** | A pairing of a source system object/table to a target Salesforce object |
| **Field Mapping** | A pairing of a source field to a target Salesforce field, with optional transformation logic |
| **Transformation Logic** | Notes or code describing how the source value must be transformed to fit the target field |
| **Mapping Status** | The current state of a field mapping: `unmapped` → `in_progress` → `confirmed` → `blocked` |
| **SQL Output** | Generated SQL that represents the confirmed field mappings for use in an ETL process |

---

## How It Connects to Other Tools

- **Data Dictionary** — target Salesforce fields are sourced directly from the Data Dictionary (not re-entered)
- **ERD** — the source object structure can be compared against the Salesforce ERD to plan the mapping
- **Metrics Glossary** — metrics that depend on migrated fields can be identified before migration

---

## User Workflows

### Starting a Migration Project
1. Create a new Migration Project → name it, define source system (legacy CRM, database, etc.)
2. Connect target Salesforce org (already connected via DataTools)
3. Import or define source objects/fields

### Field Mapping
1. Select a source object → view its fields
2. For each field: select the target Salesforce field from the Dictionary
3. Add transformation notes if the data needs cleaning/reshaping
4. Mark status: `in_progress` → `confirmed` or `blocked`

### Generating SQL
1. Filter to confirmed mappings
2. Generate SQL → copy output to ETL tool (Informatica, dbt, custom scripts, etc.)
3. Iterate: update mappings → regenerate SQL as needed

---

## Business Rules

- [ ] A Migration Project must have a defined source system and a target Salesforce org
- [ ] Target fields must come from the connected Data Dictionary — no freeform target entry
- [ ] A field mapping can only be `confirmed` if both source and target fields are defined
- [ ] SQL generation is only available for `confirmed` mappings
- [ ] A field can be `blocked` with a reason — blocked mappings are excluded from SQL output
- [ ] Deleting a Migration Project deletes all its mappings (with confirmation warning)

<!-- Fill in confirmed business rules as they are implemented -->

---

## Open Questions

- [ ] What SQL dialects are supported in generation (MySQL, Postgres, SOQL, standard SQL)?
- [ ] Can source fields be imported from a CSV / schema file?
- [ ] Is there version control on mappings (so you can roll back to a previous mapping state)?
- [ ] Can multiple people work on the same migration project simultaneously?
- [ ] Is there an approval workflow for confirming mappings?

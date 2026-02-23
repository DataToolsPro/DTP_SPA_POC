# Tool: Data Migration Tools

**Part of:** DataTools Pro
**Primary users:** Migration Engineers, Salesforce Administrators, Data Analysts

---

## What It Does

Data Migration Tools manages the **object and field mapping process** for Salesforce data migrations. It replaces the error-prone spreadsheets teams use to track source-to-target field mappings — and adds what spreadsheets can never have: a live connection to your Salesforce data dictionary, object-level progress tracking, AI-assisted mapping, and SQL code generation for your engineers.

The core problem it solves: data mapping and sign-off with data, business, and analytics teams is time-consuming and painful. DataTools Pro makes that process faster and easier by keeping everything in one connected, trackable place with real export outputs engineers can actually use.

---

## Core Capabilities

| Capability | Description |
|---|---|
| **Project Scorecard** | Object-level progress dashboard — see at a glance how many fields are mapped, confirmed, and blocked per object |
| **Dictionary-Connected Mapping** | Target Salesforce fields are sourced directly from your live DataTools Data Dictionary — no re-entry, no mismatch |
| **Metadata & Type Management** | Map and manage field metadata and types — surface type mismatches between source and target before they become ETL problems |
| **SQL Code Generation** | Generate mockup SQL code with notes for your engineers — usable code to iterate between field mapping and ETL execution |
| **AI-Assisted Mapping** | AI helps research, document, and suggest field mappings — accelerates the discovery and documentation phase |
| **Export to Excel** | Export mapping documents for team sign-off with data, business, and analytics stakeholders |
| **Status Tracking** | Every field mapping has a status: `unmapped`, `in_progress`, `confirmed`, `blocked` |

---

## Key Concepts

| Concept | Definition |
|---|---|
| **Migration Project** | A named migration initiative — source system, target Salesforce org, and all the object/field mappings within |
| **Project Scorecard** | Object-level summary view showing mapping completion percentage and status breakdown per object |
| **Object Mapping** | A pairing between a source system object/table and a target Salesforce object |
| **Field Mapping** | A pairing between a source field and a target Salesforce field — with transformation logic, status, and notes |
| **Type Mismatch** | When a source field type is incompatible with the target Salesforce field type — flagged during mapping |
| **Transformation Logic** | Notes or pseudocode describing how the source value must be changed to fit the target field |
| **SQL Mockup** | Generated SQL code representing confirmed field mappings — a starting point for ETL engineers, not a finished production script |
| **Mapping Status** | State of a field mapping: `unmapped` → `in_progress` → `confirmed` or `blocked` |

---

## Project Scorecard

The Project Scorecard provides **object-level visibility** into migration progress. For each object in the migration:

```
Object: Account
  Total fields:     47
  Unmapped:         12  ████░░░░░░  
  In Progress:       8  ████░░░░░░  
  Confirmed:        24  ████████░░  74%
  Blocked:           3  ██░░░░░░░░  
```

This keeps the migration project visible and manageable — stakeholders can see exactly where things stand without digging into individual field rows.

---

## AI-Assisted Mapping

DataTools Pro uses AI to accelerate the most time-consuming parts of migration work:

- **Research assistance** — AI helps investigate source field meaning and business context
- **Mapping suggestions** — AI suggests likely target Salesforce fields based on source field name, type, and context
- **Documentation generation** — AI helps write field descriptions and transformation notes
- **Dictionary population** — AI helps document fields in the Data Dictionary alongside the migration

> AI suggestions always require human confirmation — nothing is auto-confirmed.

---

## How It Connects to Other Tools

- **Data Dictionary** — target Salesforce fields come directly from the live Dictionary; field descriptions carry over automatically
- **ERD** — the ERD provides the visual object map used to plan source-to-target object relationships
- **Metrics Glossary** — identifies which fields are metric-critical before migration (high-risk mappings)
- **Business Topics** — migration projects can be tagged to Business Topics for context

---

## User Workflows

### Starting a Migration Project
1. Create a new Migration Project → name it, describe the source system (legacy CRM, database name, etc.)
2. Select the target Salesforce org (from connected orgs in DataTools)
3. Add source objects — import from CSV/schema file or enter manually

### Mapping Fields
1. Open an Object Mapping → view source fields alongside target Salesforce fields
2. For each field: select target from the live Data Dictionary
3. Note any type mismatches — add transformation logic to resolve
4. Use AI assist to suggest mappings or generate documentation
5. Set status: `in_progress` → `confirmed` or `blocked` with a reason

### Reviewing Progress
1. Open Project Scorecard → see object-level completion across the whole project
2. Filter to blocked mappings → resolve blockers with stakeholders
3. Filter to confirmed mappings → ready for SQL generation

### Generating SQL for Engineers
1. Filter to confirmed mappings (or select specific objects)
2. Generate SQL → copy to ETL tool (dbt, Informatica, custom scripts)
3. Engineers review the mockup, add production-specific logic, and execute
4. Iterate: update mappings in DataTools → regenerate SQL as the project evolves

### Getting Sign-off
1. Export mapping document to Excel
2. Share with data, business, and analytics stakeholders for review
3. Stakeholders annotate → team updates statuses in DataTools accordingly

---

## Business Rules

- A Migration Project must have a defined source system and a target Salesforce org
- Target fields must come from the connected Data Dictionary — no freeform target field entry
- A field mapping can only be `confirmed` if both source field name and target field are defined
- SQL generation only includes `confirmed` mappings
- A `blocked` mapping must have a `blocked_reason`
- AI mapping suggestions require explicit user confirmation before status changes
- Deleting a Migration Project deletes all its object and field mappings (confirmation required)

---

## Open Questions

- [ ] What SQL dialects does generation support — standard SQL, MySQL, Postgres, or SOQL?
- [ ] Can source fields be bulk-imported from a CSV schema export?
- [ ] Is there a version history on mappings (rollback to a previous mapping state)?
- [ ] Can multiple team members edit the same Migration Project simultaneously?
- [ ] Is there a formal approval/sign-off workflow within DataTools, or is Excel export the sign-off mechanism?
- [ ] What level of SQL complexity does the generator handle — simple SELECT/INSERT or joins and transformations?

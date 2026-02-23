# Tool: Entity Relationship Diagram (ERD)

**Part of:** DataTools Pro
**Primary users:** Salesforce Administrators, Data Analysts, Migration Engineers

---

## What It Does

The ERD tool automatically visualizes the connections between Salesforce objects using intuitive color-coding. Instead of manually drawing diagrams in Lucidchart or Visio, users select the Salesforce objects they care about and DataTools Pro generates the ERD from the live Salesforce metadata.

ERDs can be organized and saved by business topic, initiative, or application — so teams maintain multiple focused views of their Salesforce data model rather than one overwhelming mega-diagram.

---

## Core Capabilities

| Capability | Description |
|---|---|
| **Auto-generate ERD** | Select Salesforce objects → DataTools builds the relationship diagram automatically from live metadata |
| **Color-coding** | Objects are color-coded by type, topic, or custom grouping for visual clarity |
| **Organize by Business Topic** | Save ERD views scoped to a business area (e.g. "Sales Process", "Service Cloud Objects") |
| **Organize by Initiative/Application** | Group ERDs by project or application context |
| **Interactive Navigation** | Click objects/relationships to see field-level detail from the Data Dictionary |

---

## Key Concepts

| Concept | Definition |
|---|---|
| **ERD View** | A saved diagram showing a specific set of objects and their relationships, organized by a topic or initiative |
| **Salesforce Object** | A standard or custom Salesforce object (e.g. `Account`, `Opportunity`, `My_Custom_Obj__c`) |
| **Relationship** | A lookup or master-detail relationship between two Salesforce objects |
| **Business Topic** | User-defined grouping used to organize ERD views (shared across all tools) |

---

## How It Connects to Other Tools

- **Data Dictionary** — clicking an object in the ERD opens its full field dictionary
- **Metrics Glossary** — objects in the ERD can be linked to the metrics that use them
- **Data Migration** — ERDs can be used as the source map when planning field migration

---

## User Workflows

### Creating an ERD View
1. Navigate to Entity Relationship Diagram
2. Create new ERD View → name it and assign a Business Topic or Initiative
3. Select the Salesforce objects to include (from the connected org)
4. DataTools auto-generates the diagram with relationships
5. Arrange layout, apply color-coding, save

### Using an ERD View
- Browse saved ERD views by Business Topic
- Click any object → drill into its fields in the Data Dictionary
- Share/export the ERD for stakeholder communication (planned)

---

## Business Rules

- [ ] An ERD View belongs to an Organization
- [ ] ERD Views are associated with at least one Business Topic
- [ ] Object relationships are read from Salesforce metadata — they cannot be manually invented in the ERD
- [ ] An object can appear in multiple ERD Views
- [ ] Deleting an ERD View does not delete the underlying objects/fields from the Dictionary

<!-- Fill in confirmed business rules as they are implemented -->

---

## Open Questions

- [ ] Is the ERD layout saved per-user or per-organization?
- [ ] Can ERD views be shared publicly / exported to image?
- [ ] What happens when a Salesforce object is deleted — does it grey out in existing ERDs or get removed?
- [ ] Can custom relationships (non-Salesforce lookup) be added manually?

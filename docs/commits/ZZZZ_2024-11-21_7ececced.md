# fix refresh token

| Field       | Value |
|-------------|-------|
| Commit      | `7ececced09a7ad035a4d565aca647f259866c1d7` |
| Date        | 2024-11-21 10:36:15 +0500 |
| Author      | waqarcs11 <adsknock@gmail.com> |
| Jira Ticket | N/A |
| Parents     | `5b43aeedd8a11284f8e3596f6bc1f316e260e405` |

## Message



## Files Changed

```
.../snowflake/list-databases-schema-table-fields.blade.php     | 10 ++++++++++
 .../pages/snowflake/list-databases-schema-tables.blade.php     | 10 ++++++++++
 .../views/pages/snowflake/list-databases-schemas.blade.php     | 10 ++++++++++
 resources/views/pages/snowflake/list-databases.blade.php       | 10 ++++++++++
 4 files changed, 40 insertions(+)
```

## AI Summary

1. **What changed**:
   - Added a `load_table` variable to multiple JavaScript functions in various Blade templates.
   - Implemented a check in the `complete` callback of AJAX requests to refresh the data if no rows are present in the DataTable.
   - Updated the following files: `list-databases-schema-table-fields.blade.php`, `list-databases-schema-tables.blade.php`, `list-databases-schemas.blade.php`, and `list-databases.blade.php`.

2. **Why**: The changes likely aim to ensure that the data tables refresh automatically when they are empty, improving user experience.

3. **Category**: Bug Fix

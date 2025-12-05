# sql-regex-cleanup

Cleaning up messy contact data with the regular expression functions added in SQL Server 2025: `REGEXP_LIKE`, `REGEXP_REPLACE`, `REGEXP_SUBSTR`, `REGEXP_COUNT`, `REGEXP_MATCHES` and `REGEXP_SPLIT_TO_TABLE`.

These functions need SQL Server 2025 and database compatibility level 170. There is no way to run them on older versions. The scripts are written from the product documentation and run against a developer instance.

## Setup

Run `00_setup.sql`. It creates `RegexCleanup` at compatibility level 170 with a `dbo.RawContact` table of deliberately messy rows.

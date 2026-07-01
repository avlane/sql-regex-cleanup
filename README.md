# sql-regex-cleanup

Cleaning up messy contact data with the regular expression functions added in SQL Server 2025: `REGEXP_LIKE`, `REGEXP_REPLACE`, `REGEXP_SUBSTR`, `REGEXP_COUNT`, `REGEXP_MATCHES` and `REGEXP_SPLIT_TO_TABLE`.

These functions need SQL Server 2025 and database compatibility level 170, so none of this runs on older versions. The scripts are written from the product documentation; run them on a developer instance first.

## Setup

Run `00_setup.sql`. It creates `RegexCleanup` at compatibility level 170 with a `dbo.RawContact` table of deliberately messy rows. Then run the numbered scripts in any order after `00` (`02` before `10` is not required).

| Script | Function(s) | Task |
|---|---|---|
| `01_phone_validate.sql` | `REGEXP_LIKE` | find malformed phones |
| `02_phone_normalize.sql` | `REGEXP_REPLACE` | keep digits, drop country code |
| `03_email.sql` | `REGEXP_LIKE` | validate, `CHECK` constraint |
| `04_postal_codes.sql` | `REGEXP_SUBSTR` | ZIP, ZIP+4, state (capture groups) |
| `05_whitespace.sql` | `REGEXP_REPLACE` | trim and collapse |
| `06_company_suffix.sql` | `REGEXP_REPLACE` with `i` flag | Inc / LLC |
| `07_multi_value_cells.sql` | `REGEXP_COUNT` | several emails in one cell |
| `08_split_emails.sql` | `REGEXP_MATCHES` | one row per email |
| `09_split_to_table.sql` | `REGEXP_SPLIT_TO_TABLE` | split on a pattern |
| `10_names.sql` | `REGEXP_SUBSTR` groups | Last, First |
| `11_dates.sql` | `REGEXP_LIKE` + `TRY_CONVERT` | mixed date formats |
| `12_rules.sql`, `13_change_log.sql` | all | table-driven rules with a change log |
| `tests/regex_cases.sql` | `REGEXP_LIKE` | expected-match assertions |

## Notes

- `REGEXP_LIKE` is a predicate. In a select list wrap it in `CASE WHEN ... THEN 1 ELSE 0 END`.
- Regular expressions in a `WHERE` clause are not sargable, so they scan. Pre-filter with `LIKE` or clean into a persisted column once.
- Plain `<>` ignores trailing spaces, so detect whitespace-only changes by comparing bytes.

## Sample output

`02_phone_normalize.sql`:

```
ContactId  Phone            PhoneClean
---------  ---------------  ----------
1          (555) 010-2231   5550102231
2          555.010.9987     5550109987
3          +1 555 010 7745  5550107745
4          5550104412       5550104412
5          555-0100         NULL
6          ext. 22          NULL
```

`08_split_emails.sql`:

```
ContactId  source_column  match_id  email
---------  -------------  --------  ------------------------
1          Email          1         rosa.alvarez@example.com
2          Notes          1         kenji@home.example.org
3          Email          1         priya@example.com
4          Email          1         oneil@example.com
5          Email          1         mei.chen@example.com
5          Email          2         mei@work.example.com
```

Note the row for contact 4: `tom oneil@example.com` has a space in it, but `REGEXP_MATCHES` finds the substring `oneil@example.com`. Validate with `REGEXP_LIKE` and anchors (script 03) before trusting a match.

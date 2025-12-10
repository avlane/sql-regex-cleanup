USE RegexCleanup;
GO


-- REGEXP_LIKE is a predicate: use it in WHERE, CHECK constraints and CASE, not as a column value.
-- A loose phone shape: optional +, then 7 to 20 digits, spaces, dots, dashes or parentheses.
SELECT ContactId, Phone
FROM dbo.RawContact
WHERE Phone IS NOT NULL
  AND NOT REGEXP_LIKE(Phone, '^[+]?[0-9() .-]{7,20}$');

-- Stricter: after stripping punctuation there must be exactly 10 digits, or 11 starting with 1.
SELECT ContactId, Phone,
       CASE WHEN REGEXP_LIKE(REGEXP_REPLACE(Phone, '[^0-9]', ''), '^1?[0-9]{10}$') THEN 'ok' ELSE 'check' END AS verdict
FROM dbo.RawContact
ORDER BY ContactId;

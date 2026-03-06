USE RegexCleanup;
GO


-- REGEXP_MATCHES is a table-valued function: one row per match, with its position.
SELECT c.ContactId, 'Email' AS source_column, m.match_id, LOWER(m.match_value) AS email
FROM dbo.RawContact AS c
CROSS APPLY REGEXP_MATCHES(c.Email, '[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+([.][A-Za-z0-9-]+)*[.][A-Za-z]{2,}') AS m
UNION ALL
SELECT c.ContactId, 'Notes', m.match_id, LOWER(m.match_value)
FROM dbo.RawContact AS c
CROSS APPLY REGEXP_MATCHES(c.Notes, '[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+([.][A-Za-z0-9-]+)*[.][A-Za-z]{2,}') AS m
ORDER BY ContactId, source_column, match_id;

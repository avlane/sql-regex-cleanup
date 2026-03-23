USE RegexCleanup;
GO


-- Split an address into its comma separated parts, keeping their order.
SELECT c.ContactId, s.ordinal, TRIM(s.value) AS part
FROM dbo.RawContact AS c
CROSS APPLY REGEXP_SPLIT_TO_TABLE(c.Address, ',') AS s
WHERE c.Address IS NOT NULL
ORDER BY c.ContactId, s.ordinal;

-- The delimiter can be a pattern: split a list on commas, semicolons or the word "and".
SELECT s.ordinal, TRIM(s.value) AS item
FROM REGEXP_SPLIT_TO_TABLE(N'red, green;blue and yellow', '\s*(,|;|\band\b)\s*') AS s;

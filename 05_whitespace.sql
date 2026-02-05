USE RegexCleanup;
GO


-- Runs of spaces or tabs become one space; leading and trailing whitespace goes.
UPDATE dbo.RawContact
SET FullName = REGEXP_REPLACE(REGEXP_REPLACE(FullName, '^\s+|\s+$', ''), '\s{2,}', ' ')
WHERE FullName IS NOT NULL
  AND REGEXP_LIKE(FullName, '^\s|\s$|\s{2,}');
GO

-- Control characters (tab, line feed, carriage return, NUL .. US) hide in pasted text.
SELECT ContactId, Notes
FROM dbo.RawContact
WHERE REGEXP_LIKE(Notes, '[\x00-\x1F]');

USE RegexCleanup;
GO


IF COL_LENGTH(N'dbo.RawContact', N'FirstName') IS NULL
    ALTER TABLE dbo.RawContact ADD FirstName NVARCHAR(60) NULL, LastName NVARCHAR(60) NULL;
GO

UPDATE dbo.RawContact
SET LastName  = REGEXP_SUBSTR(FullName, '^([^,]+),\s*(.+)$', 1, 1, 'c', 1),
    FirstName = REGEXP_SUBSTR(FullName, '^([^,]+),\s*(.+)$', 1, 1, 'c', 2)
WHERE REGEXP_LIKE(FullName, '^[^,]+,\s*.+$');

-- 'First Last' (no comma): the last word is the surname
UPDATE dbo.RawContact
SET FirstName = REGEXP_SUBSTR(FullName, '^(.+)\s+(\S+)$', 1, 1, 'c', 1),
    LastName  = REGEXP_SUBSTR(FullName, '^(.+)\s+(\S+)$', 1, 1, 'c', 2)
WHERE FullName IS NOT NULL
  AND NOT REGEXP_LIKE(FullName, ',')
  AND REGEXP_LIKE(FullName, '^.+\s+\S+$');
GO

SELECT FullName, FirstName, LastName FROM dbo.RawContact ORDER BY ContactId;

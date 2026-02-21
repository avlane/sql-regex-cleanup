USE RegexCleanup;
GO


IF COL_LENGTH(N'dbo.RawContact', N'CompanyClean') IS NULL
    ALTER TABLE dbo.RawContact ADD CompanyClean NVARCHAR(100) NULL;
GO

-- 'Inc.', 'inc', ', Inc' and 'INC' all become ' Inc'; the same for LLC written as 'l.l.c.'.
-- The 'i' flag makes the match case-insensitive.
UPDATE dbo.RawContact
SET CompanyClean =
    REGEXP_REPLACE(
        REGEXP_REPLACE(
            REGEXP_REPLACE(Company, '\s*,?\s*\binc\b\.?\s*$', ' Inc', 1, 1, 'i'),
            '\s*,?\s*\bl\.?l\.?c\b\.?\s*$', ' LLC', 1, 1, 'i'),
        '\s{2,}', ' ')
WHERE Company IS NOT NULL;
GO

SELECT Company, CompanyClean FROM dbo.RawContact WHERE Company IS NOT NULL;

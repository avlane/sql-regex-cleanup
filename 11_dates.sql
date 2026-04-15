USE RegexCleanup;
GO


IF COL_LENGTH(N'dbo.RawContact', N'SignupDateClean') IS NULL
    ALTER TABLE dbo.RawContact ADD SignupDateClean DATE NULL;
GO

-- Formats seen: 2024-03-14, 2024/03/16, 03/15/2024 (US), 18-03-2024 (day first), 15 Mar 2024.
-- Slashes with a 4-digit year at the end are treated as US month/day/year.
UPDATE dbo.RawContact
SET SignupDateClean = CASE
        WHEN REGEXP_LIKE(SignupDate, '^[0-9]{4}[-/][0-9]{2}[-/][0-9]{2}$')
            THEN TRY_CONVERT(DATE, REGEXP_REPLACE(SignupDate, '/', '-'), 23)
        WHEN REGEXP_LIKE(SignupDate, '^[0-9]{2}/[0-9]{2}/[0-9]{4}$')
            THEN TRY_CONVERT(DATE, SignupDate, 101)
        WHEN REGEXP_LIKE(SignupDate, '^[0-9]{2}-[0-9]{2}-[0-9]{4}$')
            THEN TRY_CONVERT(DATE, SignupDate, 105)
        WHEN REGEXP_LIKE(SignupDate, '^[0-9]{1,2} [A-Za-z]{3} [0-9]{4}$')
            THEN TRY_CONVERT(DATE, SignupDate, 106)
    END
WHERE SignupDate IS NOT NULL;
GO

SELECT SignupDate, SignupDateClean FROM dbo.RawContact ORDER BY ContactId;

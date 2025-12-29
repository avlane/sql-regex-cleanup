USE RegexCleanup;
GO


IF COL_LENGTH(N'dbo.RawContact', N'PhoneClean') IS NULL
    ALTER TABLE dbo.RawContact ADD PhoneClean VARCHAR(20) NULL;
GO

-- Remove everything that is not a digit; drop a leading country code 1 from 11-digit numbers.
UPDATE dbo.RawContact
SET PhoneClean = CASE
        WHEN REGEXP_LIKE(REGEXP_REPLACE(Phone, '[^0-9]', ''), '^1[0-9]{10}$')
            THEN REGEXP_REPLACE(REGEXP_REPLACE(Phone, '[^0-9]', ''), '^1', '')
        WHEN REGEXP_LIKE(REGEXP_REPLACE(Phone, '[^0-9]', ''), '^[0-9]{10}$')
            THEN REGEXP_REPLACE(Phone, '[^0-9]', '')
        ELSE NULL   -- leave unparseable numbers for a human
    END
WHERE Phone IS NOT NULL;
GO

SELECT ContactId, Phone, PhoneClean FROM dbo.RawContact ORDER BY ContactId;

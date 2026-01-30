USE RegexCleanup;
GO


IF COL_LENGTH(N'dbo.RawContact', N'Zip5') IS NULL
    ALTER TABLE dbo.RawContact ADD Zip5 CHAR(5) NULL, Zip4 CHAR(4) NULL, StateCode CHAR(2) NULL;
GO

-- US ZIP or ZIP+4 at the end of the address. Group 1 of the state/zip pattern is the state.
UPDATE dbo.RawContact
SET Zip5      = REGEXP_SUBSTR(Address, '[0-9]{5}(?=(-[0-9]{4})?$)'),
    Zip4      = REGEXP_SUBSTR(Address, '[0-9]{5}-([0-9]{4})$', 1, 1, 'c', 1),
    StateCode = REGEXP_SUBSTR(Address, ',\s*([A-Z]{2})\s+[0-9]{5}', 1, 1, 'c', 1)
WHERE Address IS NOT NULL;
GO

SELECT ContactId, Address, StateCode, Zip5, Zip4 FROM dbo.RawContact ORDER BY ContactId;

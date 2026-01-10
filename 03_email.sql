USE RegexCleanup;
GO


-- Pragmatic shape check, not RFC 5322: local part, @, domain with a dot and a 2+ letter TLD.
SELECT ContactId, Email
FROM dbo.RawContact
WHERE Email IS NOT NULL
  AND NOT REGEXP_LIKE(Email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+([.][A-Za-z0-9-]+)*[.][A-Za-z]{2,}$');

-- 'rosa.alvarez@example.com' passes; 'kenji.mori@example' (no TLD), 'tom oneil@example.com' (space)
-- and the semicolon-joined pair fail. 'PRIYA@EXAMPLE.COM' passes because the pattern allows upper case.

-- Enforce it going forward without rejecting the rows that are already bad.
ALTER TABLE dbo.RawContact WITH NOCHECK
    ADD CONSTRAINT CK_RawContact_Email
    CHECK (Email IS NULL OR REGEXP_LIKE(Email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+([.][A-Za-z0-9-]+)*[.][A-Za-z]{2,}$'));
GO

-- REGEXP_LIKE is boolean, so it cannot sit in the select list on its own. Use CASE to get a flag.
SELECT ContactId, Email,
       CASE WHEN REGEXP_LIKE(Email, '@') THEN 1 ELSE 0 END AS has_at
FROM dbo.RawContact;

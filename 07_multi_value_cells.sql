USE RegexCleanup;
GO


-- Rows where Email or Notes hold more than one address.
SELECT ContactId,
       REGEXP_COUNT(Email, '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+')  AS emails_in_email_col,
       REGEXP_COUNT(Notes, '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+')  AS emails_in_notes
FROM dbo.RawContact
WHERE REGEXP_COUNT(Email, '@') > 1
   OR REGEXP_COUNT(Notes, '@') > 0;

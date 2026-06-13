USE RegexCleanup;
GO


-- Each row: input, pattern, whether REGEXP_LIKE should match. Any row in the final SELECT is a failure.
DECLARE @cases TABLE (id INT IDENTITY(1,1), input NVARCHAR(200), pattern NVARCHAR(400), expected BIT);
INSERT INTO @cases (input, pattern, expected)
VALUES (N'(555) 010-2231',          N'^[+]?[0-9() .-]{7,20}$', 1),
       (N'ext. 22',                 N'^[+]?[0-9() .-]{7,20}$', 0),
       (N'rosa.alvarez@example.com', N'^[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+([.][A-Za-z0-9-]+)*[.][A-Za-z]{2,}$', 1),
       (N'kenji.mori@example',      N'^[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+([.][A-Za-z0-9-]+)*[.][A-Za-z]{2,}$', 0),
       (N'tom oneil@example.com',   N'^[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+([.][A-Za-z0-9-]+)*[.][A-Za-z]{2,}$', 0),
       (N'62704',                   N'^[0-9]{5}(-[0-9]{4})?$', 1),
       (N'6270',                    N'^[0-9]{5}(-[0-9]{4})?$', 0);

SELECT c.id, c.input, c.pattern, c.expected,
       CASE WHEN REGEXP_LIKE(c.input, c.pattern) THEN 1 ELSE 0 END AS actual
FROM @cases AS c
WHERE c.expected <> CASE WHEN REGEXP_LIKE(c.input, c.pattern) THEN 1 ELSE 0 END;

-- A passing run returns no rows.

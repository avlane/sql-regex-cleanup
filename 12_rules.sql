USE RegexCleanup;
GO


CREATE TABLE dbo.CleanupRule
(
    RuleId      INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_CleanupRule PRIMARY KEY,
    TableName   SYSNAME       NOT NULL,
    ColumnName  SYSNAME       NOT NULL,
    Pattern     NVARCHAR(400) NOT NULL,
    Replacement NVARCHAR(400) NOT NULL CONSTRAINT DF_CleanupRule_Repl DEFAULT (N''),
    Flags       VARCHAR(10)   NOT NULL CONSTRAINT DF_CleanupRule_Flags DEFAULT ('c'),
    IsEnabled   BIT           NOT NULL CONSTRAINT DF_CleanupRule_On DEFAULT (1),
    SortOrder   INT           NOT NULL CONSTRAINT DF_CleanupRule_Sort DEFAULT (100)
);
GO

INSERT INTO dbo.CleanupRule (TableName, ColumnName, Pattern, Replacement, Flags, SortOrder)
VALUES (N'RawContact', N'FullName', N'^\s+|\s+$', N'',  'c', 10),
       (N'RawContact', N'FullName', N'\s{2,}',    N' ', 'c', 20),
       (N'RawContact', N'Email',    N'\s',        N'',  'c', 10),
       (N'RawContact', N'Company',  N'\s*,\s*',   N', ', 'c', 10);
GO

CREATE OR ALTER PROCEDURE dbo.usp_ApplyCleanupRules
    @TableName SYSNAME
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @rule INT, @col SYSNAME, @pattern NVARCHAR(400), @repl NVARCHAR(400), @flags VARCHAR(10), @sql NVARCHAR(MAX);

    DECLARE r CURSOR LOCAL FAST_FORWARD FOR
        SELECT RuleId, ColumnName, Pattern, Replacement, Flags
        FROM dbo.CleanupRule
        WHERE TableName = @TableName AND IsEnabled = 1
        ORDER BY SortOrder, RuleId;

    OPEN r;
    FETCH NEXT FROM r INTO @rule, @col, @pattern, @repl, @flags;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Column names cannot be parameters, so check them against the catalog and quote them.
        IF COL_LENGTH(N'dbo.' + QUOTENAME(@TableName), @col) IS NULL
            THROW 53000, N'Rule refers to a column that does not exist.', 1;

        SET @sql = N'UPDATE dbo.' + QUOTENAME(@TableName) + N' SET ' + QUOTENAME(@col)
                 + N' = REGEXP_REPLACE(' + QUOTENAME(@col) + N', @p, @r, 1, 0, @f)'
                 + N' WHERE REGEXP_LIKE(' + QUOTENAME(@col) + N', @p, @f);';
        EXEC sys.sp_executesql @sql, N'@p NVARCHAR(400), @r NVARCHAR(400), @f VARCHAR(10)', @p = @pattern, @r = @repl, @f = @flags;

        FETCH NEXT FROM r INTO @rule, @col, @pattern, @repl, @flags;
    END
    CLOSE r;
    DEALLOCATE r;
END
GO

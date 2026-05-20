USE RegexCleanup;
GO


CREATE TABLE dbo.CleanupLog
(
    LogId      BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_CleanupLog PRIMARY KEY,
    RuleId     INT           NOT NULL,
    TableName  SYSNAME       NOT NULL,
    ColumnName SYSNAME       NOT NULL,
    RowKey     NVARCHAR(100) NOT NULL,
    OldValue   NVARCHAR(MAX) NULL,
    NewValue   NVARCHAR(MAX) NULL,
    ChangedAt  DATETIME2(0)  NOT NULL CONSTRAINT DF_CleanupLog_At DEFAULT (SYSDATETIME())
);
GO

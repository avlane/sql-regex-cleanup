USE master;
GO
IF DB_ID(N'RegexCleanup') IS NOT NULL
BEGIN
    ALTER DATABASE RegexCleanup SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE RegexCleanup;
END
GO
CREATE DATABASE RegexCleanup;
GO
-- The REGEXP_* functions are only available at compatibility level 170 (SQL Server 2025).
ALTER DATABASE RegexCleanup SET COMPATIBILITY_LEVEL = 170;
GO
USE RegexCleanup;
GO

CREATE TABLE dbo.RawContact
(
    ContactId  INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_RawContact PRIMARY KEY,
    FullName   NVARCHAR(100) NULL,
    Email      NVARCHAR(200) NULL,
    Phone      NVARCHAR(40)  NULL,
    Company    NVARCHAR(100) NULL,
    Address    NVARCHAR(300) NULL,
    SignupDate NVARCHAR(30)  NULL,
    Notes      NVARCHAR(400) NULL
);
GO

INSERT INTO dbo.RawContact (FullName, Email, Phone, Company, Address, SignupDate, Notes)
VALUES (N'Alvarez, Rosa',   N'rosa.alvarez@example.com', N'(555) 010-2231',   N'Northwind Traders Inc.', N'12 Elm St, Springfield, IL 62704',     N'2024-03-14', N'prefers email'),
       (N'Kenji   Mori',    N'kenji.mori@example',       N'555.010.9987',     N'Contoso LLC',            N'9 Harbor Rd, Portland, OR 97201-1234', N'03/15/2024', N'also kenji@home.example.org'),
       (N'  Priya Nair  ',  N'PRIYA@EXAMPLE.COM',        N'+1 555 010 7745',  N'contoso, l.l.c.',        N'400 Main Street Apt 5, Austin, TX 78701', N'15 Mar 2024', NULL),
       (N'Tom O''Neil',     N'tom oneil@example.com',    N'5550104412',       N'Fabrikam,Inc',           N'PO Box 77, Denver, CO 80202',          N'2024/03/16', N'bounced'),
       (N'Mei Lin Chen',    N'mei.chen@example.com;mei@work.example.com', N'555-0100',  N'Tailspin Toys',  N'77 Pine Ave, Seattle, WA 98101',   N'2024-03-18', N'call after 5pm'),
       (N'Samuel Brandt',   NULL,                        N'ext. 22',          N'Adventure Works',        NULL,                                    N'18-03-2024', N'phone is an extension only');
GO

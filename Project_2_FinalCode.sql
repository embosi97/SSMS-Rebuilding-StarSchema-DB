--DROP DATABASE BiClass;

USE BIClass;
GO
DROP SCHEMA IF EXISTS DbSecurity;
GO
DROP SCHEMA IF EXISTS PKSequence;
GO
DROP SCHEMA IF EXISTS Process;

GO
CREATE SCHEMA DbSecurity;
GO
CREATE SCHEMA PKSequence;
GO
CREATE SCHEMA Process;



--=========================================================================== SEQUENCE OBJECTS
-- Author:       Danny.Mancheno
-- Procedure:    Project2.CreateSequenceObjects
-- Create date:  4/13/20
-- Description:  Procedure that creates sequence objects, that will be used through out the project.
--===========================================================================
GO
DROP PROC IF EXISTS Project2.CreateSequenceObjects
GO
CREATE PROC Project2.CreateSequenceObjects
AS
BEGIN

DROP SEQUENCE IF EXISTS PKSequence.WorkFlowStepTableRowCount;         -- WorkFlowStepTableRowCount
CREATE SEQUENCE PkSequence.WorkFlowStepTableRowCount
START WITH 1
INCREMENT BY 1


DROP SEQUENCE IF EXISTS PKSequence.DimProductKeyGenerator       -- Product
CREATE SEQUENCE PKSequence.DimProductKeyGenerator
    START WITH 1 INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 2147483648
    CACHE


DROP SEQUENCE IF EXISTS PKSequence.DimProductCategoryKeyGenerator       -- ProductCateogry
CREATE SEQUENCE PKSequence.DimProductCategoryKeyGenerator
    START WITH 1 INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 2147483648
    CACHE
    

DROP SEQUENCE IF EXISTS PKSequence.DimProductSubCategoryKeyGenerator  -- ProductSubCateogry
CREATE SEQUENCE PKSequence.DimProductSubCategoryKeyGenerator
    START WITH 1 INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 2147483648
    CACHE
DROP SEQUENCE IF EXISTS PKSequence.DimCustomerKeyGenerator             -- CustomerKeyGen
CREATE SEQUENCE PKSequence.DimCustomerKeyGenerator
    START WITH 1 INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 2147483648
    CACHE


DROP SEQUENCE IF EXISTS PKSequence.DimOccupationKeyGenerator            -- OccupationKeyGen
CREATE SEQUENCE PKSequence.DimOccupationKeyGenerator
    START WITH 1 INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 2147483648
    CACHE


DROP SEQUENCE IF EXISTS PKSequence.DimTerritoryKeyGenerator             -- TerritoryKeyGen
CREATE SEQUENCE PKSequence.DimTerritoryKeyGenerator
    START WITH 1 INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 2147483648
    CACHE


DROP SEQUENCE IF EXISTS PKSequence.DimSalesManagersKeyGenerator         -- SalesManagerKeyGen
CREATE SEQUENCE PKSequence.DimSalesManagersKeyGenerator
    START WITH 1 INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 2147483648
    CACHE

DROP SEQUENCE IF EXISTS PKSequence.DimDataKeyGenerator                  -- DataSequenceKey
CREATE SEQUENCE PKSequence.DimDataKeyGenerator
    START WITH 1 INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 2147483648
    CACHE

DROP SEQUENCE IF EXISTS PKSequence.DimProductCategoryKeyGenerator       -- ProductCateogry
CREATE SEQUENCE PKSequence.DimProductCategoryKeyGenerator
    START WITH 1 INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 2147483648
    CACHE

-- 1234567890



END;




--=========================================================================== WORK FLOW STEPS TRACKER
-- Author:       Emiljano Bodaj
-- Procedure:    Project2.WorkFlowStepsTracker
-- Create date:  4/13/20
-- Description:  
--===========================================================================

GO
DROP PROC IF EXISTS Project2.WorkFlowStepsTracker
GO
CREATE PROC Project2.WorkFlowStepsTracker 
        @GroupMemberUserAuthorizationKey INT
AS
BEGIN
    DROP TABLE IF EXISTS Process.WorkFlowSteps;

    DECLARE @Index INT
    SET @Index = NEXT VALUE FOR [PkSequence].WorkFlowStepTableRowCount

CREATE TABLE Process.WorkFlowSteps
(
    WorkFlowStepKey              INT NOT NULL, -- primary key
    WorkFlowStepDescription      NVARCHAR(100)       NOT NULL,
    WorkFlowStepTableRowCount    INT                 NULL DEFAULT (0),
    StartingDateTime             DATETIME2(7)        NULL DEFAULT (SYSDATETIME()) ,
    EndingDateTime               DATETIME2(7)        NULL DEFAULT (SYSDATETIME()) ,
    ClassTime                    CHAR(5)             NULL DEFAULT ('09:15'),
    UserAuthorizationKey         INT                 NOT NULL
)

INSERT INTO Process.WorkFlowSteps 
        (WorkFlowStepKey, WorkFlowStepTableRowCount, WorkFlowStepDescription, UserAuthorizationKey)
VALUES
        (@Index, @Index, 'WorkFlowSteps table created', @GroupMemberUserAuthorizationKey ) 
END
GO




--=========================================================================== TRACK WORK FLOW ENGINE
-- Author:       Emiljano Bodaj
-- Procedure:    Process.uso_TrackWorkFlow;
-- Create date:  4/13/20
-- Description:  --
--===========================================================================

USE BIClass
GO
--Emiljano Bodaj
--Sequence that’ll count the rows for the workflowsteps portion of the project


-------------------------------------------------------------------------------------------------------------------------------

--procedure made to track progress of the project
--it loads information to workflowsteps

DROP PROC IF EXISTS Process.usp_TrackWorkFlow;             
 
GO
CREATE PROC Process.usp_TrackWorkFlow    ----------- USP_TRACKWORKFLOW
   @WorkFlowStepKey                        INT,
   @GroupMemberUserAuthorizationKey        INT,
   @WorkFlowStepDescription                NVARCHAR(100),
   @StartingDateTime                       DATETIME2   
AS
BEGIN
 
   SET NOCOUNT ON;

   SET @StartingDateTime = SYSDATETIME();
  
   INSERT INTO Process.WorkFlowSteps (WorkFlowStepKey, UserAuthorizationKey, WorkFlowStepDescription, StartingDateTime)
   VALUES(@WorkFlowStepKey, @GroupMemberUserAuthorizationKey, @WorkFlowStepDescription, @StartingDateTime)

END





--=========================================================================== CREATE DBSECURITY TABLE
-- Author:       Danny.Mancheno
-- Procedure:    Project2.CreateDbSecurityTable
-- Create date:  4/13/20
-- Description:  A procedure to create the group auth table. 
--===========================================================================
GO
USE BIClass;
GO
DROP PROC IF EXISTS Project2.CreateDBSecurityTable;
GO
CREATE PROC Project2.CreateDBSecurityTable 
    @UserAuthorization              INT
AS
BEGIN
    DROP TABLE IF EXISTS DbSecurity.UserAuthorization;
    CREATE TABLE DbSecurity.UserAuthorization
    (

    UserAuthorization               INT                     NOT NULL
    CONSTRAINT  [PK_UserAuthorization]      PRIMARY KEY (UserAuthorization),
    ClassTime                       NCHAR(10)               NULL DEFAULT('9:15'),
    IndividualProject               NVARCHAR(60)            NULL DEFAULT('PROJECT 2 RECREATE THE BICLASS STAR SCHEMA'),
    GroupMemberLastName             NVARCHAR(135)           NOT NULL,
    GroupMemberFirstname            NVARCHAR(125)           NOT NULL,
    GroupName                       NVARCHAR(20)            NOT NULL DEFAULT('G9-3_C915'),
    DateAdded                       DATETIME2               NULL DEFAULT SYSDATETIME() 
    )

        INSERT INTO DbSecurity.UserAuthorization
    (   UserAuthorization,      GroupMemberLastName,        GroupMemberFirstname    )
    VALUES
    (   1,                      'Bodaj',                    'Emiljano'              ),
    (   2,                      'Mancheno',                 'Danny'                 ),
    (   3,                      'Chen',                     'Lin'                  ),
    (   4,                      'Brandwein',                'Jason'                 ),
    (   5,                      'Chen',                     'Juhao'                 ),
    (   6,                      'Ahmed',                    'Nabila'                );


    DECLARE @Index INT, @StartingDateTime DateTime2
        SET @Index = NEXT VALUE FOR [PkSequence].WorkFlowStepTableRowCount
        SET @StartingDateTime = Sysdatetime()
    EXEC [Process].[usp_TrackWorkFlow] @WorkFlowStepKey = @Index, 
                                    @GroupMemberUserAuthorizationKey = 2,
                                    @WorkFlowStepDescription = 'Created the DbSecurity.UserAuth Table',
                                    @StartingDateTime = @StartingDateTime

    --SELECT * FROM DbSecurity.UserAuthorization;

END
GO


--=========================================================================== ALTER ALL TABLES
-- Author:       Danny.Mancheno
-- Procedure:    AlterTables
-- Create date:  4/13/20
-- Description:  Alters all tables, and includes name default constraints to prevent future errors. 
--===========================================================================
GO
DROP PROC IF EXISTS Project2.AlterTables
GO
CREATE PROC Project2.AlterTables
        @UserAuthorization      INT
AS
BEGIN
    
ALTER TABLE [CH01-01-Dimension].[DimCustomer]                       -- 1
ADD     UserAuthorizationKey       INT                     NOT NULL
        CONSTRAINT                 DF_Cus_UAKDefault       DEFAULT(000),
        DateAdded                  DATETIME2(7)            NULL
        CONSTRAINT                 DF_Cus_DADefault        Default(SYSDATETIME()),
        DateOfLastUpdate           DATETIME2(7)            NULL
        CONSTRAINT                 DF_Cus_DOLUDefault      Default(SYSDATETIME());

ALTER TABLE [CH01-01-Dimension].[DimGender]                         -- 2
ADD     UserAuthorizationKey       INT                     NOT NULL
        CONSTRAINT                 DF_Gen_UAKDefault       DEFAULT(000),
        DateAdded                  DATETIME2(7)            NULL
        CONSTRAINT                 DF_Gen_DADefault        Default(SYSDATETIME()),
        DateOfLastUpdate           DATETIME2(7)            NULL
        CONSTRAINT                 DF_Gen_DOLUDefault      Default(SYSDATETIME());

ALTER TABLE [CH01-01-Dimension].[DimMaritalStatus]                  -- 3
ADD     UserAuthorizationKey       INT                     NOT NULL
        CONSTRAINT                 DF_Mar_UAKDefault       DEFAULT(000),
        DateAdded                  DATETIME2(7)            NULL
        CONSTRAINT                 DF_Mar_DADefault        Default(SYSDATETIME()),
        DateOfLastUpdate           DATETIME2(7)            NULL
        CONSTRAINT                 DF_Mar_DOLUDefault      Default(SYSDATETIME());

ALTER TABLE [CH01-01-Dimension].[DimOccupation]                     -- 4
ADD     UserAuthorizationKey       INT                     NOT NULL
        CONSTRAINT                 DF_Occ_UAKDefault       DEFAULT(000),
        DateAdded                  DATETIME2(7)            NULL
        CONSTRAINT                 DF_Occ_DADefault        Default(SYSDATETIME()),
        DateOfLastUpdate           DATETIME2(7)            NULL
        CONSTRAINT                 DF_Occ_DOLUDefault      Default(SYSDATETIME());

ALTER TABLE [CH01-01-Dimension].[DimOrderDate]                      -- 5
ADD     UserAuthorizationKey       INT                     NOT NULL
        CONSTRAINT                 DF_Ord_UAKDefault       DEFAULT(000),
        DateAdded                  DATETIME2(7)            NULL
        CONSTRAINT                 DF_Ord_DADefault        Default(SYSDATETIME()),
        DateOfLastUpdate           DATETIME2(7)            NULL
        CONSTRAINT                 DF_Ord_DOLUDefault      Default(SYSDATETIME());

ALTER TABLE [CH01-01-Dimension].[DimProduct]                        -- 6
ADD     UserAuthorizationKey       INT                     NOT NULL
        CONSTRAINT                 DF_Pro_UAKDefault       DEFAULT(000),
        DateAdded                  DATETIME2(7)            NULL
        CONSTRAINT                 DF_Pro_DADefault        Default(SYSDATETIME()),
        DateOfLastUpdate           DATETIME2(7)            NULL
        CONSTRAINT                 DF_Pro_DOLUDefault      Default(SYSDATETIME());

ALTER TABLE [CH01-01-Dimension].[DimTerritory]                      -- 7
ADD     UserAuthorizationKey       INT                     NOT NULL
        CONSTRAINT                 DF_Ter_UAKDefault       DEFAULT(000),
        DateAdded                  DATETIME2(7)            NULL
        CONSTRAINT                 DF_Ter_DADefault        Default(SYSDATETIME()),
        DateOfLastUpdate           DATETIME2(7)            NULL
        CONSTRAINT                 DF_Ter_DOLUDefault      Default(SYSDATETIME());

ALTER TABLE [CH01-01-Dimension].[SalesManagers]                     -- 8
ADD     UserAuthorizationKey       INT                     NOT NULL
        CONSTRAINT                 DF_Sal_UAKDefault       DEFAULT(000),
        DateAdded                  DATETIME2(7)            NULL
        CONSTRAINT                 DF_Sal_DADefault        Default(SYSDATETIME()),
        DateOfLastUpdate           DATETIME2(7)            NULL
        CONSTRAINT                 DF_Sal_DOLUDefault      Default(SYSDATETIME());     

ALTER TABLE [CH01-01-Fact].[Data]                                   -- 9
ADD     UserAuthorizationKey       INT                     NOT NULL
        CONSTRAINT                 DF_Dat_UAKDefault       DEFAULT(000),
        DateAdded                  DATETIME2(7)            NULL
        CONSTRAINT                 DF_Dat_DADefault        Default(SYSDATETIME()),
        DateOfLastUpdate           DATETIME2(7)            NULL
        CONSTRAINT                 DF_Dat_DOLUDefault      Default(SYSDATETIME());

        DECLARE @Index INT, @StartingDateTime DateTime2
        SET @Index = NEXT VALUE FOR [PkSequence].WorkFlowStepTableRowCount
        SET @StartingDateTime = Sysdatetime()
    EXEC [Process].[usp_TrackWorkFlow] @WorkFlowStepKey = @Index, 
                                    @GroupMemberUserAuthorizationKey = 2,
                                    @WorkFlowStepDescription = 'Altered and added all table columns',
                                    @StartingDateTime = @StartingDateTime
END
GO


--=========================================================================== DROP_FOREIGN_KEYS
-- Author:       Danny Mancheno
-- Procedure:    Project2.DropForeignKeysFromStarSchemaData;
-- Create date:  4/13/20
-- Description:  Drop all foreign keys from the CH01-01-Fact.Data Table.
--===========================================================================
GO
DROP PROC IF EXISTS Project2.DropForeignKeysFromStarSchemaData;
GO
CREATE PROC Project2.DropForeignKeysFromStarSchemaData
    @UserAuthorization              INT
AS
BEGIN
    DECLARE @StartingTime DATETIME2(7) = SYSDATETIME();

    SET NOCOUNT ON;

    ALTER TABLE [CH01-01-FACT].[DATA]
    DROP CONSTRAINT FK_Data_DimCustomer, FK_Data_DimGender, FK_Data_DimMaritalStatus, FK_Data_DimOccupation,
                    FK_Data_DimOrderDate, FK_Data_DimProduct, FK_Data_DimTerritory, FK_Data_SalesManagers;

    DECLARE @Index INT, @StartingDateTime DateTime2
    SET @Index = NEXT VALUE FOR [PkSequence].WorkFlowStepTableRowCount
    SET @StartingDateTime = Sysdatetime()

    EXEC [Process].[usp_TrackWorkFlow] @WorkFlowStepKey = @Index, 
                                       @GroupMemberUserAuthorizationKey = 2, 
                                       @WorkFlowStepDescription = 'Dropping all foreign keys',  
                                       @StartingDateTime = @StartingDateTime;
END
GO




--EXEC Project2.WorkFlowStepsTracker @GroupMemberUserAuthorizationKey = 1

--=========================================================================== COUNTING THE TABLE ROWS
-- Author:       Emiljano Bodaj
-- Procedure:    Project2.CheckRowTables
-- Create date:  4/13/20
-- Description:  This will truncate all the table data
--===========================================================================
USE BIClass
GO

--Emiljano Bodaj
--Created a procedure that'll produce a table that'll check the number of rows in each of the tables
--We will use this to make sure if we were successful in loading/repopulating the tables
DROP PROC IF EXISTS Project2.CheckTableRows
GO

CREATE PROC Project2.CheckTableRows @UserAuthorizationKey INT
AS 
BEGIN

DROP TABLE IF EXISTS Project2.CreateRowCount

CREATE TABLE Project2.CreateRowCount
(
   TableDescription  NVARCHAR(60) NOT NULL,
   TableRowCount INT NOT NULL
 )

 DECLARE @DimCust INT, 
 @DimGender INT,
 @DimMaritalStatus INT,
 @DimOccupation INT, 
 @DimOrderDate INT, 
 @DimProduct INT,
 @DimTerritory INT,
 @DimSalesManagers INT,
 @FactData INT

 SET @DimCust = (SELECT COUNT(*) FROM [CH01-01-Dimension].[DimCustomer])
 SET @DimGender = (SELECT COUNT(*) FROM [CH01-01-Dimension].[DimGender])
 SET @DimMaritalStatus = (SELECT COUNT(*) FROM [CH01-01-Dimension].[DimMaritalStatus])
 SET @DimOccupation = (SELECT COUNT(*) FROM [CH01-01-Dimension].[DimOccupation])
 SET @DimOrderDate = (SELECT COUNT(*) FROM [CH01-01-Dimension].[DimOrderDate])
 SET @DimProduct = (SELECT COUNT(*) FROM [CH01-01-Dimension].[DimProduct])
 SET @DimTerritory = (SELECT COUNT(*) FROM [CH01-01-Dimension].[DimTerritory])
 SET @DimSalesManagers = (SELECT COUNT(*) FROM [CH01-01-Dimension].[SalesManagers])
 SET @FactData = (SELECT COUNT(*) FROM [CH01-01-Fact].[Data])
 
 INSERT INTO Project2.CreateRowCount (TableDescription, TableRowCount)
 VALUES ('DimCustomer Table', @DimCust), ('DimGender Table', @DimGender), ('DimMaritalStatus Table', @DimMaritalStatus), ('DimOccupation Table', @DimOccupation), 
 ('DimOrderDate Table', @DimOrderDate), ('DimProduct Table', @DimProduct), ('DimTerritory Table', @DimTerritory), ('DimSalesManager Table', @DimSalesManagers), ('FactData Table', @FactData)
 
 SELECT *
 FROM Project2.CreateRowCount

 DECLARE @Index INT, @StartingDateTime DateTime2
    SET @Index = NEXT VALUE FOR [PkSequence].WorkFlowStepTableRowCount
    SET @StartingDateTime = Sysdatetime()

EXEC [Process].[usp_TrackWorkFlow] @WorkFlowStepKey = @Index, 
                                   @GroupMemberUserAuthorizationKey = 1, 
                                   @WorkFlowStepDescription = 'RowCount Table Checked!',  
                                   @StartingDateTime = @StartingDateTime;

 END
 GO

 --EXEC  Project2.CheckTableRows @UserAuthorizationKey = 1


--=========================================================================== TRUNCATE ALL TABLES
-- Author:       Danny.Mancheno
-- Procedure:    Project2.TruncateTables
-- Create date:  4/13/20
-- Description:  This will truncate all the table data
--===========================================================================
GO
DROP PROC IF EXISTS Project2.TruncateStarSchemaData
GO
CREATE PROC Project2.TruncateStarSchemaData
    @UserAuthorization              INT
AS
BEGIN
    TRUNCATE TABLE [CH01-01-Dimension].[DimCustomer]
    TRUNCATE TABLE [CH01-01-Dimension].[DimGender]
    TRUNCATE TABLE [CH01-01-Dimension].[DimMaritalStatus]    
    TRUNCATE TABLE [CH01-01-Dimension].[DimOccupation]
    TRUNCATE TABLE [CH01-01-Dimension].[DimOrderDate] 
    TRUNCATE TABLE [CH01-01-Dimension].[DimProduct]
    TRUNCATE TABLE [CH01-01-Dimension].[DimTerritory]    
    TRUNCATE TABLE [CH01-01-Dimension].[SalesManagers]
    TRUNCATE TABLE [CH01-01-Fact].[Data]

DECLARE @Index INT, @StartingDateTime DateTime2
    SET @Index = NEXT VALUE FOR [PkSequence].WorkFlowStepTableRowCount
    SET @StartingDateTime = Sysdatetime()

EXEC [Process].[usp_TrackWorkFlow] @WorkFlowStepKey = @Index, 
                                   @GroupMemberUserAuthorizationKey = 2, 
                                   @WorkFlowStepDescription = 'Truncate all Star Schema tables',  
                                   @StartingDateTime = @StartingDateTime;

END
GO

--##################################################################################################################################
--#############-------------------------------------------------------------------------------------------------------##############
--#############-------------------------------------------------------------------------------------------------------##############

    GO
    EXEC Project2.CreateSequenceObjects; -- 2;
    GO
    EXEC Project2.WorkFlowStepsTracker @GroupMemberUserAuthorizationKey = 1;
    GO
    EXEC Project2.CreateDBSecurityTable @UserAuthorization = 2;
    GO
    EXEC Project2.AlterTables @UserAuthorization = 2;
    GO
    EXEC Project2.DropForeignKeysFromStarSchemaData @UserAuthorization = 2;
    GO
    EXEC  Project2.CheckTableRows @UserAuthorizationKey = 1
    GO
    EXEC Project2.TruncateStarSchemaData @UserAuthorization = 2;

--#############-------------------------------------------------------------------------------------------------------##############
--#############-------------------------------------------------------------------------------------------------------##############
--#############-------------------------------------------------------------------------------------------------------##############
--##################################################################################################################################


--=========================================================================== CUSTOMERS
-- Author:       Emiljano Bodaj
-- Procedure:    Project2.Load_DimCustomer
-- Create date:  4/13/20
-- Description:  Load the columns from FileUpload.OriginallyLoadedData into the recently truncated DimCustomer table to repopulate it
--===========================================================================

DROP PROC IF EXISTS Project2.Load_DimCustomer
GO
CREATE PROC Project2.Load_DimCustomer @UserAuthorizationKey INT
AS 
BEGIN

SET IDENTITY_INSERT [CH01-01-Dimension].[DimCustomer] ON

INSERT INTO [CH01-01-Dimension].[DimCustomer] ([CustomerKey], [CustomerName], [UserAuthorizationKey], [DateAdded], [DateOfLastUpdate])

SELECT NEXT VALUE FOR [PKSequence].[DimCustomerKeyGenerator] AS CustomerKey, Fi.CustomerName, @UserAuthorizationKey, sysdatetime() as DateAdded, sysdatetime() as DateOfLastUpdate
FROM (SELECT DISTINCT CustomerName FROM [FileUpload].[OriginallyLoadedData]) AS Fi

DECLARE @Index INT, @StartingDateTime DateTime2
    SET @Index = NEXT VALUE FOR [PkSequence].WorkFlowStepTableRowCount
    SET @StartingDateTime = Sysdatetime()

EXEC [Process].[usp_TrackWorkFlow] @WorkFlowStepKey = @Index, 
                                   @GroupMemberUserAuthorizationKey = 1, 
                                   @WorkFlowStepDescription = 'DimCustomer Table loaded',  
                                   @StartingDateTime = @StartingDateTime;

END
GO

--EXEC Project2.Load_DimCustomer @UserAuthorizationKey = 1
--SET IDENTITY_INSERT [CH01-01-Dimension].[DimCustomer] OFF

--=========================================================================== GENDER
-- Author:       Danny Mancheno
-- Procedure:    Project.Load_DimGender
-- Create date:  4/13/20
-- Description:  Load DimMaritalStatus table
--===========================================================================

--SELECT GENDER FROM FileUpload.OriginallyLoadedData;
--SELECT * FROM [CH01-01-Dimension].[DimGender];

DROP PROC IF EXISTS [Project2].[Load_DimGender]
GO
CREATE PROC [Project2].[Load_DimGender]
    @UserAuthorizationKey       INT
AS
BEGIN
ALTER TABLE [CH01-01-Dimension].[DimGender] ALTER COLUMN GenderDescription VARCHAR(10);
    

-- starts here
    DECLARE @StartingTime AS DATETIME2(7) = SYSDATETIME()
    SET NOCOUNT ON;

    INSERT INTO [CH01-01-Dimension].[DimGender]
        (  Gender,   GenderDescription, UserAuthorizationKey  )
    SELECT DISTINCT Gender, 
                    CASE WHEN Gender = 'M' THEN 'Masciline' ELSE 'Feminine' END AS GenderDescription,
                    @UserAuthorizationKey
    FROM FileUpload.OriginallyLoadedData;

-- ends here.

DECLARE @Index INT, @StartingDateTime DateTime2
    SET @Index = NEXT VALUE FOR [PkSequence].WorkFlowStepTableRowCount
    SET @StartingDateTime = Sysdatetime()
EXEC [Process].[usp_TrackWorkFlow] @WorkFlowStepKey = @Index, 
                                   @GroupMemberUserAuthorizationKey = 2, 
                                   @WorkFlowStepDescription = 'Loaded Gender Table',  
                                   @StartingDateTime = @StartingDateTime
END;

--=========================================================================== MARITALSTATUS
-- Author:       Lin Chen
-- Procedure:    Project.Load_DimMaritalStatus
-- Create date:  4/13/20
-- Description:  Load DimMaritalStatus table
--===========================================================================
GO
DROP PROC IF EXISTS [Project2].[Load_DimMaritalStatus]
GO
CREATE PROC [Project2].[Load_DimMaritalStatus] @userAuthorizationKey INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @StartingTime AS DATETIME2(7) = SYSDATETIME()

	INSERT INTO [CH01-01-Dimension].[DimMaritalStatus] (
		MaritalStatus
		,MaritalStatusDescription
		,UserAuthorizationKey
		)
	SELECT DISTINCT MaritalStatus
		,CASE MaritalStatus
			WHEN 'S'
				THEN 'Single'
			ELSE 'Married'
			END AS MaritalStatusDescription
		,@UserAuthorizationKey
	FROM FileUpload.OriginallyLoadedData

	DECLARE @Index INT
		,@StartingDateTime DATETIME2

	SET @Index = NEXT VALUE
	FOR [PkSequence].WorkFlowStepTableRowCount
	SET @StartingDateTime = Sysdatetime()

	EXEC Process.usp_TrackWorkFlow @WorkFlowStepKey = @Index
		,@GroupMemberUserAuthorizationKey = @userAuthorizationKey
		,@WorkFlowStepDescription = 'Load DimMaritalStatus table'
		,@StartingDateTime = @StartingDateTime
END;

--GET THIS TO RUN
--EXEC Project2.Load_DimMaritalStatus @UserAuthorizationKey = 3;
--GO
--=========================================================================== OCCUPATION
-- Author:       Nabila Ahmed
-- Procedure:    CH01-01-Dimension.DimOccupation
-- Create date:  4/13/20
-- Description:  Loaded data into the DimOccupation data from the FileUpload.OriginallyLoadedData table
--===========================================================================
GO
DROP PROC IF EXISTS [Project2].[Load_DimOccupation]
GO
CREATE PROC [Project2].[Load_DimOccupation] 
    @UserAuthorizationKey       INT
AS
BEGIN
    DECLARE @StartingTime AS DATETIME2(7) = SYSDATETIME()
    SET NOCOUNT ON;

 INSERT INTO [CH01-01-Dimension].[DimOccupation] 
    (OccupationKey, Occupation, UserAuthorizationKey)
    SELECT
        NEXT VALUE FOR PKSequence.[DimOccupationKeyGenerator],
        O.Occupation,
        @UserAuthorizationKey
    FROM (SELECT DISTINCT Occupation FROM FileUpload.OriginallyLoadedData) AS O

DECLARE @Index INT, @StartingDateTime DateTime2
    SET @Index = NEXT VALUE FOR [PkSequence].WorkFlowStepTableRowCount
    SET @StartingDateTime = Sysdatetime()
EXEC [Process].[usp_TrackWorkFlow] @WorkFlowStepKey = @Index, 
                                   @GroupMemberUserAuthorizationKey = 6, 
                                   @WorkFlowStepDescription = 'Loaded data into the DimOccupation Table',
                                   @StartingDateTime = @StartingDateTime
END;

--=========================================================================== ORDERDATE
-- Author:       Nabila Ahmed 
-- Procedure:    CH01-01-Dimension.DimOrderDate
-- Create date:  4/12/20
-- Description:  Loads the DimOrderDate data from the FileUpload.OriginallyLoadedData 
--===========================================================================
GO
DROP PROC IF EXISTS [Project2].[Load_DimOrderDate] 
GO

CREATE PROC [Project2].[Load_DimOrderDate] @UserAuthorizationKey INT
AS
BEGIN
	DECLARE @StartingTime AS DATETIME2(7) = SYSDATETIME()

	SET NOCOUNT ON;

	INSERT INTO [CH01-01-Dimension].[DimOrderDate] (
		OrderDate
		,MonthName
		,MonthNumber
		,[Year]
		,UserAuthorizationKey
		)
	SELECT DISTINCT OrderDate
		,MonthName
		,MonthNumber
		,[Year]
		,@UserAuthorizationKey
	FROM [FileUpload].OriginallyLoadedData

	DECLARE @Index INT
		,@StartingDateTime DATETIME2

	SET @Index = NEXT VALUE
	FOR [PkSequence].WorkFlowStepTableRowCount
	SET @StartingDateTime = Sysdatetime()

	EXEC [Process].[usp_TrackWorkFlow] @WorkFlowStepKey = @Index
		,@GroupMemberUserAuthorizationKey = 6
		,@WorkFlowStepDescription = 'Loaded the DimOrderDate Table'
		,@StartingDateTime = @StartingDateTime
END;

--=========================================================================== GRANDPARENT/PARENT/CHILD
-- Author:       Lin Chen 
-- Procedure:    [Project2].[Load_ProductCategory_ProductSubCategory]
-- Create date:  4/13/20
-- Description:  Create DimProductSubCategory and DimProductCategory tables, load data into DimProduct table.
--===========================================================================
--GRANDPARENT
--DROP TABLE IF EXISTS [CH01-01-Dimension].[DimProductSubCategory]
--GO
GO
DROP PROC IF EXISTS [Project2].[Load_Product_ProductCategory_ProductSubCategory] 
GO
CREATE PROC [Project2].[Load_Product_ProductCategory_ProductSubCategory] @UserAuthorizationKey INT
AS
BEGIN
    CREATE TABLE [CH01-01-Dimension].[DimProductSubCategory]
    (
        ProductSubCategoryKey          INT                     NOT NULL
            CONSTRAINT [PK_ProductSubCategoryKey]  PRIMARY KEY (ProductSubCategoryKey),
        ProductSubCategory             VARCHAR(20)             NULL
    );

    -- INSERT INTO DimProductSubCategory Table
    INSERT INTO [CH01-01-Dimension].[DimProductSubCategory]
    (   ProductSubCategoryKey,  ProductSubCategory     )
    SELECT 
        NEXT VALUE FOR PKSequence.DimProductSubCategoryKeyGenerator, 
        OLDVAL.ProductSubCategory
    FROM
    (
        SELECT DISTINCT ProductSubCategory
        FROM FileUpload.OriginallyLoadedData
    ) AS OLDVAL


-- TEST DimProductSubCategory Table
--SELECT * FROM [CH01-01-Dimension].DimProductSubCategory

--PARENT
--DROP TABLE IF EXISTS [CH01-01-Dimension].[DimProductCategory]
--GO
    CREATE TABLE [CH01-01-Dimension].[DimProductCategory]
    (
        ProductCategoryKey          INT                     NOT NULL
            CONSTRAINT [PK_ProductCategoryKey]  PRIMARY KEY (ProductCategoryKey),
        ProductSubCategoryKey       INT                     NOT NULL,
        ProductCategory             VARCHAR(20)             NULL,
        FOREIGN KEY (ProductSubCategoryKey) REFERENCES [CH01-01-Dimension].[DimProductSubCategory](ProductSubCategoryKey)
    ); 

    -- INSERT INTO DimProductCategory Table
    INSERT INTO [CH01-01-Dimension].[DimProductCategory]
    (   ProductCategoryKey,  ProductSubCategoryKey, ProductCategory    )
    SELECT 
        NEXT VALUE FOR PKSequence.DimProductCategoryKeyGenerator, NEWVAL.ProductSubCategoryKey, NEWVAL.ProductCategory
    FROM
    (
        SELECT DISTINCT OLDVAL.ProductCategory, OLDVAL.ProductSubCategory, D.ProductSubCategoryKey 

        FROM FileUpload.OriginallyLoadedData AS OLDVAL
            INNER JOIN [CH01-01-Dimension].[DimProductSubCategory] AS D
            ON OLDVAL.ProductSubCategory = D.ProductSubCategory
    ) AS NEWVAL
-- TEST DimProductCategory Table
--SELECT * FROM [CH01-01-Dimension].DimProductCategory

--CHILD
    --truncate table [CH01-01-Dimension].[DimProduct]
    SET IDENTITY_INSERT [CH01-01-Dimension].[DimProduct] ON
    INSERT INTO [CH01-01-Dimension].[DimProduct]
        (ProductKey, ProductSubcategoryKey, ProductSubcategory, ProductCategory, ProductCode, ProductName, Color, ModelName)
    SELECT
        NEXT VALUE FOR PKSequence.DimProductKeyGenerator,
        NEWVAL.ProductSubcategoryKey,
        NEWVAL.ProductSubcategory,
        NEWVAL.Productcategory,
        NEWVAL.ProductCode,
        NEWVAL.ProductName,
        NEWVAL.Color,
        NEWVAL.ModelName
    FROM
        (SELECT
            DISTINCT
            D.ProductSubcategoryKey,
            OLDVAL.ProductSubcategory,
            OLDVAL.Productcategory,
            ProductCode,
            ProductName,
            Color,
            ModelName
        FROM FileUpload.OriginallyLoadedData AS OLDVAL
            INNER JOIN [CH01-01-Dimension].[DimProductCategory] AS D
            ON OLDVAL.ProductCategory = D.ProductCategory
            INNER JOIN [CH01-01-Dimension].[DimProductSubCategory] AS DPS
            ON D.ProductSubCategoryKey = DPS.ProductSubCategoryKey
        ) AS NEWVAL
    SET IDENTITY_INSERT [CH01-01-Dimension].[DimProduct] OFF
--SELECT * FROM [CH01-01-Dimension].DimProduct

    DECLARE @Index INT, @StartingDateTime DateTime2
        SET @Index = NEXT VALUE FOR [PkSequence].WorkFlowStepTableRowCount
        SET @StartingDateTime = Sysdatetime()
    EXEC [Process].[usp_TrackWorkFlow] @WorkFlowStepKey = @Index, 
                                    @GroupMemberUserAuthorizationKey = 3, 
                                    @WorkFlowStepDescription = 'Create Load_Product_ProductCategory_ProductSubCategory procedure',
                                    @StartingDateTime = @StartingDateTime


END
GO

--=========================================================================== TERRITORY
-- Author:       Lin Chen
-- Procedure:    Project2.DimTerritory
-- Create date:  4/13/20
-- Description:  Load DimTerritory table
--===========================================================================
GO
DROP PROC IF EXISTS [Project2].[Load_DimTerritory]
GO
CREATE PROC [Project2].[Load_DimTerritory] @userAuthorizationKey INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @StartingTime AS DATETIME2(7) = SYSDATETIME()

	INSERT INTO [CH01-01-Dimension].[DimTerritory] (
		TerritoryGroup
		,TerritoryCountry
		,TerritoryRegion
		,UserAuthorizationKey
		)
	SELECT DISTINCT TerritoryGroup
		,TerritoryCountry
		,TerritoryRegion
		,@UserAuthorizationKey
	FROM FileUpload.OriginallyLoadedData

	DECLARE @Index INT
		,@StartingDateTime DATETIME2

	SET @Index = NEXT VALUE
	FOR [PkSequence].WorkFlowStepTableRowCount
	SET @StartingDateTime = Sysdatetime()

	EXEC Process.usp_TrackWorkFlow @WorkFlowStepKey = @Index
		,@GroupMemberUserAuthorizationKey = @userAuthorizationKey
		,@WorkFlowStepDescription = 'Load DimTerritory table'
		,@StartingDateTime = @StartingDateTime
END;

--GET THIS TO RUN
--EXEC Project2.Load_DimTerritory @UserAuthorizationKey = 3;
--GO

--SELECT * FROM [CH01-01-Dimension].[DimTerritory];


--=========================================================================== SALESMANAGERS
-- Author:       Nabila Ahmed
-- Procedure:    CH01-01-Dimension.SalesManagers
-- Create date:  4/12/20
-- Description:  Loaded SalesManagers table data from the FileUpload.OriginallyLoadedData table
--===========================================================================
GO
DROP PROC IF EXISTS [Project2].[Load_SalesManagers];
GO
CREATE PROC [Project2].[Load_SalesManagers] @UserAuthorizationKey INT
AS
BEGIN
	DECLARE @StartingTime AS DATETIME2(7) = SYSDATETIME()

	SET NOCOUNT ON;

	INSERT INTO [CH01-01-Dimension].[SalesManagers] (
		SalesManagerKey
		,Category
		,SalesManager
		,Office
		,UserAuthorizationKey
		)
	SELECT NEXT VALUE
	FOR [PKSequence].[DimSalesManagersKeyGenerator] AS SalesManagerKey
		,ProductCategory AS Category
		,SalesManager
		,CASE 
			WHEN SalesManager LIKE N'Maurizio%'
				OR SalesManager LIKE N'Marco%'
				THEN 'Redmond'
			WHEN SalesManager LIKE N'Alberto%'
				OR SalesManager LIKE N'Luis%'
				THEN 'Seattle'
			END AS Office
		,@UserAuthorizationKey
	FROM (
		SELECT DISTINCT ProductCategory
			,SalesManager
		FROM FileUpload.OriginallyLoadedData
		) AS O;

	DECLARE @Index INT
		,@StartingDateTime DATETIME2

	SET @Index = NEXT VALUE
	FOR [PkSequence].WorkFlowStepTableRowCount
	SET @StartingDateTime = Sysdatetime()

	EXEC [Process].[usp_TrackWorkFlow] @WorkFlowStepKey = @Index
		,@GroupMemberUserAuthorizationKey = 6
		,@WorkFlowStepDescription = 'Loaded SalesManagers table'
		,@StartingDateTime = @StartingDateTime
END;

--=========================================================================== LOAD FACT DATA
-- Author:       Juhao Chen
-- Procedure:    [Project2].[LoadData]
-- Create date:  4/13/20
-- Description:  <Description>
--===========================================================================
------------------------------------------------------------------------------------------------
---**Commented Out For Debugging Purposes**-----------------------------------------------------
------------------------------------------------------------------------------------------------
/*
DROP PROCEDURE

IF EXISTS [Project2].[LoadData] 
GO
	CREATE PROCEDURE [Project2].[LoadData] @UserAuthorizationKey INT
	AS
	BEGIN
		SET NOCOUNT ON;

		DECLARE @StartingTime DATETIME2(7)

		SET @StartingTime = SYSDATETIME();

		CREATE SEQUENCE [Project2].[DataSequenceKey] START
			WITH 1 INCREMENT BY 1

		INSERT INTO [CH01-01-Fact].[Data] (
			SalesKey
			,SalesManagerKey
			,OccupationKey
			,TerritoryKey
			,ProductKey
			,CustomerKey
			,ProductCategory
			,SalesManager
			,ProductSubcategory
			,ProductCode
			,ProductName
			,Color
			,ModelName
			,OrderQuantity
			,UnitPrice
			,ProductStandardCost
			,SalesAmount
			,OrderDate
			,MonthName
			,[Year]
			,CustomerName
			,MaritalStatus
			,Gender
			,Education
			,Occupation
			,TerritoryRegion
			,TerritoryCountry
			,TerritoryGroup
			)
		SELECT NEXT VALUE
		FOR [Project2].[DataSequenceKey]
			,old.SalesManagerKey
			,old.OccupationKey
			,DT.TerritoryKey
			,DP.ProductKey
			,DC.CustomerKey
			,old.ProductCategory
			,old.SalesManager
			,old.ProductSubcategory
			,old.ProductCode
			,old.ProductName
			,old.Color
			,old.ModelName
			,old.OrderQuantity
			,old.UnitPrice
			,old.ProductStandardCost
			,old.SalesAmount
			,old.OrderDate
			,old.MonthName
			,[Year]
			,old.CustomerName
			,old.MaritalStatus
			,old.Gender
			,old.Education
			,old.Occupation
			,old.TerritoryRegion
			,old.TerritoryCountry
			,old.TerritoryGroup
		FROM FileUpload.OriginallyLoadedData AS old
		INNER JOIN [CH01-01-Dimension].[SalesManagers] AS SM ON SM.SalesManagerKey = old.SalesManagerKey
		INNER JOIN [CH01-01-Dimension].[DimOccupation] AS DO ON DO.OccupationKey = old.OccupationKey
		INNER JOIN [CH01-01-Dimension].[DimTerritory] AS DT ON DT.TerritoryGroup = old.TerritoryGroup
			AND DT.TerritoryCountry = old.TerritoryCountry
			AND DT.TerritoryRegion = old.TerritoryRegion
		INNER JOIN [CH01-01-Dimension].[DimProduct] AS DP ON DP.ProductName = old.ProductName
		INNER JOIN [CH01-01-Dimension].[DimCustomer] AS DC ON DC.CustomerName = old.CustomerName

		EXEC Process.usp_TrackWorkFlow @WorkFlowStepDescription = 'Loaded the Fact.Data table with data'
			,@GroupMemberUserAuthorizationKey = @UserAuthorizationKey
			,@StartingDateTime = @StartingTime;
	END 
    GO
*/
--=========================================================================== LOAD STAR SCHEMA DATA
-- Author:       Danny.Mancheno
-- Procedure:    Project2.LoadStarSchemaData
-- Create date:  4/13/20
-- Description:  <Description>
--===========================================================================

/*
    EXEC Project2.CreateSequenceObjects; -- 2;
    EXEC Project2.WorkFlowStepsTracker @GroupMemberUserAuthorizationKey = 1;
    
    EXEC Project2.CreateDBSecurityTable @UserAuthorization = 2;
    EXEC Project2.AlterTables @UserAuthorization = 2;
    EXEC Project2.DropForeignKeysFromStarSchemaData @UserAuthorization = 2;
    EXEC Project2.TruncateStarSchemaData @UserAuthorization = 2;
    */
    --EXEC Project2.AddForeignKeysTOStarSchemaData
GO
DROP PROC IF EXISTS Project2.LoadStarSchemaData
GO
CREATE PROC Project2.LoadStarSchemaData
AS
BEGIN
    

    EXEC [Project2].[Load_DimCustomer] @UserAuthorizationKey = 1;
    EXEC [Project2].[Load_DimGender] @UserAuthorizationKey = 2;
    EXEC [Project2].[Load_DimMaritalStatus] @userAuthorizationKey = 3;
    EXEC [Project2].[Load_DimOccupation] @userAuthorizationKey = 4;
    EXEC [Project2].[Load_DimOrderDate] @UserAuthorizationKey = 6;
    EXEC [Project2].[Load_Product_ProductCategory_ProductSubCategory] @UserAuthorizationKey = 3;
    EXEC [Project2].[Load_DimTerritory] @userAuthorizationKey = 3;
    EXEC [Project2].[Load_SalesManagers] @UserAuthorizationKey = 6;
    --EXEC Project2.Load_Data
    

END
GO


EXEC Project2.LoadStarSchemaData;
SELECT * FROM Process.WorkFlowSteps;

/*
SELECT * FROM [CH01-01-Dimension].[DimCustomer];
SELECT * FROM [CH01-01-Dimension].[DimGender];
SELECT * FROM [CH01-01-Dimension].[DimMaritalStatus];
SELECt * FROM [CH01-01-Dimension].[DimOccupation];
SELECT * FROM [CH01-01-Dimension].[DimProduct];
SELECT * FROM [CH01-01-Dimension].[DimTerritory];
SELECT * FROM [CH01-01-Dimension].[DimOrderDate];
SELECT * FROM [CH01-01-Dimension].[SalesManagers];
SELECT * FROM [CH01-01-Fact].[Data];
*/



/*
-- Early code used below for undoing the table alterations ( adding the 3 columns ).
-- Originally tried backwards engineering any progress i made, because i couldn't 
-- resolve a restoration issue at the time. That issue has been overcomed. 
-- Redundant now but used earlier to help relieve many many many headaches. - Danny 

USE BIClass
GO
ALTER TABLE [CH01-01-Dimension].[DimCustomer]                       -- 1
DROP CONSTRAINT DF_Cus_UAKDefault,DF_Cus_DADefault,DF_Cus_DOLUDefault;    
GO
ALTER TABLE [CH01-01-Dimension].[DimGender]                         -- 2
DROP CONSTRAINT DF_Gen_UAKDefault,DF_Gen_DADefault,DF_Gen_DOLUDefault;
GO    
ALTER TABLE [CH01-01-Dimension].[DimMaritalStatus]                  -- 3
DROP CONSTRAINT DF_Mar_UAKDefault,DF_Mar_DADefault,DF_Mar_DOLUDefault;
GO
ALTER TABLE [CH01-01-Dimension].[DimOccupation]                     -- 4
DROP CONSTRAINT DF_Occ_UAKDefault,DF_Occ_DADefault,DF_Occ_DOLUDefault;
GO
ALTER TABLE [CH01-01-Dimension].[DimOrderDate]                      -- 5
DROP CONSTRAINT DF_Ord_UAKDefault,DF_Ord_DADefault,DF_Ord_DOLUDefault;    
GO
ALTER TABLE [CH01-01-Dimension].[DimProduct]                        -- 6
DROP CONSTRAINT DF_Pro_UAKDefault,DF_Pro_DADefault,DF_Pro_DOLUDefault;
GO
ALTER TABLE [CH01-01-Dimension].[DimTerritory]                      -- 7
DROP CONSTRAINT DF_Ter_UAKDefault,DF_Ter_DADefault,DF_Ter_DOLUDefault;
GO    
ALTER TABLE [CH01-01-Dimension].[SalesManagers]                      -- 8
DROP CONSTRAINT DF_Sal_UAKDefault,DF_Sal_DADefault,DF_Sal_DOLUDefault;
GO    
ALTER TABLE [CH01-01-Fact].[Data]                                   -- 9
DROP CONSTRAINT DF_Dat_UAKDefault,DF_Dat_DADefault,DF_Dat_DOLUDefault;
    
-- DROP ALL NEW TABLE COLUMNS, TO UNDO WORK.
USE BIClass
GO
ALTER TABLE [CH01-01-Dimension].[DimCustomer]                       -- 1
DROP COLUMN UserAuthorizationKey, DateAdded, DateOfLastUpdate;
GO
ALTER TABLE [CH01-01-Dimension].[DimGender]                         -- 2
DROP COLUMN UserAuthorizationKey, DateAdded, DateOfLastUpdate;
GO
ALTER TABLE [CH01-01-Dimension].[DimMaritalStatus]                  -- 3
DROP COLUMN UserAuthorizationKey, DateAdded, DateOfLastUpdate;
GO
ALTER TABLE [CH01-01-Dimension].[DimOccupation]                     -- 4
DROP COLUMN UserAuthorizationKey, DateAdded, DateOfLastUpdate;
GO
ALTER TABLE [CH01-01-Dimension].[DimOrderDate]                      -- 5
DROP COLUMN UserAuthorizationKey, DateAdded, DateOfLastUpdate;
GO
ALTER TABLE [CH01-01-Dimension].[DimProduct]                        -- 6
DROP COLUMN UserAuthorizationKey, DateAdded, DateOfLastUpdate;
GO
ALTER TABLE [CH01-01-Dimension].[DimTerritory]                      -- 7
DROP COLUMN UserAuthorizationKey, DateAdded, DateOfLastUpdate;
GO
ALTER TABLE [CH01-01-Dimension].[SalesManagers]                     -- 8
DROP COLUMN UserAuthorizationKey, DateAdded, DateOfLastUpdate;
GO
ALTER TABLE [CH01-01-Fact].[Data]                                   -- 9
DROP COLUMN UserAuthorizationKey, DateAdded, DateOfLastUpdate;


*/
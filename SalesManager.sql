--=========================================================================== SALESMANAGERS
-- Author:       Nabila Ahmed
-- Procedure:    CH01-01-Dimension.SalesManagers
-- Create date:  4/12/20
-- Description:  Loaded SalesManagers table data from the FileUpload.OriginallyLoadedData table
--===========================================================================
GO
USE BIClass
DROP SEQUENCE IF EXISTS PKSequence.DimSalesManagersKeyGenerator ---------------------- SalesManagerKeyGen
GO
CREATE SEQUENCE PKSequence.DimSalesManagersKeyGenerator
    START WITH 1 INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 2147483648
    CACHE
    
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

EXEC Project2.Load_SalesManagers @UserAuthorizationKey = 6;


SELECT * from [CH01-01-Dimension].SalesManagers

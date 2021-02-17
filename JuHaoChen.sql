--=========================================================================== LOAD FACT DATA
-- Author:       Juhao Chen
-- Procedure:    [Project2].[LoadData]
-- Create date:  4/13/20
-- Description:  <Description>
--===========================================================================
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

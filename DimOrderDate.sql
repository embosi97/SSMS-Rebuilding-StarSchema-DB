--=========================================================================== ORDERDATE
-- Author:       Nabila Ahmed 
-- Procedure:    CH01-01-Dimension.DimOrderDate
-- Create date:  4/12/20
-- Description:  Loads the DimOrderDate data from the FileUpload.OriginallyLoadedData 
--===========================================================================
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

EXEC Project2.Load_DimOrderDate @UserAuthorizationKey = 6;


SELECT * FROM [CH01-01-Dimension].[DimOrderDate]
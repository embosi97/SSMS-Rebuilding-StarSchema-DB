--=========================================================================== OCCUPATION
-- Author:       <NAME>
-- Procedure:    CH01-01-Dimension.DimOccupation
-- Create date:  4/13/20
-- Description:  Loaded data into the DimOccupation data from the FileUpload.OriginallyLoadedData table
--===========================================================================

GO
USE BIClass
DROP SEQUENCE IF EXISTS PKSequence.DimOccupationKeyGenerator -- OccupationKeyGen
GO
CREATE SEQUENCE PKSequence.DimOccupationKeyGenerator
    START WITH 1 INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 2147483648
    CACHE

EXEC Project2.Load_DimOccupation @UserAuthorizationKey = 6;
--------------
DROP PROC IF EXISTS [Project2].[Load_DimOccupation]
GO
CREATE PROC [Project2].[Load_DimOccupation] 
    @UserAuthorizationKey       INT
AS
BEGIN
    DECLARE @StartingTime AS DATETIME2(7) = SYSDATETIME()
    SET NOCOUNT ON;

/*
    YOUR LOADING CODE HERE
*/
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
                                   @GroupMemberUserAuthorizationKey = 6, --  GET USER-AUTH-KEY, REPLACE -999
                                   @WorkFlowStepDescription = 'Loaded data into the DimOccupation Table',  -- REPLACE DEFAULT DESCRIPTION
                                   @StartingDateTime = @StartingDateTime
END;

SELECT * FROM [CH01-01-Dimension].[DimOccupation] 
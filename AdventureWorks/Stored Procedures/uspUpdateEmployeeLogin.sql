﻿
CREATE PROCEDURE [HumanResources].[uspUpdateEmployeeLogin]
    @BusinessEntityID [int], 
    @OrganizationNode [sys].[hierarchyid],
    @LoginID [nvarchar](256),
    @JobTitle [nvarchar](50),
    @HireDate [datetime],
    @CurrentFlag [dbo].[Flag]
WITH EXECUTE AS CALLER
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        UPDATE [HumanResources].[Employee] 
        SET [HumanResources].[Employee].[OrganizationNode] = @OrganizationNode 
            ,[HumanResources].[Employee].[LoginID] = @LoginID 
            ,[HumanResources].[Employee].[JobTitle] = @JobTitle 
            ,[HumanResources].[Employee].[HireDate] = @HireDate 
            ,[HumanResources].[Employee].[CurrentFlag] = @CurrentFlag 
        WHERE [HumanResources].[Employee].[BusinessEntityID] = @BusinessEntityID;
    END TRY
    BEGIN CATCH
        EXECUTE [dbo].[uspLogError];
    END CATCH;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Updates the Employee table with the values specified in the input parameters for the given BusinessEntityID.', @level0type = N'SCHEMA', @level0name = N'HumanResources', @level1type = N'PROCEDURE', @level1name = N'uspUpdateEmployeeLogin';


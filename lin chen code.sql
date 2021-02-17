--=========================================================================== GRANDPARENT/PARENT/CHILD
-- Author:       Lin Chen 
-- Procedure:    
-- Create date:  4/13/20
-- Description:  
--===========================================================================
--GRANDPARENT
--DROP TABLE IF EXISTS [CH01-01-Dimension].[DimProductSubCategory]
--GO

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
END
GO
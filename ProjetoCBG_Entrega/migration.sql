-- Diogo Sabino nº202300149
-- Rodrigo Antunes nº2024151048
--
-- Sript migration
-- Migração de dados da base de dados antiga "AdventureWorksLegacy" para a nova base de dados "AdventureWorks".


-- Group
INSERT INTO Location.[Group] (groupName)
SELECT DISTINCT SalesTerritoryGroup 
FROM AdventureWorksLegacy.dbo.SalesTerritory
WHERE SalesTerritoryGroup IS NOT NULL;

-- Country
INSERT INTO Location.Country (countryName, groupID)
SELECT DISTINCT st.SalesTerritoryCountry, g.groupID
FROM AdventureWorksLegacy.dbo.SalesTerritory st
JOIN Location.[Group] g ON g.groupName = st.SalesTerritoryGroup
WHERE SalesTerritoryCountry IS NOT NULL;

-- Region
INSERT INTO Location.Region (regionName, countryID)
SELECT DISTINCT st.SalesTerritoryRegion, c.countryID
FROM AdventureWorksLegacy.dbo.SalesTerritory st
JOIN Location.Country c ON c.countryName = st.SalesTerritoryCountry
WHERE st.SalesTerritoryRegion IS NOT NULL;

-- StateProvince
INSERT INTO Location.StateProvince (stateProvinceName, regionID)
SELECT DISTINCT cu.StateProvinceName, r.regionID
FROM AdventureWorksLegacy.dbo.Customer cu
JOIN AdventureWorksLegacy.dbo.SalesTerritory st
    ON st.SalesTerritoryKey = cu.SalesTerritoryKey
JOIN Location.Region r
    ON r.regionName = st.SalesTerritoryRegion
WHERE cu.StateProvinceName IS NOT NULL;

-- City
INSERT INTO Location.City (cityName, stateProvinceID)
SELECT DISTINCT cu.City, sp.stateProvinceID
FROM AdventureWorksLegacy.dbo.Customer cu
JOIN Location.StateProvince sp
    ON sp.stateProvinceName = cu.StateProvinceName
WHERE cu.City IS NOT NULL;

-- Address
INSERT INTO Location.Address (addressLine1, cityID, postalCode)
SELECT DISTINCT cu.AddressLine1, ci.cityID, cu.PostalCode
FROM AdventureWorksLegacy.dbo.Customer cu
JOIN Location.City ci
    ON ci.cityName = cu.City
JOIN Location.StateProvince sp
    ON sp.stateProvinceID = ci.stateProvinceID
WHERE cu.AddressLine1 IS NOT NULL;

--------------------------------------------------------------
-- REFERENCE TABLES
--------------------------------------------------------------

-- Gender
INSERT INTO Reference.Gender (genderName)
SELECT DISTINCT Gender
FROM AdventureWorksLegacy.dbo.Customer;

-- Occupation
INSERT INTO Reference.Occupation (occupationName)
SELECT DISTINCT Occupation
FROM AdventureWorksLegacy.dbo.Customer;

-- Education
INSERT INTO Reference.Education (educationName)
SELECT DISTINCT Education
FROM AdventureWorksLegacy.dbo.Customer;

-- Color
INSERT INTO Reference.Color (colorName)
SELECT DISTINCT Color
FROM AdventureWorksLegacy.dbo.Products
WHERE Color IS NOT NULL;

-- Category
INSERT INTO Reference.Category (categoryName)
SELECT DISTINCT EnglishProductCategoryName
FROM AdventureWorksLegacy.dbo.Products;

-- Subcategories
INSERT INTO Reference.Category (categoryName, parentCategoryID)
SELECT DISTINCT p.EnglishProductSubcategoryName, parent.categoryID
FROM AdventureWorksLegacy.dbo.Products p
JOIN Reference.Category parent 
    ON parent.categoryName = p.EnglishProductCategoryName
WHERE p.EnglishProductSubcategoryName IS NOT NULL;

-- Currency
INSERT INTO Reference.Currency (currencyName, currencyAlternateKey)
SELECT DISTINCT CurrencyName, CurrencyAlternateKey
FROM AdventureWorksLegacy.dbo.Currency;

--------------------------------------------------------------
-- USER MANAGEMENT
--------------------------------------------------------------

-- UserSecurity
INSERT INTO UserManagement.UserSecurity (userEmail, [password], phone)
SELECT DISTINCT EmailAddress, [Password], Phone
FROM AdventureWorksLegacy.dbo.Customer
WHERE EmailAddress IS NOT NULL;

--------------------------------------------------------------
-- CUSTOMERS
--------------------------------------------------------------

WITH DistinctCustomers AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY EmailAddress ORDER BY CustomerKey) AS rn
    FROM AdventureWorksLegacy.dbo.Customer
)
INSERT INTO Sales.Customers (
    firstName, middleName, lastName, birthDate, yearlyIncome,
    numbersCarsOwned, dateFirstPurchase, title, martialStatus,
    genderID, occupationID, educationID, addressID, userEmail
)
SELECT 
    FirstName, MiddleName, LastName, BirthDate, YearlyIncome,
    NumberCarsOwned, DateFirstPurchase, Title, MaritalStatus,
    g.genderID, o.occupationID, e.educationID, a.addressID, EmailAddress
FROM DistinctCustomers cu
JOIN Reference.Gender g ON g.genderName = cu.Gender
JOIN Reference.Occupation o ON o.occupationName = cu.Occupation
JOIN Reference.Education e ON e.educationName = cu.Education
JOIN Location.Address a 
    ON a.addressLine1 = cu.AddressLine1
   AND a.postalCode = cu.PostalCode
WHERE rn = 1;

-- Remove Duplicated
WITH RankedCustomers AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY userEmail ORDER BY customerID) AS rn
    FROM Sales.Customers
)
DELETE FROM RankedCustomers
WHERE rn > 1;

--------------------------------------------------------------
-- PRODUCTS
--------------------------------------------------------------

INSERT INTO Production.Products (
    productName,
    modelName,
    sizeRange,
    description,
    class,
    style,
    weight,
    weightUnitMeasureCode,
    standardCost,
    listPrice,
    dealerPrice,
    safetyStockLevel,
    daysToManufacture,
    finishedGoodFlag,
    productLine,
    colorID,
    categoryID
)
SELECT 
    p.EnglishProductName,
    p.ModelName,
    p.SizeRange,
    p.EnglishDescription,
    p.Class,
    p.Style,
    p.Weight,
    p.WeightUnitMeasureCode,
    p.StandardCost,
    p.ListPrice,
    p.DealerPrice,
    p.SafetyStockLevel,
    p.DaysToManufacture,
    p.FinishedGoodsFlag,
    p.ProductLine,
    c.colorID,
    cat.categoryID
FROM AdventureWorksLegacy.dbo.Products p
LEFT JOIN Reference.Color c ON c.colorName = p.Color
LEFT JOIN Reference.Category cat ON cat.categoryName = p.EnglishProductSubcategoryName;

--------------------------------------------------------------
-- SALES ORDERS
--------------------------------------------------------------

-- 1. TRUNCATE the target tables to ensure a clean start
TRUNCATE TABLE Sales.SalesOrderLine;

-- 2. Drop and Create the temporary mapping table for SalesOrder
DROP TABLE IF EXISTS #SalesOrderMap;
CREATE TABLE #SalesOrderMap (
    SalesOrderNumber VARCHAR(50) NOT NULL,
    salesOrderID INT NOT NULL
);

-- Insert data into the new SalesOrder table using MERGE
MERGE INTO Sales.SalesOrder AS target
USING (
    SELECT 
        s.SalesOrderNumber,
        s.OrderDate,
        s.DueDate,
        s.ShipDate,
        SUM(s.Freight) AS Freight,
        SUM(s.TaxAmt) AS TaxAmt,
        SUM(s.TotalSalesAmount) AS TotalSalesAmt,
        c.customerID,
        curr.currencyID
    FROM AdventureWorksLegacy.dbo.Sales s
    JOIN Sales.Customers c ON c.userEmail = (
        SELECT TOP 1 EmailAddress 
        FROM AdventureWorksLegacy.dbo.Customer old_cu 
        WHERE old_cu.CustomerKey = s.CustomerKey
    )
    JOIN AdventureWorksLegacy.dbo.Currency old_curr
        ON old_curr.CurrencyKey = s.CurrencyKey
    JOIN Reference.Currency curr 
        ON curr.currencyName = old_curr.CurrencyName
    GROUP BY 
        s.SalesOrderNumber, s.OrderDate, s.DueDate, s.ShipDate, c.customerID, curr.currencyID
) AS s (SalesOrderNumber, OrderDate, DueDate, ShipDate, Freight, TaxAmt, TotalSalesAmt, customerID, currencyID)
ON 1 = 0
WHEN NOT MATCHED BY TARGET THEN
    INSERT (orderDate, dueDate, shipDate, freight, taxAmt, totalSalesAmt, customerID, currencyID)
    VALUES (s.OrderDate, s.DueDate, s.ShipDate, s.Freight, s.TaxAmt, s.TotalSalesAmt, s.customerID, s.currencyID)
OUTPUT 
    s.SalesOrderNumber, 
    INSERTED.salesOrderID
INTO #SalesOrderMap (SalesOrderNumber, salesOrderID);

-- 3. Product Mapping
DROP TABLE IF EXISTS #ProductMap;

SELECT 
    old_p.ProductKey,
    MIN(p.productID) AS productID
INTO #ProductMap
FROM AdventureWorksLegacy.dbo.Products old_p
JOIN Production.Products p
    ON p.productName = old_p.EnglishProductName
GROUP BY old_p.ProductKey;

-- 4. Insert SalesOrderLine
INSERT INTO Sales.SalesOrderLine (
    salesOrderLineNumber,
    unitPrice,
    salesOrderID,
    productID
)
SELECT 
    s.SalesOrderLineNumber,
    s.UnitPrice,
    som.salesOrderID,
    pm.productID
FROM AdventureWorksLegacy.dbo.Sales s
JOIN #SalesOrderMap som 
    ON som.SalesOrderNumber = s.SalesOrderNumber
JOIN #ProductMap pm 
    ON pm.ProductKey = s.ProductKey;

-- 5. Clean up temp tables
DROP TABLE IF EXISTS #SalesOrderMap;
DROP TABLE IF EXISTS #ProductMap;
GO

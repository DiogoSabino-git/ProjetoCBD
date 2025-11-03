-- Group
INSERT INTO dbo.[Group] (groupName)
SELECT DISTINCT SalesTerritoryGroup 
FROM AdventureWorksLegacy.dbo.SalesTerritory
WHERE SalesTerritoryGroup IS NOT NULL;

-- Country
INSERT INTO dbo.Country (countryName, groupID)
SELECT DISTINCT st.SalesTerritoryCountry, g.groupID
FROM AdventureWorksLegacy.dbo.SalesTerritory st
JOIN dbo.[Group] g ON g.groupName = st.SalesTerritoryGroup
WHERE SalesTerritoryCountry IS NOT NULL;

-- Region
INSERT INTO dbo.Region (regionName, countryID)
SELECT DISTINCT st.SalesTerritoryRegion, c.countryID
FROM AdventureWorksLegacy.dbo.SalesTerritory st
JOIN dbo.Country c ON c.countryName = st.SalesTerritoryCountry
WHERE st.SalesTerritoryRegion IS NOT NULL;

-- StateProvince
INSERT INTO dbo.StateProvince (stateProvinceName, regionID)
SELECT DISTINCT cu.StateProvinceName, r.regionID
FROM AdventureWorksLegacy.dbo.Customer cu
JOIN AdventureWorksLegacy.dbo.SalesTerritory st
    ON st.SalesTerritoryKey = cu.SalesTerritoryKey
JOIN dbo.Region r
    ON r.regionName = st.SalesTerritoryRegion
WHERE cu.StateProvinceName IS NOT NULL;

-- City
INSERT INTO dbo.City (cityName, stateProvinceID)
SELECT DISTINCT cu.City, sp.stateProvinceID
FROM AdventureWorksLegacy.dbo.Customer cu
JOIN dbo.StateProvince sp
    ON sp.stateProvinceName = cu.StateProvinceName
WHERE cu.City IS NOT NULL;

-- Address
INSERT INTO dbo.Address (addressLine1, cityID, postalCode)
SELECT DISTINCT cu.AddressLine1, ci.cityID, cu.PostalCode
FROM AdventureWorksLegacy.dbo.Customer cu
JOIN dbo.City ci
    ON ci.cityName = cu.City
JOIN dbo.StateProvince sp
    ON sp.stateProvinceID = ci.stateProvinceID
WHERE cu.AddressLine1 IS NOT NULL;

-- Gender
INSERT INTO dbo.Gender (genderName)
SELECT DISTINCT Gender
FROM AdventureWorksLegacy.dbo.Customer;

-- Occupation
INSERT INTO dbo.Occupation (occupationName)
SELECT DISTINCT Occupation
FROM AdventureWorksLegacy.dbo.Customer;

-- Education
INSERT INTO dbo.Education (educationName)
SELECT DISTINCT Education
FROM AdventureWorksLegacy.dbo.Customer;

-- Color
INSERT INTO dbo.Color (colorName)
SELECT DISTINCT Color
FROM AdventureWorksLegacy.dbo.Products
WHERE Color IS NOT NULL;

-- Category
INSERT INTO dbo.Category (categoryName)
SELECT DISTINCT EnglishProductCategoryName
FROM AdventureWorksLegacy.dbo.Products;

-- Subcategories
INSERT INTO dbo.Category (categoryName, parentCategoryID)
SELECT DISTINCT p.EnglishProductSubcategoryName, parent.categoryID
FROM AdventureWorksLegacy.dbo.Products p
JOIN dbo.Category parent 
    ON parent.categoryName = p.EnglishProductCategoryName
WHERE p.EnglishProductSubcategoryName IS NOT NULL;

-- Currency
INSERT INTO dbo.Currency (currencyName, curencyAlternateKey)
SELECT DISTINCT CurrencyName, CurrencyAlternateKey
FROM AdventureWorksLegacy.dbo.Currency;

--UserSecurity
INSERT INTO dbo.UserSecurity (userEmail, [password], phone)
SELECT DISTINCT EmailAddress, [Password], Phone
FROM AdventureWorksLegacy.dbo.Customer
WHERE EmailAddress IS NOT NULL;

--Customers
WITH DistinctCustomers AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY EmailAddress ORDER BY CustomerKey) AS rn
    FROM AdventureWorksLegacy.dbo.Customer
)
INSERT INTO dbo.Customers (
    firstName, middleName, lastName, birthDate, yearlyIncome,
    numbersCarsOwned, dateFirstPurchase, title, martialStatus,
    genderID, occupationID, educationID, addressID, userEmail
)
SELECT 
    FirstName, MiddleName, LastName, BirthDate, YearlyIncome,
    NumberCarsOwned, DateFirstPurchase, Title, MaritalStatus,
    g.genderID, o.occupationID, e.educationID, a.addressID, EmailAddress
FROM DistinctCustomers cu
JOIN dbo.Gender g ON g.genderName = cu.Gender
JOIN dbo.Occupation o ON o.occupationName = cu.Occupation
JOIN dbo.Education e ON e.educationName = cu.Education
JOIN dbo.Address a 
    ON a.addressLine1 = cu.AddressLine1
   AND a.postalCode = cu.PostalCode
WHERE rn = 1;

--Remove Duplicated
WITH RankedCustomers AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY userEmail ORDER BY customerID) AS rn
    FROM dbo.Customers
)
DELETE FROM RankedCustomers
WHERE rn > 1;

--Products
INSERT INTO dbo.Products (
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
LEFT JOIN dbo.Color c ON c.colorName = p.Color
LEFT JOIN dbo.Category cat ON cat.categoryName = p.EnglishProductSubcategoryName;


--SalesOrder

-- 1. TRUNCATE the target tables to ensure a clean start
TRUNCATE TABLE dbo.SalesOrderLine;
-- 2. Drop and Create the temporary mapping table for SalesOrder
DROP TABLE IF EXISTS #SalesOrderMap;
CREATE TABLE #SalesOrderMap (
    SalesOrderNumber VARCHAR(50) NOT NULL,
    salesOrderID INT NOT NULL
);
-- Insert data into the new SalesOrder table using MERGE
MERGE INTO dbo.SalesOrder AS target
USING (
    -- Source data set: aggregate all details into one header row
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
    JOIN dbo.Customers c ON c.userEmail = (
        SELECT TOP 1 EmailAddress 
        FROM AdventureWorksLegacy.dbo.Customer old_cu 
        WHERE old_cu.CustomerKey = s.CustomerKey
    )
    JOIN AdventureWorksLegacy.dbo.Currency old_curr
        ON old_curr.CurrencyKey = s.CurrencyKey
    JOIN dbo.Currency curr 
        ON curr.currencyName = old_curr.CurrencyName
    GROUP BY 
        s.SalesOrderNumber, s.OrderDate, s.DueDate, s.ShipDate, c.customerID, curr.currencyID
) AS s (SalesOrderNumber, OrderDate, DueDate, ShipDate, Freight, TaxAmt, TotalSalesAmt, customerID, currencyID)
ON 1 = 0 -- Ensures all rows are INSERTED
WHEN NOT MATCHED BY TARGET THEN
    INSERT (orderDate, dueDate, shipDate, freight, taxAmt, totalSalesAmt, customerID, currencyID)
    VALUES (s.OrderDate, s.DueDate, s.ShipDate, s.Freight, s.TaxAmt, s.TotalSalesAmt, s.customerID, s.currencyID)
-- Output the old key and the new identity ID to the temp table
OUTPUT 
    s.SalesOrderNumber, 
    INSERTED.salesOrderID
INTO #SalesOrderMap (SalesOrderNumber, salesOrderID);

--SalesOrderLine
-- 3. Create a Product Mapping Table to ensure 1:1 ProductKey -> productID
DROP TABLE IF EXISTS #ProductMap;

SELECT 
    old_p.ProductKey,
    MIN(p.productID) AS productID  -- Arbitrarily pick one new productID if duplicates exist
INTO #ProductMap
FROM AdventureWorksLegacy.dbo.Products old_p
JOIN dbo.Products p
    ON p.productName = old_p.EnglishProductName
GROUP BY old_p.ProductKey;


-- 4. Insert into SalesOrderLine using the explicit map tables
INSERT INTO dbo.SalesOrderLine (
    salesOrderLineNumber,
    unitPrice,
    salesOrderID,
    productID
)
SELECT 
    s.SalesOrderLineNumber,
    s.UnitPrice,
    som.salesOrderID,  -- New SalesOrderID from the #SalesOrderMap
    pm.productID       -- New productID from the #ProductMap
FROM AdventureWorksLegacy.dbo.Sales s
-- Join to the SalesOrder Map (MUST be active in this session)
JOIN #SalesOrderMap som 
    ON som.SalesOrderNumber = s.SalesOrderNumber
-- Join to the NEWLY CREATED Product Map
JOIN #ProductMap pm 
    ON pm.ProductKey = s.ProductKey;

-- 5. Clean up the temporary tables
DROP TABLE IF EXISTS #SalesOrderMap;
DROP TABLE IF EXISTS #ProductMap;


-- Diogo Sabino nº202300149
-- Rodrigo Antunes nº2024151048
--
-- Sript MigrationQueries
-- Queries que verificam a integridade da importação de dados da base de dados antiga para a nova.


-- Customers
SELECT COUNT(*) AS OldCount FROM AdventureWorksLegacy.dbo.Customer;
SELECT COUNT(*) AS NewCount FROM AdventureWorks.Sales.Customers;

-- Emails Matching
SELECT o.EmailAddress, n.userEmail
FROM AdventureWorksLegacy.dbo.Customer o
JOIN AdventureWorks.Sales.Customers n
  ON o.EmailAddress = n.userEmail;

-- Gender
SELECT DISTINCT Gender FROM AdventureWorksLegacy.dbo.Customer
EXCEPT
SELECT genderName FROM AdventureWorks.Reference.Gender;

SELECT COUNT(*) AS OldGenderCount FROM AdventureWorksLegacy.dbo.Customer WHERE Gender IS NOT NULL;
SELECT COUNT(*) AS NewGenderCount FROM AdventureWorks.Reference.Gender;

-- Education
SELECT DISTINCT Education FROM AdventureWorksLegacy.dbo.Customer
EXCEPT
SELECT educationName FROM AdventureWorks.Reference.Education;

SELECT COUNT(DISTINCT Education) AS OldEducationCount FROM AdventureWorksLegacy.dbo.Customer WHERE Education IS NOT NULL;
SELECT COUNT(*) AS NewEducationCount FROM AdventureWorks.Reference.Education;

-- Occupation
SELECT DISTINCT Occupation FROM AdventureWorksLegacy.dbo.Customer
EXCEPT
SELECT occupationName FROM AdventureWorks.Reference.Occupation;

SELECT COUNT(DISTINCT Occupation) AS OldOccupationCount FROM AdventureWorksLegacy.dbo.Customer WHERE Occupation IS NOT NULL;
SELECT COUNT(*) AS NewOccupationCount FROM AdventureWorks.Reference.Occupation;

-- Address
SELECT DISTINCT 
    o.AddressLine1, o.City, o.PostalCode
FROM AdventureWorksLegacy.dbo.Customer o
EXCEPT
SELECT a.addressLine1, c.cityName, a.postalCode
FROM AdventureWorks.Location.Address a
JOIN AdventureWorks.Location.City c ON a.cityID = c.cityID;

SELECT COUNT(DISTINCT AddressLine1) AS OldAddressCount FROM AdventureWorksLegacy.dbo.Customer;
SELECT COUNT(*) AS NewAddressCount FROM AdventureWorks.Location.Address;

-- Products
SELECT COUNT(*) AS OldCount FROM AdventureWorksLegacy.dbo.Products;
SELECT COUNT(*) AS NewCount FROM AdventureWorks.Production.Products;

-- Color
SELECT DISTINCT Color FROM AdventureWorksLegacy.dbo.Products
EXCEPT
SELECT colorName FROM AdventureWorks.Reference.Color;

SELECT COUNT(DISTINCT Color) AS OldColorCount FROM AdventureWorksLegacy.dbo.Products WHERE Color IS NOT NULL;
SELECT COUNT(*) AS NewColorCount FROM AdventureWorks.Reference.Color;

-- Category
SELECT DISTINCT EnglishProductCategoryName FROM AdventureWorksLegacy.dbo.Products
EXCEPT
SELECT categoryName FROM AdventureWorks.Reference.Category;

SELECT o.EnglishProductName, n.productName
FROM AdventureWorksLegacy.dbo.Products o
JOIN AdventureWorks.Production.Products n
  ON o.EnglishProductName = n.productName;

SELECT COUNT(DISTINCT EnglishProductCategoryName) AS OldCategoryCount 
FROM AdventureWorksLegacy.dbo.Products;

SELECT COUNT(*) AS NewCategoryCount 
FROM AdventureWorks.Reference.Category WHERE parentCategoryID IS NULL;

-- Subcategory
SELECT 
    ps.EnglishProductSubcategoryName AS OldSubcategory,
    ps.ParentCategoryName AS OldParentCategory,
    c1.categoryName AS NewSubcategory,
    c2.categoryName AS NewParentCategory
FROM AdventureWorksLegacy.dbo.ProductSubCategory ps
LEFT JOIN AdventureWorks.Reference.Category c1 
    ON ps.EnglishProductSubcategoryName = c1.categoryName
LEFT JOIN AdventureWorks.Reference.Category c2
    ON c1.parentCategoryID = c2.categoryID
WHERE c2.categoryName <> ps.ParentCategoryName
   OR c2.categoryName IS NULL;

SELECT COUNT(*) AS OldSubcategoryCount
FROM AdventureWorksLegacy.dbo.ProductSubCategory;

SELECT COUNT(*) AS NewSubcategoryCount
FROM AdventureWorks.Reference.Category
WHERE parentCategoryID IS NOT NULL;

-- Currency
SELECT COUNT(*) AS OldCount FROM AdventureWorksLegacy.dbo.Currency;
SELECT COUNT(*) AS NewCount FROM AdventureWorks.Reference.Currency;

SELECT o.CurrencyName, o.CurrencyAlternateKey
FROM AdventureWorksLegacy.dbo.Currency o
EXCEPT
SELECT c.currencyName, c.currencyAlternateKey
FROM AdventureWorks.Reference.Currency c;

-- SalesTerritory

-- Groups 
SELECT DISTINCT SalesTerritoryGroup FROM AdventureWorksLegacy.dbo.SalesTerritory
EXCEPT
SELECT groupName FROM AdventureWorks.Location.[Group];

SELECT COUNT(DISTINCT SalesTerritoryGroup) AS OldGroupCount 
FROM AdventureWorksLegacy.dbo.SalesTerritory
WHERE SalesTerritoryGroup IS NOT NULL;

SELECT COUNT(*) AS NewGroupCount 
FROM AdventureWorks.Location.[Group];

-- Countries
SELECT DISTINCT SalesTerritoryCountry FROM AdventureWorksLegacy.dbo.SalesTerritory
EXCEPT
SELECT countryName FROM AdventureWorks.Location.Country;

SELECT COUNT(DISTINCT SalesTerritoryCountry) AS OldCountryCount 
FROM AdventureWorksLegacy.dbo.SalesTerritory
WHERE SalesTerritoryCountry IS NOT NULL;

SELECT COUNT(*) AS NewCountryCount 
FROM AdventureWorks.Location.Country;

-- Regions
SELECT DISTINCT SalesTerritoryRegion FROM AdventureWorksLegacy.dbo.SalesTerritory
EXCEPT
SELECT regionName FROM AdventureWorks.Location.Region;

SELECT COUNT(DISTINCT SalesTerritoryRegion) AS OldRegionCount 
FROM AdventureWorksLegacy.dbo.SalesTerritory
WHERE SalesTerritoryRegion IS NOT NULL;

SELECT COUNT(*) AS NewRegionCount 
FROM AdventureWorks.Location.Region;

-- Sales
SELECT 'SalesOrder (New)' AS TableName, COUNT(*) AS NewRowCount
FROM AdventureWorks.Sales.SalesOrder

UNION ALL

SELECT 'SalesOrderLine (New)' AS TableName, COUNT(*) AS NewRowCount
FROM AdventureWorks.Sales.SalesOrderLine

UNION ALL

SELECT 'Sales (Legacy - Header)' AS TableName, COUNT(DISTINCT SalesOrderNumber) AS LegacyHeaderCount
FROM AdventureWorksLegacy.dbo.Sales

UNION ALL

SELECT 'Sales (Legacy - Detail)' AS TableName, COUNT(*) AS LegacyDetailCount
FROM AdventureWorksLegacy.dbo.Sales;

-- Extra verifications

SELECT * FROM AdventureWorks.Location.City;
SELECT * FROM AdventureWorks.Location.Region;
SELECT * FROM AdventureWorks.Location.StateProvince;

SELECT * FROM AdventureWorks.Location.City WHERE stateProvinceID = 10;

SELECT * FROM AdventureWorks.Sales.SalesOrderLine;

SELECT 
    firstName, 
    middleName, 
    lastName,
    COUNT(*) AS duplicateCount
FROM AdventureWorks.Sales.Customers
GROUP BY 
    firstName, 
    middleName, 
    lastName
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS TotalCustomers FROM AdventureWorks.Sales.Customers;
SELECT COUNT(*) AS TotalOrders FROM AdventureWorks.Sales.SalesOrder;
SELECT COUNT(*) AS TotalOrderLines FROM AdventureWorks.Sales.SalesOrderLine;

SELECT * FROM AdventureWorks.Reference.Occupation;
SELECT * FROM AdventureWorks.Reference.Education;
SELECT * FROM AdventureWorks.Reference.Gender;

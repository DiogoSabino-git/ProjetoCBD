---------------------------
-- Data Migration Checks --
---------------------------

-- Customers
SELECT COUNT(*) AS OldCount FROM AdventureWorksLegacy.dbo.Customer;
SELECT COUNT(*) AS NewCount FROM AdventureWorks.dbo.Customers;

-- Emails Matching
SELECT o.EmailAddress, n.userEmail
FROM AdventureWorksLegacy.dbo.Customer o
JOIN AdventureWorks.dbo.Customers n
  ON o.EmailAddress = n.userEmail;

-- Gender
SELECT DISTINCT gender FROM AdventureWorksLegacy.dbo.Customer
EXCEPT
SELECT genderName FROM AdventureWorks.dbo.Gender;

-- Old
SELECT COUNT(*) AS OldGenderCount FROM AdventureWorksLegacy.dbo.Customer WHERE Gender IS NOT NULL;

-- New
SELECT COUNT(*) AS NewGenderCount FROM AdventureWorks.dbo.Gender;

-- Education
SELECT DISTINCT Education FROM AdventureWorksLegacy.dbo.Customer
EXCEPT
SELECT educationName FROM AdventureWorks.dbo.Education;

-- Old
SELECT COUNT(DISTINCT Education) AS OldEducationCount FROM AdventureWorksLegacy.dbo.Customer WHERE Education IS NOT NULL;

-- New
SELECT COUNT(*) AS NewEducationCount FROM AdventureWorks.dbo.Education;

-- Occupation
SELECT DISTINCT Occupation FROM AdventureWorksLegacy.dbo.Customer
EXCEPT
SELECT occupationName FROM AdventureWorks.dbo.Occupation;

-- Old
SELECT COUNT(DISTINCT Occupation) AS OldOccupationCount FROM AdventureWorksLegacy.dbo.Customer WHERE Occupation IS NOT NULL;

-- New
SELECT COUNT(*) AS NewOccupationCount FROM AdventureWorks.dbo.Occupation;


-- Address
SELECT DISTINCT 
    o.AddressLine1, o.City, o.PostalCode
FROM AdventureWorksLegacy.dbo.Customer o
EXCEPT
SELECT a.addressLine1, c.cityName, a.postalCode
FROM AdventureWorks.dbo.Address a
JOIN AdventureWorks.dbo.City c ON a.cityID = c.cityID;

-- Old
SELECT COUNT(DISTINCT AddressLine1) AS OldAddressCount FROM AdventureWorksLegacy.dbo.Customer;

-- New
SELECT COUNT(*) AS NewAddressCount FROM AdventureWorks.dbo.Address;


-- Products
SELECT COUNT(*) AS OldCount FROM AdventureWorksLegacy.dbo.Products;
SELECT COUNT(*) AS NewCount FROM AdventureWorks.dbo.Products;

-- Color
SELECT DISTINCT Color FROM AdventureWorksLegacy.dbo.Products
EXCEPT
SELECT colorName FROM AdventureWorks.dbo.Color;

-- Old
SELECT COUNT(DISTINCT Color) AS OldColorCount FROM AdventureWorksLegacy.dbo.Products WHERE Color IS NOT NULL;

-- New
SELECT COUNT(*) AS NewColorCount FROM AdventureWorks.dbo.Color;


-- Category 
SELECT DISTINCT EnglishProductCategoryName FROM AdventureWorksLegacy.dbo.Products
EXCEPT
SELECT categoryName FROM AdventureWorks.dbo.Category;

SELECT o.EnglishProductName, n.productName
FROM AdventureWorksLegacy.dbo.Products o
JOIN AdventureWorks.dbo.Products n
  ON o.EnglishProductName = n.productName;

-- Old
SELECT COUNT(DISTINCT EnglishProductCategoryName) AS OldCategoryCount FROM AdventureWorksLegacy.dbo.Products;

-- New
SELECT COUNT(*) AS NewCategoryCount FROM AdventureWorks.dbo.Category WHERE parentCategoryID IS NULL;


-- Subcategory
SELECT 
    ps.EnglishProductSubcategoryName AS OldSubcategory,
    ps.ParentCategoryName AS OldParentCategory,
    c1.categoryName AS NewSubcategory,
    c2.categoryName AS NewParentCategory
FROM AdventureWorksLegacy.dbo.ProductSubCategory ps
LEFT JOIN AdventureWorks.dbo.Category c1 
    ON ps.EnglishProductSubcategoryName = c1.categoryName
LEFT JOIN AdventureWorks.dbo.Category c2
    ON c1.parentCategoryID = c2.categoryID
WHERE c2.categoryName <> ps.ParentCategoryName
   OR c2.categoryName IS NULL;

SELECT COUNT(*) AS OldSubcategoryCount
FROM AdventureWorksLegacy.dbo.ProductSubCategory;

SELECT COUNT(*) AS NewSubcategoryCount
FROM AdventureWorks.dbo.Category
WHERE parentCategoryID IS NOT NULL;



-- Currency
SELECT COUNT(*) AS OldCount FROM AdventureWorksLegacy.dbo.Currency;
SELECT COUNT(*) AS NewCount FROM AdventureWorks.dbo.Currency;

SELECT o.CurrencyName, o.CurrencyAlternateKey
FROM AdventureWorksLegacy.dbo.Currency o
EXCEPT
SELECT c.currencyName, c.curencyAlternateKey
FROM AdventureWorks.dbo.Currency c;

-- SalesTerritory
-- Groups 
SELECT DISTINCT SalesTerritoryGroup FROM AdventureWorksLegacy.dbo.SalesTerritory
EXCEPT
SELECT groupName FROM AdventureWorks.dbo.[Group];

-- Old
SELECT COUNT(DISTINCT SalesTerritoryGroup) AS OldGroupCount 
FROM AdventureWorksLegacy.dbo.SalesTerritory
WHERE SalesTerritoryGroup IS NOT NULL;

-- New
SELECT COUNT(*) AS NewGroupCount 
FROM AdventureWorks.dbo.[Group];


-- Countries
SELECT DISTINCT SalesTerritoryCountry FROM AdventureWorksLegacy.dbo.SalesTerritory
EXCEPT
SELECT countryName FROM AdventureWorks.dbo.Country;

-- Old
SELECT COUNT(DISTINCT SalesTerritoryCountry) AS OldCountryCount 
FROM AdventureWorksLegacy.dbo.SalesTerritory
WHERE SalesTerritoryCountry IS NOT NULL;

-- New
SELECT COUNT(*) AS NewCountryCount 
FROM AdventureWorks.dbo.Country;



-- Regions
SELECT DISTINCT SalesTerritoryRegion FROM AdventureWorksLegacy.dbo.SalesTerritory
EXCEPT
SELECT regionName FROM AdventureWorks.dbo.Region;

-- Old
SELECT COUNT(DISTINCT SalesTerritoryRegion) AS OldRegionCount 
FROM AdventureWorksLegacy.dbo.SalesTerritory
WHERE SalesTerritoryRegion IS NOT NULL;

-- New
SELECT COUNT(*) AS NewRegionCount 
FROM AdventureWorks.dbo.Region;


--Sales
SELECT 'SalesOrderHeader (New)' AS TableName, COUNT(*) AS NewRowCount
FROM dbo.SalesOrder

UNION ALL

SELECT 'SalesOrderDetail (New)' AS TableName, COUNT(*) AS NewRowCount
FROM dbo.SalesOrderLine

UNION ALL

SELECT 'Sales (Legacy)' AS TableName, COUNT(DISTINCT SalesOrderNumber) AS LegacyHeaderCount
FROM AdventureWorksLegacy.dbo.Sales

UNION ALL

SELECT 'Sales (Legacy)' AS TableName, COUNT(*) AS LegacyDetailCount
FROM AdventureWorksLegacy.dbo.Sales;

---------------------------

select * from City;

select * from Region; -- 10

select * from StateProvince;

select * from City
where stateProvinceID = 10;

select * from SalesOrderLine;

SELECT 
    firstName, 
    middleName, 
    lastName,
    COUNT(*) AS duplicateCount
FROM dbo.Customers
GROUP BY 
    firstName, 
    middleName, 
    lastName
HAVING COUNT(*) > 1;

select count(*) from Customers;

select * from Customers;

select Count(*) from SalesOrder;

select count(*) from SalesOrderLine;

select * from SalesOrderLine;

select * from Occupation;

select * from Education;

select * from Gender;


USE master;
GO

-- Forçar a desconexão de utilizadores que estejam a usar a base de dados (opcional mas recomendado)
ALTER DATABASE AdventureWorks SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

-- Eliminar a base de dados
DROP DATABASE AdventureWorks;
GO

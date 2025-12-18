-- Diogo Sabino nº202300149
-- Rodrigo Antunes nº2024151048
--
-- Script Indexes

USE AdventureWorks;
GO

--------------------------------
-- SALES SCHEMA OPTIMIZATIONS --
--------------------------------

-- Sales.SalesOrderLine
-- Optimizes the view 'vProductSalesSummary' and joins with Production.Products.
CREATE NONCLUSTERED INDEX IX_SalesOrderLine_ProductID
ON Sales.SalesOrderLine (productID)
INCLUDE (unitPrice);
GO

-- Sales.SalesOrder
-- Optimizes filtering by Date
CREATE NONCLUSTERED INDEX IX_SalesOrder_OrderDate
ON Sales.SalesOrder (orderDate)
INCLUDE (totalSalesAmt);
GO

-- Optimizes "Sales by City" query
CREATE NONCLUSTERED INDEX IX_SalesOrder_CustomerID_Covering
ON Sales.SalesOrder (customerID)
INCLUDE (totalSalesAmt);
GO

-- Optimizes "Sales > 1000" query
CREATE NONCLUSTERED INDEX IX_SalesOrder_TotalSalesAmt
ON Sales.SalesOrder (totalSalesAmt ASC);
GO

-- Sales.Customers
-- Enforces uniqueness and optimizes 'spAddCustomer'/'spDeleteCustomer'
CREATE UNIQUE NONCLUSTERED INDEX UX_Customers_UserEmail
ON Sales.Customers (userEmail);
GO

-- Optimizes joins to Location.Address
CREATE NONCLUSTERED INDEX IX_Customers_AddressID
ON Sales.Customers (addressID);
GO

-------------------------------------
-- PRODUCTION SCHEMA OPTIMIZATIONS --
-------------------------------------

-- Production.Products
-- Optimizes "Sales by Category per Year" query
CREATE NONCLUSTERED INDEX IX_Products_CategoryID
ON Production.Products (categoryID)
INCLUDE (productName);
GO

-----------------------------------
-- LOCATION SCHEMA OPTIMIZATIONS --
-----------------------------------

-- Location.Address
CREATE NONCLUSTERED INDEX IX_Address_CityID
ON Location.Address (cityID);
GO

-- Location.City
-- Optimizes "Sales by City" query.
CREATE NONCLUSTERED INDEX IX_City_StateProvinceID
ON Location.City (stateProvinceID)
INCLUDE (cityName);
GO

-- Location.StateProvince
CREATE NONCLUSTERED INDEX IX_StateProvince_RegionID
ON Location.StateProvince (regionID);
GO

-- Location.Region
CREATE NONCLUSTERED INDEX IX_Region_CountryID
ON Location.Region (countryID);
GO




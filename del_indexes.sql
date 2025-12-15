-- Diogo Sabino nº202300149
-- Rodrigo Antunes nº2024151048
--
-- Script Drop Indexes (Debugging)
-- Remove todos os índices de performance criados na Fase 2.

USE AdventureWorks;
GO

------------------------------------
-- DROP SALES SCHEMA OPTIMIZATIONS --
------------------------------------

-- Sales.SalesOrderLine
DROP INDEX IF EXISTS IX_SalesOrderLine_ProductID ON Sales.SalesOrderLine;
GO

-- Sales.SalesOrder
DROP INDEX IF EXISTS IX_SalesOrder_OrderDate ON Sales.SalesOrder;
DROP INDEX IF EXISTS IX_SalesOrder_CustomerID_Covering ON Sales.SalesOrder;
DROP INDEX IF EXISTS IX_SalesOrder_TotalSalesAmt ON Sales.SalesOrder;
GO

-- Sales.Customers
DROP INDEX IF EXISTS UX_Customers_UserEmail ON Sales.Customers;
DROP INDEX IF EXISTS IX_Customers_AddressID ON Sales.Customers;
GO

-----------------------------------------
-- DROP PRODUCTION SCHEMA OPTIMIZATIONS --
-----------------------------------------

-- Production.Products
DROP INDEX IF EXISTS IX_Products_CategoryID ON Production.Products;
GO

---------------------------------------
-- DROP LOCATION SCHEMA OPTIMIZATIONS --
---------------------------------------

-- Location.Address
DROP INDEX IF EXISTS IX_Address_CityID ON Location.Address;
GO

-- Location.City
DROP INDEX IF EXISTS IX_City_StateProvinceID ON Location.City;
GO

-- Location.StateProvince
DROP INDEX IF EXISTS IX_StateProvince_RegionID ON Location.StateProvince;
GO

-- Location.Region
DROP INDEX IF EXISTS IX_Region_CountryID ON Location.Region;
GO

PRINT 'Todos os índices da Fase 2 foram removidos com sucesso.';
CREATE DATABASE AdventureWorksLegacy;
GO

SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Sales';

ALTER TABLE dbo.Sales
ALTER COLUMN ProductKey smallint;

ALTER TABLE dbo.Sales
ALTER COLUMN CustomerKey smallint;

ALTER TABLE dbo.Sales
ALTER COLUMN CurrencyKey tinyint;

ALTER TABLE dbo.Sales
ALTER COLUMN SalesTerritoryKey tinyint;

ALTER TABLE dbo.Sales
ALTER COLUMN SalesOrderNumber nvarchar(50);

ALTER TABLE dbo.Sales
ALTER COLUMN SalesOrderLineNumber tinyint;

ALTER TABLE dbo.Sales
ALTER COLUMN UnitPrice FLOAT;

ALTER TABLE dbo.Sales
ALTER COLUMN ProductStandardCost float;

ALTER TABLE dbo.Sales
ALTER COLUMN TotalSalesAmount FLOAT;

ALTER TABLE dbo.Sales
ALTER COLUMN TaxAmt FLOAT;

ALTER TABLE dbo.Sales
ALTER COLUMN Freight FLOAT;

ALTER TABLE dbo.Sales
ALTER COLUMN OrderDate date;

ALTER TABLE dbo.Sales
ALTER COLUMN DueDate date;

ALTER TABLE dbo.Sales
ALTER COLUMN ShipDate date;
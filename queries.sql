-- Diogo Sabino nº202300149
-- Rodrigo Antunes nº2024151048
--
-- Script Queries

------------------------
-- NOVA BASE DE DADOS --
------------------------

-- Pesquisa de Vendas por Cidade (Otimizada)
USE AdventureWorks;
GO

SET STATISTICS PROFILE ON;

SELECT 
    ci.cityName AS 'City', 
    sp.stateProvinceName AS 'State/Province',
    SUM(so.totalSalesAmt) AS 'TotalSales'
FROM Sales.SalesOrder so
    JOIN Sales.Customers cu ON so.customerID = cu.customerID
    JOIN Location.Address a ON cu.addressID = a.addressID
    JOIN Location.City ci ON a.cityID = ci.cityID
    JOIN Location.StateProvince sp ON ci.stateProvinceID = sp.stateProvinceID
GROUP BY ci.cityName, sp.stateProvinceName;

-- Pesquisa de produtos associados a vendas com valor total monetário superior a 1000
USE AdventureWorks;
GO

SET STATISTICS PROFILE ON;

SELECT DISTINCT 
    p.productName, 
    so.totalSalesAmt
FROM Sales.SalesOrder so
    JOIN Sales.SalesOrderLine sol ON so.salesOrderID = sol.salesOrderID
    JOIN Production.Products p ON sol.productID = p.productID
WHERE so.totalSalesAmt > 1000;

-- Número de produtos vendidos por categoria por ano
USE AdventureWorks;
GO

SET STATISTICS PROFILE ON;

SELECT 
    YEAR(so.orderDate) AS SalesYear,
    cat.categoryName,
    COUNT(sol.productID) AS TotalProductsSold
FROM Sales.SalesOrder so
    JOIN Sales.SalesOrderLine sol ON so.salesOrderID = sol.salesOrderID
    JOIN Production.Products p ON sol.productID = p.productID
    JOIN Reference.Category cat ON p.categoryID = cat.categoryID
GROUP BY YEAR(so.orderDate), cat.categoryName
ORDER BY SalesYear, cat.categoryName;


--------------------------
-- ANTIGA BASE DE DADOS --
--------------------------

-- Pesquisa de Vendas por Cidade (Antiga)
USE AdventureWorksLegacy;
GO

SET STATISTICS PROFILE ON;

SELECT 
    distinct c.StateProvinceName,
    c.City,
    SUM(s.TotalSalesAmount) AS TotalSales
FROM dbo.Sales s
    JOIN dbo.Customer c ON s.CustomerKey = c.CustomerKey
GROUP BY c.City, c.StateProvinceName;

-- Pesquisa de produtos associados a vendas com valor total monetário superior a 1000 (Antiga)
USE AdventureWorksLegacy;
GO

SET STATISTICS PROFILE ON;

SELECT DISTINCT 
    p.EnglishProductName, 
    OrderTotals.OrderTotal
FROM dbo.Sales s
    JOIN dbo.Products p ON s.ProductKey = p.ProductKey
    JOIN (
        -- Subquery to calculate Order Totals first (mimicking SalesOrder table)
        SELECT SalesOrderNumber, SUM(TotalSalesAmount) as OrderTotal
        FROM dbo.Sales
        GROUP BY SalesOrderNumber
        HAVING SUM(TotalSalesAmount) > 1000
    ) AS OrderTotals ON s.SalesOrderNumber = OrderTotals.SalesOrderNumber;

-- Número de produtos vendidos por categoria por ano (Antiga)
USE AdventureWorksLegacy;
GO

SET STATISTICS PROFILE ON;

SELECT 
    YEAR(s.OrderDate) AS SalesYear,
    p.EnglishProductSubcategoryName AS CategoryName,
    COUNT(s.ProductKey) AS TotalProductsSold
FROM dbo.Sales s
    JOIN dbo.Products p ON s.ProductKey = p.ProductKey
WHERE p.EnglishProductSubcategoryName IS NOT NULL 
GROUP BY YEAR(s.OrderDate), p.EnglishProductSubcategoryName
ORDER BY SalesYear, CategoryName;
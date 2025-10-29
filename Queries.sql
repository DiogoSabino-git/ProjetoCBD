select * from SalesTerritory;

select * from Sales;

select * from Currency;

select * from Products;

select * from ProductSubCategory;

select * from SalesTerritory;

select * from Customer;

select COUNT(*) from Sales;

select COUNT(SalesTerritoryKey) from SalesTerritory;

select COUNT(Title) from Customer;

select * from Customer
where Title is not null;

select * from Sales
where UnitPrice != TotalSalesAmount;

select * from Sales
where SalesOrderLineNumber != 1;

select COUNT(distinct Color) from Products;

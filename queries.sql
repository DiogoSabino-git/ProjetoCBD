

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
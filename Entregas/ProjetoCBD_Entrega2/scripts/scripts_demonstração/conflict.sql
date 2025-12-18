-- Diogo Sabino nº202300149
-- Rodrigo Antunes nº2024151048
--
-- Script Conflict

USE AdventureWorks;
GO

-- Garantir que o produto 1 tem o preço base de 100.00
UPDATE Production.Products
SET listPrice = 100.00
WHERE productID = 1;

SELECT productID, productName, listPrice 
FROM Production.Products 
WHERE productID = 1;


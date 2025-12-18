-- Diogo Sabino nº202300149
-- Rodrigo Antunes nº2024151048
--
-- Script Security

USE master;
GO

------------------------
-- CRIAÇÃO DOS LOGINS --
------------------------

IF EXISTS (SELECT * FROM sys.server_principals WHERE name = 'AdminLogin') DROP LOGIN AdminLogin;
IF EXISTS (SELECT * FROM sys.server_principals WHERE name = 'SalesPersonLogin') DROP LOGIN SalesPersonLogin;
IF EXISTS (SELECT * FROM sys.server_principals WHERE name = 'SalesTerritoryLogin') DROP LOGIN SalesTerritoryLogin;
GO

CREATE LOGIN AdminLogin WITH PASSWORD = 'AdminPassword1!', CHECK_POLICY = OFF;
CREATE LOGIN SalesPersonLogin WITH PASSWORD = 'SalesPersonPassword2!', CHECK_POLICY = OFF;
CREATE LOGIN SalesTerritoryLogin WITH PASSWORD = 'SalesTerritoryPassword3!', CHECK_POLICY = OFF;
GO

------------------------------
-- CRIAÇÃO DOS UTILIZADORES --
------------------------------

USE AdventureWorks;
GO

IF EXISTS (SELECT * FROM sys.database_principals WHERE name = 'User_Admin') DROP USER User_Admin;
IF EXISTS (SELECT * FROM sys.database_principals WHERE name = 'User_SalesPerson') DROP USER User_SalesPerson;
IF EXISTS (SELECT * FROM sys.database_principals WHERE name = 'User_SalesTerritory') DROP USER User_SalesTerritory;
GO

CREATE USER User_Admin FOR LOGIN AdminLogin;
CREATE USER User_SalesPerson FOR LOGIN SalesPersonLogin;
CREATE USER User_SalesTerritory FOR LOGIN SalesTerritoryLogin;
GO

-------------------------
-- ROLES E PERMISSÕES --
-------------------------

-- Admininstrador
ALTER ROLE db_owner ADD MEMBER User_Admin;

-- SalesPerson
IF DATABASE_PRINCIPAL_ID('Role_Vendas') IS NOT NULL
    DROP ROLE Role_Vendas;
GO
CREATE ROLE Role_Vendas;
ALTER ROLE db_datareader ADD MEMBER Role_Vendas;
GRANT INSERT, UPDATE, DELETE ON SCHEMA::Sales TO Role_Vendas;

ALTER ROLE Role_Vendas ADD MEMBER User_SalesPerson;

-- SalesTerritory
IF DATABASE_PRINCIPAL_ID('Role_Territory') IS NOT NULL
    DROP ROLE Role_Territory;
GO
CREATE ROLE Role_Territory;

GRANT SELECT ON OBJECT::Sales.vAustraliaCustomers TO Role_Territory;
GO

-- 3. Adicionar o utilizador ao Role
ALTER ROLE Role_Territory ADD MEMBER User_SalesTerritory;
GO


------------
-- TESTES --
------------

PRINT '>>> A INICIAR TESTES DE SEGURANÇA...';

-- TESTE ADMIN (Deve conseguir ler tudo)
EXECUTE AS USER = 'User_Admin';
    PRINT '[TESTE ADMIN] A ler tabela Production.Products...';
    SELECT TOP 1 productID, productName FROM Production.Products;
REVERT;


-- TESTE SALESPERSON (Deve conseguir ler tudo, mas só alterar Sales)
EXECUTE AS USER = 'User_SalesPerson';
    PRINT '[TESTE SALESPERSON] 1. Ler Production (Sucesso esperado)...';
    SELECT TOP 1 productID, productName FROM Production.Products;
    
    PRINT '[TESTE SALESPERSON] 2. Tentar APAGAR produto (Falha esperada)...';
    BEGIN TRY
        DELETE FROM Production.Products WHERE productID = 1;
    END TRY
    BEGIN CATCH
        PRINT '   -> SUCESSO: Bloqueio confirmado! Erro: ' + ERROR_MESSAGE();
    END CATCH
REVERT;


-- TESTE SALES TERRITORY (Deve ler View, mas falhar na Tabela)
EXECUTE AS USER = 'User_SalesTerritory';
    PRINT '[TESTE TERRITORY] 1. Ler View Austrália (Sucesso esperado)...';
    SELECT TOP 1 * FROM Sales.vAustraliaCustomers;
    
    PRINT '[TESTE TERRITORY] 2. Ler Tabela Customers Direta (Falha esperada)...';
    BEGIN TRY
        SELECT TOP 1 * FROM Sales.Customers;
    END TRY
    BEGIN CATCH
        PRINT '   -> SUCESSO: Bloqueio confirmado! Erro: ' + ERROR_MESSAGE();
    END CATCH
REVERT;
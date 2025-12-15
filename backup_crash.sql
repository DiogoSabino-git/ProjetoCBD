-- Diogo Sabino nº202300149
-- Rodrigo Antunes nº2024151048
--
-- Script Crash & Recovery (Corrigido: Sales.Customers)

USE AdventureWorks;
GO

------------------------------------------
-- O TRABALHO (Inserir Dados Críticos) --
------------------------------------------
-- CORREÇÃO: Adicionado o 's' em Customers
EXEC Sales.spAddCustomer @FirstName = 'Lúcio', @MiddleName = 'Correia', @LastName = 'Dos Santos', @CustomerEmail = 'luciocdssds@gmail.com', 
                    @CustomerPassword = 'frogger123', @SecurityQuestion = 'Why are you so angry?', @SecurityAnswer = 'boop', 
                    @Phone = '111111111', @Address = 'Paraíso', @PostalCode = '2805', @MartialStatus = "S", @BirthDate = '1930-01-10', 
                    @Education = 'Bachelors', @Occupation = "Professional", @Gender = "M";

PRINT '?? Cliente Precioso inserido.';
GO

---------------------------------------
-- O DESASTRE (Backup de Emergência) --
---------------------------------------
USE master;
GO

BACKUP LOG AdventureWorks 
TO DISK = '/var/opt/mssql/data/AdventureWorks_Tail.trn' 
WITH NO_TRUNCATE, FORMAT; 
GO

---------------------------------------
-- PREPARAÇÃO (Expulsar conexões) --
---------------------------------------
PRINT '>>> Expulsando utilizadores...';
ALTER DATABASE AdventureWorks SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

----------------------
-- A RECUPERAÇÃO --
----------------------
PRINT '>>> Iniciando Recuperação...';

-- Restore Full
RESTORE DATABASE AdventureWorks 
FROM AW_Full_Device 
WITH FILE = 1, NORECOVERY, REPLACE;

-- Restore Diff
RESTORE DATABASE AdventureWorks 
FROM AW_Diff_Device 
WITH FILE = 1, NORECOVERY;

-- Restore Tail-Log
RESTORE LOG AdventureWorks 
FROM DISK = '/var/opt/mssql/data/AdventureWorks_Tail.trn' 
WITH RECOVERY;
GO

ALTER DATABASE AdventureWorks SET MULTI_USER;
GO

--------------------
-- 5. VERIFICAÇÃO --
--------------------
USE AdventureWorks;
GO

select * from Sales.Customers
where firstName = 'Lúcio';
PRINT '✅ Recuperação terminada com sucesso.';
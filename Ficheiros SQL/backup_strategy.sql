-- Diogo Sabino nº202300149
-- Rodrigo Antunes nº2024151048
--
-- Script Backup Strategy
-- Estratégia de backups (Full).

USE master;
GO

------------------------------------------------
-- 1. CONFIGURAÇÃO (Recovery Model & Devices) --
------------------------------------------------

-- Define o modelo para FULL
ALTER DATABASE AdventureWorks SET RECOVERY FULL;
GO

-- Limpeza de dispositivos antigos (se existirem)
IF EXISTS (SELECT name FROM sys.backup_devices WHERE name = 'AW_Full_Device')
    EXEC sp_dropdevice 'AW_Full_Device';
IF EXISTS (SELECT name FROM sys.backup_devices WHERE name = 'AW_Diff_Device')
    EXEC sp_dropdevice 'AW_Diff_Device';
IF EXISTS (SELECT name FROM sys.backup_devices WHERE name = 'AW_Log_Device')
    EXEC sp_dropdevice 'AW_Log_Device';
GO

-- Criação dos Dispositivos Lógicos 
EXEC sp_addumpdevice 'disk', 'AW_Full_Device', '/var/opt/mssql/data/AdventureWorks_Full.bak';
EXEC sp_addumpdevice 'disk', 'AW_Diff_Device', '/var/opt/mssql/data/AdventureWorks_Diff.bak';
EXEC sp_addumpdevice 'disk', 'AW_Log_Device',  '/var/opt/mssql/data/AdventureWorks_Log.trn';
GO

-------------------------------------------
-- 2. EXECUÇÃO DA ESTRATÉGIA (Simulação) --
-------------------------------------------

-- Backup Completo
BACKUP DATABASE AdventureWorks 
TO AW_Full_Device 
WITH FORMAT, NAME = 'AdventureWorks Full Backup';
GO

-- Backup de Log (Simulação: Transações iniciais)
BACKUP LOG AdventureWorks 
TO AW_Log_Device 
WITH FORMAT, NAME = 'Log Backup 1';
GO

-- Backup Diferencial
-- Captura mudanças desde o Full
BACKUP DATABASE AdventureWorks 
TO AW_Diff_Device 
WITH FORMAT, DIFFERENTIAL, NAME = 'AdventureWorks Diff Backup';
GO

PRINT 'Estratégia de Backups concluída em /var/opt/mssql/data/';

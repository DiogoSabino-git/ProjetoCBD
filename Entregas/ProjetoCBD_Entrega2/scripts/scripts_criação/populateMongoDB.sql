-- Diogo Sabino nº202300149
-- Rodrigo Antunes nº2024151048
--
-- Script PopulateMongoDB

-- Gerar 50 registos de histórico para a tabela access logs
INSERT INTO UserManagement.AccessLogs (UserEmail, AccessDate, ActionType, IPAddress, [Status])
SELECT TOP 50
    U.userEmail,
    DATEADD(HOUR, -ABS(CHECKSUM(NEWID()) % 720), GETDATE()), -- Últimos 30 dias
    CASE ABS(CHECKSUM(NEWID()) % 4)
        WHEN 0 THEN 'LOGIN'
        WHEN 1 THEN 'LOGOUT'
        WHEN 2 THEN 'VIEW_REPORT'
        WHEN 3 THEN 'UPDATE_PROFILE'
    END,
    CONCAT('192.168.1.', ABS(CHECKSUM(NEWID()) % 255)),
    CASE WHEN ABS(CHECKSUM(NEWID()) % 10) = 0 THEN 'FAILURE' ELSE 'SUCCESS' END
FROM UserManagement.UserSecurity U
CROSS JOIN (VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10)) AS T(N); -- Multiplicar linhas
GO

-- Verifica se ficaram lá
SELECT * FROM UserManagement.AccessLogs ORDER BY AccessDate DESC;

-- Query para gerar o JSON 
SELECT 
    UserEmail AS [user_email],
    AccessDate AS [timestamp],
    ActionType AS [action],
    IPAddress AS [ip_address],
    Status AS [status]
FROM UserManagement.AccessLogs
ORDER BY AccessDate DESC
FOR JSON PATH, ROOT('logs');
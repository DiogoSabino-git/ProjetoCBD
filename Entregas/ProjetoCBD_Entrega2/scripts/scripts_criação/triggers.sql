-- Diogo Sabino nº202300149
-- Rodrigo Antunes nº2024151048
--
-- Sript Triggers
-- Criação de triggers.


-- Deletes all subcategories after a category is deleted
CREATE OR ALTER TRIGGER trDeleteSubcategories
ON Reference.Category
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Recursively delete subcategories
    ;WITH RecursiveCTE AS (
        SELECT c.categoryID
        FROM Reference.Category c
        INNER JOIN deleted d ON c.parentCategoryID = d.categoryID
        UNION ALL
        SELECT c.categoryID
        FROM Reference.Category c
        INNER JOIN RecursiveCTE r ON c.parentCategoryID = r.categoryID
    )
    DELETE FROM Reference.Category
    WHERE categoryID IN (SELECT categoryID FROM RecursiveCTE);

    -- Delete the parent(s)
    DELETE FROM Reference.Category
    WHERE categoryID IN (SELECT categoryID FROM deleted);
END;
GO

-- Sends an email to the user when the passsword is changed
CREATE OR ALTER TRIGGER trSendEmail
ON UserManagement.UserSecurity
AFTER UPDATE
AS
BEGIN
    IF NOT UPDATE(password) 
        RETURN;
    DECLARE @EmailD VARCHAR(255);

SELECT @EmailD = i.userEmail
FROM inserted i
INNER JOIN deleted d ON i.userEmail = d.userEmail
WHERE i.[password] <> d.[password];

EXEC UserManagement.sp_sendEmail @Email= @EmailD, @Message='A sua password foi alterada com sucesso!';

END;
GO
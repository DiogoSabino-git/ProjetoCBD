-- Deletes all subcategories after a category is deleted
CREATE OR ALTER TRIGGER trDeleteCategory
ON Category
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Recursively delete subcategories
    ;WITH RecursiveCTE AS (
        SELECT c.categoryID
        FROM Category c
        INNER JOIN deleted d ON c.parentCategoryID = d.categoryID
        UNION ALL
        SELECT c.categoryID
        FROM Category c
        INNER JOIN RecursiveCTE r ON c.parentCategoryID = r.categoryID
    )
    DELETE FROM Category
    WHERE categoryID IN (SELECT categoryID FROM RecursiveCTE);

    -- Delete the parent(s)
    DELETE FROM Category
    WHERE categoryID IN (SELECT categoryID FROM deleted);
END;


-- 
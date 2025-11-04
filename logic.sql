---------------------------------
-- SP to add a new Subcategory --
---------------------------------
CREATE OR ALTER PROCEDURE spAddSubcategory
    @SubcategoryName VARCHAR(50),
    @CategoryName VARCHAR (50)
AS
BEGIN
    DECLARE @CategoryID INT;
    SELECT @CategoryID = categoryID
    FROM Category
    WHERE categoryName = @CategoryName;

    IF @CategoryID IS NULL
    BEGIN
        PRINT 'Category not found: ' + @CategoryName;
        RETURN;
    END

    INSERT INTO Category (categoryName, parentCategoryID) VALUES (@SubcategoryName, @CategoryID)
END;
GO

---------------------------------
-- SP to add a new Customer --
---------------------------------
CREATE OR ALTER PROCEDURE spAddCustomer
    @FirstName VARCHAR (50),
    @MiddleName VARCHAR (50),
    @LastName VARCHAR (50),
    @CustomerEmail VARCHAR (255),
    @CustomerPassword VARCHAR (255),
    @SecurityQuestion VARCHAR (100),
    @SecurityAnswer VARCHAR (100),
    @Phone VARCHAR (20),
    @Address VARCHAR (50),
    @PostalCode VARCHAR (10),
    @MartialStatus VARCHAR (15),
    @BirthDate DATE,
    @Education VARCHAR (50),
    @Occupation VARCHAR (50),
    @Gender VARCHAR (50)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM UserSecurity WHERE userEmail = @CustomerEmail)
        BEGIN
    PRINT 'Error: User already exists with this email.';
    RETURN;
        END

    INSERT INTO UserSecurity (userEmail, [password], securityQuestion, securityAnswer)
    VALUES (@CustomerEmail, @CustomerPassword, @SecurityQuestion, @SecurityAnswer)

    IF NOT EXISTS (SELECT 1 FROM [Address] WHERE addressLine1 = @Address AND postalCode = @PostalCode)
        BEGIN
    INSERT INTO [Address] (addressLine1, postalCode, cityID) 
    VALUES (@Address, @PostalCode, 75)
        END

    DECLARE @GenderID INT
    SELECT @GenderID = genderID
    FROM Gender
    WHERE genderName = @Gender;

    DECLARE @OccupationID INT
    SELECT @OccupationID = occupationID
    FROM Occupation
    WHERE occupationName = @Occupation

    DECLARE @EducationID INT
    SELECT @EducationID = educationID
    FROM Education
    WHERE educationName = @Education

    DECLARE @AddressID INT = SCOPE_IDENTITY();

    INSERT INTO Customers (firstName, middleName, lastName, birthDate, martialStatus, genderID, occupationID, educationID, addressID, userEmail)
    VALUES (@FirstName, @MiddleName, @LastName, @BirthDate, @MartialStatus, @GenderID, @OccupationID, @EducationID, @AddressID, @CustomerEmail)
END;
GO

---------------------------
-- SP to delete Customer --
---------------------------

CREATE OR ALTER PROCEDURE spDeleteCustomer
    @CustomerEmail VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;

    BEGIN TRY
        DELETE FROM Customers WHERE userEmail = @CustomerEmail;
        DELETE FROM UserSecurity WHERE userEmail = @CustomerEmail;

        COMMIT TRANSACTION;
        PRINT 'Customer and related data deleted.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

--------------------------
-- SP add to Statistics --
--------------------------

CREATE OR ALTER PROCEDURE spdbstatistics
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TableName NVARCHAR(255);
    DECLARE @SQL NVARCHAR(MAX);
    DECLARE @RowCount INT;
    DECLARE @SpaceUsed DECIMAL(18,2);

    -- Cursor to loop through all user tables in the current database
    DECLARE table_cursor CURSOR FOR
        SELECT QUOTENAME(s.name) + '.' + QUOTENAME(t.name)
        FROM sys.tables t
        INNER JOIN sys.schemas s ON t.schema_id = s.schema_id;

    OPEN table_cursor;
    FETCH NEXT FROM table_cursor INTO @TableName;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        BEGIN TRY
            -- Get number of rows
            SET @SQL = N'SELECT @rcount = COUNT(*) FROM ' + @TableName;
            EXEC sp_executesql @SQL, N'@rcount INT OUTPUT', @rcount = @RowCount OUTPUT;

            -- Get space used (in KB)
            SET @SQL = N'
                SELECT @space = SUM(a.total_pages) * 8.0
                FROM sys.tables t
                INNER JOIN sys.indexes i ON t.object_id = i.object_id
                INNER JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
                INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
                WHERE t.object_id = OBJECT_ID(@tname)';
            EXEC sp_executesql @SQL, 
                N'@tname NVARCHAR(255), @space DECIMAL(18,2) OUTPUT', 
                @tname = @TableName, 
                @space = @SpaceUsed OUTPUT;

            -- Insert stats into the Statistics table
            INSERT INTO [Statistics] (tableName, registersNum, spaceUsedKB, lastUpdate)
            VALUES (@TableName, @RowCount, @SpaceUsed, GETDATE());
        END TRY
        BEGIN CATCH
            PRINT '⚠️ Skipping table: ' + @TableName + ' (Error: ' + ERROR_MESSAGE() + ')';
        END CATCH;

        FETCH NEXT FROM table_cursor INTO @TableName;
    END

    CLOSE table_cursor;
    DEALLOCATE table_cursor;
END;
GO


--------------------------
-- SP edit Customer --
--------------------------
CREATE OR ALTER PROCEDURE spEditFirstName
@ID INT,
@first VARCHAR(50)
AS
BEGIN
    UPDATE Customers
    SET firstName=@first
    WHERE customerID=@ID;
END;
GO

CREATE OR ALTER PROCEDURE spEditMiddleName
@ID INT,
@middle VARCHAR(50)
AS
BEGIN
    UPDATE Customers
    SET middleName=@middle
    WHERE customerID=@ID;
END;
GO

CREATE OR ALTER PROCEDURE spEditLastName
@ID INT,
@last VARCHAR(50)
AS
BEGIN
    UPDATE Customers
    SET lastName=@last
    WHERE customerID=@ID;
END;
GO

CREATE OR ALTER PROCEDURE spEdityearlyIncome
@ID INT,
@income DECIMAL (10,2)
AS
BEGIN
    UPDATE Customers
    SET yearlyIncome=@income
    WHERE customerID=@ID;
END;
GO

CREATE OR ALTER PROCEDURE spEditNumberCars
@ID INT,
@num TINYINT
AS
BEGIN
    UPDATE Customers
    SET numbersCarsOwned=@num
    WHERE customerID=@ID;
END;
GO

CREATE OR ALTER PROCEDURE spEditTitle
@ID INT,
@title VARCHAR (5)
AS
BEGIN
    UPDATE Customers
    SET title=@title
    WHERE customerID=@ID;
END;
GO

CREATE OR ALTER PROCEDURE spEditMartialStatus
@ID INT,
@stat VARCHAR (15)
AS
BEGIN
    UPDATE Customers
    SET martialStatus=@stat
    WHERE customerID=@ID;
END;
GO

CREATE OR ALTER PROCEDURE spEditGender
@ID INT,
@gender TINYINT
AS
BEGIN
    UPDATE Customers
    SET genderID=@gender
    WHERE customerID=@ID;
END;
GO

CREATE OR ALTER PROCEDURE spEditOccupation
@ID INT,
@occuption TINYINT
AS
BEGIN
    UPDATE Customers
    SET occupationID=@occuption
    WHERE customerID=@ID;
END;
GO

CREATE OR ALTER PROCEDURE spEditEducation
@ID INT,
@education TINYINT
AS
BEGIN
    UPDATE Customers
    SET educationID=@education
    WHERE customerID=@ID;
END;
GO

CREATE OR ALTER PROCEDURE spEditAddress
    @ID INT,
    @AddressID INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Customers WHERE customerID = @ID)
    BEGIN
        PRINT'Error: Customer not found.';
    END;

    IF NOT EXISTS (SELECT 1 FROM Address WHERE addressID = @AddressID)
    BEGIN
        PRINT 'Error: Address not found.';
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE Customers
        SET addressID = @AddressID
        WHERE customerID = @ID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO

CREATE OR ALTER PROCEDURE spEditUserEmail
@ID INT,
@email VARCHAR(255)
AS
BEGIN TRY
    BEGIN TRANSACTION
    IF EXISTS (SELECT 1 FROM UserSecurity WHERE userEmail = @email)
        BEGIN
    PRINT 'Error: User already exists with this email.';
    RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM Customers WHERE customerID = @ID)
BEGIN
    PRINT 'Error: Customer not found.';
END

    DECLARE @emailA VARCHAR(255);

    SELECT @emailA = userEmail
    FROM Customers
    WHERE customerID=@ID;

     INSERT INTO UserSecurity (userEmail, [password], securityQuestion, securityAnswer, phone)
        SELECT @email, [password], securityQuestion, securityAnswer, phone
        FROM UserSecurity
        WHERE userEmail = @emailA;

    UPDATE Customers
    SET userEmail=@email
    WHERE userEmail=@emailA;

    DELETE FROM UserSecurity
        WHERE userEmail = @emailA;
    
COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    THROW;
END CATCH









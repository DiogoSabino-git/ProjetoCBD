---------------------------------
-- SP to add a new Subcategory --
---------------------------------
CREATE OR ALTER PROCEDURE Reference.spAddSubcategory
    @SubcategoryName VARCHAR(50),
    @CategoryName VARCHAR (50)
AS
BEGIN
    DECLARE @CategoryID INT;
    SELECT @CategoryID = categoryID
    FROM Reference.Category
    WHERE categoryName = @CategoryName;

    IF @CategoryID IS NULL
    BEGIN
        PRINT 'Category not found: ' + @CategoryName;
        RETURN;
    END

    INSERT INTO Reference.Category (categoryName, parentCategoryID) VALUES (@SubcategoryName, @CategoryID)
END;
GO


---------------------------------
-- SP to add a new Customer --
---------------------------------
CREATE OR ALTER PROCEDURE Sales.spAddCustomer
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
    IF EXISTS (SELECT 1 FROM UserManagement.UserSecurity WHERE userEmail = @CustomerEmail)
        BEGIN
    PRINT 'Error: User already exists with this email.';
    RETURN;
        END

    INSERT INTO UserManagement.UserSecurity (userEmail, [password], securityQuestion, securityAnswer)
    VALUES (@CustomerEmail, @CustomerPassword, @SecurityQuestion, @SecurityAnswer)

    IF NOT EXISTS (SELECT 1 FROM Location.Address WHERE addressLine1 = @Address AND postalCode = @PostalCode)
        BEGIN
    INSERT INTO Location.Address (addressLine1, postalCode, cityID) 
    VALUES (@Address, @PostalCode, 75)
        END

    DECLARE @GenderID INT
    SELECT @GenderID = genderID
    FROM Reference.Gender
    WHERE genderName = @Gender;

    DECLARE @OccupationID INT
    SELECT @OccupationID = occupationID
    FROM Reference.Occupation
    WHERE occupationName = @Occupation

    DECLARE @EducationID INT
    SELECT @EducationID = educationID
    FROM Reference.Education
    WHERE educationName = @Education

    DECLARE @AddressID INT = SCOPE_IDENTITY();

    INSERT INTO Sales.Customers (firstName, middleName, lastName, birthDate, martialStatus, genderID, occupationID, educationID, addressID, userEmail)
    VALUES (@FirstName, @MiddleName, @LastName, @BirthDate, @MartialStatus, @GenderID, @OccupationID, @EducationID, @AddressID, @CustomerEmail)
END;
GO


---------------------------
-- SP to delete Customer --
---------------------------
CREATE OR ALTER PROCEDURE Sales.spDeleteCustomer
    @CustomerEmail VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;

    BEGIN TRY
        DELETE FROM Sales.Customers WHERE userEmail = @CustomerEmail;
        DELETE FROM UserManagement.UserSecurity WHERE userEmail = @CustomerEmail;

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
CREATE OR ALTER PROCEDURE Monitoring.spdbstatistics
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
            INSERT INTO Monitoring.[Statistics] (tableName, registersNum, spaceUsedKB, lastUpdate)
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

-- Edit First Name
CREATE OR ALTER PROCEDURE Sales.spEditFirstName
@ID INT,
@first VARCHAR(50)
AS
BEGIN
    UPDATE Sales.Customers
    SET firstName=@first
    WHERE customerID=@ID;
END;
GO

-- Edit Middle Name
CREATE OR ALTER PROCEDURE Sales.spEditMiddleName
@ID INT,
@middle VARCHAR(50)
AS
BEGIN
    UPDATE Sales.Customers
    SET middleName=@middle
    WHERE customerID=@ID;
END;
GO

-- Edit Last Name
CREATE OR ALTER PROCEDURE Sales.spEditLastName
@ID INT,
@last VARCHAR(50)
AS
BEGIN
    UPDATE Sales.Customers
    SET lastName=@last
    WHERE customerID=@ID;
END;
GO

-- Edit Yearly Income
CREATE OR ALTER PROCEDURE Sales.spEdityearlyIncome
@ID INT,
@income DECIMAL (10,2)
AS
BEGIN
    UPDATE Sales.Customers
    SET yearlyIncome=@income
    WHERE customerID=@ID;
END;
GO

-- Edit Number of Cars
CREATE OR ALTER PROCEDURE Sales.spEditNumberCars
@ID INT,
@num TINYINT
AS
BEGIN
    UPDATE Sales.Customers
    SET numbersCarsOwned=@num
    WHERE customerID=@ID;
END;
GO

-- Edit Title
CREATE OR ALTER PROCEDURE Sales.spEditTitle
@ID INT,
@title VARCHAR (5)
AS
BEGIN
    UPDATE Sales.Customers
    SET title=@title
    WHERE customerID=@ID;
END;
GO

-- Edit Martial Status
CREATE OR ALTER PROCEDURE Sales.spEditMartialStatus
@ID INT,
@stat VARCHAR (15)
AS
BEGIN
    UPDATE Sales.Customers
    SET martialStatus=@stat
    WHERE customerID=@ID;
END;
GO

-- Edit Gender
CREATE OR ALTER PROCEDURE Sales.spEditGender
@ID INT,
@gender VARCHAR (50)
AS
BEGIN
    DECLARE @GenderID INT;

    SELECT @GenderID = genderID
    FROM Reference.Gender
    WHERE genderName = @gender;

    IF @GenderID IS NULL
    BEGIN
        PRINT 'Error: Gender does not exist. (Polémico)'
        RETURN;
    END

    UPDATE Sales.Customers
    SET genderID = @GenderID
    WHERE customerID = @ID;
END;
GO

-- Edit Occupation
CREATE OR ALTER PROCEDURE Sales.spEditOccupation
@ID INT,
@occupation VARCHAR (50)
AS
BEGIN
    DECLARE @OccupationID INT;
    
    SELECT @OccupationID = occupationID
    FROM Reference.Occupation
    WHERE occupationName = @occupation;
    
    IF @OccupationID IS NULL
    BEGIN
        PRINT 'Error: Occupation does not exist.';
        RETURN;
    END

    UPDATE Sales.Customers        
    SET occupationID = @OccupationID
    WHERE customerID = @ID;
END;
GO

-- Edit Education
CREATE OR ALTER PROCEDURE Sales.spEditEducation
@ID INT,
@education VARCHAR (50)
AS
BEGIN
    DECLARE @EducationID INT;
    
    SELECT @EducationID = educationID
    FROM Reference.Education
    WHERE educationName = @education;

    IF @EducationID IS NULL
    BEGIN
        PRINT 'Error: Education does not exist. (Tenso)'
        RETURN;
    END

    UPDATE Sales.Customers
    SET educationID=@EducationID
    WHERE customerID=@ID;
END;
GO

-- Edit Address
CREATE OR ALTER PROCEDURE Sales.spEditAddress
    @ID INT,
    @Address VARCHAR(50),
    @postal VARCHAR(10)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Sales.Customers WHERE customerID = @ID)
    BEGIN
        PRINT'Error: Customer not found.';
    END;

    IF NOT EXISTS (SELECT 1 FROM Location.Address WHERE addressLine1 = @Address AND postalCode=@postal)
    BEGIN
        INSERT INTO Location.Address VALUES(@Address, @postal, 285)
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @IdAddress INT;

        SELECT @IdAddress = addressID
        FROM Location.Address
        where addressLine1 = @Address AND postalCode=@postal;

        UPDATE Sales.Customers
        SET addressID = @IdAddress
        WHERE customerID = @ID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO

-- Edit User Email
CREATE OR ALTER PROCEDURE Sales.spEditUserEmail
@ID INT,
@email VARCHAR(255)
AS
BEGIN TRY
    BEGIN TRANSACTION
    IF EXISTS (SELECT 1 FROM UserManagement.UserSecurity WHERE userEmail = @email)
        BEGIN
    PRINT 'Error: User already exists with this email.';
    RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM Sales.Customers WHERE customerID = @ID)
BEGIN
    PRINT 'Error: Customer not found.';
END

    DECLARE @emailA VARCHAR(255);

    SELECT @emailA = userEmail
    FROM Sales.Customers
    WHERE customerID=@ID;

     INSERT INTO UserManagement.UserSecurity (userEmail, [password], securityQuestion, securityAnswer, phone)
        SELECT @email, [password], securityQuestion, securityAnswer, phone
        FROM UserManagement.UserSecurity
        WHERE userEmail = @emailA;

    UPDATE Sales.Customers
    SET userEmail=@email
    WHERE userEmail=@emailA;

    DELETE FROM UserManagement.UserSecurity
        WHERE userEmail = @emailA;
    
COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    THROW;
END CATCH
GO

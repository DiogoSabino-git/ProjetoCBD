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

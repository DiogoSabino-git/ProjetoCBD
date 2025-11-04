--------------------------------
-- Subcategories Trigger Test --
--------------------------------
select * from Category;

-- Insert test data
INSERT INTO Category (categoryName, parentCategoryID) VALUES ('Electronics', NULL);  -- 1
INSERT INTO Category (categoryName, parentCategoryID) VALUES ('Phones', 42);          -- 2
INSERT INTO Category (categoryName, parentCategoryID) VALUES ('Smartphones', 42);     -- 3
INSERT INTO Category (categoryName, parentCategoryID) VALUES ('Laptops', 42);         -- 4
INSERT INTO Category (categoryName, parentCategoryID) VALUES ('Gaming Laptops', 42);  -- 5

SELECT * FROM Category ORDER BY categoryID;

-- Delete the Electronics category and all its subcategories
DELETE FROM Category WHERE categoryName = 'Electronics';

-- Check results
SELECT * FROM Category ORDER BY categoryID;

SELECT name, is_instead_of_trigger
FROM sys.triggers
WHERE parent_id = OBJECT_ID('Category');

DBCC CHECKIDENT ('Category', RESEED, 41);


--------------------------
-- Add Subcategory Test --
--------------------------

INSERT INTO Category (categoryName, parentCategoryID) VALUES ('Electronics', NULL);

EXEC spAddSubcategory @SubcategoryName = 'Smartphones', @CategoryName = 'Electronics';

SELECT * FROM Category ORDER BY categoryID;

DELETE FROM Category WHERE categoryName = 'Electronics';

SELECT * FROM Category ORDER BY categoryID;

DBCC CHECKIDENT ('Category', RESEED, 41);

-----------------------
-- Add Customer Test --
-----------------------

EXEC spAddCustomer @FirstName = 'Lúcio', @MiddleName = 'Correia', @LastName = 'Dos Santos', @CustomerEmail = 'luciocdssds@gmail.com', 
                    @CustomerPassword = 'frogger123', @SecurityQuestion = 'Why are you so angry?', @SecurityAnswer = 'boop', 
                    @Phone = '111111111', @Address = 'Paraíso', @PostalCode = '2805', @MartialStatus = "S", @BirthDate = '1930-01-10', 
                    @Education = 'Bachelors', @Occupation = "Professional", @Gender = "M";

select * from Customers
where firstName = 'Lúcio';

select * from [Address]
where addressLine1 = 'Paraíso';

select * from [Address]
where addressID = 20072;

--------------------------
-- Delete Customer Test --
--------------------------

EXEC spDeleteCustomer @CustomerEmail = 'luciocdssds@gmail.com';

select * from Customers c
join UserSecurity u ON c.userEmail = u.userEmail
where c.userEmail = 'luciocdssds@gmail.com';

--------------------------
-- spEditFirstName Test --
--------------------------

EXEC Sales.spAddCustomer @FirstName = 'Lúcio', @MiddleName = 'Correia', @LastName = 'Dos Santos', @CustomerEmail = 'luciocdssds@gmail.com', 
                    @CustomerPassword = 'frogger123', @SecurityQuestion = 'Why are you so angry?', @SecurityAnswer = 'boop', 
                    @Phone = '111111111', @Address = 'Paraíso', @PostalCode = '2805', @MartialStatus = "S", @BirthDate = '1930-01-10', 
                    @Education = 'Bachelors', @Occupation = "Professional", @Gender = "M";

select * from Sales.Customers where firstName = 'Lúcio';

EXEC Sales.spEditFirstName @ID = 20070, @first = 'Luciano';

select * from Sales.Customers where firstName = 'Luciano';

--------------------------
-- spEditMiddleName Test --
--------------------------

EXEC Sales.spEditMiddleName @ID = 20070, @middle = 'Corrente';
select * from Sales.Customers where middleName = 'Corrente';

--------------------------
-- spEditLastName Test --
--------------------------

EXEC Sales.spEditlastName @ID = 20070, @last = 'Abreu';
select * from Sales.Customers where lastName = 'Abreu';

-----------------------------
-- spEditYearlyIncome Test --
-----------------------------

select * from Sales.Customers where customerID = 1;
EXEC Sales.spEditYearlyIncome @ID = 1, @income = 10000;
select * from Sales.Customers where customerID = 1;

---------------------------
-- spEditNumberCars Test --
---------------------------

select * from Sales.Customers where customerID = 1;
EXEC Sales.spEditNumberCars @ID = 1, @num = 2;
select * from Sales.Customers where customerID = 1;

----------------------
-- spEditTitle Test --
----------------------

select * from Sales.Customers where customerID = 1;
EXEC Sales.spEditTitle @ID = 1, @title = Ms;
select * from Sales.Customers where customerID = 1;

------------------------------
-- spEditMartialStatus Test --
------------------------------

select * from Sales.Customers where customerID = 1;
EXEC Sales.spEditMartialStatus @ID = 1, @stat = M;
select * from Sales.Customers where customerID = 1;

-----------------------
-- spEditGender Test --
-----------------------

select * from Sales.Customers where customerID = 1;
EXEC Sales.spEditGender @ID = 1, @gender = 'M';
select * from Sales.Customers where customerID = 1;

select * from Reference.Gender;

---------------------------
-- spEditOccupation Test --
---------------------------

select * from Sales.Customers where customerID = 1;
EXEC Sales.spEditOccupation @ID = 1, @occupation = 'Manual';
select * from Sales.Customers where customerID = 1;

--------------------------
-- spEditEducation Test --
--------------------------

select * from Sales.Customers where customerID = 1;
select * from Reference.Education;
EXEC Sales.spEditEducation @ID = 1, @education = 'Bachelors';
select * from Sales.Customers where customerID = 1;

------------------------
-- spEditAddress Test --
------------------------

-----------------------
-- spEditEmail Test ---
-----------------------

-------------------------------
-- EXEC Statistics Procedure --
-------------------------------
EXEC spdbStatistics;

-- Before migration

select * from [Statistics];

-- After migration

select * from [Statistics];


EXEC spEditUserEmail
    @ID = 1,
    @email = 'jeremy.roberts@newmail.com';


    SELECT name AS SchemaName
FROM sys.schemas
ORDER BY name;

-----------------------
-- Test vFullAddress --
-----------------------

select * from Location.vFullAddress;

--------------------------------------
-- Test UserManagement.vUserProfile --
--------------------------------------

select * from UserManagement.vUserProfile;

------------------------------
-- Test Sales.vOrderDetails --
------------------------------

select * from Sales.vOrderDetails;

--------------------------------
-- Test Sales.vCustomerOrders --
--------------------------------

select * from Sales.vCustomerOrders;

-------------------------------------
-- Test Sales.vProductSalesSummary --
-------------------------------------

select * from Sales.vProductSalesSummary;


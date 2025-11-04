--------------------------------
-- Subcategories Trigger Test --
--------------------------------
select * from Reference.Category;

-- Insert test data
INSERT INTO Reference.Category (categoryName, parentCategoryID) VALUES ('Electronics', NULL);  -- 1
INSERT INTO Reference.Category (categoryName, parentCategoryID) VALUES ('Phones', 42);          -- 2
INSERT INTO Reference.Category (categoryName, parentCategoryID) VALUES ('Smartphones', 42);     -- 3
INSERT INTO Reference.Category (categoryName, parentCategoryID) VALUES ('Laptops', 42);         -- 4
INSERT INTO Reference.Category (categoryName, parentCategoryID) VALUES ('Gaming Laptops', 42);  -- 5

SELECT * FROM Reference.Category ORDER BY categoryID;

-- Delete the Electronics category and all its subcategories
DELETE FROM Reference.Category WHERE categoryName = 'Electronics';

-- Check results
SELECT * FROM Reference.Category ORDER BY categoryID;

DBCC CHECKIDENT ('Category', RESEED, 41);


--------------------------
-- Add Subcategory Test --
--------------------------

INSERT INTO Reference.Category (categoryName, parentCategoryID) VALUES ('Electronics', NULL);

EXEC spAddSubcategory @SubcategoryName = 'Smartphones', @CategoryName = 'Electronics';

SELECT * FROM Reference.Category ORDER BY categoryID;

DELETE FROM Reference.Category WHERE categoryName = 'Electronics';

SELECT * FROM Reference.Category ORDER BY categoryID;

DBCC CHECKIDENT ('Category', RESEED, 41);

-----------------------
-- Add Customer Test --
-----------------------

EXEC Sales.spAddCustomer @FirstName = 'Lúcio', @MiddleName = 'Correia', @LastName = 'Dos Santos', @CustomerEmail = 'luciocdssds@gmail.com', 
                    @CustomerPassword = 'frogger123', @SecurityQuestion = 'Why are you so angry?', @SecurityAnswer = 'boop', 
                    @Phone = '111111111', @Address = 'Paraíso', @PostalCode = '2805', @MartialStatus = "S", @BirthDate = '1930-01-10', 
                    @Education = 'Bachelors', @Occupation = "Professional", @Gender = "M";

select * from Sales.Customers
where firstName = 'Lúcio';

select * from [Location.Address]
where addressLine1 = 'Paraíso';

select * from [Location.Address]
where addressID = 20072;

--------------------------
-- Delete Customer Test --
--------------------------

EXEC Sales.spDeleteCustomer @CustomerEmail = 'luciocdssds@gmail.com';

select * from Sales.Customers c
join UserManagement.UserSecurity u ON c.userEmail = u.userEmail
where c.userEmail = 'luciocdssds@gmail.com';

--------------------------
-- spEditFirstName Test --
--------------------------

EXEC Sales.spAddCustomer @FirstName = 'Lúcio', @MiddleName = 'Correia', @LastName = 'Dos Santos', @CustomerEmail = 'luciocdssds@gmail.com', 
                    @CustomerPassword = 'frogger123', @SecurityQuestion = 'Why are you so angry?', @SecurityAnswer = 'boop', 
                    @Phone = '111111111', @Address = 'Paraíso', @PostalCode = '2805', @MartialStatus = "S", @BirthDate = '1930-01-10', 
                    @Education = 'Bachelors', @Occupation = "Professional", @Gender = "M";

select * from Sales.Customers where firstName = 'Lúcio';

EXEC Sales.spEditFirstName @ID = 20071, @first = 'Luciano';

select * from Sales.Customers where firstName = 'Luciano';

--------------------------
-- spEditMiddleName Test --
--------------------------

EXEC Sales.spEditMiddleName @ID = 20071, @middle = 'Corrente';
select * from Sales.Customers where middleName = 'Corrente';

--------------------------
-- spEditLastName Test --
--------------------------

EXEC Sales.spEditlastName @ID = 20071, @last = 'Abreu';
select * from Sales.Customers where lastName = 'Abreu';

-----------------------------
-- spEditYearlyIncome Test --
-----------------------------

select * from Sales.Customers where customerID = 20071;
EXEC Sales.spEditYearlyIncome @ID = 20071, @income = 10000;
select * from Sales.Customers where customerID = 20071;

---------------------------
-- spEditNumberCars Test --
---------------------------

select * from Sales.Customers where customerID = 20071;
EXEC Sales.spEditNumberCars @ID = 20071, @num = 2;
select * from Sales.Customers where customerID = 20071;

----------------------
-- spEditTitle Test --
----------------------

select * from Sales.Customers where customerID = 20071;
EXEC Sales.spEditTitle @ID = 20071, @title = Ms;
select * from Sales.Customers where customerID = 20071;

------------------------------
-- spEditMartialStatus Test --
------------------------------

select * from Sales.Customers where customerID = 20071;
EXEC Sales.spEditMartialStatus @ID = 20071, @stat = M;
select * from Sales.Customers where customerID = 20071;

-----------------------
-- spEditGender Test --
-----------------------

select * from Sales.Customers where customerID = 1;
EXEC Sales.spEditGender @ID = 1, @gender = 'F';
select * from Sales.Customers where customerID = 1;

select * from Reference.Gender;

---------------------------
-- spEditOccupation Test --
---------------------------

select * from Sales.Customers where customerID = 1;
EXEC Sales.spEditOccupation @ID = 1, @occupation = 'Professional';
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
select * from [Location].Address where addressLine1 = '1085 Greenbelt Way';
select * from Sales.Customers where customerID = 1;
EXEC Sales.spEditAddress @ID = 1, @address = '1085 Greenbelt Way', @postal = 90012;
select * from Sales.Customers where customerID =1;

-----------------------
-- spEditEmail Test ---
-----------------------
select * from UserManagement.UserSecurity where userEmail='kendra14@adventure-works.com';
select * from Sales.Customers where customerID=1;
EXEC Sales.spEditUserEmail @ID = 1, @email = 'kendra14@adventure-works-new.com';
select * from Sales.Customers where customerID=1;

-------------------------------
-- EXEC Statistics Procedure --
-------------------------------
EXEC spdbStatistics;

-- Before migration

select * from [Statistics];

-- After migration

select * from [Statistics];

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


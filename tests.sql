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
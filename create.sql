CREATE DATABASE AdventureWorks
ON
PRIMARY (
    NAME = AdventurePrimary,
    FILENAME = '/var/opt/mssql/data/AdventurePrimary.mdf',
    SIZE = 1MB,
    MAXSIZE = 20MB,
    FILEGROWTH = 1MB
),
FILEGROUP AdventureSecondaryFG
(
    NAME = AdventureSecondary,
    FILENAME = '/var/opt/mssql/data/AdventureSecondary.mdf',
    SIZE = 25MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 10MB 
),
FILEGROUP LogFileGroup
(
    NAME = AdventureLogsData,
    FILENAME = '/var/opt/mssql/data/AdventureLogsData.ndf',
    SIZE = 50MB,
    MAXSIZE = 500MB,
    FILEGROWTH = 50MB
)
LOG ON (
    NAME = AdventureLogs,
    FILENAME = '/var/opt/mssql/data/AdventureLogs.ldf',
    SIZE = 100MB,
    MAXSIZE = 1GB,
    FILEGROWTH = 100MB
);
GO

----------------------------------------------------------
-- GROUP, COUNTRY, REGION, STATEPROVINCE, City, Address --
----------------------------------------------------------

CREATE TABLE [Group] (
    groupID TINYINT IDENTITY(1,1) PRIMARY KEY,
    groupName VARCHAR(50) NOT NULL,
)ON [PRIMARY];

CREATE TABLE Country (
    countryID INT IDENTITY(1,1) PRIMARY KEY,
    countryName VARCHAR(50) NOT NULL,
    groupID TINYINT NOT NULL,
    FOREIGN KEY (groupID) REFERENCES [Group](groupID)
)ON [PRIMARY];

CREATE TABLE Region (
    regionID INT IDENTITY(1,1) PRIMARY KEY,
    regionName VARCHAR(50) NOT NULL,
    countryID INT NOT NULL,
    FOREIGN KEY (countryID) REFERENCES [Country](countryID)
)ON [PRIMARY];

CREATE TABLE StateProvince (
    stateProvinceID INT IDENTITY(1,1) PRIMARY KEY,
    stateProvinceName VARCHAR(50) NOT NULL,
    regionID INT NOT NULL,
    FOREIGN KEY (regionID) REFERENCES [Region](regionID)
)ON [PRIMARY];

CREATE TABLE City (
    cityID INT IDENTITY(1,1) PRIMARY KEY,
    cityName VARCHAR(50) NOT NULL,
    postalCode VARCHAR(10),
    stateProvinceID INT NOT NULL,
    FOREIGN KEY (stateProvinceID) REFERENCES [StateProvince](stateProvinceID)
)ON [AdventureSecondaryFG];

CREATE TABLE Address (
    addressID INT IDENTITY(1,1) PRIMARY KEY,
    addressLine1 VARCHAR(50) NOT NULL,
    cityID INT NOT NULL,
    FOREIGN KEY (cityID) REFERENCES [City](cityID)
)ON [AdventureSecondaryFG];

------------------------------
-- SENTEMAILS, USERSECURITY --
------------------------------

CREATE TABLE SentEmails (
    sentEmailsID INT IDENTITY(1,1) PRIMARY KEY,
    [message] VARCHAR(100) NOT NULL,
    [timestamp] DATETIME NOT NULL,
    destination VARCHAR(255) NOT NULL,
)ON [LogFileGroup];

CREATE TABLE UserSecurity (
    userEmail VARCHAR (255) PRIMARY KEY,
    [password] VARCHAR (255) NOT NULL,
    securityQuestion VARCHAR (100),
    securityAnswer VARCHAR (100),
    phone VARCHAR (20)
)ON [AdventureSecondaryFG];

-----------------------------------
-- OCCUPATION, EDUCATION, GENDER --
-----------------------------------

CREATE TABLE Occupation (
    occupationID TINYINT IDENTITY(1,1) PRIMARY KEY,
    occupationName VARCHAR (50) NOT NULL
)ON [PRIMARY];

CREATE TABLE Education (
    educationID TINYINT IDENTITY(1,1) PRIMARY KEY,
    educationName VARCHAR (50) NOT NULL
)ON [PRIMARY];
CREATE TABLE Gender (
    genderID TINYINT IDENTITY(1,1) PRIMARY KEY,
    genderName VARCHAR (50) NOT NULL
)ON [PRIMARY];

---------------------
-- CATEGORY, COLOR --
---------------------

CREATE TABLE Category (
    categoryID INT IDENTITY(1,1) PRIMARY KEY,
    categoryName VARCHAR (50) NOT NULL,
    parentCategoryID INT NULL, 
    CONSTRAINT fkParent
        FOREIGN KEY (parentCategoryID)
        REFERENCES Category(categoryID)
        ON DELETE NO ACTION
)ON [PRIMARY];

CREATE TABLE Color (
    colorID TINYINT IDENTITY(1,1) PRIMARY KEY,
    colorName VARCHAR (20) NOT NULL
)ON [PRIMARY];

--------------
-- CURRENCY --
--------------

CREATE TABLE Currency (
    currencyID INT IDENTITY(1,1) PRIMARY KEY,
    currencyName VARCHAR (50) NOT NULL,
    curencyAlternateKey CHAR (3)
)ON [PRIMARY];

--------------
-- PRODUCTS --
--------------

CREATE TABLE Products (
    productID INT IDENTITY(1,1) PRIMARY KEY,
    productName VARCHAR (50) NOT NULL,
    modelName VARCHAR (50),
    sizeRange VARCHAR (20), 
    description VARCHAR (200),
    class CHAR(1),
    style CHAR(1),
    [weight] DECIMAL(5,2), 
    weightUnitMeasureCode CHAR(2), 
    standardCost DECIMAL(10, 6), 
    listPrice DECIMAL(10, 6),
    dealerPrice DECIMAL(10, 6),
    safetyStockLevel SMALLINT,
    daysToManufacture TINYINT,
    finishedGoodFlag CHAR(5),
    productLine CHAR(1) ,
    colorID TINYINT, 
    categoryID INT,
    FOREIGN KEY (colorID) REFERENCES [Color](colorID),
    FOREIGN KEY (categoryID) REFERENCES [Category](categoryID)
)ON [AdventureSecondaryFG];

---------------
-- CUSTOMERS --
---------------

CREATE TABLE Customers (
    customerID INT IDENTITY(1,1) PRIMARY KEY,
    firstName VARCHAR (50) NOT NULL,
    middleName VARCHAR (50),
    lastName VARCHAR (50) NOT NULL,
    brithDate DATE NOT NULL,
    yearlyIncome DECIMAL (10,2),
    numbersCarsOwned TINYINT,
    dateFirstPurchase DATE,
    title VARCHAR (5),
    martialStatus VARCHAR (15),
    genderID TINYINT,
    occupationID TINYINT,
    addressID INT,
    userEmail VARCHAR(255),
    FOREIGN KEY (genderID) REFERENCES [Gender](genderID),
    FOREIGN KEY (occupationID) REFERENCES [Occupation](occupationID),
    FOREIGN KEY (addressID) REFERENCES [Address](addressID),
    FOREIGN KEY (userEmail) REFERENCES [UserSecurity](userEmail)
)ON [AdventureSecondaryFG];

--------------------------------
-- SALESORDER, SALESORDERLINE --
--------------------------------

CREATE TABLE SalesOrder (
    salesOrderID INT IDENTITY(1,1) PRIMARY KEY,
    orderDate DATE,
    dueDate DATE,
    shipDate DATE,
    freight DECIMAL (5,2),
    taxAmt DECIMAL (7,3),
    totalSalesAmt DECIMAL (10,2),
    customerID INT,
    currencyID INT,
    FOREIGN KEY (customerID) REFERENCES [Customers](customerID),
    FOREIGN KEY (currencyID) REFERENCES [Currency](currencyID),
)ON [AdventureSecondaryFG];

CREATE TABLE SalesOrderLine (
    salesOrderLineNumber TINYINT,
    unitPrice DECIMAL (9,3),
    salesOrderID INT,
    productID INT,
    PRIMARY KEY (salesOrderID, salesOrderLineNumber),
    FOREIGN KEY (productID) REFERENCES [Products](productID),
    CONSTRAINT fkSalesOrderLine
        FOREIGN KEY (salesOrderID)
        REFERENCES SalesOrder(salesOrderID)
        ON DELETE CASCADE

)ON [AdventureSecondaryFG];


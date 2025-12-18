-- Diogo Sabino nº202300149
-- Rodrigo Antunes nº2024151048
--
-- Sript Create
-- Criação de filegroups, shemas e tabelas.


---------------------------------------------
-- CRIAÇÃO DA BASE DE DADOS COM FILEGROUPS --
---------------------------------------------

CREATE DATABASE AdventureWorks
ON
PRIMARY (
    NAME = AdventurePrimary,
    FILENAME = '/var/opt/mssql/data/AdventurePrimary.mdf',
    SIZE = 2MB,
    MAXSIZE = 20MB,
    FILEGROWTH = 1MB
),
FILEGROUP AdventureSecondaryFG
(
    NAME = AdventureSecondary,
    FILENAME = '/var/opt/mssql/data/AdventureSecondary.mdf',
    SIZE = 10MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 10MB 
),
FILEGROUP LogFileGroup
(
    NAME = AdventureLogsData,
    FILENAME = '/var/opt/mssql/data/AdventureLogsData.ndf',
    SIZE = 15MB,
    MAXSIZE = 500MB,
    FILEGROWTH = 50MB
)
GO

USE AdventureWorks;
GO

-------------------------
-- CRIAÇÃO DOS SCHEMAS --
-------------------------
CREATE SCHEMA Location;
GO
CREATE SCHEMA UserManagement;
GO
CREATE SCHEMA Reference;
GO
CREATE SCHEMA Production;
GO
CREATE SCHEMA Sales;
GO
CREATE SCHEMA Monitoring;
GO


--------------------------------------------------------------------
-- LOCATION: GROUP, COUNTRY, REGION, STATEPROVINCE, CITY, ADDRESS --
--------------------------------------------------------------------

CREATE TABLE Location.[Group] (
    groupID TINYINT IDENTITY(1,1) PRIMARY KEY,
    groupName VARCHAR(50) NOT NULL
) ON [PRIMARY];

CREATE TABLE Location.Country (
    countryID INT IDENTITY(1,1) PRIMARY KEY,
    countryName VARCHAR(50) NOT NULL,
    groupID TINYINT NOT NULL,
    FOREIGN KEY (groupID) REFERENCES Location.[Group](groupID)
) ON [PRIMARY];

CREATE TABLE Location.Region (
    regionID INT IDENTITY(1,1) PRIMARY KEY,
    regionName VARCHAR(50) NOT NULL,
    countryID INT NOT NULL,
    FOREIGN KEY (countryID) REFERENCES Location.Country(countryID)
) ON [PRIMARY];

CREATE TABLE Location.StateProvince (
    stateProvinceID INT IDENTITY(1,1) PRIMARY KEY,
    stateProvinceName VARCHAR(50) NOT NULL,
    regionID INT NOT NULL,
    FOREIGN KEY (regionID) REFERENCES Location.Region(regionID)
) ON [PRIMARY];

CREATE TABLE Location.City (
    cityID INT IDENTITY(1,1) PRIMARY KEY,
    cityName VARCHAR(50) NOT NULL,
    stateProvinceID INT NOT NULL,
    FOREIGN KEY (stateProvinceID) REFERENCES Location.StateProvince(stateProvinceID)
) ON [AdventureSecondaryFG];

CREATE TABLE Location.Address (
    addressID INT IDENTITY(1,1) PRIMARY KEY,
    addressLine1 VARCHAR(50) NOT NULL,
    postalCode VARCHAR(10),
    cityID INT NOT NULL,
    FOREIGN KEY (cityID) REFERENCES Location.City(cityID)
) ON [AdventureSecondaryFG];

----------------------------------------------
-- USERMANAGEMENT: SENTEMAILS, USERSECURITY --
----------------------------------------------

CREATE TABLE UserManagement.SentEmails (
    sentEmailsID INT IDENTITY(1,1) PRIMARY KEY,
    [message] VARCHAR(100) NOT NULL,
    [timestamp] DATETIME NOT NULL,
    destination VARCHAR(255) NOT NULL
) ON [LogFileGroup];

CREATE TABLE UserManagement.UserSecurity (
    userEmail VARCHAR (255) PRIMARY KEY,
    [password] VARCHAR (255) NOT NULL,
    securityQuestion VARCHAR (100),
    securityAnswer VARCHAR (100),
    phone VARCHAR (20)
) ON [AdventureSecondaryFG];

CREATE TABLE UserManagement.AccessLogs (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    UserEmail VARCHAR(255) NOT NULL,
    AccessDate DATETIME DEFAULT GETDATE(),
    ActionType VARCHAR(50),
    IPAddress VARCHAR(45),
    Status VARCHAR(20) CHECK (Status IN ('SUCCESS', 'FAILURE')),
    Description VARCHAR(MAX) NULL,
    
    CONSTRAINT FK_AccessLogs_User FOREIGN KEY (UserEmail) 
    REFERENCES UserManagement.UserSecurity(userEmail)
) ON [LogFileGroup];

-------------------------------------------------------------------------
-- REFERENCE: OCCUPATION, EDUCATION, GENDER, CATEGORY, COLOR, CURRENCY --
-------------------------------------------------------------------------

CREATE TABLE Reference.Occupation (
    occupationID TINYINT IDENTITY(1,1) PRIMARY KEY,
    occupationName VARCHAR (50) NOT NULL
) ON [PRIMARY];

CREATE TABLE Reference.Education (
    educationID TINYINT IDENTITY(1,1) PRIMARY KEY,
    educationName VARCHAR (50) NOT NULL
) ON [PRIMARY];

CREATE TABLE Reference.Gender (
    genderID TINYINT IDENTITY(1,1) PRIMARY KEY,
    genderName VARCHAR (50) NOT NULL
) ON [PRIMARY];

CREATE TABLE Reference.Category (
    categoryID INT IDENTITY(1,1) PRIMARY KEY,
    categoryName VARCHAR (50) NOT NULL,
    parentCategoryID INT NULL, 
    CONSTRAINT fkParentCategory
        FOREIGN KEY (parentCategoryID)
        REFERENCES Reference.Category(categoryID)
        ON DELETE NO ACTION
) ON [PRIMARY];

CREATE TABLE Reference.Color (
    colorID TINYINT IDENTITY(1,1) PRIMARY KEY,
    colorName VARCHAR (20) NOT NULL
) ON [PRIMARY];

CREATE TABLE Reference.Currency (
    currencyID INT IDENTITY(1,1) PRIMARY KEY,
    currencyName VARCHAR (50) NOT NULL,
    currencyAlternateKey CHAR (3)
) ON [PRIMARY];

--------------------------
-- PRODUCTION: PRODUCTS --
--------------------------

CREATE TABLE Production.Products (
    productID INT IDENTITY(1,1) PRIMARY KEY,
    productName VARCHAR (50) NOT NULL,
    modelName VARCHAR (50),
    sizeRange VARCHAR (20), 
    description VARCHAR (500),
    class CHAR(1),
    style CHAR(1),
    [weight] DECIMAL(10,2), 
    weightUnitMeasureCode CHAR(2), 
    standardCost DECIMAL(18, 6), 
    listPrice DECIMAL(18, 6),
    dealerPrice DECIMAL(18, 6),
    safetyStockLevel SMALLINT,
    daysToManufacture TINYINT,
    finishedGoodFlag CHAR(5),
    productLine CHAR(1),
    colorID TINYINT, 
    categoryID INT,
    FOREIGN KEY (colorID) REFERENCES Reference.Color(colorID),
    FOREIGN KEY (categoryID) REFERENCES Reference.Category(categoryID)
) ON [AdventureSecondaryFG];

--------------------------------------------------
-- SALES: CUSTOMERS, SALESORDER, SALESORDERLINE --
--------------------------------------------------

CREATE TABLE Sales.Customers (
    customerID INT IDENTITY(1,1) PRIMARY KEY,
    firstName VARCHAR (50) NOT NULL,
    middleName VARCHAR (50),
    lastName VARCHAR (50) NOT NULL,
    birthDate DATE NOT NULL,
    yearlyIncome DECIMAL (10,2),
    numbersCarsOwned TINYINT,
    dateFirstPurchase DATE,
    title VARCHAR (5),
    martialStatus VARCHAR (15),
    genderID TINYINT,
    occupationID TINYINT,
    educationID TINYINT,
    addressID INT,
    userEmail VARCHAR(255),
    FOREIGN KEY (genderID) REFERENCES Reference.Gender(genderID),
    FOREIGN KEY (occupationID) REFERENCES Reference.Occupation(occupationID),
    FOREIGN KEY (educationID) REFERENCES Reference.Education(educationID),
    FOREIGN KEY (addressID) REFERENCES Location.Address(addressID),
    FOREIGN KEY (userEmail) REFERENCES UserManagement.UserSecurity(userEmail)
) ON [AdventureSecondaryFG];

CREATE TABLE Sales.SalesOrder (
    salesOrderID INT IDENTITY(1,1) PRIMARY KEY,
    orderDate DATE,
    dueDate DATE,
    shipDate DATE,
    freight DECIMAL (5,2),
    taxAmt DECIMAL (7,3),
    totalSalesAmt DECIMAL (10,2),
    customerID INT,
    currencyID INT,
    FOREIGN KEY (customerID) REFERENCES Sales.Customers(customerID),
    FOREIGN KEY (currencyID) REFERENCES Reference.Currency(currencyID)
) ON [AdventureSecondaryFG];

CREATE TABLE Sales.SalesOrderLine (
    salesOrderLineNumber TINYINT,
    unitPrice DECIMAL (9,3),
    salesOrderID INT,
    productID INT,
    PRIMARY KEY (salesOrderID, salesOrderLineNumber),
    FOREIGN KEY (productID) REFERENCES Production.Products(productID),
    CONSTRAINT fkSalesOrderLine
        FOREIGN KEY (salesOrderID)
        REFERENCES Sales.SalesOrder(salesOrderID)
        ON DELETE CASCADE
) ON [AdventureSecondaryFG];

----------------------------
-- MONITORING: STATISTICS --
----------------------------

CREATE TABLE Monitoring.[Statistics] (
    statisticsID INT IDENTITY (1,1) PRIMARY KEY,
    tableName SYSNAME,
    registersNum INT,
    spaceUsedKB DECIMAL(18,2),
    lastUpdate DATE DEFAULT GETDATE()
) ON [LogFileGroup];
GO

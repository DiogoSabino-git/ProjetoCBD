-- Full Address
CREATE VIEW Location.vFullAddress
AS
    SELECT
        a.addressID,
        a.addressLine1,
        a.postalCode,
        c.cityName,
        sp.stateProvinceName,
        r.regionName,
        co.countryName,
        g.groupName
    FROM Location.Address a
        JOIN Location.City c ON a.cityID = c.cityID
        JOIN Location.StateProvince sp ON c.stateProvinceID = sp.stateProvinceID
        JOIN Location.Region r ON sp.regionID = r.regionID
        JOIN Location.Country co ON r.countryID = co.countryID
        JOIN Location.[Group] g ON co.groupID = g.groupID;
GO

-- All of User info
CREATE VIEW UserManagement.vUserProfile
AS
    SELECT
        us.userEmail,
        c.firstName,
        c.lastName,
        c.birthDate,
        c.genderID,
        g.genderName,
        c.occupationID,
        o.occupationName,
        c.educationID,
        e.educationName,
        c.yearlyIncome,
        c.numbersCarsOwned,
        c.dateFirstPurchase,
        c.addressID,
        fa.addressLine1,
        fa.cityName,
        fa.stateProvinceName,
        fa.countryName
    FROM UserManagement.UserSecurity us
        LEFT JOIN Sales.Customers c ON us.userEmail = c.userEmail
        LEFT JOIN Reference.Gender g ON c.genderID = g.genderID
        LEFT JOIN Reference.Occupation o ON c.occupationID = o.occupationID
        LEFT JOIN Reference.Education e ON c.educationID = e.educationID
        LEFT JOIN Location.vFullAddress fa ON c.addressID = fa.addressID;
GO

-- All of Sales Order info
CREATE VIEW Sales.vOrderDetails
AS
    SELECT
        so.salesOrderID,
        sol.salesOrderLineNumber,
        p.productName,
        p.listPrice,
        sol.unitPrice,
        (sol.unitPrice * 1.00) AS lineTotal,
        so.totalSalesAmt,
        so.orderDate,
        so.shipDate,
        c.firstName + ' ' + c.lastName AS customerName,
        cur.currencyName
    FROM Sales.SalesOrder so
        JOIN Sales.SalesOrderLine sol ON so.salesOrderID = sol.salesOrderID
        JOIN Production.Products p ON sol.productID = p.productID
        JOIN Sales.Customers c ON so.customerID = c.customerID
        JOIN Reference.Currency cur ON so.currencyID = cur.currencyID;
GO

-- Customers Sales info
CREATE VIEW Sales.vCustomerOrders
AS
    SELECT
        c.customerID,
        c.firstName + ' ' + c.lastName AS fullName,
        COUNT(so.salesOrderID) AS totalOrders,
        SUM(so.totalSalesAmt) AS totalSpent,
        MAX(so.orderDate) AS lastOrderDate
    FROM Sales.Customers c
        LEFT JOIN Sales.SalesOrder so ON c.customerID = so.customerID
    GROUP BY c.customerID, c.firstName, c.lastName;
GO

-- Sales per Product
CREATE VIEW Sales.vProductSalesSummary AS
SELECT 
    p.productID,
    p.productName,
    COUNT(sol.salesOrderID) AS totalOrders,
    SUM(sol.unitPrice) AS totalRevenue
FROM Production.Products p
JOIN Sales.SalesOrderLine sol ON p.productID = sol.productID
GROUP BY p.productID, p.productName;
GO



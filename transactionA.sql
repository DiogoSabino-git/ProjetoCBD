-- Aumenta 10%
BEGIN TRAN
    DECLARE @Price DECIMAL(18,6);
    
    -- Lê o preço atual (100.00)
    SELECT @Price = listPrice 
    FROM Production.Products 
    WHERE productID = 1;

    WAITFOR DELAY '00:00:10';

    -- Atualiza (100 * 1.10 = 110)
    UPDATE Production.Products
    SET listPrice = @Price * 1.10
    WHERE productID = 1;

    PRINT 'Janela 1: Preço atualizado para ' + CAST(@Price * 1.10 AS VARCHAR);
COMMIT TRAN

-- Solução
BEGIN TRAN
    DECLARE @Price DECIMAL(18,6);
    
    SELECT @Price = listPrice 
    FROM Production.Products WITH (UPDLOCK) 
    WHERE productID = 1;

    WAITFOR DELAY '00:00:10';

    UPDATE Production.Products
    SET listPrice = @Price * 1.10
    WHERE productID = 1;

COMMIT TRAN
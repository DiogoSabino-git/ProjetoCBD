-- Diogo Sabino nº202300149
-- Rodrigo Antunes nº2024151048
--
-- Script TransactionB


-- Aumenta 5€ 
BEGIN TRAN
    DECLARE @Price DECIMAL(18,6);
    
    -- Lê o preço atual (Lê 100.00 porque transaction A ainda não gravou)
    SELECT @Price = listPrice 
    FROM Production.Products 
    WHERE productID = 1;

    -- Atualiza (100 + 5 = 105)
    UPDATE Production.Products
    SET listPrice = @Price + 5
    WHERE productID = 1;

    PRINT 'Janela 2: Preço atualizado para ' + CAST(@Price + 5 AS VARCHAR);
COMMIT TRAN

-- Solução
BEGIN TRAN
    DECLARE @Price DECIMAL(18,6);
    
    SELECT @Price = listPrice 
    FROM Production.Products WITH (UPDLOCK) 
    WHERE productID = 1;

    UPDATE Production.Products
    SET listPrice = @Price + 5
    WHERE productID = 1;

COMMIT TRAN
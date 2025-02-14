CREATE TRIGGER CountTransactionPartialPriceAndVat
ON Transaction_products
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO Transaction_products (transaction_number, product_ean, amount, partial_price, partial_vat)
    SELECT 
        i.transaction_number,
        i.product_ean,
        i.amount,
        ROUND(p.unit_price * i.amount,2) AS partial_price,
        ROUND(p.unit_price * i.amount * p.vat ,2)AS partial_vat
    FROM 
        inserted i
    JOIN 
        Products p ON i.product_ean = p.ean;
END;
GO 

CREATE TRIGGER UpdateOverallPrice/*uwzglednia 5% znizki dla zalogowanych klientow*/
ON Transaction_products
AFTER INSERT, DELETE
AS
BEGIN
    DECLARE @transaction_number INT;

    DECLARE cur CURSOR FOR
    SELECT DISTINCT transaction_number FROM 
    (
        SELECT transaction_number FROM inserted
        UNION
        SELECT transaction_number FROM deleted
    ) as razem;

    OPEN cur;
    FETCH NEXT FROM cur INTO @transaction_number;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        DECLARE @client_id INT;
        SELECT @client_id = client_id FROM Transactions WHERE id = @transaction_number;

        IF EXISTS (SELECT * FROM Clients WHERE id = @client_id AND status = 'aktywny')
        BEGIN
            UPDATE Transactions
            SET overall_price = 
            (
                SELECT SUM(partial_price) * 0.95
                FROM Transaction_products
                WHERE transaction_number = @transaction_number
            )
            WHERE id = @transaction_number;
        END
        ELSE
        BEGIN
            UPDATE Transactions
            SET overall_price = 
            (
                SELECT SUM(partial_price)
                FROM Transaction_products
                WHERE transaction_number = @transaction_number
            )
            WHERE id = @transaction_number;
        END

        FETCH NEXT FROM cur INTO @transaction_number;
    END;

    CLOSE cur;
    DEALLOCATE cur;
END;

GO
CREATE TRIGGER CountDeliveriesPartialPrice
ON Delivery_products
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO Delivery_products (delivery_id,product_ean,amount,partial_cost)
    SELECT 
        i.delivery_id,
        i.product_ean,
        i.amount,
        ROUND(p.unit_price * i.amount,2) AS partial_cost
    FROM 
        inserted i
    JOIN 
        Products p ON i.product_ean = p.ean;
END;

GO
CREATE TRIGGER UpdateProductsCost
ON Delivery_products
AFTER INSERT, DELETE
AS
BEGIN
    DECLARE @delivery_number CHAR(18);

    DECLARE cur CURSOR FOR
    SELECT DISTINCT delivery_id FROM 
    (
        SELECT delivery_id FROM inserted
        UNION
        SELECT delivery_id FROM deleted
    ) as razem;

    OPEN cur;
    FETCH NEXT FROM cur INTO @delivery_number;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        UPDATE Deliveries
        SET products_cost = 
        (
            SELECT SUM(partial_cost)
            FROM Delivery_products
            WHERE delivery_id = @delivery_number
        )
        WHERE id = @delivery_number;

        FETCH NEXT FROM cur INTO @delivery_number;
    END;

    CLOSE cur;
    DEALLOCATE cur;
END;
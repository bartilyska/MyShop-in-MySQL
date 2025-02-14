--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN TRANSACTION;
declare @amount INTEGER;
SELECT @amount = Products.amount_in_storage FROM Products
WHERE Products.ean = '1231231231235'; --odczyt
WAITFOR DELAY '00:00:07'
--INNY KLIENT KUPUJE TEN SAM PRODUKT I BAZA UZYWA 
--POPRZEDNIO ODCZYTANYCH DANYCH (amount)
UPDATE Products
SET Products.amount_in_storage = @amount - 1
WHERE Products.ean = '1231231231235' AND Products.amount_in_storage>0;

SELECT * FROM Products WHERE Products.ean ='1231231231235';--sprawdz stan
--Liczba produktu zmniejszyla sie o 2 a powinna byla o 1
COMMIT;
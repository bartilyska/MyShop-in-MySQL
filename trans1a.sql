/*Dwóch klientów kupuje po 1 produkt ze sklepu i zmniejsza siê
ich iloœæ na magazynie, ale jednak jedna transakcja siê nie udaje.*/
--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN TRANSACTION;
/*¯eby zapobiec problemowi dirty read trzeba podnieœæ poziom
izolacji na READ COMMITED z UNCOMMITED. Niezatwierdzone zmiany zostaj¹
odczytane przez drug¹ transakcjê i nastêpuje podwójne zmniejszenie. */
UPDATE Products
SET Products.amount_in_storage = Products.amount_in_storage - 1
WHERE Products.ean = '1231231231235' AND Products.amount_in_storage>0; /* klient kupuje produkt */

WAITFOR DELAY '00:00:05';
ROLLBACK; -- cos sie nie powiodlo w transakcji

SELECT * FROM Products WHERE Products.ean = '1231231231235'; -- sprawdz stan
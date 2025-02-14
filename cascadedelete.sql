DELETE FROM Employees WHERE Employees.id IN (1,2);
DELETE FROM Clients WHERE Clients.name='Bartosz';/*SET NULL*/	
DELETE FROM Transactions WHERE Transactions.date='2024-12-01';
DELETE FROM Products WHERE Products.type IN ('warzywa','owoce');/*SET NULL*/
DELETE FROM Deliveries WHERE CONVERT(DATE, date_of_submission)='2024-12-02';
DELETE FROM Suppliers WHERE Suppliers.name='Bartosz';
DELETE FROM Companies WHERE Companies.country<>'Polska';/*czesciowy set null i cascade*/
--sprawdzenie triggera
DELETE FROM Transaction_products WHERE id=7;--usuwa auto z pierwszej
DELETE FROM Delivery_products WHERE id=16;--usuwa auto z pierwszej dostawy(nie po kolei jest w delivery products)
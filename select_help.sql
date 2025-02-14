--pierwsze usuwanie
SELECT * FROM Employees;
SELECT * FROM Working_hours;
SELECT  * FROM Transactions;
SELECT *
FROM Employees INNER JOIN Working_hours ON Working_hours.employee_id = Employees.id;
--drugie usuwanie
SELECT * FROM Transactions;
SELECT * FROM Clients;
--trzecie usuwanie
SELECT * FROM Transactions;
SELECT * FROM Transaction_products;
--czwarte usuwanie
SELECT * FROM Products; 
SELECT * FROM Transaction_products;--poznac mozna ze usunelo po tym ze w przecinkach IS NULL
SELECT * FROM Delivery_products;--usuniecie produktu usuwa cala historie o nim (nie powinno byc normalnie robione bo transakcje straca informacje o niektorych produktach)
--piate usuwanie
SELECT * FROM Deliveries;
SELECT * FROM Delivery_products;
--szoste usuwanie
SELECT * FROM Suppliers;
SELECT * FROM Deliveries;
SELECT * FROM Delivery_products;--pierwsza delivery ma koncowke id 23
--siodme usuwanie
SELECT * FROM Companies;
SELECT * FROM Products;
SELECT * FROM Products INNER JOIN Companies ON Products.company_krs=Companies.krs;
SELECT * FROM Suppliers INNER JOIN Companies ON Suppliers.company_krs=Companies.krs;
SELECT * FROM Deliveries;
SELECT * FROM Delivery_products;

--help
SELECT * FROM Transactions INNER JOIN Employees ON Transactions.employee_id=Employees.id;
SELECT * 
FROM Products INNER JOIN Companies ON Products.company_krs = Companies.krs;
SELECT *
FROM Suppliers INNER JOIN Companies ON Suppliers.company_krs = Companies.krs;




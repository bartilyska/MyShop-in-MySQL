/*Obecnie na magazynie kt�rego�/kt�ry� produkt�w jest najwi�cej.". 
Szef chce wiedzie� dokladnie kiedy zostawa�y te produkty/produkt zakupiony i kto je wtedy kupowa� i ile sztuk kupi�, je�eli klient nie jest w bazie ma by� podany jako unknown.*/
SELECT Transactions.date, COALESCE(Clients.name,'UNKNOWN') AS Client_name, COALESCE(Clients.surname,'UNKNOWN') AS Client_surname,
Products.name AS Product_name,Transaction_products.amount FROM Transaction_products
INNER JOIN Transactions ON Transactions.id = Transaction_products.transaction_number
INNER JOIN Products ON Products.ean = Transaction_products.product_ean
LEFT JOIN Clients ON Clients.id = Transactions.client_id --LEFT zeby klienci spoza bazy tez byli w wyniku
WHERE Products.ean IN (
	SELECT Products.ean FROM Products
	WHERE Products.amount_in_storage = ( 
		SELECT MAX(Products.amount_in_storage) FROM Products --moze byc kilka takich temu subquery a nie order by i top 1
	)
)
ORDER BY Transactions.date;
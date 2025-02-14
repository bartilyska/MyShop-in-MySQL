/*Niekt�re opakowania w sklepie s� podejrzliwie pouszkadzane.
Kierownik chce znale�� nazwy wszystkich produkt�w, kt�re przy dostarczeniu mia�y komentarz zwi�zany z opakowaniem.
Domy�la si� �e winowajcami s� pewnie dostawcy z niskim poziomem niezawodno�ci (poni�ej �redniej (pomi� tych kt�rzy maj� tam null)).
Pomo� kierownikowi znale�� te nazwy w bazie, kierownik chce te� nazw� firmy produkuj�cej produkt. (Uniknij duplikat�w nazw)*/
SELECT DISTINCT Products.name AS Product_name , Companies.name AS Company_name FROM Delivery_products --duplikaty byly by bo kilka razy moze byc dostarczany produkt uszkodzony
INNER JOIN Products ON Products.ean = Delivery_products.product_ean
INNER JOIN Deliveries ON Deliveries.id = Delivery_products.delivery_id
INNER JOIN Suppliers ON Suppliers.id = Deliveries.supplier_id
INNER JOIN Companies ON Companies.krs = Products.company_krs
WHERE Deliveries.comments LIKE '%opakowanie%' AND Deliveries.everything_correct = 'nie' AND
	  Suppliers.reliability_score < (SELECT
		AVG(Suppliers.reliability_score * 1.0) FROM Suppliers
	  )
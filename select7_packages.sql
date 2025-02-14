/*Niektóre opakowania w sklepie s¹ podejrzliwie pouszkadzane.
Kierownik chce znaleŸæ nazwy wszystkich produktów, które przy dostarczeniu mia³y komentarz zwi¹zany z opakowaniem.
Domyœla siê ¿e winowajcami s¹ pewnie dostawcy z niskim poziomem niezawodnoœci (poni¿ej œredniej (pomiñ tych którzy maj¹ tam null)).
Pomo¿ kierownikowi znaleŸæ te nazwy w bazie, kierownik chce te¿ nazwê firmy produkuj¹cej produkt. (Uniknij duplikatów nazw)*/
SELECT DISTINCT Products.name AS Product_name , Companies.name AS Company_name FROM Delivery_products --duplikaty byly by bo kilka razy moze byc dostarczany produkt uszkodzony
INNER JOIN Products ON Products.ean = Delivery_products.product_ean
INNER JOIN Deliveries ON Deliveries.id = Delivery_products.delivery_id
INNER JOIN Suppliers ON Suppliers.id = Deliveries.supplier_id
INNER JOIN Companies ON Companies.krs = Products.company_krs
WHERE Deliveries.comments LIKE '%opakowanie%' AND Deliveries.everything_correct = 'nie' AND
	  Suppliers.reliability_score < (SELECT
		AVG(Suppliers.reliability_score * 1.0) FROM Suppliers
	  )
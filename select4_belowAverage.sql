/*Szefa ciekawi� miasta, w kt�rych siedziby maj� firmy, kt�rym p�aci mniej ni� �rednio za dostawy jak i za transport (podaj te �rednie).
Ma w planach zwi�kszy� kupno produkt�w z tych miast.
Firmy bez wpisanego miasta siedziby maj� zosta� pomini�te w liczeniu �redniej, jak i zestawieniu.
Posortuj po sredniej koszt�w dostaw zaczynajac od najmniejszej.*/
SELECT Companies.city,CAST (ROUND(AVG(Deliveries.products_cost),2) AS DECIMAL(10,2)) AS sredni_koszt_dostaw_do_firm_z_miasta,
CAST(ROUND(AVG(Deliveries.transport_cost),2) AS DECIMAL(10,2)) AS sredni_koszt_transportu_do_firm_z_miasta 
FROM 
	Companies INNER JOIN Suppliers ON Companies.krs = Suppliers.company_krs 
	INNER JOIN Deliveries ON Deliveries.supplier_id = Suppliers.id
WHERE Companies.city IS NOT NULL
GROUP BY Companies.city
HAVING(
	AVG(Deliveries.products_cost) < (SELECT ROUND(AVG(Deliveries.products_cost),2) AS sredni_koszt_dostaw FROM --joiny po to by m�c si� dosta� do miasta != null
	Companies INNER JOIN Suppliers ON Companies.krs = Suppliers.company_krs 
	INNER JOIN Deliveries ON Deliveries.supplier_id = Suppliers.id
	WHERE Companies.city IS NOT NULL) AND
	AVG(Deliveries.transport_cost) < (SELECT ROUND(AVG(Deliveries.transport_cost),2) AS sredni_koszt_transportu FROM
	Companies INNER JOIN Suppliers ON Companies.krs = Suppliers.company_krs 
	INNER JOIN Deliveries ON Deliveries.supplier_id = Suppliers.id
	WHERE Companies.city IS NOT NULL))
ORDER BY sredni_koszt_dostaw_do_firm_z_miasta;

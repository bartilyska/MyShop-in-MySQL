/*Szefa ciekawi jakie koszta ponosi ka�dego dnia. Interesuje go wy��cznie przedzia� dni 1.12 - 3.12.
Chce zobaczy� ile ka�dego dnia p�aci pracownikom, zak�ada �e miesi�c ma 4,3 tygodni przy obliczaniu dok�adnej godziny pracy.
Gdy pracownik przepracuje p�noc jego wyp�ata zalicza si� do nast�pnego dnia.
Wydatki na dostawy s� naliczane, przy z�o�eniu zam�wienia.*/
WITH EmployeesPayment AS
(
	SELECT CAST(W.end_date AS DATE) dzien,
		   CAST (ROUND(SUM(DATEDIFF(MINUTE,W.start_date,W.end_date)/60.0 * E.salary/(E.weekly_working_time*4.3)),2) AS DECIMAL(10,2))AS wydane_na_pracownikow
	FROM Employees E INNER JOIN Working_hours  W ON E.id = W.employee_id
	WHERE CAST (W.end_date AS DATE) BETWEEN '2024-12-01' AND '2024-12-03'
	GROUP BY CAST(W.end_date AS DATE)
),DeliveriesExpenses AS
(
	SELECT CAST (D.date_of_submission AS DATE ) AS dzien, SUM(D.products_cost+D.transport_cost) AS wydatki FROM Deliveries D
	WHERE CAST (D.date_of_submission AS DATE) BETWEEN '2024-12-01' AND '2024-12-03'
	GROUP BY CAST (D.date_of_submission AS DATE)
)
SELECT E.dzien, D.wydatki + E.wydane_na_pracownikow AS ��czne_wydatki FROM EmployeesPayment E INNER JOIN DeliveriesExpenses D ON E.dzien = D.dzien;
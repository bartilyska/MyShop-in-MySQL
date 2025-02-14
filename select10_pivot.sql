/*Szef nadzoruje prac� swoich sprzedawc�w. Chce sprawdzi�, czy m�czy�ni pracuj� tak wytrwale jak kobiety.
Dla ka�dego dnia chce zobaczy� ile klient�w obs�u�yli m�czy�ni a ile kobiety (uwzgl�dniaj�c tylko sprzedawc�w).*/
SELECT 
    date, [M] AS mezczyzni, [K] AS kobiety
FROM 
    (SELECT CAST(t.date AS DATE) AS date, e.gender FROM Transactions t INNER JOIN Employees e ON t.employee_id = e.id 
	WHERE e.position ='sprzedawca') AS Glowna
PIVOT 
    (COUNT(gender) FOR gender IN ([M], [K])) AS PivotT;
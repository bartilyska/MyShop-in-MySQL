/*Szef nadzoruje pracê swoich sprzedawców. Chce sprawdziæ, czy mê¿czyŸni pracuj¹ tak wytrwale jak kobiety.
Dla ka¿dego dnia chce zobaczyæ ile klientów obs³u¿yli mê¿czyŸni a ile kobiety (uwzglêdniaj¹c tylko sprzedawców).*/
SELECT 
    date, [M] AS mezczyzni, [K] AS kobiety
FROM 
    (SELECT CAST(t.date AS DATE) AS date, e.gender FROM Transactions t INNER JOIN Employees e ON t.employee_id = e.id 
	WHERE e.position ='sprzedawca') AS Glowna
PIVOT 
    (COUNT(gender) FOR gender IN ([M], [K])) AS PivotT;
/*Szef chce sprawdziæ, którzy pracownicy pracuj¹ nocki.
Wypisz id, imiona i nazwiska pracowników, którzy przepracowali chocia¿ raz pó³noc (zaczêli prace w jeden dzieñ, a skoñczyli w nastêpny).
Wypisz dla ka¿dego z nich ile razy mia³o to zdarzenie miejsce i ile godzin trwa³y w sumie ich zmiany, w trakcie przepracowania pó³nocy(zaokr¹glij do 2 miejsc po przecinku).
Posortuj wybieraj¹c najpierw tych, którzy najwiêcej razy przepracowali pó³noc, a potem po sumie godzin*/
SELECT Employees.id, Employees.name , Employees.surname,
COUNT(*) AS how_many_times, CAST(ROUND(SUM(DATEDIFF(MINUTE,Working_hours.start_date , Working_hours.end_date)/60.0),2) AS DECIMAL (10,2)) AS hours
FROM Employees INNER JOIN Working_hours ON Employees.id=Working_hours.employee_id
WHERE DATEDIFF(DAY,Working_hours.start_date , Working_hours.end_date) > 0
GROUP BY Employees.id,Employees.name , Employees.surname
ORDER BY how_many_times DESC, hours DESC;
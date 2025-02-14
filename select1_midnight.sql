/*Szef chce sprawdzi�, kt�rzy pracownicy pracuj� nocki.
Wypisz id, imiona i nazwiska pracownik�w, kt�rzy przepracowali chocia� raz p�noc (zacz�li prace w jeden dzie�, a sko�czyli w nast�pny).
Wypisz dla ka�dego z nich ile razy mia�o to zdarzenie miejsce i ile godzin trwa�y w sumie ich zmiany, w trakcie przepracowania p�nocy(zaokr�glij do 2 miejsc po przecinku).
Posortuj wybieraj�c najpierw tych, kt�rzy najwi�cej razy przepracowali p�noc, a potem po sumie godzin*/
SELECT Employees.id, Employees.name , Employees.surname,
COUNT(*) AS how_many_times, CAST(ROUND(SUM(DATEDIFF(MINUTE,Working_hours.start_date , Working_hours.end_date)/60.0),2) AS DECIMAL (10,2)) AS hours
FROM Employees INNER JOIN Working_hours ON Employees.id=Working_hours.employee_id
WHERE DATEDIFF(DAY,Working_hours.start_date , Working_hours.end_date) > 0
GROUP BY Employees.id,Employees.name , Employees.surname
ORDER BY how_many_times DESC, hours DESC;
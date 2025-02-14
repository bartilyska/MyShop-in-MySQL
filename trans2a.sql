SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
--SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
/*Za³ó¿my ¿e szef chce stworzyæ zestawienie ile p³aci srednio pracownik¹ co miesi¹c*/
/*W trakcie jego analityk uwzglêdnia podwy¿ki dla kierowników na nowy miesi¹c*/
/*Nie mog¹ one siê pojawiæ w zestawieniu, odpowiedni poziom REPEATABLE READ*/
--jeœli dwie osoby pracuj¹ nad zwiekszeniem pensji pracownikow
--to wyniki moga byc zaskakuj¹ce na nieodpowiednim poziomie izolacji
--na repeatable read aktualizacja czeka az selecty sie wykonaj¹
BEGIN TRANSACTION;
SELECT Avg(Employees.salary) AS Fir FROM Employees;--Tutaj wyplata pracownika jest jak poczatkowa
--Tu szef wstawia dodatkowe przykladowe selecty
WAITFOR DELAY '00:00:05'
SELECT Avg(Employees.salary) AS Sec FROM Employees; --tutaj wyplata juz jest inna ze wzgledu na podwyzke
COMMIT;
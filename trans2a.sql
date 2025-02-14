SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
--SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
/*Za��my �e szef chce stworzy� zestawienie ile p�aci srednio pracownik� co miesi�c*/
/*W trakcie jego analityk uwzgl�dnia podwy�ki dla kierownik�w na nowy miesi�c*/
/*Nie mog� one si� pojawi� w zestawieniu, odpowiedni poziom REPEATABLE READ*/
--je�li dwie osoby pracuj� nad zwiekszeniem pensji pracownikow
--to wyniki moga byc zaskakuj�ce na nieodpowiednim poziomie izolacji
--na repeatable read aktualizacja czeka az selecty sie wykonaj�
BEGIN TRANSACTION;
SELECT Avg(Employees.salary) AS Fir FROM Employees;--Tutaj wyplata pracownika jest jak poczatkowa
--Tu szef wstawia dodatkowe przykladowe selecty
WAITFOR DELAY '00:00:05'
SELECT Avg(Employees.salary) AS Sec FROM Employees; --tutaj wyplata juz jest inna ze wzgledu na podwyzke
COMMIT;
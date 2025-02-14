SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
--SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRANSACTION;
UPDATE Employees
SET Employees.salary = Employees.salary*1.1 --zwiekszam pensje kierownikow
WHERE Employees.position LIKE 'kierownik';
COMMIT;
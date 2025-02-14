--SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
/*Za³o¿my, ¿e u¿ytkownik zapisuje siê jako sta³y klient naszego sklepu i robi to w trakcie gdy szef sprawdza liste klientow
Jeœli logownie nast¹pi³o by idealnie w trakcie transakcji szefa to bez SERIALIZABLE mogl by sie pojawic u niego wiersz ktory nie byl wczesniej 
widoczny (phantom)*/

BEGIN TRANSACTION;
SELECT * FROM Clients
WHERE Clients.name LIKE 'Piotr';--przed dodaniem

WAITFOR DELAY '00:00:05'

SELECT * FROM Clients
WHERE Clients.name LIKE 'Piotr';--po dodaniu
COMMIT;

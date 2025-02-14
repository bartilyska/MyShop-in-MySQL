/*W sklepie obowiazuja 5% znizki dla zalogowanych klientow.
Nalicz dla kazdego klienta laczny rabat po wszystkich transakcjach ktory otrzymal robiac zakupy w sklepie.*/
WITH SumWithoutDiscount AS
(
	SELECT Clients.id,Clients.name,Clients.surname,SUM(partial_price) AS sumaBez FROM Clients --w partial_price w bazie nie jest uwzgledniona obnizka 
	INNER JOIN Transactions ON Clients.id=Transactions.client_id
	INNER JOIN Transaction_products ON Transactions.id = Transaction_products.transaction_number
	GROUP BY Clients.id,Clients.name,Clients.surname
), SumWithDiscount AS
(
	SELECT Clients.id,Clients.name,Clients.surname,SUM(Transactions.overall_price) AS sumaZ FROM Clients -- overall price jest juz po obnizce
	INNER JOIN Transactions ON Clients.id=Transactions.client_id
	GROUP BY Clients.id,Clients.name,Clients.surname
)
SELECT SumWithDiscount.id,SumWithDiscount.name,SumWithoutDiscount.surname,SumWithoutDiscount.sumaBez-SumWithDiscount.sumaZ AS rabat 
FROM SumWithoutDiscount INNER JOIN SumWithDiscount ON SumWithDiscount.id=SumWithoutDiscount.id
WHERE SumWithoutDiscount.sumaBez-SumWithDiscount.sumaZ > 0
ORDER BY rabat DESC;
/*Szef chce sprawdzic zarobki w got�wce i przez terminal.
Prosi o zestawienie zarejestrowanych klient�w, kt�rzy w sumie wydali wi�cej pieni�dzy w sklepie p�ac�c got�wk� ni� kart�.
Posortowa� po najwi�kszej r�nicy mi�dzy zap�at� w got�wce, a kart� malej�co.*/
SELECT Clients.id,Clients.name,Clients.surname,SUM(CASE WHEN payment_method='gotowka' THEN Transactions.overall_price ELSE 0 END) AS SumaGotowka,
SUM(CASE WHEN payment_method='karta' THEN Transactions.overall_price ELSE 0 END) AS SumaKarta
FROM Clients INNER JOIN Transactions ON Clients.id = Transactions.client_id
GROUP BY Clients.id,Clients.name,Clients.surname
HAVING (SUM(CASE WHEN payment_method='gotowka' THEN Transactions.overall_price ELSE -Transactions.overall_price END) > 0) --moge tak zrobic bo jest tylko karta lub gotowka do wyboru
ORDER BY SUM(CASE WHEN payment_method='gotowka' THEN Transactions.overall_price ELSE -Transactions.overall_price END) DESC;
/*Szef chce sprawdzic zarobki w gotówce i przez terminal.
Prosi o zestawienie zarejestrowanych klientów, którzy w sumie wydali wiêcej pieniêdzy w sklepie p³ac¹c gotówk¹ ni¿ kart¹.
Posortowaæ po najwiêkszej ró¿nicy miêdzy zap³at¹ w gotówce, a kart¹ malej¹co.*/
SELECT Clients.id,Clients.name,Clients.surname,SUM(CASE WHEN payment_method='gotowka' THEN Transactions.overall_price ELSE 0 END) AS SumaGotowka,
SUM(CASE WHEN payment_method='karta' THEN Transactions.overall_price ELSE 0 END) AS SumaKarta
FROM Clients INNER JOIN Transactions ON Clients.id = Transactions.client_id
GROUP BY Clients.id,Clients.name,Clients.surname
HAVING (SUM(CASE WHEN payment_method='gotowka' THEN Transactions.overall_price ELSE -Transactions.overall_price END) > 0) --moge tak zrobic bo jest tylko karta lub gotowka do wyboru
ORDER BY SUM(CASE WHEN payment_method='gotowka' THEN Transactions.overall_price ELSE -Transactions.overall_price END) DESC;
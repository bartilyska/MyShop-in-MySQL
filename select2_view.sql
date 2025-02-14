/*Szef chce wiedzie� z jakich firm z POLSKI pochodz� produkty na kt�rych zarobi�by najwi�cej, gdyby sprzeda� wszystko, co dost�pne w magazynie.
Dla ka�dego g��wnego typu produkowanego przez firmy szef chce zobaczy� nazwe produktu i firmy kt�ra go produkuje (w przypadku remisu pokaz obie),
wraz z maksymalna cen� wyprzedazy calego magazynu z tego produktu. Posortuj po cenie malejaco.*/
CREATE VIEW ProductsFromCompanies AS
SELECT Companies.name AS CompanyName, Companies.main_type AS CompanyMainType, Companies.country AS CompanyCountry, Products.name AS ProductName,
	ROUND(Products.unit_price*Products.amount_in_storage,2) AS ProductStoragePrice
	FROM Companies INNER JOIN Products ON Companies.krs=Products.company_krs
	WHERE Companies.country='Polska';
/*oddzielnie puscic widok i selecta*/
WITH MaxPricesByMainType AS
(
    SELECT CompanyMainType , MAX(ProductStoragePrice) AS MaxValue
    FROM ProductsFromCompanies
    GROUP BY CompanyMainType
)
SELECT  pf.CompanyMainType,pf.ProductName,pf.CompanyName, pf.ProductStoragePrice AS MaxValue
FROM ProductsFromCompanies pf
INNER JOIN MaxPricesByMainType mp ON (pf.CompanyMainType = mp.CompanyMainType AND pf.ProductStoragePrice = mp.MaxValue)
ORDER BY MaxValue DESC;
/*dropnac*/
DROP VIEW IF EXISTS ProductsFromCompanies;
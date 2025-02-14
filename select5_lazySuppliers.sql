/*Firmy dostarczaj¹ce towary chc¹ wiedzieæ, ilu ich pracowników NIE dostarczy³o do tej pory ¿adnej dostawy do sklepu.
Dla ka¿dej firmy, w której pracuj¹ JACYŒ pracownicy podaj iloœæ tych, którzy nic nie dostarczyli  nigdy do sklepu. Podaj te¿ jaki jest to procent w stosunku do wszystkich dostawców
tej firmy. 
*/ 
WITH Ilu_nie_dostarczy³o_firmom AS
(
	SELECT Companies.krs, Companies.name, COUNT(*) AS ilu_nigdy_nie_dostarczy³o --policz dla firm ilu bylo takich supplierow inne firmy potem wyzerowane przez COALESCE
	FROM Companies INNER JOIN Suppliers ON Companies.krs = Suppliers.company_krs
	WHERE Suppliers.id IN( SELECT Suppliers.id 
	FROM Suppliers LEFT JOIN Deliveries ON Suppliers.id = Deliveries.supplier_id --wybierz id tych ktorzy nie dostarczyli nigdy przez LEFT 
	WHERE  Deliveries.id IS NULL) 
	GROUP BY Companies.krs,Companies.name
),
Ilu_³¹cznie_dostawców AS
(
	SELECT Companies.krs,Companies.name,COUNT(*) AS ilu_³acznie
	FROM Companies INNER JOIN Suppliers ON Companies.krs = Suppliers.company_krs -- inner zeby nie miec tych firm w ktorych nie ma zadnego suppliera (by nie dzielic przez 0)
	GROUP BY Companies.krs,Companies.name
)
SELECT Overall.name,  COALESCE(Never.ilu_nigdy_nie_dostarczy³o,0) AS ilu_nigdy_nie_dostarczy³o, --COALESCE zwraca pierwsza not nullowa wartosc
 CONCAT (COALESCE (CAST(ROUND(Never.ilu_nigdy_nie_dostarczy³o*1.0/Overall.ilu_³acznie*100,2) AS DECIMAL(10,2)),0),'%') AS jaki_procent_wszystkich_dostawców_firmy_nie_dostarczylo
FROM Ilu_³¹cznie_dostawców Overall LEFT JOIN Ilu_nie_dostarczy³o_firmom Never ON Overall.krs = Never.krs -- LEFT zeby miec tez te w ktorych sa jacys pracownicy ktorzy dostarczyli
ORDER BY ilu_nigdy_nie_dostarczy³o DESC, jaki_procent_wszystkich_dostawców_firmy_nie_dostarczylo DESC;
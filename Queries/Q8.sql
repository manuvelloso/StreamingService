/*Mostrar las cuentas que no pagaron el mes actual, y han usado el servicio en algún momento, 
durante los dos días anteriores a la consulta.*/

WITH Deudor AS(
	SELECT
		Email
	FROM
		abono
	WHERE
		FechaPago IS NULL
		AND MONTH(CURDATE()) = MONTH(FechaVTO)
		AND YEAR(CURDATE()) = YEAR(FechaVTO)
		AND DAY(CURDATE()) > DAY(FechaVTO)
)
SELECT 
	Deudor.Email AS Cuenta
FROM 
	Deudor
    INNER JOIN usuario ON usuario.Email = Deudor.Email
	INNER JOIN reproduccionencurso ON usuario.Username = reproduccionencurso.Username
WHERE 
reproduccionencurso.FechaVisto > CURDATE() - 2
GROUP BY Cuenta

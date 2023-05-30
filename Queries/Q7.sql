-- Calcular el monto total recaudado con los abonos en el mes actual.

SELECT sum(monto)
FROM abono
WHERE DATE_FORMAT(FechaPago, '%Y-%m') = DATE_FORMAT(CURDATE(), '%Y-%m') -- AND FechaPago IS NOT NULL

-- Calcular el monto total recaudado con los abonos en el mes actual.

SELECT sum(monto) AS $MontoTotal
FROM abono
WHERE (FechaPago IS NOT NULL AND DATE_FORMAT(FechaPago, '%Y-%m') = DATE_FORMAT(CURDATE(), '%Y-%m'))

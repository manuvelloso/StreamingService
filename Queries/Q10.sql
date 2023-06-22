-- 10 Marcas de televisores más usados para casting
SELECT MarcaDisp, COUNT(*) AS cantidad
FROM dispositivo
INNER JOIN casting ON dispositivo.idDispositivo = casting.DispReceptor
WHERE dispositivo.TipoDisp LIKE 'TV'
GROUP BY MarcaDisp
ORDER BY cantidad DESC
LIMIT 10;

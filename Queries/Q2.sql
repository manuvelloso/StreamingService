-- Mostrar cuál es la película más vista de la plataforma por cada mes de los últimos seis 
WITH pelis_6M AS(
SELECT
	DATE_FORMAT(historial.FechaVisto, '%Y-%m') AS Mes,
	historial.TiOriginal AS Nombre
FROM
	historial
	INNER JOIN pelicula ON historial.TiOriginal = pelicula.TiOriginal
WHERE
	historial.FechaVisto >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
)

SELECT Mes, Nombre
FROM (
	SELECT 
		Mes, 
		Nombre, 
		ROW_NUMBER() OVER (PARTITION BY mes ORDER BY COUNT(Nombre) DESC) AS rn
	FROM 
		pelis_6M
	GROUP BY 
		Mes, Nombre
) AS ranking
WHERE rn = 1;

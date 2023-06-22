-- Mostrar cuál es la película más vista de la plataforma por cada mes de los últimos seis 
WITH pelis_6M AS(
SELECT
	DATE_FORMAT(historial.FechaVisto, '%Y-%m') AS Mes,
	historial.TiOriginal AS Nombre
FROM
	reproduccionencurso
	INNER JOIN pelicula ON reproduccionencurso.TiOriginal = pelicula.TiOriginal
	INNER JOIN contenido ON contenido.TiOriginal = pelicula.TiOriginal
WHERE
	reproduccionencurso.FechaVisto >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH
	AND reproduccionencurso.PtoSuspenso = contenido.Duracion
	)
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

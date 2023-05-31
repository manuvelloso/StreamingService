-- Listar el contenido más descargado de películas series y documental

SELECT * 
FROM (
	(SELECT 
		descarga.TiOriginal AS Pelicula_mas_vista
	FROM 
		descarga
		INNER JOIN pelicula ON descarga.TiOriginal = pelicula.TiOriginal
	GROUP BY descarga.TiOriginal
	ORDER BY COUNT(descarga.TiOriginal) DESC
	LIMIT 1) AS Pelicula,

	(SELECT 
		descarga.TiOriginal AS Documental_mas_visto
	FROM 
		descarga
		INNER JOIN documental ON descarga.TiOriginal = documental.TiOriginal
	GROUP BY descarga.TiOriginal
	ORDER BY COUNT(descarga.TiOriginal) DESC
	LIMIT 1) AS Documental,

	(SELECT 
		capitulo.NombreSerie AS Serie_mas_vista
	FROM 
		descarga
		INNER JOIN capitulo ON descarga.TiOriginal = capitulo.TiOriginal
	GROUP BY capitulo.NombreSerie
	ORDER BY COUNT(capitulo.NombreSerie) DESC
	LIMIT 1) AS Serie
    )
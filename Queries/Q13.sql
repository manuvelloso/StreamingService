-- Hacer una lista de sugerencias para niños
SELECT 
	contenido.TiOriginal AS Peliculas
FROM
	contenido 
    INNER JOIN pelicula ON contenido.TiOriginal = pelicula.TiOriginal
WHERE 
	pelicula.CalifSalida LIKE "%ATP%"
UNION 
SELECT
	serie.NombreSerie AS Series
FROM
	contenido
	INNER JOIN capitulo ON contenido.TiOriginal = capitulo.TiOriginal
    INNER JOIN serie ON capitulo.NombreSerie = serie.NombreSerie
WHERE 
	serie.CalifSalida LIKE "%ATP%"
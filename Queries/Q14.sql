-- Lista de todas las pelis de un mismo director 
SELECT
	pelicula.TiOriginal
FROM
	pelicula
    INNER JOIN contenido ON pelicula.TiOriginal = contenido.TiOriginal
WHERE
	contenido.Director LIKE "John G. Avildsen"
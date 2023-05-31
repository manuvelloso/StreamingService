-- ¿Cuál es la serie que más le gusta a los usuarios de la plataforma?
 
SELECT
	capitulo.NombreSerie,
    avg(contenido.CalifAverage) AS Calificacion -- Esto es un promedio de la califiación de cada capitulo (promedio del promedio)
FROM
	contenido
    INNER JOIN capitulo ON capitulo.TiOriginal = contenido.TiOriginal
GROUP BY NombreSerie
ORDER BY Calificacion DESC
LIMIT 1
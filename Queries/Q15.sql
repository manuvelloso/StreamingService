-- ¿Cuál es la serie que más le gusta a los usuarios de la plataforma?
-- VER
SELECT
	capitulo.NombreSerie AS Serie,
    sum(contenido.CalifAverage) AS Total
FROM
	contenido
    INNER JOIN capitulo ON contenido.TiOriginal = capitulo.TiOriginal
GROUP BY Serie, contenido.CalifAverage
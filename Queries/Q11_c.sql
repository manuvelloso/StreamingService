-- Listar cuál es la serie mas abandonada (consideramos que la dejo colgada hace un año)

SELECT NombreSerie, COUNT(NombreSerie) as cant
FROM reproduccionencurso 
INNER JOIN capitulo ON capitulo.TiOriginal = reproduccionencurso.TiOriginal
INNER JOIN contenido ON contenido.TiOriginal = capitulo.TiOriginal
INNER JOIN serie ON capitulo.NombreSerie = serie.NombreSerie
WHERE(
	reproduccionencurso.PtoSuspenso < contenido.Duracion
	AND reproduccionencurso.FechaVisto < CURDATE() - 365
)
ORDER BY cant DESC
LIMIT 1


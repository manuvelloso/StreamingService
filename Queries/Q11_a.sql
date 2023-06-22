-- Listar cuál es la pelicula mas abandonada (consideramos que la dejo colgada hace un año)

SELECT TiOriginal, COUNT(TiOriginal) as cant
FROM reproduccionencurso 
INNER JOIN pelicula ON pelicula.TiOriginal = reproduccionencurso.TiOriginal
INNER JOIN contenido ON contenido.TiOriginal = pelicula.TiOriginal
WHERE(
	reproduccionencurso.PtoSuspenso < contenido.Duracion
	AND reproduccionencurso.FechaVisto < CURDATE() - 365
)
ORDER BY cant DESC
LIMIT 1


-- Listar cuál es el documental mas abandonada (consideramos que la dejo colgada hace un año)

SELECT TiOriginal, COUNT(TiOriginal) as cant
FROM reproduccionencurso 
INNER JOIN documental ON documental.TiOriginal = reproduccionencurso.TiOriginal
INNER JOIN contenido ON contenido.TiOriginal = pelicula.TiOriginal
WHERE(
	reproduccionencurso.PtoSuspenso < contenido.Duracion
	AND reproduccionencurso.FechaVisto < CURDATE() - 365
)
ORDER BY cant DESC
LIMIT 1


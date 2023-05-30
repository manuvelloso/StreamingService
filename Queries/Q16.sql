-- Listar documentales que duran menos de una hora

SELECT 
	documental.TiOriginal
FROM
	documental
    INNER JOIN contenido ON contenido.TiOriginal = documental.TiOriginal
WHERE 
	contenido.Duracion < 60

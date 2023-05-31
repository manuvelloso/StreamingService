-- Listar documentales que duran menos de una hora

SELECT 
	documental.TiOriginal AS Documentales
FROM
	documental
    INNER JOIN contenido ON contenido.TiOriginal = documental.TiOriginal
WHERE 
	contenido.Duracion < 60

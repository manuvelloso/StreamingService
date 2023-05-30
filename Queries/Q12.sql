-- Indicar cuál es el actor estelar más buscado por los usuarios. 

SELECT
	ActNombre AS Nombre,
	ActApellido AS Apellido
FROM (
	SELECT 
		idActor,
		count(idActor) as Cantidad
	FROM 
		actua
		INNER JOIN reproduccionencurso ON actua.TiOriginal = reproduccionencurso.TiOriginal
	GROUP BY idActor
    ) AS Mini
INNER JOIN actor ON Mini.idActor = actor.idActor
ORDER BY Cantidad DESC
LIMIT 1

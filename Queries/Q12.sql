-- Indicar cuál es el actor estelar más buscado por los usuarios. 

WITH Actores AS (
	SELECT
		idActor
	FROM
		actua
		INNER JOIN reproduccionencurso ON actua.TiOriginal = reproduccionencurso.TiOriginal
	UNION
    SELECT
		idActor
	FROM
		actua
		INNER JOIN historial ON actua.TiOriginal = historial.TiOriginal
)

SELECT
	ActNombre AS Nombre,
	ActApellido AS Apellido
FROM (
	SELECT 
		idActor,
		count(idActor) as Cantidad
	FROM 
		Actores
	GROUP BY idActor
    ) AS Mini
	INNER JOIN actor ON Mini.idActor = actor.idActor
ORDER BY Cantidad DESC
LIMIT 1

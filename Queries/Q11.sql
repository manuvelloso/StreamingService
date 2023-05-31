-- Listar los contenidos más abandonados, separados por película, serie y documental. 
-- Abandonado: lo arrancó pero no lo termino (tiempo: 1 año)

WITH CantidadCap AS (
SELECT 
		NombreSerie,
		count(NombreSerie) AS CantidadCapitulos
	FROM capitulo
    GROUP BY NombreSerie
)

/*

SELECT 
	NombreSerie
FROM (
	(SELECT
		NombreSerie
    FROM
		capitulo
		INNER JOIN reproduccionencurso ON capitulo.TiOriginal = reproduccionencurso.TiOriginal
	WHERE
		FechaVisto < CURDATE() - 30) AS RepPausado,
   
   (SELECT
		NombreSerie
	FROM
		historial
        INNER JOIN capitulo ON capitulo.TiOriginal = historial.TiOriginal
	WHERE (
		capitulo.NumCap < CantidadCap.CantidadCapitulos
		AND capitulo.NombreSerie LIKE CantidadCap.NombreSerie)
	GROUP BY Username, TiOriginal) AS TempPausada
)
*/
SELECT * 
FROM (
/*(SELECT 
	capitulo.NombreSerie AS Serie_abandonada
FROM
	capitulo
	INNER JOIN reproduccionencurso ON reproduccionencurso.TiOriginal = capitulo.TiOriginal
WHERE
	reproduccionencurso.FechaVisto < CURDATE() - 30
GROUP BY reproduccionencurso.TiOriginal 
ORDER BY COUNT(reproduccionencurso.TiOriginal) DESC
LIMIT 1) AS Series) */
(SELECT 
	reproduccionencurso.TiOriginal AS Pelicula_abandonada
FROM
	pelicula
	INNER JOIN reproduccionencurso ON reproduccionencurso.TiOriginal = pelicula.TiOriginal
WHERE
	reproduccionencurso.FechaVisto < CURDATE() - 1
GROUP BY reproduccionencurso.TiOriginal 
ORDER BY COUNT(reproduccionencurso.TiOriginal) DESC
LIMIT 1) AS Peliculas,

(SELECT 
	reproduccionencurso.TiOriginal AS Documental_abandonado
FROM
	documental
	INNER JOIN reproduccionencurso ON reproduccionencurso.TiOriginal = documental.TiOriginal
WHERE
	reproduccionencurso.FechaVisto < CURDATE() - 1
GROUP BY reproduccionencurso.TiOriginal 
ORDER BY COUNT(reproduccionencurso.TiOriginal) DESC
LIMIT 1) AS Documentales
)
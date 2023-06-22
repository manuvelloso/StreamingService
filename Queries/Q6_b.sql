/*Listar los usuarios y sus perfiles que vieron durante el año 2023, la serie “GAME OF THRONES”. 
Indicar cuántos la vieron en idioma original y cuántos en castellano. */

WITH UsuariosGT AS (
	SELECT 
		usuario.Username,
		usuario.Email,
		usuario.Telefono,
		GOT.IdiomaAudio
	FROM (
		SELECT
			reproduccionencurso.Username,
			reproduccionencurso.IdiomaAudio
		FROM 
			reproduccionencurso
		INNER JOIN capitulo ON reproduccionencurso.TiOriginal = capitulo.TiOriginal 
		WHERE 
			NombreSerie LIKE 'Game of Thrones'
			AND YEAR(reproduccionencurso.FechaVisto) = 2023
		GROUP BY reproduccionencurso.Username, reproduccionencurso.IdiomaAudio
    ) AS GOT
	INNER JOIN usuario ON GOT.Username = usuario.Username
)

SELECT 
	IdiomaAudio, 
	count(IdiomaAudio) as Cantidad
FROM 
	UsuariosGT 
GROUP BY IdiomaAudio
ORDER BY Cantidad

-- Listar todas las películas que tengan audio en español
SELECT
	audiocontenido.TiOriginal AS Pelicula
FROM
	audiocontenido
    INNER JOIN pelicula on audiocontenido.TiOriginal = pelicula.TiOriginal
    INNER JOIN audio on audiocontenido.idAudio = audio.idAudio
WHERE
	audio.Audio LIKE 'castellano'

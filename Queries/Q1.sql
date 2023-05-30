-- Listar todas las películas que tengan audio en español
SELECT
	audiocontenido.TiOriginal AS Pelicula
FROM
	audiocontenido
    INNER JOIN audio on audiocontenido.idAudio = audio.idAudio
WHERE
	audio.Audio LIKE 'castellano'

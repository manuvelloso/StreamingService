-- Listar cuál es el contenido más visto en watchparty para segmento entre 20 y 25 años
SELECT TiOriginal, count(TiOriginal) AS cant
FROM 
(
(SELECT TiOriginal, usuario.Username, usuario.FechaNac FROM 
watchparty 
INNER JOIN reproduccionencurso ON watchparty.idReproduccion = reproduccionencurso.idReproduccion
INNER JOIN usuario ON usuario.Username = watchparty.UserEmisor)

UNION

(SELECT TiOriginal, usuario.Username, usuario.FechaNac FROM 
watchparty 
INNER JOIN reproduccionencurso ON watchparty.idReproduccion = reproduccionencurso.idReproduccion
INNER JOIN usuario ON usuario.Username = watchparty.UserReceptor)
)
WHERE(YEAR(CURDATE() - FechaNac) BETWEEN 20 AND 25)
GROUP BY TiOriginal
ORDER BY cant
LIMIT 1


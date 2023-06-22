-- Listar cuál es el contenido más visto en watchparty para segmento entre 20 y 25 años
SELECT *
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


CREATE VIEW Buscar_Actor AS (
SELECT TiOriginal 
FROM actua 
INNER JOIN actor ON actua.idActor = actor.idActor
WHERE actor.ActNombre LIKE 'Laverne' AND actor.ActApellido LIKE 'Gargett'
);
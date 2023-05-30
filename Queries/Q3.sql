-- Ver los dispositivos que tiene vinculado un determinado usuario

-- OPCIÓN 1
SELECT  -- seleccionamos los atributos de dispositivo
	* 
FROM
	dispositivo 
	INNER JOIN usuario ON dispositivo.Username = usuario.Username
WHERE usuario.Username LIKE 'Vicky' -- lo ponemos nosotras


-- OPCIÓN 2
SELECT 
	dispositivo.Username,
	DispNom,
	idDispositivo AS id
FROM
	dispositivo INNER JOIN usuario ON dispositivo.Username = usuario.Username
ORDER BY dispositivo.Username ASC


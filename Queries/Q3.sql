-- Ver los dispositivos que tiene vinculado un determinado usuario

-- OPCIÓN 1
SELECT  -- seleccionamos los atributos de dispositivo
	usuario.Username AS Usuario,
    dispositivo.DispNom AS NombreDispositivo,
    dispositivo.idDispositivo,
    dispositivo.MarcaDisp AS Marca,
    dispositivo.TipoDisp AS Tipo,
    dispositivo.RedWifi
FROM
	dispositivo 
	INNER JOIN usuario ON dispositivo.Username = usuario.Username
WHERE usuario.Username LIKE 'Vicky' -- lo ponemos nosotras


-- OPCIÓN 2
SELECT 
	dispositivo.Username AS Usuario,
	DispNom AS NombreDispositivo,
	idDispositivo,
    dispositivo.MarcaDisp AS Marca,
    dispositivo.TipoDisp AS Tipo,
    dispositivo.RedWifi
FROM
	dispositivo INNER JOIN usuario ON dispositivo.Username = usuario.Username
ORDER BY dispositivo.Username ASC


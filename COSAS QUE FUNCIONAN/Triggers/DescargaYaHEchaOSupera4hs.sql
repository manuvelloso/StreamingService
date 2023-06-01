CREATE DEFINER=`root`@`localhost` TRIGGER `descarga_BEFORE_INSERT` BEFORE INSERT ON `descarga` FOR EACH ROW BEGIN

DECLARE TotalMins INT UNSIGNED;
DECLARE titulito VARCHAR(40);

    SELECT SUM(contenido.Duracion) INTO TotalMins
    FROM descarga 
    INNER JOIN contenido ON descarga.TiOriginal = contenido.TiOriginal
    WHERE descarga.Username = NEW.Username;
    
    SELECT TiOriginal INTO titulito
    FROM descarga
    WHERE (Username = NEW.Username AND TiOriginal = NEW.TiOriginal);
    
    IF titulito IS NOT NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'el contenido ya ha sido descargado por el usuario';
	ELSE
    
    IF TotalMins + (SELECT Duracion FROM contenido WHERE TiOriginal = NEW.TiOriginal) > 240 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La descarga supera el límite de 4 horas de contenido.';
    ELSE
		INSERT INTO descarga (Username, TiOriginal, Calidad)
		VALUES (NEW.Username, NEW.TiOriginal, NEW.Calidad);
	END IF;
    END IF;

END
CREATE DEFINER=`root`@`localhost` TRIGGER `casting_BEFORE_INSERT` BEFORE INSERT ON `casting` FOR EACH ROW BEGIN

DECLARE W1 VARCHAR(20);
DECLARE W2 VARCHAR(20);

SELECT RedWifi INTO W1 
FROM casting INNER JOIN dispositivo 
ON dispositivo.idDispositivo = casting.DispEmisor;

SELECT RedWifi INTO W2 
FROM casting INNER JOIN dispositivo 
ON dispositivo.idDispositivo = casting.DispReceptor;

IF W1 NOT LIKE w2 THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error en la conexión WiFi';
ELSE
	INSERT INTO casting(DispEmisor, DispReceptor)
	VALUES (NEW.DispEmisor, NEW.DispReceptor);
END IF;

END
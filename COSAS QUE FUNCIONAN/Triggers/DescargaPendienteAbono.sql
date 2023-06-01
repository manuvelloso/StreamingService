CREATE DEFINER = CURRENT_USER TRIGGER `mydb_final`.`descarga_BEFORE_INSERT_1` BEFORE INSERT ON `descarga` FOR EACH ROW
BEGIN
DECLARE VTO DATE;

SELECT FechaVTO INTO VTO
FROM descarga 
INNER JOIN usuario ON descarga.Username = usuario.Username
INNER JOIN abono ON usuario.Email = abono.Email
WHERE usuario.Username = NEW.usuario.Username
GROUP BY Email;

IF CURDATE() >= VTO + 5 THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Abono pendiente de pago.';
ELSE 
	INSERT INTO descarga (Username, TiOriginal, Calidad)
	VALUES (NEW.Username, NEW.TiOriginal, NEW.Calidad);
END IF;
END

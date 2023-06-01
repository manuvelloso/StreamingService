CREATE DEFINER=`root`@`localhost` TRIGGER `favorito_BEFORE_INSERT` BEFORE INSERT ON `favorito` FOR EACH ROW BEGIN
DECLARE VTO DATE;

SELECT FechaVTO INTO VTO
FROM favorito 
INNER JOIN usuario ON favorito.Username = usuario.Username
INNER JOIN abono ON usuario.Email = abono.Email
WHERE usuario.Username = NEW.usuario.Username
GROUP BY Email;

IF CURDATE() >= VTO + 5 THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Abono pendiente de pago.';
ELSE 
	INSERT INTO favorito (Username, TiOriginal)
	VALUES (NEW.Username, NEW.TiOriginal);
END IF;
END
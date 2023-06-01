CREATE DEFINER=`root`@`localhost` TRIGGER `serie_BEFORE_INSERT` BEFORE INSERT ON `serie` FOR EACH ROW BEGIN
IF NEW.AnioLanzamiento > YEAR(CURDATE()) THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Año de lanzamiento inválido';
ELSE
	INSERT INTO serie (NombreSerie, TiIngles, TiEspañol, AnioLanzamiento,Productor, CalifSalida)
	VALUES (NEW.NombreSerie, NEW.TiIngles, NEW.TiEspañol, NEW.AnioLanzamiento,NEW.Productor, NEW.CalifSalida);
END IF;
END
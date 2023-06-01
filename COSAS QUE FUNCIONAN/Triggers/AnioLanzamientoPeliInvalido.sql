CREATE DEFINER=`root`@`localhost` TRIGGER `pelicula_BEFORE_INSERT` BEFORE INSERT ON `pelicula` FOR EACH ROW BEGIN

IF NEW.AnioLanzamiento > YEAR(CURDATE()) THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Año de lanzamiento inválido';
ELSE
	INSERT INTO película (TiOriginal, TiIngles, TiEspaniol, AnioLanzamiento,Productor, CalifSalida)
	VALUES (NEW.TiOriginal, NEW.TiIngles, NEW.TiEspaniol, NEW.AnioLanzamiento,NEW.Productor, NEW.CalifSalida);
END IF;

END
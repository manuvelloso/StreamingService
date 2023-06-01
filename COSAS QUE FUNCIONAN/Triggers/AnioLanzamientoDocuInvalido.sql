CREATE DEFINER=`root`@`localhost` TRIGGER `documental_BEFORE_INSERT` BEFORE INSERT ON `documental` FOR EACH ROW BEGIN
IF NEW.AnioLanzamiento > YEAR(CURDATE()) THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Año de lanzamiento inválido';
ELSE
	INSERT INTO documental (TiOriginal, Tema, AnioLanzamiento)
	VALUES (NEW.TiOriginal, NEW.Tema, NEW.AnioLanzamiento);
END IF;
END
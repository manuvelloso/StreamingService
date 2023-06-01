CREATE DEFINER = CURRENT_USER TRIGGER `mydb_final`.`serie_AFTER_INSERT` AFTER INSERT ON `serie` FOR EACH ROW
BEGIN

SELECT NumTemp
FROM capitulo INNER JOIN serie
WHERE capitulo.NombreSerie = NEW.serie.NombreSerie
GROUP BY NombreSerie;

-- si es la ultima temporada -> avisar
IF NumTemp = NEW.serie.CantTemporadas THEN
 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FINAL SEASON!!!';
END IF;


END
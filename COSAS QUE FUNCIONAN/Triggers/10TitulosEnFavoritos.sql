CREATE DEFINER = CURRENT_USER TRIGGER `mydb_final`.`favorito_BEFORE_INSERT_1` BEFORE INSERT ON `favorito` FOR EACH ROW
BEGIN

DECLARE cant INT UNSIGNED;

SELECT count(Username) INTO cant
FROM favorito
WHERE favorito.Username = NEW.favorito.Username
GROUP BY Username;

IF cant >= 10 THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ya has marcado 10 títulos como favorito';
ELSE
	INSERT INTO favorito(Username, TiOriginal)
    VALUES (NEW.Username, NEW.TiOriginal);
END IF;

END
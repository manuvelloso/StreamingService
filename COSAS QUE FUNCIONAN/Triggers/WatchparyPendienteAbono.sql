CREATE DEFINER = CURRENT_USER TRIGGER `mydb_final`.`watchparty_BEFORE_INSERT` BEFORE INSERT ON `watchparty` FOR EACH ROW
BEGIN
-- primero chequeo que ambos no esten pendientes de abono

DECLARE fv1 DATE;
DECLARE fv2 DATE;

SELECT *
FROM (
(SELECT FechaVTO INTO fv1
FROM watchparty 
INNER JOIN usuario ON watchparty.UserEmisor = usuario.Username
INNER JOIN abono ON usuario.Email = abono.Email
WHERE usuario.Username = NEW.watchparty.UserEmisor
GROUP BY Email) emisor,

(SELECT FechaVTO INTO fv2
FROM watchparty 
INNER JOIN usuario ON watchparty.UserReceptor = usuario.Username
INNER JOIN abono ON usuario.Email = abono.Email
WHERE usuario.Username = NEW.watchparty.UserReceptor
GROUP BY Email) receptor
);

IF CURDATE() >= VTO + 5 THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Abono pendiente de pago.';
ELSE 
	INSERT INTO watchparty (UserEmisor, UserReceptor, TiOriginal)
	VALUES (NEW.UserEmisor, NEW.UserReceptor, NEW.TiOriginal);
END IF;


END
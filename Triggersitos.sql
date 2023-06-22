-- ABONO
-- Modiicar tabla abono las fechas de vto
DELIMITER $$
USE `mydb_final`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `abono_BEFORE_INSERT` BEFORE INSERT ON `abono` FOR EACH ROW BEGIN
    -- Si hubo un cambio de mes, la nueva FechaVTO es + 30
    IF DATE_FORMAT(CURDATE(), '%Y-%m') > DATE_FORMAT(CURDATE()-1, '%Y-%m') THEN
		SET NEW.FechaVTO = CURDATE() + 30;
    END IF;
END$$

/*CREATE DEFINER=`root`@`localhost` TRIGGER `abono_AFTER_INSERT` AFTER INSERT ON `abono` FOR EACH ROW BEGIN
 -- Si pagó con 'Comprobante'
 DECLARE formita VARCHAR(45);
 SELECT NEW.FormaPago INTO formita;

 IF formita LIKE 'Comprobante' THEN
   SET MESSAGE_TEXT = 'Generando comprobante';
 END IF;

END$$**/

/* CREATE DEFINER=`root`@`localhost` TRIGGER `abono_AFTER_UPDATE` AFTER UPDATE ON `abono` FOR EACH ROW BEGIN

-- Siempre que se modifique la tabla abono ==> chequeo los deudores
-- Si el usuario no pagó, se le avisa la futura cancelación del servicio
IF FechaVTO < CURDATE() AND FechaPago IS NULL THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Futura cancelacion del servicio de streaming ante la falta de pago\nSe otorgan 5 días para la cancelacion de la deuda';
END IF;

END$$*/


-- CALIFICA
-- el usuario solo puede calificar la pelicula si la vio
CREATE DEFINER=`root`@`localhost` TRIGGER `califica_BEFORE_INSERT` BEFORE INSERT ON `califica` FOR EACH ROW BEGIN
    DECLARE fechita DATE;
    DECLARE califi VARCHAR(10);
    DECLARE VTO DATE;
    DECLARE puntito INT UNSIGNED;
    DECLARE duracioncita INT UNSIGNED;
    
    --
    SELECT PtoSuspenso, Duracion INTO puntito, duracioncita
    FROM califica 
    INNER JOIN reproduccionencurso ON celifica.TiOriginal = reproduccionencurso.TiOriginal
    INNER JOIN contenido ON contenido.TiOriginal = reproduccionencurso.TiOriginal
    WHERE(Username = NEW.Username AND califica.TiOriginal = NEW.alifica.TiOriginal);
    
    -- NIÑOS --
    SELECT FechaNac INTO fechita
    FROM califica INNER JOIN usuario ON califica.Username = usuario.Username
    WHERE califica.Username = NEW.Username;

    SELECT CalifSalida INTO califi
    FROM 
    (
        -- Pelicula
        (SELECT pelicula.TiOriginal AS Titulo, CalifSalida FROM califica 
        INNER JOIN pelicula ON califica.TiOriginal = pelicula.TiOriginal) 
        
        UNION
        
        -- Serie
        (SELECT capitulo.TiOriginal AS Titulo, CalifSalida FROM califica 
        INNER JOIN capitulo ON capitulo.TiOriginal = califica.TiOriginal
        INNER JOIN serie ON serie.NombreSerie = capitulo.NombreSerie) 
    ) AS e
    WHERE Titulo = NEW.TiOriginal;

    -- ABONO VENCIDO --
    SELECT FechaVTO INTO VTO
    FROM califica 
    INNER JOIN usuario ON califica.Username = usuario.Username
    INNER JOIN abono ON usuario.Email = abono.Email
    WHERE usuario.Username = NEW.Username
    GROUP BY usuario.Email;

    -- Si el abono está vencido
    IF CURDATE() >= VTO + INTERVAL 5 DAY THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Abono pendiente de pago.';
    -- Si no
    ELSE
        -- Si es niño
        IF YEAR(CURDATE()) - YEAR(fechita) < 13 AND califi NOT LIKE 'ATP' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Restricción de menor de edad aplicada sobre este título';
		ELSE
			IF PtoSuspenso <> Duracioncita THEN 
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No podes calificar algo que todavía no viste :P';
            ELSE
				-- Si no: lo puedo ingresar!
				IF NEW.Calificacion LIKE 'no me gusto' THEN
					SET NEW.Valor = 1;
				END IF;
				
				IF NEW.Calificacion LIKE 'no me decido' THEN
					SET NEW.Valor = 2;
				END IF;
				
				IF NEW.Calificacion LIKE 'me gusto un poco' THEN
					SET NEW.Valor = 3;
				END IF;
				
				IF NEW.Calificacion LIKE 'me gusta bastante' THEN
					SET NEW.Valor = 4;
				END IF;
				
				IF NEW.Calificacion LIKE 'me encanto' THEN
					SET NEW.Valor = 5;
				END IF;
			END IF;
        END IF;
        
        
        END IF;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` TRIGGER `califica_AFTER_INSERT` AFTER INSERT ON `califica` FOR EACH ROW BEGIN
	DECLARE CalTotal INT UNSIGNED;
    DECLARE CantCal INT UNSIGNED;
    DECLARE NuevaCal FLOAT;
    
    SELECT COUNT(*), SUM(Valor) INTO CantCal, CalTotal
    FROM califica
    WHERE TiOriginal = NEW.TiOriginal;
    
    -- Calcular la nueva calificación promedio
    SET NuevaCal = CalTotal / CantCal;
    
    -- Actualizar la calificación promedio en la tabla de contenido
    UPDATE contenido
    SET CalifAverage = NuevaCal
    WHERE TiOriginal = NEW.TiOriginal;
END$$

-- CAPÍTULO 
/*CREATE DEFINER=`root`@`localhost` TRIGGER `capitulo_AFTER_INSERT` AFTER INSERT ON `capitulo` FOR EACH ROW BEGIN

DECLARE nt INT UNSIGNED;

SELECT NumTemp INTO nt
FROM capitulo INNER JOIN serie
WHERE capitulo.NombreSerie = NEW.serie.NombreSerie
GROUP BY NombreSerie;

-- si es la ultima temporada -> avisar
IF nt = NEW.serie.CantTemporadas THEN
 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FINAL SEASON!!!';
END IF;

END$$*/

-- CASTING
CREATE DEFINER=`root`@`localhost` TRIGGER `casting_BEFORE_INSERT` BEFORE INSERT ON `casting` FOR EACH ROW BEGIN
-- after insert en casting -> update reproducción en curso (por el tema de la velocidad)

DECLARE W1 VARCHAR(20);
DECLARE W2 VARCHAR(20);
DECLARE id1 INT UNSIGNED;
DECLARE id2 INT UNSIGNED;

SELECT idDispositivo INTO id1
FROM casting INNER JOIN dispositivo ON casting.DispEmisor = dispositivo.idDispositivo
WHERE casting.DispEmisor = NEW.casting.DispEmisor;

SELECT idDispositivo INTO id2
FROM casting INNER JOIN dispositivo ON casting.DispReceptor = dispositivo.idDispositivo
WHERE casting.DispReceptor = NEW.casting.DispReceptor;

SELECT RedWifi INTO W1 
FROM casting INNER JOIN dispositivo 
ON dispositivo.idDispositivo = casting.DispEmisor;

SELECT RedWifi INTO W2 
FROM casting INNER JOIN dispositivo 
ON dispositivo.idDispositivo = casting.DispReceptor;

IF id1 = id2 THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede castear un dispositivo con si mismo';
ELSE
	IF W1 NOT LIKE w2 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error en la conexión WiFi de los dispositivos';
	END IF;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` TRIGGER `casting_AFTER_INSERT` AFTER INSERT ON `casting` FOR EACH ROW BEGIN

DECLARE id INT UNSIGNED;

SELECT idReproduccion INTO id
FROM casting
WHERE (casting.idReproduccion = NEW.casting.idReproduccion);

UPDATE Reproduccionencurso
SET Reproduccionencurso.Velocidad = 1.0
WHERE(Reproduccionencurso.idReproduccion = id);

END$$

-- DESCARGA
CREATE DEFINER=`root`@`localhost` TRIGGER `descarga_BEFORE_INSERT` BEFORE INSERT ON `descarga` FOR EACH ROW BEGIN
DECLARE TotalMins INT UNSIGNED;
DECLARE titulito VARCHAR(40);
DECLARE fechita DATE;
DECLARE VTO DATE;
DECLARE califi VARCHAR(10);
DECLARE gamita VARCHAR(10);

-- CHEQUEO SI ES ALTA GAMA
SELECT ModeloDisp INTO gamita
FROM descarga INNER JOIN dispositivo ON descarga.idDispositivo = dispositivo.idDispositivo
WHERE descarga.idDispositivo = NEW.descarga.idDispositivo;

-- NO HAY ESPACIO PARA LA DESCARGA --
SELECT SUM(contenido.Duracion) INTO TotalMins
FROM descarga 
INNER JOIN contenido ON descarga.TiOriginal = contenido.TiOriginal
WHERE descarga.Username = NEW.Username;

-- YA LO DESCARGÓ --
SELECT TiOriginal INTO titulito
FROM descarga
WHERE (Username = NEW.Username AND TiOriginal = NEW.TiOriginal);

-- ABONO VENCIDO --
SELECT FechaVTO INTO VTO
FROM descarga 
INNER JOIN usuario ON descarga.Username = usuario.Username
INNER JOIN abono ON usuario.Email = abono.Email
WHERE usuario.Username = NEW.usuario.Username
GROUP BY Email;

-- NIÑOS --
SELECT FechaNac INTO fechita
FROM descarga INNER JOIN usuario ON descarga.Username = usuario.Username
WHERE Username = NEW.Username;
	
SELECT CalifSalida INTO califi
FROM 
(
-- Pelicula
(SELECT TiOriginal FROM descarga 
INNER JOIN pelicula ON descarga.TiOriginal = pelicula.TiOriginal) 
    
UNION
    
-- Documental
(SELECT TiOriginal FROM descarga 
INNER JOIN documental ON descarga.TiOriginal = documental.TiOriginal)
    
UNION
    
-- Serie
(SELECT NombreSerie AS TiOriginal FROM descarga 
INNER JOIN capitulo ON capitulo.TiOriginal = descarga.TiOriginal
INNER JOIN serie ON serie.NombreSerie = capitulo.NombreSerie) 
) as e
WHERE(TiOriginal = NEW.TiOriginal);

-- Si ya lo descargó
IF titulito IS NOT NULL THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'el contenido ya ha sido descargado por el usuario';
ELSE
	-- Si no hay espacio
	IF TotalMins + (SELECT Duracion FROM contenido WHERE TiOriginal = NEW.TiOriginal) > 240 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO HAY ESPACIO. La descarga supera el límite de 4 horas de contenido.';
    ELSE
		-- Si no pagó
		IF CURDATE() >= VTO + 5 THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Abono pendiente de pago.';
		ELSE 
			-- Si es niño
			IF YEAR(CURDATE()) - YEAR(fechita) < 13 AND califi NOT LIKE 'ATP' THEN
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Restricción de menor de edad aplicada sobre este título';
			ELSE
				-- no es de alta gama
				IF gamita NOT LIKE 'alta gama' THEN
					SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El dispositivo donde se quiso descargar no es de alta gama';
                ELSE
					-- Si el dispositivo no le pertenece a la persona
                    IF NEW.descarga.idDispositivo NOT IN (SELECT idDispositivo FROM dispositivo WHERE dispositivo.Username = NEW.descarga.Username) THEN
						SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El dispositivo no le pertenece al usuario';
                    END IF;
                END IF;
			END IF;
		END IF;
	END IF;
END IF;

END$$

-- DISPOSITIVO
CREATE DEFINER=`root`@`localhost` TRIGGER `dispositivo_BEFORE_INSERT` BEFORE INSERT ON `dispositivo` FOR EACH ROW BEGIN

DECLARE cant INT UNSIGNED;

SELECT count(Username) INTO cant
FROM dispositivo
WHERE (Username = NEW.Username) 
GROUP BY Username;

IF cant >= 5 THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario ya tiene 5 dispositivos.';
END IF;
END$$

-- CONTENIDO (AGREGARLO EN CONTENIDO!!)
CREATE DEFINER=`root`@`localhost` TRIGGER `contenido_BEFORE_INSERT` BEFORE INSERT ON `contenido` FOR EACH ROW BEGIN
IF NEW.AnioLanzamiento > YEAR(CURDATE()) THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Año de lanzamiento inválido';
END IF;
END$$

-- FAVORITO
CREATE DEFINER=`root`@`localhost` TRIGGER `favorito_BEFORE_INSERT` BEFORE INSERT ON `favorito` FOR EACH ROW BEGIN
	DECLARE califi VARCHAR(10);
	DECLARE VTO DATE;
    DECLARE fechita DATE;
    DECLARE cant INT UNSIGNED;
    
    -- YA HAY 10 FAVS -- 
    SELECT count(Username) INTO cant
    FROM favorito
    WHERE(Username = NEW.Username)
    GROUP BY Username;

	-- NIÑOS --
	SELECT FechaNac INTO fechita
    FROM favorito INNER JOIN usuario ON favorito.Username = usuario.Username
    WHERE Username = NEW.Username;
	
	SELECT CalifSalida INTO califi
    FROM 
    (
    -- Pelicula
    (SELECT TiOriginal FROM favorito 
    INNER JOIN pelicula ON favorito.TiOriginal = pelicula.TiOriginal) 
    
    UNION
    
    -- Documental
    (SELECT TiOriginal FROM califica 
    INNER JOIN documental ON califica.TiOriginal = documental.TiOriginal)
    
    UNION
    
    -- Serie
    (SELECT NombreSerie AS TiOriginal FROM favorito 
    INNER JOIN capitulo ON capitulo.TiOriginal = favorito.TiOriginal
    INNER JOIN serie ON serie.NombreSerie = capitulo.NombreSerie) 
    ) as e
    WHERE(TiOriginal = NEW.TiOriginal);
    
    -- ABONO VENCIDO --
	SELECT FechaVTO INTO VTO
	FROM favorito 
	INNER JOIN usuario ON favorito.Username = usuario.Username
	INNER JOIN abono ON usuario.Email = abono.Email
	WHERE usuario.Username = NEW.usuario.Username
	GROUP BY Email;
	
    -- si ya hay 10 títulos en favoritor
    IF cant >= 10 THEN
    	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ya hay 10 títulos en favoritos.';
    ELSE
		-- Si el abono está vencido
		IF CURDATE() >= VTO + 5 THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Abono pendiente de pago.';
		-- Si no
		ELSE
			-- Si es niño
			IF YEAR(CURDATE()) - YEAR(fechita) < 13 AND califi NOT LIKE 'ATP' THEN
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Restricción de menor de edad aplicada sobre este título';
			END IF;
		END IF;
	END IF;
END$$

-- PREMIO
CREATE DEFINER=`root`@`localhost` TRIGGER `premio_BEFORE_INSERT` BEFORE INSERT ON `premio` FOR EACH ROW BEGIN
DECLARE aniesito INT UNSIGNED;

SELECT AnioLanzamiento INTO aniesito
FROM pelicula INNER JOIN contenido ON pelicula.TiOriginal = contenido.TiOriginal
WHERE pelicula.idPelicula = NEW.premio.idPelicula;

IF NEW.premio.Anio < aniesito THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La pelicula no pudo ganar un premio antes de haber sido lanzada';
END IF;

END;

-- REPRODUCCIÓN EN CURSO
CREATE DEFINER=`root`@`localhost` TRIGGER `reproduccionencurso_BEFORE_INSERT` BEFORE INSERT ON `reproduccionencurso` FOR EACH ROW BEGIN
	DECLARE fechita DATE;
	DECLARE VTO DATE;
	DECLARE califi VARCHAR(10);
	DECLARE iAud INT UNSIGNED;
    DECLARE iSub INT UNSIGNED;
    DECLARE wifi_ VARCHAR(20);
    DECLARE descargado VARCHAR(40);
    DECLARE cal VARCHAR(10);
    
    SELECT NEW.IdAudio INTO iAud;
    SELECT NEW.IdSubtitulo INTO iSub;
    
    -- DESCARGA
    SELECT TiOriginal, Calidad INTO descargado, cal
    FROM reproduccionencurso 
    INNER JOIN descarga ON reproduccionencurso.TiOriginal = descarga.TiOriginal
    INNER JOIN usuario ON usuario.Username = descarga.Username
    WHERE reproduccionencurso.Username = NEW.reproduccionencurso.Username;
    
    -- WIFI --
    SELECT Wifi INTO wifi_
    FROM reproduccionencurso 
    INNER JOIN dispositivo ON reproduccioencurso.idDisopositivo = dispositivo.idDispositivo
    WHERE reproduccioencurso.idDisopositivo = NEW.reproduccioencurso.idDisopositivo;
    
    -- ABONO VENCIDO --
    SELECT FechaVTO INTO VTO
	FROM reproduccionencurso 
	INNER JOIN usuario ON reproduccionencurso.Username = usuario.Username
	INNER JOIN abono ON usuario.Email = abono.Email
	WHERE usuario.Username = NEW.usuario.Username
	GROUP BY Email;

	-- NIÑOS --
	SELECT FechaNac INTO fechita
    FROM reproduccionencurso INNER JOIN usuario ON reproduccionencurso.Username = usuario.Username
    WHERE Username = NEW.Username;
	
	SELECT CalifSalida INTO califi
    FROM 
    (
    -- Pelicula
    (SELECT TiOriginal FROM reproduccionencurso 
    INNER JOIN pelicula ON reproduccionencurso.TiOriginal = pelicula.TiOriginal) 
    
    UNION
    
    -- Documental
    (SELECT TiOriginal FROM reproduccionencurso 
    INNER JOIN documental ON reproduccionencurso.TiOriginal = documental.TiOriginal)
    
    UNION
    
    -- Serie
    (SELECT NombreSerie AS TiOriginal FROM reproduccionencurso 
    INNER JOIN capitulo ON capitulo.TiOriginal = reproduccionencurso.TiOriginal
    INNER JOIN serie ON serie.NombreSerie = capitulo.NombreSerie) 
    ) as e
    WHERE(TiOriginal = NEW.TiOriginal);

-- Si no pagó
IF CURDATE() >= VTO + 5 THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Abono pendiente de pago.';
-- Sino
ELSE 
	-- Si es niño
	IF YEAR(CURDATE()) - YEAR(fechita) < 13 AND califi NOT LIKE 'ATP' THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Restricción de menor de edad aplicada sobre este título';
	-- Si no
    ELSE
		-- Si no tiene el audio seleccionado
		IF iAud NOT IN (SELECT idAudio FROM audiocontenido WHERE (audiocontenido.TiOriginal = NEW.TiOriginal)) THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Idioma de audio no disponible en este título';
		ELSE
			-- Si no tiene el subtitulo seleccionado
			IF iSub NOT IN (SELECT idSubtitulo FROM subtitulocontenido WHERE (subtitulocontenido.TiOriginal = NEW.TiOriginal)) THEN
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Idioma de subtitulo no disponible en este título';
			ELSE
				-- Si no tiene wifi y tampoco está en descargas
				IF wifi_ IS NULL AND descargado IS NULL THEN
					SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No tienes red wifi ni tampoco descargado para reproducir el contenido';
				ELSE
					IF descargado IS NOT NULL AND cal LIKE 'normal' THEN
						SET NEW.IdAudio = 1;
						SET NEW.IdSubtitulo = NULL;
                    END IF;
				END IF;
			END IF;
		END IF;
	END IF;
END IF;

END$$

/*CREATE DEFINER=`root`@`localhost` TRIGGER `reproduccionencurso_AFTER_UPDATE` AFTER UPDATE ON `reproduccionencurso` FOR EACH ROW BEGIN
	DECLARE DurContenido INT UNSIGNED;

    SELECT Duracion INTO DurContenido
    FROM contenido
    WHERE TiOriginal = NEW.TiOriginal;
	
    -- Si se terminó de reproducir
    IF NEW.PtoSuspenso = DurContenido THEN
		-- Se inserta el registro en la tabla historial 
        INSERT INTO historial (TiOriginal, FechaVisto, Username, IdiomaAudio)
        VALUES (NEW.TiOriginal, NEW.FechaVisto, NEW.Username, NEW.IdiomaAudio);
	
		-- Se saca el registro de la tabla de reproducción
        DELETE FROM reproduccionencurso
        WHERE reproduccionencurso.idReproduccion = NEW.idReproduccion;
    END IF;
END$$*/

CREATE DEFINER=`root`@`localhost` TRIGGER `reproduccionencurso_BEFORE_DELETE` BEFORE DELETE ON `reproduccionencurso` FOR EACH ROW BEGIN

DECLARE puntito INT UNSIGNED;
DECLARE duracioncita INT UNSIGNED;

SELECT PtoSuspenso INTO puntito
FROM reproduccionencurso
WHERE reproduccionencurso.PtoSuspenso = OLD.reproduccionencurso.PtoSuspenso;

SELECT duracion INTO duracioncita
FROM reproduccionencurso INNER JOIN contenido ON reproduccionencurso.TiOriginal = contenido.TiOriginal
WHERE reproduccionencurso.TiOriginal = OLD.reproduccionencurso.TiOriginal;


IF duracioncita >= puntito THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No puedes eliminar tu historial';
END IF;

END;

-- USUARIO
CREATE DEFINER=`root`@`localhost` TRIGGER `usuario_BEFORE_INSERT` BEFORE INSERT ON `usuario` FOR EACH ROW BEGIN
	DECLARE TotalUsuarios INT UNSIGNED;
    DECLARE fechanaci DATE;
    
	SELECT NEW.FechaNac INTO fechanaci;
    
    SELECT SUM(usuario.Email) INTO TotalUsuarios
    FROM usuario 
    WHERE (usuario.Email = NEW.Email)
    GROUP BY Email;
    
    -- Si la FechaNac es inválida
	IF YEAR(fechanaci > CURDATE()) OR YEAR(NEW.FechaNac) < 1910 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Fecha de nacimiento invalida';
	-- Si no
    ELSE
        -- Si hay 3 o más usuarios en un mismo mail
		IF TotalUsuarios >= 3 THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ya hay 3 usuarios en la cuenta';
		END IF;
	END IF;
    
END$$

-- WATCHPARTY
CREATE DEFINER=`root`@`localhost` TRIGGER `watchparty_BEFORE_INSERT` BEFORE INSERT ON `watchparty` FOR EACH ROW BEGIN

DECLARE user1 VARCHAR(20);
DECLARE user2 VARCHAR(20);
DECLARE fechita1 DATE;
DECLARE fechita2 DATE;
DECLARE califi VARCHAR(10);

SELECT NEW.UserEmisor INTO user1;
SELECT New.UserReceptor INTO user2;

-- NIÑOS --
SELECT FechaNac INTO fechita1
FROM watchparty INNER JOIN usuario ON watchparty.UserEmisor = usuario.Username
WHERE Username = NEW.UserEmisor;

SELECT FechaNac INTO fechita2
FROM watchparty INNER JOIN usuario ON watchparty.UserReceptor = usuario.Username
WHERE Username = NEW.UserReceptor;
	
SELECT CalifSalida INTO califi
FROM 
(
-- Pelicula
(SELECT TiOriginal FROM watchparty 
INNER JOIN reproduccionencurso ON watchparty.idReproduccion = reproduccionencurso.idReproduccion
INNER JOIN pelicula ON pelicula.TiOriginal = reproduccionencurso.TiOriginal) 
    
UNION
    
-- Documental
(SELECT TiOriginal FROM watchparty 
INNER JOIN reproduccionencurso ON watchparty.idReproduccion = reproduccionencurso.idReproduccion
INNER JOIN documental ON documental.TiOriginal = reproduccionencurso.TiOriginal) 
    
UNION
    
-- Serie
(SELECT NombreSerie AS TiOriginal FROM watchparty 
INNER JOIN reproduccionencurso ON watchparty.idReproduccion = reproduccionencurso.idReproduccion
INNER JOIN capitulo ON capitulo.TiOriginal = reproduccionencurso.TiOriginal
INNER JOIN serie ON serie.NombreSerie = capitulo.NombreSerie) 
) as e
WHERE(idReproduccion = NEW.idReproduccion);

IF user1 LIKE user2 THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No puedes hacer watchparty con vos mismo';
ELSE
	IF (YEAR(CURDATE()) - YEAR(fechita1) < 13 OR YEAR(CURDATE()) - YEAR(fechita2) < 13) AND califi NOT LIKE 'ATP' THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Restricción de menor de edad aplicada sobre este título';
	END IF;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` TRIGGER `watchparty_AFTER_INSERT` AFTER INSERT ON `watchparty` FOR EACH ROW BEGIN

DECLARE titulo VARCHAR(40);
DECLARE v FLOAT UNSIGNED;
DECLARE ps INT UNSIGNED;
DECLARE fv DATE;
DECLARE ia VARCHAR(10);
DECLARE isub VARCHAR(10);

SELECT TiOriginal, Velocidad, PtoSuspenso, FechaVisto, IdiomaAudio, IdiomaSubtitulo INTO titulo, v, ps, fv, ia, isub
FROM watchparty
INNER JOIN reproduccionencurso ON watchparty.idReproduccion = reproduccionencurso.idReproduccion
WHERE(NEW.watchparty.idReproduccion = watchparty.idReproduccion);

INSERT INTO Reproduccionencurso (TiOriginal, Username, Velocidad, PtoSuspenso, FechaVisto, IdiomaAudio, IdiomaSubtitulo)
VALUES (titulo, UserReceptor, v, ps, fv, ia, isub);

END;

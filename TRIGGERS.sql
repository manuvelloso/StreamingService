-- ABONO
-- Modiicar tabla abono las fechas de vto
DELIMITER $$
USE `mydb_final`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `abono_BEFORE_INSERT` BEFORE INSERT ON `abono` FOR EACH ROW BEGIN
    -- Si hubo un cambio de mes
    IF DATE_FORMAT(CURDATE(), '%Y-%m') > DATE_FORMAT(CURDATE()-1, '%Y-%m') THEN
		INSERT INTO abono(Email, Monto, FechaVTO, FormaPago)
        VALUES (NEW.Email,NEW.Monto,NEW.FechaVTO,NEW.FormaPago); -- FechaVTO=curdate()+30
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` TRIGGER `abono_AFTER_INSERT` AFTER INSERT ON `abono` FOR EACH ROW BEGIN
 -- Si pagó con 'Comprobante'
 DECLARE formita VARCHAR(45);
 SELECT NEW.FormaPago INTO formita;

 IF formita LIKE 'Comprobante' THEN
   SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Generando comprobante';
END IF;
/* 
-- Siempre que se modifique la tabla abono ==> chequeo los deudores
-- Si el usuario no pagó, se le avisa la futura cancelación del servicio
IF NEW.FechaVTO < CURDATE() THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Futura cancelacion del servicio de streaming ante la falta de pago\nSe otorgan 5 días para la cancelacion de la deuda';
END IF;*/
END$$

-- BUSQUEDA
-- Los niños no pueden buscar títulos originales que no sean ATP

-- CALIFICA
CREATE DEFINER=`root`@`localhost` TRIGGER `califica_BEFORE_INSERT` BEFORE INSERT ON `califica` FOR EACH ROW BEGIN
    DECLARE fechita DATE;
    DECLARE califi VARCHAR(10);
    DECLARE VTO DATE;

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
        -- Si no: lo puedo ingresar!
        ELSE
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
CREATE DEFINER=`root`@`localhost` TRIGGER `capitulo_AFTER_INSERT` AFTER INSERT ON `capitulo` FOR EACH ROW BEGIN

DECLARE nt INT UNSIGNED;

SELECT NumTemp INTO nt
FROM capitulo INNER JOIN serie
WHERE capitulo.NombreSerie = NEW.serie.NombreSerie
GROUP BY NombreSerie;

-- si es la ultima temporada -> avisar
IF nt = NEW.serie.CantTemporadas THEN
 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FINAL SEASON!!!';
END IF;

END$$

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
	ELSE
		INSERT INTO casting(DispEmisor, DispReceptor)
		VALUES (NEW.DispEmisor, NEW.DispReceptor);
	END IF;
END IF;
END$$

-- DESCARGA
CREATE DEFINER=`root`@`localhost` TRIGGER `descarga_BEFORE_INSERT` BEFORE INSERT ON `descarga` FOR EACH ROW BEGIN
DECLARE TotalMins INT UNSIGNED;
DECLARE titulito VARCHAR(40);
DECLARE fechita DATE;
DECLARE VTO DATE;
DECLARE califi VARCHAR(10);

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
-- si no
ELSE
	-- Si no hay espacio
	IF TotalMins + (SELECT Duracion FROM contenido WHERE TiOriginal = NEW.TiOriginal) > 240 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO HAY ESPACIO. La descarga supera el límite de 4 horas de contenido.';
	-- Sino
    ELSE
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
				INSERT INTO favorito (Username, TiOriginal)
				VALUES (NEW.Username, NEW.TiOriginal);
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
ELSE
	INSERT INTO dispositivo(Username, DispNom, MarcaDisp, TipoDisp, ModeloDisp, RedWifi)
    VALUES (NEW.Username, NEW.DispNom, NEW.MarcaDisp, NEW.TipoDisp, NEW.ModeloDisp, NEW.RedWifi);
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
			-- Si no: lo puedo ingresar!
			ELSE
				INSERT INTO favorito (Username, TiOriginal)
				VALUES (NEW.Username, NEW.TiOriginal);
			END IF;
		END IF;
	END IF;
END$$

-- PREMIO
-- Año del premio debe ser >= a el del lanzamiento de la pelicula

-- REPRODUCCIÓN EN CURSO
CREATE DEFINER=`root`@`localhost` TRIGGER `reproduccionencurso_BEFORE_INSERT` BEFORE INSERT ON `reproduccionencurso` FOR EACH ROW BEGIN
DECLARE fechita DATE;
	DECLARE VTO DATE;
	DECLARE califi VARCHAR(10);
	DECLARE iAud VARCHAR(20);
    DECLARE iSub VARCHAR(20);
    
    SELECT NEW.IdiomaAudio INTO iAud;
    SELECT NEW.IdiomaSubtitulo INTO iSub;
    
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
        IF iAud NOT IN (SELECT IdiomaAudio FROM audiocontenido INNER JOIN audio ON audio.idAudio = audiocontenido.idAudio WHERE (audiocontenido.TiOriginal = NEW.TiOriginal)) THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Idioma de audio no disponible en este título';
		ELSE
			IF iSub NOT IN (SELECT IdiomaSubtitulo FROM subtitulocontenido INNER JOIN subtitulo ON subtitulo.idSubtitulo = subtitulocontenido.idSubtitulo WHERE (subtitulocontenido.TiOriginal = NEW.TiOriginal)) THEN
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Idioma de subtitulo no disponible en este título';
			ELSE
				INSERT INTO reproduccionencurso(TiOriginal, Username, Velocidad, PtoSuspenso, FechaVisto, IdiomaAudio, IdiomaSubtitulo)
				VALUES (NEW.TiOriginal, NEW.Username, NEW.Velocidad, NEW.PtoSuspenso, NEW.FechaVisto, NEW.IdiomaAudio, NEW.IdiomaSubtitulo);
			END IF;
		END IF;
	END IF;
END IF;

END$$
-- ADD: si no tengo wifi -> busco el contenido a reproducir en descarga y si no está no lo puedo reproducir
-- ADD: antes de insertar en rep en curso, me tengo que fijar si estoy descargado con calidad normal (set sub = español) en el caso de que no sea null y set audio = castellano

CREATE DEFINER=`root`@`localhost` TRIGGER `reproduccionencurso_AFTER_UPDATE` AFTER UPDATE ON `reproduccionencurso` FOR EACH ROW BEGIN
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
END$$

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
INNER JOIN pelicula ON watchparty.TiOriginal = pelicula.TiOriginal) 
    
UNION
    
-- Documental
(SELECT TiOriginal FROM watchparty 
INNER JOIN documental ON watchparty.TiOriginal = documental.TiOriginal)
    
UNION
    
-- Serie
(SELECT NombreSerie AS TiOriginal FROM watchparty 
INNER JOIN capitulo ON capitulo.TiOriginal = watchparty.TiOriginal
INNER JOIN serie ON serie.NombreSerie = capitulo.NombreSerie) 
) as e
WHERE(TiOriginal = NEW.TiOriginal);

IF user1 LIKE user2 THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No puedes hacer watchparty con vos mismo';
ELSE
	IF (YEAR(CURDATE()) - YEAR(fechita1) < 13 OR YEAR(CURDATE()) - YEAR(fechita2) < 13) AND califi NOT LIKE 'ATP' THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Restricción de menor de edad aplicada sobre este título';
	END IF;
END IF;

END$$
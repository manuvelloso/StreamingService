CREATE DATABASE IF NOT EXISTS StreamingService
USE StreamingService

-- -----------------------------------------------------
-- Table ABONA
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ABONA (
  Email VARCHAR(30) NOT NULL,
  Factura VARCHAR(45) NOT NULL,
  Monto FLOAT UNSIGNED NOT NULL,
  FechaPago DATE NULL DEFAULT NULL,
  FormaPago VARCHAR(45) NOT NULL,
  PRIMARY KEY (Email, Factura),
  FOREIGN KEY (Factura) REFERENCES ABONO (Factura)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  FOREIGN KEY (Email) REFERENCES CUENTA (Email)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CHECK(Email IN (SELECT Email FROM CUENTA) 
        AND Factura IN (SELECT Factura FROM ABONO))
  -- PODRIAMOS VER LO DEL DESCUENTO!!
  );
  
-- -----------------------------------------------------
-- Table ABONO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ABONO (
  Factura VARCHAR(45) NOT NULL AUTO_INCREMENT,
  FechaVTO DATE NOT NULL,
  PRIMARY KEY (Factura));
  CHECK ( IF FechaPago IS NULL AND FormaPago NULL) -- VER ESTO!!
-- -----------------------------------------------------
-- Table ACTOR
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ACTOR (
  idActor INT UNSINED NOT NULL AUTO_INCREMENT,
  Nombre VARCHAR(45) NOT NULL,
  Apellido VARCHAR(45) NOT NULL,
  PRIMARY KEY (idActor));

-- -----------------------------------------------------
-- Table ACTUA
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ACTUA (
  idActor INT UNSIGNED NOT NULL,
  TiOriginal VARCHAR(40) NOT NULL,
  PRIMARY KEY (idActor, TiOriginal),
  FOREIGN KEY (idActor) REFERENCES ACTOR (idActor)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  FOREIGN KEY (TiOriginal) REFERENCES CONTENIDO (TiOriginal)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CHECK(idActor IN (SELECT idActor FROM ACTOR) 
        AND TiOriginal IN (SELECT TiOriginal FROM CONTENIDO))
);
  
-- -----------------------------------------------------
-- Table CUENTA
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS CUENTA (
  Email VARCHAR(30) NOT NULL,
  Contrasenia VARCHAR(20) NOT NULL,
  Tarjeta VARCHAR(16) NOT NULL,
  Idioma VARCHAR(15) NOT NULL,
  PRIMARY KEY (Email));
  -- CHEQUEAR QUE NO TENGA + DE 3 USUARIOS!!
  
-- -----------------------------------------------------
-- Table CONTENIDO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS CONTENIDO (
  TiOriginal VARCHAR(40) NOT NULL,
  idAudio INT UNSIGNED NOT NULL,
  CalifAverage FLOAT NULL,
  Genero VARCHAR(20) NULL,
  Director VARCHAR(45) NULL,
  PRIMARY KEY (TiOriginal),
  FOREIGN KEY (idAudio) REFERENCES AUDIO (idAudio)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
   FOREIGN KEY (Genero) REFERENCES GENCON (idGenero)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CHECK(idAudio IN (SELECT idAudio FROM AUDIO) 
        AND Genero IN (SELECT idGenero FROM GENCON))
);

-- -----------------------------------------------------
-- Table DISPOSITIVO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS DISPOSITIVO (
  idDispositivo INT UNSIGNED NOT NULL AUTO_INCREMENT,
  Nombre VARCHAR(10) NOT NULL,
  Marca VARCHAR(20) NOT NULL,
  Tipo INT NOT NULL,
  Modelo VARCHAR(10) NOT NULL,
  RedWifi VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (idDispositivo)),
  FOREIGN KEY (Tipo) REFERENCES TIPODISP (idTipo)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CHECK(Tipo IN (SELECT idTipo IN TIPODISP))
  );

-- -----------------------------------------------------
-- Table ASOCIAN
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ASOCIAN (
  idDispositivo INT UNSIGNED NOT NULL,
  Email VARCHAR(30) NOT NULL,
  PRIMARY KEY (idDispositivo, Email),
  FOREIGN KEY (Email) REFERENCES CUENTA (Email),
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  FOREIGN KEY (idDispositivo) REFERENCES DISPOSITIVO (idDispositivo)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CHECK(EmaiL IN (SELECT Email FROM CUENTA) 
        AND idDispositIvo IN (SELECT idDispositivo FROM DISPOSITIVO))
  -- DEVERÍAMOS CHEQUEAR LA CANTIDAD DE DISPOSITIVOS QUE SE PUEDEN VINCULAR
);

-- -----------------------------------------------------
-- Table SERIE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS SERIE (
  NombreSerie VARCHAR(45) NOT NULL,
  TiEspañol VARCHAR(45) NOT NULL,
  TiIngles VARCHAR(45) NOT NULL,
  AnioLanzamiento DATE NOT NULL,
  Productor VARCHAR(45) NOT NULL,
  CalifSalida INT UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (NombreSerie)
  FOREIGN KEY (CalifSalida) REFERENCES CALIFICACION (idCalificacion)
    ON UPDATE CASCADE
);

-- -----------------------------------------------------
-- Table CAPITULO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS CAPITULO (
  TiOriginal VARCHAR(45) NOT NULL,
  NombreSerie VARCHAR(45) NOT NULL,
  NumCap INT UNSIGNED NOT NULL,
  NumTemp INT UNSIGNED NOT NULL,
  FechaLanzamiento DATE NOT NULL,
  Duracion INT UNSIGNED NOT NULL,
  PRIMARY KEY (TiOriginal, NombreSerie),
  FOREIGN KEY (NombreSerie) REFERENCES SERIE (NombreSerie),
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  FOREIGN KEY (TiOriginal) REFERENCES CONTENIDO(TiOriginal)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CHECK(NombreSerie IN (SELECT NombreSerie FROM SERIE) 
        AND TiOriginal IN (SELECT TiOriginal FROM CONTENIDO)
);

-- -----------------------------------------------------
-- Table USUARIO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS USUARIO (
  Username VARCHAR(20) NOT NULL,
  Telefono VARCHAR(10) NOT NULL,
  FechaNac DATE NOT NULL,
  PRIMARY KEY (Username));

-- -----------------------------------------------------
-- Table USAURIOASOCIADO (es la new contiene)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS USUARIOASOCIADO (
  Username VARCHAR(20) NOT NULL,
  Email VARCHAR(30) NOT NULL,
  PRIMARY KEY (Username, Email),
  FOREIGN KEY (Email) REFERENCES CUENTA (Email)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  FOREIGN KEY (Username) REFERENCES USUARIO (Username)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CHECK(Email IN (SELECT Email FROM CUENTA) 
        AND Username IN (SELECT Username FROM USUARIO)
  -- DEVERÍAMOS CHEQUEAR LA CANTIDAD DE CUENTAS QUE SE PUEDEN VINCULAR
);

-- -----------------------------------------------------
-- Table DOCUMENTAL
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS DOCUMENTAL (
  TiOriginal VARCHAR(45) NOT NULL,
  Tema INT UNSIGNED NOT NULL,
  Duracion INT UNSIGNED NOT NULL,
  AnioLanzamiento DATE NOT NULL,
  PRIMARY KEY (TiOriginal),
  FOREIGN KEY (TiOriginal) REFERENCES CONTENIDO (TiOriginal)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  FOREIGN KEY (Tema) REFERENCES TEMADOC (idTema)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CHECK(TiOriginal IN (SELECT TiOrignal FROM CONTENIDO) 
        AND Tema IN (SELECT idTema FROM TEMADOC)
  );

-- -----------------------------------------------------
-- Table ESDUEÑO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ESDUEÑO (
  Username VARCHAR(20) NOT NULL,
  idDispositivo INT UNSIGNED NOT NULL,
  PRIMARY KEY (Username, idDispositivo),
  FOREIGN KEY (Username) REFERENCES USUARIO (Username)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  FOREIGN KEY (idDispositivo) REFERENCES DISPOSITIVO (idDispositivo)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CHECK(Username IN (SELECT Username FROM USUARIO) 
        AND idDispositivo IN (SELECT idDispositivo FROM DISPOSITIVO)
);

-- -----------------------------------------------------
-- Table HISTORIAL *************************************
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS HISTORIAL (
  TiOriginal VARCHAR(40) NOT NULL,
  FechaVisto DATE NOT NULL,
  Usuario VARCHAR(45) NOT NULL,
  IdiomaAudio VARCHAR(20) NULL,
  PRIMARY KEY (TiOriginal),
  FOREIGN KEY (TiOriginal) REFERENCES CONTENIDO (TiOriginal)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  FOREIGN KEY (Usuario) REFERENCES USUARIO (Username)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
  
-- -----------------------------------------------------
-- Table PELICULA
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PELICULA (
  TiOriginal VARCHAR(40) NOT NULL,
  TiIngles VARCHAR(45) NOT NULL,
  TiEspaniol VARCHAR(45) NOT NULL,
  Duracion INT UNSIGNED NOT NULL,
  AnioLanzamiento DATE NOT NULL,
  Productor VARCHAR(45) NOT NULL,
  CalifSalida VARCHAR(10) NULL DEFAULT NULL,
  PRIMARY KEY (TiOriginal),
  FOREIGN KEY (TiOriginal) REFERENCES CONTENIDO (TiOriginal)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CHECK(TiOriginal IN (SELECT TiOriginal FROM CONTENIDO))
);

-- -----------------------------------------------------
-- Table PREMIO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PREMIO (
  TiOriginal VARCHAR(40) NOT NULL,
  Anio DATE NOT NULL,
  Categoria VARCHAR(30) NOT NULL,
  Festival VARCHAR(20) NOT NULL,
  PRIMARY KEY (TiOriginal),
  FOREIGN KEY (TiOriginal) REFERENCES PELICULA (TiOriginal)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CHECK(TiOriginal IN (SELECT TiOriginal FROM PELICULA))
);

-- -----------------------------------------------------
-- Table DESCARGA
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS DESCARGA (
  Usuario VARCHAR(20) NOT NULL,
  TiOriginal VARCHAR(40) NOT NULL,
  TotalMins INT NOT NULL,
  Calidad INT UNSIGNED NOT NULL,
  PRIMARY KEY (Usuario, TiOriginal),
  FOREIGN KEY (Usuario) REFERENCES USUARIO (Username)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  FOREIGN KEY (TiOriginal) REFERENCES CONTENIDO (TiOriginal)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  FOREIGN KEY (Calidad) REFERENCES CALIDADVIDEO(idCalidad),
  CHECK(Usuario IN (SELECT Username FROM USUARIO) 
        AND TiOriginal IN (SELECT TiOriginal FROM CONTENIDO)
        AND Calidad IN (SELECT idCalidad FROM CALIDADVIDEO))
  
 -- CHEQUEAR LA CANTIDAD DE VIDEOS DECARGADOS!!
);

-- -----------------------------------------------------
-- Table FAVORITO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS FAVORITO (
  Usuario VARCHAR(20) NOT NULL,
  TiOriginal VARCHAR(40) NOT NULL,
  PRIMARY KEY (Usuario, TiOriginal),
  FOREIGN KEY (Usuario) REFERENCES USUARIO (Username)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  FOREIGN KEY (TiOriginal) REFERENCES CONTENIDO (TiOriginal)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
 CHECK(Usuario IN (SELECT Username FROM USUARIO) 
        AND TiOriginal IN (SELECT TiOriginal FROM CONTENIDO))
);

-- -----------------------------------------------------
-- Table CALIFICA
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS CALIFICA (
  Usuario VARCHAR(20) NOT NULL,
  TiOriginal VARCHAR(40) NOT NULL,
  CalPersonal INT UNSIGNED NOT NULL,
  PRIMARY KEY (Usuario, TiOriginal),
  FOREIGN KEY (Usuario) REFERENCES USUARIO (Username)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  FOREIGN KEY (TiOriginal) REFERENCES CONTENIDO (TiOriginal)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  FOREIGN KEY (CalPersonal) REFERENCES CALIFICACION (idCalificacion)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CHECK(Usuario IN (SELECT Username FROM USUARIO) 
        AND TiOriginal IN (SELECT TiOriginal FROM CONTENIDO))
);

-- -----------------------------------------------------
-- Table REPRODUCE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS REPRODUCE (
  TiOriginal VARCHAR(40) NOT NULL,
  Username VARCHAR(20) NOT NULL,
  Velocidad INT UNSIGNED NOT NULL,
  IdiomaAudio INT UNSIGNED NOT NULL,
  IdiomaSub INT UNSIGNED NULL,
  PtoSuspenso INT UNSIGNED NOT NULL,
  FechaVisto DATE NOT NULL,
  PRIMARY KEY (TiOriginal, Username),
  FOREIGN KEY (TiOriginal) REFERENCES CONTENIDO (TiOriginal)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  FOREIGN KEY (Username) REFERENCES USUARIO (Username)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  FOREIGN KEY (Velocidad) REFERENCES VELREP (idVelocidad)
    ON UPDATE CASCADE,
  FOREIGN KEY (IdiomaAudio) REFERENCES AUDIO (idAudio)
    ON UPDATE CASCADE,
  FOREIGN KEY (IdiomaSub) REFERENCES SUBTITULO (idSubtitulo)
    ON UPDATE CASCADE,
  CHECK(Usuario IN (SELECT Username FROM USUARIO) 
        AND TiOriginal IN (SELECT TiOriginal FROM CONTENIDO)
        AND Velocidad IN (SELECT idVelocidad FROM VELREP)
        AND IdiomaAudio IN (SELECT idAudio FROM AUDIO)
        AND IdiomaSub IN (SELECT idSubtitulo FROM SUBTITULO)
-- HAY QUE CHEQUEAR LO DE LOS MODELOS DE ALTA GAMA PARA LA VELOCIDAD!!
);

-- -----------------------------------------------------
-- Table PERMITEVER
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PERMITEVER (
  idDispositivo INT UNSIGNED NOT NULL,
  TiOriginal VARCHAR(40) NOT NULL,
  PRIMARY KEY (idDispositivo, TiOriginal),
  FOREIGN KEY (idDispositivo) REFERENCES DISPOSITIVO (idDispositivo)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  FOREIGN KEY (TiOriginal) REFERENCES CONTENIDO (TiOriginal)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
   CHECK(Usuario IN (SELECT Username FROM USUARIO) 
        AND TiOriginal IN (SELECT TiOriginal FROM CONTENIDO)
        AND idDispositivo IN (SELECT idDispositivo FROM DISPOSITIVO))
);
  
-- -----------------------------------------------------
-- Table CALIDADVIDEO
-- -----------------------------------------------------
  CREATE TABLE IF NOT EXISTS CALIDADVIDEO (
    idCalidad INT UNSIGNED NOT NULL AUTO_INCREMENT,
    Calidad VARCHAR(10) NOT NULL,
    PRIMARY KEY (idCalidad));

-- -----------------------------------------------------
-- Table VELREP
-- -----------------------------------------------------
  CREATE TABLE IF NOT EXISTS VELREP (
    idVelocidad INT UNSIGNED NOT NULL AUTO_INCREMENT,
    Velocidad FLOAT NOT NULL,
    PRIMARY KEY (idVelocidad));
  
-- -----------------------------------------------------
-- Table CALIFICACION
-- -----------------------------------------------------
  CREATE TABLE IF NOT EXISTS CALIFICACION (
    idCalificacion INT UNSIGNED NOT NULL AUTO_INCREMENT,
    Calificacion VARCHAR (10) NOT NULL,
    PRIMARY KEY (idCalificacion));
  
-- -----------------------------------------------------
-- Table SUBTITULO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS SUBTITULO (
  idSubtitulo INT UNSIGNED NOT NULL,
  IdiomaSub VARCHAR(20) NULL,
  PRIMARY KEY (idSubtitulo));

-- -----------------------------------------------------
-- Table AUDIO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS AUDIO (
  idAudio INT UNSIGNED NOT NULL AUTO_INCREMENT,
  IdiomaAudio VARCHAR(20) NOT NULL,
  PRIMARY KEY (idAudio));
  
-- -----------------------------------------------------
-- Table TIPODISP
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS TIPODISP (
  idTipo INT UNSIGNED NOT NULL AUTO_INCREMENT,
  Tipo VARCHAR(20) NOT NULL,
  PRIMARY KEY (idTipo));

-- -----------------------------------------------------
-- Table TEMADOC
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS TEMADOC (
  idTema INT UNSIGNED NOT NULL AUTO_INCREMENT,
  Tema VARCHAR(20) NOT NULL,
  PRIMARY KEY (idTema));
  
-- -----------------------------------------------------
-- Table GENCON
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS GENCON (
  idGenero INT UNSIGNED NOT NULL AUTO_INCREMENT,
  Genero VARCHAR(20) NOT NULL,
  PRIMARY KEY (idGenero));
  
-- -----------------------------------------------------
-- Table MODELO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS MODELO (
  idModelo INT UNSIGNED NOT NULL AUTO_INCREMENT,
  MODELO VARCHAR(10) NOT NULL,
  PRIMARY KEY (idModelo));

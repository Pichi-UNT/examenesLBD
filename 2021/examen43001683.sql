-- Año: 2023
-- Carrizo Avellaneda Agustin
-- Plataforma (SO + Versión): Linux Lubuntu
-- Motor y Versión: MySQL 8.0.33
DROP SCHEMA IF EXISTS examen43001683;
CREATE SCHEMA IF NOT EXISTS examen43001683;
USE examen43001683;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null,
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS Direcciones
(
    -- add columns
    idDireccion  INT AUTO_INCREMENT NOT NULL,
    calleYNumero varchar(50)        NOT NULL,
    municipio    varchar(20)        NOT NULl,
    codigoPostal varchar(10)        NULL,
    telefono     varchar(20)        NOT NULL,

    -- set primary key
    PRIMARY KEY (idDireccion),
    -- add necessary indexs and unique indexs
    UNIQUE INDEX UX_calleYNumero (calleYNumero)
)
    ENGINE = InnoDB;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null,
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
-- si quiero crear una foreign key creo la columna y elijo si es nula o not null, 
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS Generos
(
    -- add columns
    idGenero char(10)    NOT NULL,
    nombre   varchar(25) NOT NULL,
    -- set primary key
    PRIMARY KEY (idGenero),

    -- add necessary indexs and unique indexs
    UNIQUE INDEX UX_nombre (nombre)

)
    ENGINE = InnoDB;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null,
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS Peliculas
(
    -- add columns
    idPelicula    INT          NOT NULL,
    titulo        varchar(128) NOT NULL,
    estreno       INT          NULL,
    duracion      INT          NULL,
    clasificacion varchar(10)  NOT NULL DEFAULT 'G',
    -- set primary key
    PRIMARY KEY (idPelicula),
    -- add necessary indexs and unique indexs
    UNIQUE INDEX UX_titulo (titulo)

)
    ENGINE = InnoDB;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null, 
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS Personal
(
    -- add columns
    idPersonal  INT         NOT NULL,
    nombres     VARCHAR(45) NOT NULL,
    apellidos   VARCHAR(45) not null,
    idDireccion INT         NOT NULL,
    correo      VARCHAR(50) NULL,
    estado      char(1)     not null default 'E',
    -- set primary key
    PRIMARY KEY (idPersonal),
    -- add foreign key reference
    CONSTRAINT refDirecciones77 FOREIGN KEY (idDireccion)
        REFERENCES Direcciones (idDireccion),
    -- add foreign key indexs
    INDEX IX_idDireccion80 (idDireccion),
    -- add necessary indexs and unique indexs
    UNIQUE INDEX UX_correo (correo)
    -- add checks
)
    ENGINE = InnoDB;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null,
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS Sucursales
(
    -- add columns
    idSucursal  CHAR(10) NOT NULL,
    idGerente   INT      NOT NULL,
    idDireccion INT      NOT NULL,
    -- set primary key
    PRIMARY KEY (idSucursal),
    -- add foreign key reference
    CONSTRAINT refPersonal98 FOREIGN KEY (idGerente)
        REFERENCES Personal (idPersonal),
    CONSTRAINT refDirecciones100 FOREIGN KEY (idDireccion)
        REFERENCES Direcciones (idDireccion),
    -- add foreign key indexs
    INDEX IX_idGerente103 (idGerente),
    INDEX IX_idDireccion104 (idDireccion)
)
    ENGINE = InnoDB;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null, 
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS Inventario
(
    -- add columns
    idInventario INT      NOT NULL,
    idPelicula   INT      NOT NULL,
    idSucursal   CHAR(10) not null,
    -- set primary key
    PRIMARY KEY (idInventario),
    -- add foreign key reference
    CONSTRAINT refPeliculas119 FOREIGN KEY (idPelicula)
        REFERENCES Peliculas (idPelicula),
    CONSTRAINT refSucursales121 FOREIGN KEY (idSucursal)
        REFERENCES Sucursales (idSucursal),
    -- add foreign key indexs
    INDEX IX_idPelicula124 (idPelicula),
    INDEX IX_idSucursal125 (idSucursal)
)
    ENGINE = InnoDB;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null, 
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS GenerosDePeliculas
(
    -- add columns
    idPelicula INT      NOT NULL,
    idGenero   CHAR(10) not null,
    -- set primary key
    PRIMARY KEY (idPelicula, idGenero),
    -- add foreign key reference
    CONSTRAINT refGeneros139 FOREIGN KEY (idGenero)
        REFERENCES Generos (idGenero),
    CONSTRAINT refPeliculas141 FOREIGN KEY (idPelicula)
        REFERENCES Peliculas (idPelicula),
    -- add foreign key indexs
    INDEX IX_idGenero144 (idGenero),
    INDEX IX_idPelicula145 (idPelicula)
)
    ENGINE = InnoDB;


USE examen43001683;
-- PUNTO 2


create view VCantidadPeliculas as
SELECT p.idPelicula, titulo, COUNT(idInventario) as cantidad
FROM Peliculas p
         JOIN Inventario I on p.idPelicula = I.idPelicula
GROUP BY p.idPelicula, titulo
ORDER BY titulo;

select *
FROM VCantidadPeliculas;

-- PUNTO 3

DROP PROCEDURE IF EXISTS `NuevaDireccion`;
DELIMITER //

CREATE PROCEDURE `NuevaDireccion`(pCalleYNumero VARCHAR(50), pMunicipio VARCHAR(20), pCodigoPostal VARCHAR(10),
                                  pTelefono VARCHAR(20), out pMensaje varchar(256))
FINAL:
BEGIN
    -- Descripcion
    /*

    */
    -- Declaraciones

    -- Exception handler
    DECLARE EXIT HANDLER FOR SQLEXCEPTION -- lo puedo cambiar por el numero de la exception
        BEGIN
            SHOW ERRORS;
            SET pMensaje = 'Error en la transacción. Contáctese con el administrador.';
            ROLLBACK;
        END;

    IF pCalleYNumero is null OR TRIM(pCalleYNumero) = '' OR pMunicipio is null OR trim(pMunicipio) = '' OR
       pTelefono IS NULL OR TRIM(pTelefono) = '' THEN
        SET pMensaje = 'Los parametros calleYNumero, Municipio, telefono no pueden ser nulos';
        LEAVE FINAL;
    END IF;

    IF EXISTS(SELECT calleYNumero FROM Direcciones WHERE calleYNumero = pCalleYNumero) THEN
        SET pMensaje = 'Ya existe una direccion con la misma calle y numero';
        LEAVE FINAL;
    END IF;

    IF pCalleYNumero NOT REGEXP '^[a-zA-Z0-9\\s]+$' THEN
        SET pMensaje = 'Formato de calle y numero incorrecto.';
        LEAVE FINAL;
    END IF;

    IF pMunicipio NOT REGEXP
       '^[a-zA-Z\\s]+$' THEN
        SET pMensaje = 'Formato de municipio incorrecto.';
        LEAVE FINAL;
    END IF;

    IF pCodigoPostal IS NOT NULL AND pCodigoPostal NOT REGEXP
                                     '^[0-9]{1,10}$' THEN
        SET pMensaje = 'Formato de codigo postal incorrecto.';
        LEAVE FINAL;
    END IF;

    IF pTelefono NOT REGEXP
       '^[0-9]{1,20}$'THEN
        SET pMensaje = 'Formato de telefono incorrecto.';
        LEAVE FINAL;
    END IF;

    INSERT INTO Direcciones (calleYNumero, municipio, codigoPostal, telefono)
    VALUES (pCalleYNumero, pMunicipio, pCodigoPostal, pTelefono);

    SET pMensaje = CONCAT('OK', LAST_INSERT_ID());

END //


DELIMITER ;

CALL NuevaDireccion('Thames 2645', 'sm tucuman', '4000', '123456789', @mensaje);
SELECT @mensaje;
CALL NuevaDireccion('Thames 2645', 'sm tucuman', '4000', '123456789', @mensaje);
SELECT @mensaje;
CALL NuevaDireccion('Mexico 2828', 'sm tucuman', NULL, '123456789', @mensaje);
SELECT @mensaje;
CALL NuevaDireccion('Laprida 2828', 'sm tucuman', 'asd', '123456789', @mensaje);
SELECT @mensaje;
CALL NuevaDireccion('Laprida 2828', 'sm tucu123man', '1234', '12236789', @mensaje);
SELECT @mensaje;
CALL NuevaDireccion('Laprida 2828', 'sm tucuman', '1234', '12asd6789', @mensaje);
SELECT @mensaje;
CALL NuevaDireccion(NULL, NULL, '2131', NULL, @mensaje);
SELECT @mensaje;

-- PUNTO 4
DROP PROCEDURE IF EXISTS `BuscarPeliculasPorGenero`;
DELIMITER //

CREATE PROCEDURE `BuscarPeliculasPorGenero`(pIdGenero CHAR(10))
FINAL:
BEGIN
    -- Descripcion
    /*

    */
    -- Declaraciones

    SELECT p.idPelicula, p.titulo, S.idSucursal, COUNT(idInventario), D.calleYNumero
    FROM Peliculas p
             join GenerosDePeliculas GDP on p.idPelicula = GDP.idPelicula
             JOIN Inventario I on p.idPelicula = I.idPelicula
             JOIN Sucursales S on S.idSucursal = I.idSucursal
             JOIN Direcciones D on D.idDireccion = S.idDireccion
    WHERE idGenero = pIdGenero
    GROUP BY idPelicula, titulo, idSucursal, calleYNumero
    ORDER BY titulo;


END //

DELIMITER ;

CALL BuscarPeliculasPorGenero(6);

-- PUNTO 5
DELIMITER //
CREATE TRIGGER Direcciones_after_delete
    BEFORE DELETE
    ON Direcciones
    FOR EACH ROW
BEGIN
    IF EXISTS(SELECT Sucursales.idDireccion FROM Sucursales WHERE Sucursales.idDireccion = OLD.idDireccion) OR
       EXISTS(SELECT Personal.idDireccion FROM Personal WHERE Personal.idDireccion = OLD.idDireccion) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error sucursal o personal tiene como referencia la direccion que se desea eliminar';
    END IF;

END //
DELIMITER ;

DELETE FROM Direcciones WHERE idDireccion=1;
DELETE FROM Direcciones WHERE idDireccion=6;
SELECT * FROM Personal;
SELECT * FROM Direcciones WHERE idDireccion=6;


-- Año: 2023
-- Carrizo Avellaneda Agustin
-- Plataforma (SO + Versión): Linux Lubuntu
-- Motor y Versión: MySQL 8.0.33
DROP SCHEMA IF EXISTS examen43001683;
CREATE SCHEMA IF NOT EXISTS examen43001683;
USE examen43001683;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null, 
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS Autores
(
    -- add columns
    idAutor      VARCHAR(11) NOT NULL,
    apellido     varchar(40) NOT NULL,
    nombre       varchar(20) NOT NULL,
    telefono     varchar(12) NOT NULL DEFAULT 'UNKNOWN',
    domicilio    varchar(40) null,
    ciudad       varchar(20) null,
    estado       char(2)     null,
    codigoPostal char(5)     null,

    -- set primary key
    PRIMARY KEY (idAutor)

    -- add necessary indexs and unique indexs
    -- add checks
)
    ENGINE = InnoDB;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null, 
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS Tiendas
(
    -- add columns
    idTienda     char(4)     NOT NULL,
    nombre       varchar(40) not null,
    domicilio    varchar(40) null,
    ciudad       varchar(20) null,
    estado       char(2)     null,
    codigoPostal char(5)     null,
    -- set primary key
    PRIMARY KEY (idTienda),

    -- add necessary indexs and unique indexs
    UNIQUE INDEX UX_nombre46 (nombre)
    -- add checks


)
    ENGINE = InnoDB;


-- si quiero crear una foreign key creo la columna y elijo si es nula o not null,
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS Editoriales
(
    -- add columns
    idEditorial char(4)     not null,
    nombre      varchar(40) not null,
    ciudad      varchar(20) null,
    estado      char(2)     null,
    pais        varchar(30) not null default 'USA',
    -- set primary key
    PRIMARY KEY (idEditorial),

    -- add necessary indexs and unique indexs
    UNIQUE INDEX UX_nombre69 (nombre)
    -- add checks

)
    ENGINE = InnoDB;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null, 
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS Ventas
(
    -- add columns
    codigoVenta varchar(20) not null,
    idTienda    char(4)     not null,
    fecha       datetime    not null,
    tipo        varchar(12) not null,
    -- set primary key
    PRIMARY KEY (codigoVenta),
    -- add foreign key reference
    CONSTRAINT refTiendas87 FOREIGN KEY (idTienda)
        REFERENCES Tiendas (idTienda),
    -- add foreign key indexs
    INDEX IX_idTienda90 (idTienda)
    -- add necessary indexs and unique indexs
    -- add checks


)
    ENGINE = InnoDB;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null,
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS Titulos
(
    -- add columns
    idTitulo         varchar(6)    not null,
    titulo           varchar(80)   not null,
    genero           char(12)      not null DEFAULT 'UNDECIDED',
    idEditorial      char(4)       not null,
    precio           decimal(8, 2) null,
    sinopsis         varchar(200)  null,
    fechaPublicacion datetime      not null DEFAULT NOW(),
    -- set primary key
    PRIMARY KEY (idTitulo),
    -- add foreign key reference
    CONSTRAINT refEditoriales113 FOREIGN KEY (idEditorial)
        REFERENCES Editoriales (idEditorial),
    -- add foreign key indexs
    INDEX IX_idEditorial116 (idEditorial),
    -- add necessary indexs and unique indexs
    -- add checks
    CHECK ((precio is not null AND precio >= 0) OR precio is null )

)
    ENGINE = InnoDB;


-- si quiero crear una foreign key creo la columna y elijo si es nula o not null, 
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS TitulosDelAutor
(
    -- add columns
    idAutor  VARCHAR(11) not null,
    idTitulo VARCHAR(6)  not null,
    -- set primary key
    PRIMARY KEY (idAutor, idTitulo),
    -- add foreign key reference
    CONSTRAINT refAutores136 FOREIGN KEY (idAutor)
        REFERENCES Autores (idAutor),
    CONSTRAINT refTitulos138 FOREIGN KEY (idTitulo)
        REFERENCES Titulos (idTitulo),
    -- add foreign key indexs
    INDEX IX_idAutor139 (idAutor),
    INDEX IX_idTitulo140 (idTitulo)

    -- add necessary indexs and unique indexs
    -- add checks


)
    ENGINE = InnoDB;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null,
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS Detalles
(
    -- add columns
    idDetalle   INT AUTO_INCREMENT not null,
    codigoVenta varchar(20)        NOT NULL,
    idTitulo    varchar(6)         NOT NULL,
    cantidad    SMALLINT           NOT NULL,
    -- set primary key
    PRIMARY KEY (idDetalle),
    -- add foreign key reference
    CONSTRAINT refVentas161 FOREIGN KEY (codigoVenta)
        REFERENCES Ventas (codigoVenta),
    CONSTRAINT refTitulos163 FOREIGN KEY (idTitulo)
        REFERENCES Titulos (idTitulo),
    -- add foreign key indexs
    INDEX IX_codigoVenta166 (codigoVenta),
    INDEX IX_idTitulo167 (idTitulo),
    -- add necessary indexs and unique indexs
    -- add checks
    CHECK (cantidad >= 0)

)
    ENGINE = InnoDB;

create view VCantidadVentas as
SELECT V.idTienda,
       COUNT(V.idTienda)          as 'Cantidad de ventas',
       SUM(T.precio * D.cantidad) as 'Importe total de ventas'
FROM Detalles D
         JOIN Titulos T on T.idTitulo = D.idTitulo
         JOIN Ventas V on V.codigoVenta = D.codigoVenta
GROUP BY V.idTienda
ORDER BY `Cantidad de ventas` DESC;

SELECT *
FROM VCantidadVentas;

-- PUNTO 3

DROP PROCEDURE IF EXISTS `NuevaEditorial`;
DELIMITER //

CREATE PROCEDURE `NuevaEditorial`(pIdEditorial CHAR(4), pNombre varchar(40), pCiudad varchar(20), pEstado char(2),
                                  pPais varchar(30), out pMensaje varchar(256))
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

    IF pNombre IS NULL OR pPais IS NULL OR pIdEditorial IS NULL THEN
        SET pMensaje = 'ERROR nombre, ID y pais no pueden ser nulos';
        LEAVE FINAL;
    END IF;

    IF EXISTS(SELECT nombre FROM Editoriales WHERE nombre = pNombre) THEN
        SET pMensaje = 'ERROR el nombre ya existe';
        LEAVE FINAL;
    END IF;

    IF EXISTS(SELECT idEditorial FROM Editoriales WHERE idEditorial = pIdEditorial) THEN
        SET pMensaje = 'ERROR el ID ya existe';
        LEAVE FINAL;
    END IF;

    INSERT INTO Editoriales (idEditorial, nombre, ciudad, estado)
    VALUES (pIdEditorial, pNombre, pCiudad, pEstado);


    SET pMensaje = 'OK';


END //


DELIMITER ;

CALL NuevaEditorial('0001', 'PRUEBA1', 'CIUDAD AA', NULL, 'Argentina', @Mensaje);
SELECT @Mensaje;
CALL NuevaEditorial('0001', 'PRUEBA1', 'CIUDAD AA', NULL, 'Argentina', @Mensaje);
SELECT @Mensaje;
CALL NuevaEditorial('0001', 'PRUEBA2', 'CIUDAD AA', NULL, 'Argentina', @Mensaje);
SELECT @Mensaje;
CALL NuevaEditorial(NULL, NULL, 'CIUDAD AA', NULL, 'Argentina', @Mensaje);
SELECT @Mensaje;

-- PUNTO 4


SELECT *
FROM Titulos
         JOIN TitulosDelAutor TDA on Titulos.idTitulo = TDA.idTitulo
where Titulos.idTitulo = 'BU1032';

DROP PROCEDURE IF EXISTS `BuscarTitulosPorAutor`;
DELIMITER //

CREATE PROCEDURE `BuscarTitulosPorAutor`(pIdAutor VARCHAR(11))
FINAL:
BEGIN

    SELECT T.idTitulo AS 'Codigo', T.titulo, T.genero, E.nombre, T.precio, T.sinopsis, DATE(T.fechaPublicacion)
    FROM TitulosDelAutor
             JOIN Titulos T on T.idTitulo = TitulosDelAutor.idTitulo
             JOIN Editoriales E on E.idEditorial = T.idEditorial
    WHERE TitulosDelAutor.idAutor = pIdAutor;

END //


DELIMITER ;

CALL BuscarTitulosPorAutor('213-46-8915');


DELIMITER //
DROP TRIGGER if exists Editoriales_after_delete;
CREATE TRIGGER Editoriales_after_delete
    BEFORE DELETE
    ON Editoriales
    FOR EACH ROW
BEGIN
  IF EXISTS(SELECT Titulos.idTitulo FROM Titulos WHERE Titulos.idEditorial = OLD.idEditorial) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error editorial tiene como referencia un titulo';
    END IF;
END //

DELIMITER ;

DELETE FROM Editoriales WHERE idEditorial='0736'

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null, 
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS 
(
    -- add columns
    -- set primary key
    PRIMARY KEY (),
    -- add foreign key reference
    -- add foreign key indexs
    
    -- add necessary indexs and unique indexs
    -- add checks
    
    

)
    ENGINE = InnoDB;

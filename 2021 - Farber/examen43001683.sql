-- Año: 2023
-- Carrizo Avellaneda Agustin
-- Plataforma (SO + Versión): Linux Lubuntu
-- Motor y Versión: MySQL 8.0.33
DROP SCHEMA IF EXISTS examen43001683;
CREATE SCHEMA IF NOT EXISTS examen43001683;
USE examen43001683;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null, 
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS Actores
(
    -- add columns
    idActor   char(10)    NOT NULL,
    apellidos varchar(50) null,
    nombres   varchar(50) not null,
    -- set primary key
    PRIMARY KEY (idActor)

)
    ENGINE = InnoDB;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null, 
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS Peliculas
(
    -- add columns
    idPelicula    int          not null,
    titulo        varchar(128) NOT NULL,
    clasificacion varchar(5)   NOT NULL DEFAULT 'G',
    estreno       int          NULL,
    duracion      int          null,
    -- set primary key
    PRIMARY KEY (idPelicula),
    -- add foreign key reference
    -- add foreign key indexs

    -- add necessary indexs and unique indexs
    UNIQUE INDEX UX_titulo39 (titulo),
    -- add checks
    CHECK (clasificacion IN ('G', 'PG', 'PG-13', 'NC-17', 'R'))


)
    ENGINE = InnoDB;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null,
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS Direcciones
(
    -- add columns
    idDireccion  INT         NOT NULL,
    calleYNumero VARCHAR(50) NOT NULL,
    codigoPostal VARCHAR(10) NULL,
    telefono     varchar(25) NOT null,
    municipio    VARCHAR(25) null,
    -- set primary key
    PRIMARY KEY (idDireccion),
    -- add foreign key reference
    -- add foreign key indexs

    -- add necessary indexs and unique indexs
    UNIQUE INDEX UX_ca (calleYNumero)
    -- add checks


)
    ENGINE = InnoDB;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null,
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS Empleados
(
    -- add columns
    idEmpleado  INT         not null,
    apellidos   varchar(50) not null,
    nombres     varchar(50) not null,
    correo      varchar(50) null,
    estado      char(1)     not null DEFAULT 'E',
    idDireccion INT         NOT NULL,
    -- set primary key
    PRIMARY KEY (idEmpleado),
    -- add foreign key reference
    CONSTRAINT refDirecciones83 FOREIGN KEY (idDireccion)
        REFERENCES Direcciones (idDireccion),
    -- add foreign key indexs
    INDEX IX_idDireccion86 (idDireccion),

    -- add necessary indexs and unique indexs
    UNIQUE INDEX UX_correo (correo),
    -- add checks
    CHECK (estado in ('E', 'D'))


)
    ENGINE = InnoDB;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null,
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS Sucursales
(
    -- add columns
    idSucursal  CHAR(10) NOT NULL,
    idDireccion INT      NOT NULL,
    idGerente   INT      NOT NULL,

    -- set primary key
    PRIMARY KEY (idSucursal),
    -- add foreign key reference
    CONSTRAINT refDirecciones108 FOREIGN KEY (idDireccion)
        REFERENCES Direcciones (idDireccion),
    CONSTRAINT refEmpleados110 FOREIGN KEY (idGerente)
        REFERENCES Empleados (idEmpleado),
    -- add foreign key indexs
    UNIQUE INDEX UX_idDireccion (idDireccion),
    INDEX IX_idGerente114 (idGerente)
    -- add necessary indexs and unique indexs
    -- add checks


)
    ENGINE = InnoDB;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null,
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS Inventario
(
    -- add columns
    idInventario INT      NOT NULL,
    idPelicula   INT      NOT NULL,
    idSucursal   CHAR(10) NOT NULL,
    -- set primary key
    PRIMARY KEY (idInventario),
    -- add foreign key reference
    CONSTRAINT refPeliculas134 FOREIGN KEY (idPelicula)
        REFERENCES Peliculas (idPelicula),
    CONSTRAINT refSucursales136 FOREIGN KEY (idSucursal)
        REFERENCES Sucursales (idSucursal),
    -- add foreign key indexs
    INDEX IX_idPelicula139 (idPelicula),
    INDEX IX_idSucursal140 (idSucursal)

    -- add necessary indexs and unique indexs
    -- add checks


)
    ENGINE = InnoDB;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null,
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS ActoresDePeliculas
(
    -- add columns
    idActor    char(10) not null,
    idPelicula INT      NOT NULL,
    -- set primary key
    PRIMARY KEY (idActor, idPelicula),
    -- add foreign key reference
    CONSTRAINT refPeliculas160 FOREIGN KEY (idPelicula)
        REFERENCES Peliculas (idPelicula),
    CONSTRAINT refActores162 FOREIGN KEY (idActor)
        REFERENCES Actores (idActor),
    -- add foreign key indexs
    INDEX IX_idPelicula165 (idPelicula),
    INDEX IX_idActor166 (idActor)

    -- add necessary indexs and unique indexs
    -- add checks


)
    ENGINE = InnoDB;

-- PUNTO 2

create view VCantidadPeliculasEnSucursales as
SELECT P.titulo,
       S.idSucursal,
       D.calleYNumero,
       COUNT(I.idPelicula),
       CONCAT(E.apellidos, ', ', E.nombres) as Gerente
FROM Peliculas P
         join Inventario I on P.idPelicula = I.idPelicula
         join Sucursales S on S.idSucursal = I.idSucursal
         join Direcciones D on D.idDireccion = S.idDireccion
         join Empleados E on E.idEmpleado = S.idGerente
GROUP BY P.titulo, S.idSucursal, D.calleYNumero, Gerente
ORDER BY P.titulo;


SELECT *
FROM VCantidadPeliculasEnSucursales;

-- PUNTO 3
DROP PROCEDURE IF EXISTS `ModificarDireccion`;
DELIMITER //

CREATE PROCEDURE `ModificarDireccion`(pIdDireccion INT, pCalleYNumero VARCHAR(50), pCodigoPostal VARCHAR(10),
                                      pTelefono VARCHAR(25), pMunicipio VARCHAR(25), out pMensaje varchar(256))
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
            SELECT 'Error en la transacción. Contáctese con el administrador.' AS Mensaje;
            ROLLBACK;
        END;

    IF pIdDireccion IS NULL THEN
        SET pMensaje = 'Id no puede ser nulo';
        LEAVE FINAL;
    END IF;

    IF (pCalleYNumero IS NOT NULL AND trim(pCalleYNumero) = '') OR
       (pTelefono IS NOT NULL AND TRIM(pTelefono) = '') IS NULL THEN
        SET pMensaje = 'los campos calleYNumero y telefono no pueden ser nulos o estar vacio';
        LEAVE FINAL;
    END IF;

    IF NOT EXISTS(SELECT idDireccion FROM Direcciones WHERE idDireccion = pIdDireccion) THEN
        SET pMensaje = 'la direccion que se quiere modificar no existe';
        LEAVE FINAL;
    END IF;

    IF pCalleYNumero IS NOT NULL AND EXISTS(SELECT calleYNumero
                                            FROM Direcciones
                                            WHERE calleYNumero = pCalleYNumero
                                              AND idDireccion != pIdDireccion) THEN
        SET pMensaje = 'Error calle y numero ya existen';
        LEAVE FINAL;
    END IF;

    update Direcciones
    set calleYNumero = COALESCE(pCalleYNumero, calleYNumero),
        codigoPostal=pCodigoPostal,
        telefono=COALESCE(pTelefono, telefono),
        municipio=pMunicipio
    where idDireccion = pIdDireccion;

    SET pMensaje = 'OK';

END //


DELIMITER ;


SELECT *
FROM Direcciones
where idDireccion = 1;
-- Volver a los datos originales
CALL ModificarDireccion(1, '47 MySakila Drive', '-', '-', 'Alberta', @mensaje);
SELECT @mensaje;

CALL ModificarDireccion(1, 'Thames 2645', '1234', '56789', 'Tucuman', @mensaje);
SELECT @mensaje;


CALL ModificarDireccion(1, '', '1234', '56789', 'Tucuman', @mensaje);
SELECT @mensaje;


CALL ModificarDireccion(1, '28 MySQL Boulevard', '1234', '56789', 'Tucuman', @mensaje);
SELECT @mensaje;

CALL ModificarDireccion(10000, 'Camaron 1234', '1234', '56789', 'Tucuman', @mensaje);
SELECT @mensaje;

-- PUNTO 4

(SELECT A.idActor, CONCAT(A.apellidos, ', ', A.nombres) AS Actor, COUNT(ADP.idPelicula) AS Cantidad
 FROM Actores A
          join ActoresDePeliculas ADP on A.idActor = ADP.idActor
 GROUP BY A.idActor, Actor
 ORDER BY Actor)
UNION
(SELECT NULL, NULL, COUNT(*) AS Cantidad
 FROM ActoresDePeliculas ADP);


DROP PROCEDURE IF EXISTS `TotalPeliculas`;
DELIMITER //

CREATE PROCEDURE `TotalPeliculas`()
FINAL:
BEGIN
    -- Descripcion
    /*

    */
    -- Declaraciones

    -- Exception handler
    (SELECT A.idActor, CONCAT(A.apellidos, ', ', A.nombres) AS Actor, COUNT(ADP.idPelicula) AS Cantidad
     FROM Actores A
              join ActoresDePeliculas ADP on A.idActor = ADP.idActor
     GROUP BY A.idActor, Actor)
    UNION
    (SELECT NULL, NULL, COUNT(*) AS Cantidad
     FROM ActoresDePeliculas ADP)
    ORDER BY (Actor is null ), Actor;


END //


DELIMITER ;

CALL TotalPeliculas();

DROP TRIGGER IF EXISTS Peliculas_before_update;
DELIMITER //
CREATE TRIGGER Peliculas_before_update
    BEFORE UPDATE
    ON Peliculas
    FOR EACH ROW
BEGIN

    IF EXISTS(SELECT Peliculas.idPelicula FROM Peliculas WHERE Peliculas.titulo = NEW.titulo AND Peliculas.idPelicula !=NEW.idPelicula) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error el titulo ya existe';
    END IF;
END //

DELIMITER ;

select *
from Peliculas;

update Peliculas
set clasificacion = 'PG'
where idPelicula=2;




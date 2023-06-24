-- Año: 2023
-- Carrizo Avellaneda Agustin
-- Plataforma (SO + Versión): Linux Lubuntu
-- Motor y Versión: MySQL 8.0.33
DROP SCHEMA IF EXISTS examen43001683;
CREATE SCHEMA IF NOT EXISTS examen43001683;
USE examen43001683;
-- PUNTO 1
CREATE TABLE IF NOT EXISTS Trabajos
(
    -- add columns
    idTrabajo          INT          NOT NULL,
    titulo             VARCHAR(100) NOT NULL,
    duracion           INT          NOT NULL DEFAULT 6,
    area               varchar(10)  not null,
    fechaPresentacionn DATE         not null,
    fechaAprobacion    DATE         NOT NULL,
    fechaFinalizacion  DATE         NULL,
    -- set primary key
    PRIMARY KEY (idTrabajo),

    -- add necessary indexs and unique indexs
    UNIQUE INDEX UX_titulo (titulo),
    -- add checks
    CHECK (area IN ('Hardware', 'Redes', 'Software'))


)
    ENGINE = InnoDB;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null,
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS Personas
(
    -- add columns
    dni       INT         not null,
    apellidos varchar(40) not null,
    nombres   varchar(40) not null,
    -- set primary key
    PRIMARY KEY (dni)

    -- add necessary indexs and unique indexs
    -- add checks


)
    ENGINE = InnoDB;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null,
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS Cargos
(
    -- add columns
    idCargo INT         not null,
    cargo   varchar(20) not null,
    -- set primary key
    PRIMARY KEY (idCargo),
    -- add foreign key reference
    -- add foreign key indexs

    -- add necessary indexs and unique indexs
    UNIQUE INDEX UX_cargo (cargo)
    -- add checks


)
    ENGINE = InnoDB;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null,
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS Profesores
(
    -- add columns
    dni     INT NOT NULL,
    idCargo INT NOT NULL,
    -- set primary key
    PRIMARY KEY (dni),
    -- add foreign key reference
    CONSTRAINT refPersonas80 FOREIGN KEY (dni)
        REFERENCES Personas (dni),
    CONSTRAINT refCargos82 FOREIGN KEY (idCargo)
        REFERENCES Cargos (idCargo),
    -- add foreign key indexs
    INDEX IX_idCargo86 (idCargo)

    -- add necessary indexs and unique indexs
    -- add checks


)
    ENGINE = InnoDB;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null,
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS Alumnos
(
    -- add columns
    dni INT     NOT NULL,
    cx  char(7) NOT NULL,
    -- set primary key
    PRIMARY KEY (dni),
    -- add foreign key reference
    CONSTRAINT refPersonas105 FOREIGN KEY (dni)
        REFERENCES Personas (dni),
    -- add necessary indexs and unique indexs
    UNIQUE INDEX UX_cx (cx)
    -- add checks


)
    ENGINE = InnoDB;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null,
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS RolesEnTrabajos
(
    -- add columns
    idTrabajo INT          NOT NULL,
    dni       INT          NOT NULL,
    rol       varchar(7)   NOT NULL,
    desde     date         NOT NULL,
    hasta     DATE         null,
    razon     varchar(100) null,
    -- set primary key
    PRIMARY KEY (idTrabajo, dni),
    -- add foreign key reference
    CONSTRAINT refProfesores126 FOREIGN KEY (dni)
        REFERENCES Profesores (dni),
    CONSTRAINT refTrabajos128 FOREIGN KEY (idTrabajo)
        REFERENCES Trabajos (idTrabajo),
    -- add foreign key indexs
    INDEX IX_idTrabajo131 (idTrabajo),
    INDEX IX_dni132 (dni),

    -- add necessary indexs and unique indexs
    -- add checks
    CHECK (rol in ('Tutor', 'Cotutor', 'Jurado'))


)
    ENGINE = InnoDB;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null,
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS AlumnosEnTrabajos
(
    -- add columns
    idTrabajo INT          NOT NULL,
    dni       INT          NOT NULL,
    desde     DATE         not null,
    hasta     DATE         NULL,
    razon     VARCHAR(100) null,
    -- set primary key
    PRIMARY KEY (idTrabajo, dni),
    -- add foreign key reference
    CONSTRAINT refTrabajos160 FOREIGN KEY (idTrabajo)
        REFERENCES Trabajos (idTrabajo),
    CONSTRAINT refAlumnos162 FOREIGN KEY (dni)
        REFERENCES Alumnos (dni),
    -- add foreign key indexs
    INDEX IX_idTrabajo165 (idTrabajo),
    INDEX IX_dni166 (dni)
    -- add necessary indexs and unique indexs
    -- add checks


)
    ENGINE = InnoDB;

SELECT *
FROM RolesEnTrabajos
WHERE dni = 1003;

-- PUNTO 2
DROP PROCEDURE IF EXISTS `DetalleRoles`;
DELIMITER //

CREATE PROCEDURE `DetalleRoles`(pDesde DATE, pHasta DATE)
FINAL:
BEGIN

    DECLARE fechaAux DATE;

    IF pHasta IS NULL THEN
        SET pHasta = CURDATE(); -- Asigna la fecha actual si el parámetro pHasta es nulo
    END IF;


    IF pDesde > pHasta AND pDesde IS NOT NULL THEN -- se invierten las fechas
        SET fechaAux = pDesde;
        SET pDesde = pHasta;
        SET pHasta = fechaAux;
    END IF;

    select YEAR(RET.desde)                    Anio,
           P.dni,
           P2.apellidos,
           P2.nombres,
           SUM(IF(RET.rol = 'Tutor', 1, 0))   'Tutor',
           SUM(IF(RET.rol = 'Cotutor', 1, 0)) 'Cotutor',
           SUM(IF(RET.rol = 'Jurado', 1, 0))  'Jurado'
    FROM Profesores P
             join RolesEnTrabajos RET on P.dni = RET.dni
             join Personas P2 on P2.dni = P.dni
    WHERE year(desde) between YEAR(pDesde) AND (YEAR(pHasta))
       OR (pDesde IS NULL AND desde < pHasta)
    GROUP BY Anio, P.dni, P2.apellidos, P2.nombres
    ORDER BY Anio, P2.apellidos, P2.nombres;

END //

DELIMITER ;

CALL DetalleRoles('2021-1-1', '2015-1-2');

-- PUNTO 3

DROP PROCEDURE IF EXISTS `NuevoTrabajo`;
DELIMITER //

CREATE PROCEDURE `NuevoTrabajo`(pTitulo varchar(100), pDuracion INTEGER, pArea VARCHAR(10), pFechaPresentacion DATE,
                                pFechaAprobacion DATE, out pMensaje varchar(256))
FINAL:
BEGIN
    -- Descripcion
    /*

    */
    -- Declaraciones
    DECLARE vUltimoID INT;

    -- Exception handler
    DECLARE EXIT HANDLER FOR SQLEXCEPTION -- lo puedo cambiar por el numero de la exception
        BEGIN
            -- SHOW ERRORS;
            SET pMensaje = 'Error en la transacción. Contáctese con el administrador.';
            ROLLBACK;
        END;

    IF pTitulo IS NULL OR trim(pTitulo) = '' OR pDuracion IS NULL or pArea IS NULL OR pFechaPresentacion IS NULL OR
       pFechaAprobacion IS NULL THEN
        SET pMensaje = 'Error ningun parametro puede ser nulo';
        LEAVE FINAL;
    END IF;

    IF pFechaPresentacion > pFechaAprobacion THEN
        SET pMensaje = 'Error la fecha de presentacion no puede ser posterior a la fecha de aprobacion';
        LEAVE FINAL;
    END IF;


    IF pDuracion <= 0 THEN
        SET pMensaje = 'La duracion no puede ser menor o igual a cero';
        LEAVE FINAL;
    END IF;

    IF EXISTS(SELECT titulo FROM Trabajos WHERE titulo = pTitulo) THEN
        SET pMensaje = 'No puede haber titulos repetidos';
        LEAVE FINAL;
    END IF;

    IF pArea NOT IN ('Hardware', 'Redes', 'Software') THEN
        SET pMensaje = 'ERROR Area debe ser Hardware, Redes o Software';
        LEAVE FINAL;
    END IF;

    SET vUltimoID = (SELECT COALESCE(MAX(idTrabajo), 1) FROM Trabajos);

    INSERT INTO Trabajos (idTrabajo, titulo, area, fechaPresentacionn, fechaAprobacion)
    VALUES (vUltimoID + 1, pTitulo, pArea, pFechaPresentacion, pFechaAprobacion);

    SET pMensaje = 'Insercion exitosa';

END //


DELIMITER ;

CALL NuevoTrabajo('AGUSTIN', 7, 'Hardware', '2023-4-5',
                  '2023-5-5', @Mensaje);
SELECT @Mensaje;

SELECT *
from Trabajos;
-- mismo titulo
CALL NuevoTrabajo('AGUSTIN', 7, 'Hardware', '2023-4-5',
                  '2023-5-5', @Mensaje);
SELECT @Mensaje;

CALL NuevoTrabajo(NULL, 7, 'Hardware', '2023-4-5',
                  '2023-5-5', @Mensaje);
SELECT @Mensaje;


CALL NuevoTrabajo('A', 0, 'Hardware', '2023-4-5',
                  '2023-5-5', @Mensaje);
SELECT @Mensaje;

CALL NuevoTrabajo('A', 4, 'Harare', '2023-4-5',
                  '2023-5-5', @Mensaje);
SELECT @Mensaje;

CALL NuevoTrabajo('J', 0, 'Hardware', '2024-4-5',
                  '2023-5-5', @Mensaje);
SELECT @Mensaje;


CREATE TABLE IF NOT EXISTS aud_trabajos
(
    Id                 BIGINT       NOT NULL AUTO_INCREMENT,
    FechaAud           DATETIME     NOT NULL,
    UsuarioAud         VARCHAR(30)  NOT NULL,
    IP                 VARCHAR(40)  NOT NULL,
    UserAgent          VARCHAR(255) NULL,
    Aplicacion         VARCHAR(50)  NOT NULL,
    Motivo             VARCHAR(100) NULL,
    TipoAud            CHAR(1)      NOT NULL, -- Insercion(I), Borrado(B), Modificacion(A:Antes o D:Despues)
    -- Add up the columns of the table I want to audit.
    idTrabajo          INT          NOT NULL,
    titulo             VARCHAR(100) NOT NULL,
    duracion           INT          NOT NULL,
    area               varchar(10)  not null,
    fechaPresentacionn DATE         not null,
    fechaAprobacion    DATE         NOT NULL,
    fechaFinalizacion  DATE         NULL,
    PRIMARY KEY (`Id`),
    -- create index of the table i want to audit
    INDEX IX_idTrabajo328 (idTrabajo),
    -- remove examples
    INDEX `IX_Usuario` (`UsuarioAud` ASC)
) ENGINE = InnoDB;

-- PUNTO 4
DROP TRIGGER IF EXISTS AuditarTrabajos;
DELIMITER //

CREATE TRIGGER AuditarTrabajos
    AFTER INSERT
    ON Trabajos
    FOR EACH ROW
BEGIN
    IF NEW.duracion > 12 OR NEW.duracion < 3 THEN
        INSERT INTO aud_trabajos
        VALUES (0, NOW(), SUBSTRING_INDEX(USER(), '@', 1), SUBSTRING_INDEX(USER(), '@', -1), NULL,
                SUBSTRING_INDEX(USER(), '@', -1), NULL, 'I',
                NEW.idTrabajo, NEW.titulo, NEW.duracion, NEW.area, NEW.fechaPresentacionn, NEW.fechaAprobacion,
                NEW.fechaFinalizacion);
    END IF;

END //

DELIMITER ;

INSERT INTO Trabajos (idTrabajo, titulo, area,duracion, fechaPresentacionn, fechaAprobacion, fechaFinalizacion)
VALUES (10000,'asdsad','Hardware',22,'2020-2-2','2023-2-2',NULL);

INSERT INTO Trabajos (idTrabajo, titulo, area,duracion, fechaPresentacionn, fechaAprobacion, fechaFinalizacion)
VALUES (10002,'asds123123ad','Hardware',22,'2020-2-2','2023-2-2',NULL);

INSERT INTO Trabajos (idTrabajo, titulo, area,duracion, fechaPresentacionn, fechaAprobacion, fechaFinalizacion)
VALUES (10003,'asds1231asd23ad','Hardware',7,'2020-2-2','2023-2-2',NULL);

INSERT INTO Trabajos (idTrabajo, titulo, area,duracion, fechaPresentacionn, fechaAprobacion, fechaFinalizacion)
VALUES (100203,'asds1231asadsd23ad','Hardware',2,'2020-2-2','2023-2-2',NULL);
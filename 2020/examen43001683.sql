-- Año: 2023
-- Carrizo Avellaneda Agustin
-- Plataforma (SO + Versión): Linux Lubuntu
-- Motor y Versión: MySQL 8.0.33
DROP SCHEMA IF EXISTS examen43001683;
CREATE SCHEMA IF NOT EXISTS examen43001683;
USE examen43001683;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null,
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS Pintores
(
    -- add columns
    IDPintor     INT         NOT NULL,
    Apellidos    VARCHAR(30) not null,
    Nombres      VARCHAR(30) NOT NULL,
    Nacionalidad VARCHAR(30) NOT NULL,
    -- set primary key
    PRIMARY KEY (IDPintor),
    -- add foreign key reference
    -- add foreign key indexs

    -- add necessary indexs and unique indexs
    INDEX IX_ApellidosNombres24 (Apellidos, Nombres)
    -- add checks


)
    ENGINE = InnoDB;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null,
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS Metodos
(
    -- add columns
    IDMetodo INT         NOT NULL,
    Metodo   VARCHAR(30) NOT NULL,
    -- set primary key
    PRIMARY KEY (IDMetodo),
    -- add foreign key reference
    -- add foreign key indexs

    -- add necessary indexs and unique indexs
    UNIQUE INDEX UX_IDMetodo44 (IDMetodo)
    -- add checks


)
    ENGINE = InnoDB;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null,
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS Exhibiciones
(
    -- add columns
    IDExhibicion INT          NOT NULL,
    Titulo       VARCHAR(50)  NOT NULL,
    Descripcion  VARCHAR(200) NULL,
    Inauguracion DATE         NOT NULL,
    Clausura     DATE         NULL,
    -- set primary key
    PRIMARY KEY (IDExhibicion),
    -- add foreign key reference
    -- add foreign key indexs

    -- add necessary indexs and unique indexs
    INDEX IX_Titulo69 (Titulo),
    -- add checks
    CHECK ( Clausura IS NULL OR Inauguracion < Clausura)


)
    ENGINE = InnoDB;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null,
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS Cuadros
(
    -- add columns
    IDCuadro INT            NOT NULL,
    IDPintor INT            NOT NULL,
    IDMetodo INT            NOT NULL,
    Titulo   VARCHAR(60)    NOT NULL,
    Fecha    DATE           NOT NULL,
    Precio   DECIMAL(12, 2) NOT NULL,
    -- set primary key
    PRIMARY KEY (IDCuadro, IDPintor),
    -- add foreign key reference
    CONSTRAINT refPintores88 FOREIGN KEY (IDPintor)
        REFERENCES Pintores (IDPintor),
    CONSTRAINT refMetodos90 FOREIGN KEY (IDMetodo)
        REFERENCES Metodos (IDMetodo),
    -- add foreign key indexs
    INDEX IX_IDPintor91 (IDPintor),
    INDEX IX_IDMetodo94 (IDMetodo),


    -- add necessary indexs and unique indexs
    UNIQUE INDEX UX_IDCuadro (IDCuadro),
    INDEX IX_Titulo103 (Titulo),
    INDEX IX_Fecha104 (Fecha)
    -- add checks


)
    ENGINE = InnoDB;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null,
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS Certamenes
(
    -- add columns
    IDCuadro     INT NOT NULL,
    IDPintor     INT NOT NULL,
    IDExhibicion INT NOT NULL,
    -- set primary key
    PRIMARY KEY (IDCuadro, IDPintor, IDExhibicion),
    -- add foreign key reference
    CONSTRAINT refCuadros117 FOREIGN KEY (IDCuadro, IDPintor)
        REFERENCES Cuadros (IDCuadro, IDPintor),
    CONSTRAINT refExhibiciones119 FOREIGN KEY (IDExhibicion)
        REFERENCES Exhibiciones (IDExhibicion),
    -- add foreign key indexs
    INDEX IX_IDCuadroIdPintor122 (IDCuadro, IdPintor),
    INDEX IX_IDExhibicion123 (IDExhibicion),
    INDEX IX_IDCuadro124 (IDCuadro),
    INDEX IX_IDPintor125 (IDPintor)

    -- add necessary indexs and unique indexs
    -- add checks


)
    ENGINE = InnoDB;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null,
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS Propuestas
(
    -- add columns
    IDPropuesta  CHAR(10)       NOT NULL,
    IDCuadro     INT            NOT NULL,
    IDPintor     INT            NOT NULL,
    IDExhibicion INT            NOT NULL,
    Fecha        DATE           NULL,
    Importe      DECIMAL(12, 2) NOT NULL,
    Persona      VARCHAR(100)   NOT NULL,
    Vendido      CHAR(1)        NOT NULL,
    -- set primary key
    PRIMARY KEY (IDPropuesta, IDCuadro, IDPintor, IDExhibicion),
    -- add foreign key reference
    CONSTRAINT refCertamenes151 FOREIGN KEY (IDCuadro, IDPintor, IDExhibicion)
        REFERENCES Certamenes (IDCuadro, IDPintor, IDExhibicion),
    -- add foreign key indexs
    INDEX IX_IDCuadroIdPintorIDExhibicion154 (IDCuadro, IdPintor, IDExhibicion),
    INDEX IX_IDCuadro155 (IDCuadro),
    INDEX IX_IDPintor156 (IDPintor),
    INDEX IX_IDExhibicion157 (IDExhibicion),

    -- add necessary indexs and unique indexs
    INDEX IX_Fecha162 (Fecha),
    UNIQUE INDEX UX_IDPropuesta160 (IDPropuesta),
    INDEX IX_Persona166 (Persona),
    -- add checks
    CHECK (Vendido IN ('S', 'N')),
    CHECK ( Importe > 0 )

)
    ENGINE = InnoDB;

-- PUNTO 2
DROP PROCEDURE IF EXISTS `BorrarCuadro`;
DELIMITER //

CREATE PROCEDURE `BorrarCuadro`(pIdCuadro INT, out pMensaje varchar(256))
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

    IF pIdCuadro IS NULL THEN
        SET pMensaje = 'El Id no puede ser nulo';
        LEAVE FINAL;
    END IF;

    IF NOT EXISTS(SELECT IDCuadro FROM Cuadros WHERE IDCuadro = pIdCuadro) THEN
        SET pMensaje = 'No existe ese cuadro';
        LEAVE FINAL;
    END IF;

    IF EXISTS(SELECT IDCuadro FROM Certamenes WHERE IDCuadro = pIdCuadro) THEN
        SET pMensaje = 'No se puede borrar cuadros que esten en certamenes';
        LEAVE FINAL;
    END IF;

    delete from Cuadros where IDCuadro = pIdCuadro;


    SET pMensaje = 'OK';


END //


DELIMITER ;

select *
from Cuadros;

INSERT INTO Cuadros (IDCuadro, IDPintor, IDMetodo, Titulo, Fecha, Precio)
VALUES (1000, 1, 2, 'Cuadro a borrar', '2020-2-12', 12.2);

CALL BorrarCuadro(1000, @Mensaje);
SELECT @Mensaje;
CALL BorrarCuadro(NULL, @Mensaje);
SELECT @Mensaje;
CALL BorrarCuadro(10000, @Mensaje);
SELECT @Mensaje;
CALL BorrarCuadro(1, @Mensaje);
SELECT @Mensaje;



SELECT C.IDCuadro,
       C.Titulo,
       C.Precio,
       MAX(P.Importe)            AS 'Mejor propuesta',
       MAX(P.Importe - C.Precio) AS Ganancia
FROM Cuadros C
         join Propuestas P on C.IDCuadro = P.IDCuadro
WHERE C.IDPintor = 1
GROUP BY C.IDCuadro, C.Titulo, C.Precio
;



DROP PROCEDURE IF EXISTS `EstadoCuadros`;
DELIMITER //

CREATE PROCEDURE `EstadoCuadros`(pIdPintor INT)
FINAL:
BEGIN
    -- Descripcion
    /*

    */
    -- Declaraciones
    DROP TEMPORARY TABLE IF EXISTS temp_estadoCuadro;


    SELECT C.IDCuadro,
           C.Titulo,
           C.Precio,
           COALESCE(MAX(P.Importe), 0)            AS 'Mejor propuesta',
           COALESCE(
                   (SELECT P.Vendido FROM Propuestas P WHERE P.IDCuadro = C.IDCuadro ORDER BY P.Importe DESC LIMIT 1),
                   'N'
               )                                  AS Vendido,
           COALESCE(MAX(P.Importe - C.Precio), 0) AS Ganancia
    FROM Cuadros C
             left join Propuestas P on C.IDCuadro = P.IDCuadro
    WHERE C.IDPintor = pIdPintor
    GROUP BY C.IDCuadro, C.Titulo, C.Precio, Vendido;


    DROP TEMPORARY TABLE IF EXISTS temp_estadoCuadro;


END //

DELIMITER ;


CALL EstadoCuadros(5);

create view VentasCuadros as
SELECT C.IDCuadro,
       C.Titulo                                TituloCuadro,
       M.Metodo,
       P.IDPintor,
       CONCAT(P.Nombres, ', ', P.Apellidos) AS Pintor,
       E.IDExhibicion,
       E.Titulo                                TituloExhibicion,
       P2.Fecha,
       P2.Persona,
       P2.Importe
FROM Cuadros C
         JOIN Metodos M on C.IDMetodo = M.IDMetodo
         JOIN Pintores P on P.IDPintor = C.IDPintor
         JOIN Certamenes C2 on C.IDCuadro = C2.IDCuadro and C.IDPintor = C2.IDPintor
         JOIN Propuestas P2
              on C2.IDCuadro = P2.IDCuadro and C2.IDPintor = P2.IDPintor and C2.IDExhibicion = P2.IDExhibicion
         JOIN Exhibiciones E on E.IDExhibicion = C2.IDExhibicion
WHERE P2.Vendido = 'S';


CREATE TABLE IF NOT EXISTS `aud_Cuadros`
(
    Id         BIGINT         NOT NULL AUTO_INCREMENT,
    FechaAud   DATETIME       NOT NULL,
    UsuarioAud VARCHAR(30)    NOT NULL,
    IP         VARCHAR(40)    NOT NULL,
    UserAgent  VARCHAR(255)   NULL,
    Aplicacion VARCHAR(50)    NOT NULL,
    Motivo     VARCHAR(100)   NULL,
    TipoAud    CHAR(1)        NOT NULL, -- Insercion(I), Borrado(B), Modificacion(A:Antes o D:Despues)
    IDCuadro   INT            NOT NULL,
    IDPintor   INT            NOT NULL,
    IDMetodo   INT            NOT NULL,
    Titulo     VARCHAR(60)    NOT NULL,
    Fecha      DATE           NOT NULL,
    Precio     DECIMAL(12, 2) NOT NULL,
    -- Add up the columns of the table I want to audit.
    PRIMARY KEY (`Id`),
    -- create index of the table i want to audit
    INDEX IX_IDCuadro307 (IDCuadro),
    INDEX IX_IDPintor308 (IDPintor),
    INDEX IX_IDMetodo309 (IDMetodo),
    INDEX IX_Fecha310 (Fecha),
    INDEX IX_FechaAud311 (FechaAud),
    INDEX IX_UsuarioAud312 (UsuarioAud)
    -- remove examples
) ENGINE = InnoDB;

DROP TRIGGER IF EXISTS Cuadros_after_delete;
DELIMITER //
CREATE TRIGGER Cuadros_after_delete
    AFTER DELETE
    ON Cuadros
    FOR EACH ROW
BEGIN
    INSERT INTO aud_Cuadros
    VALUES (0, NOW(), SUBSTRING_INDEX(USER(), '@', 1), SUBSTRING_INDEX(USER(), '@', -1), NULL,
            SUBSTRING_INDEX(USER(), '@', -1), NULL, 'B',
            OLD.IDCuadro, OLD.IDPintor, OLD.IDMetodo, OLD.Titulo, OLD.Fecha, OLD.Precio);
END //
DELIMITER ;

select *
FROM aud_Cuadros;
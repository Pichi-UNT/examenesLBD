-- Año: 2023
-- Carrizo Avellaneda Agustin
-- Plataforma (SO + Versión): Linux Lubuntu
-- Motor y Versión: MySQL 8.0.33
DROP SCHEMA IF EXISTS examen43001683;
CREATE SCHEMA IF NOT EXISTS examen43001683;
USE examen43001683;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null,
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS Clientes
(
    -- add columns
    IdCliente INT         NOT NULL,
    Apellidos VARCHAR(50) NOT NULL,
    Nombres   VARCHAR(50) NOT NULL,
    Telefono  VARCHAR(25) NOT NULL,
    -- set primary key
    PRIMARY KEY (IdCliente),

    -- add necessary indexs and unique indexs
    UNIQUE INDEX UX_Telefono (Telefono)

)
    ENGINE = InnoDB;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null,
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS Ofertas
(
    -- add columns
    IdOferta       INT      NOT NULL,
    Descuento      FLOAT    NOT NULL DEFAULT 0.05,
    FechaInicio    DATETIME not null DEFAULT NOW(),
    FechaFin       DATETIME NOT NULL,
    CantidadMinima INT      not null DEFAULT 1,
    CantidadMaxima INT      null,
    -- set primary key
    PRIMARY KEY (IdOferta),
    -- add necessary indexs and unique indexs
    INDEX IX_FechaInicio41 (FechaInicio),
    INDEX IX_FechaFin42 (FechaFin)
    -- add checks


)
    ENGINE = InnoDB;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null,
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS Categorias
(
    -- add columns
    IdCategoria INT         NOT NULL,
    Nombre      VARCHAR(50) NOT NULL,
    -- set primary key
    PRIMARY KEY (IdCategoria),

    -- add necessary indexs and unique indexs
    -- add checks
    UNIQUE INDEX UX_Nombre (Nombre)


)
    ENGINE = InnoDB;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null,
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS Productos
(
    -- add columns
    IdProducto  INT            NOT NULL,
    Nombre      VARCHAR(50)    NOT NULL,
    Color       VARCHAR(50)    NULL,
    Precio      DECIMAL(10, 4) NOT NULL,
    IdCategoria INT            NULL,
    -- set primary key
    PRIMARY KEY (IdProducto),
    -- add foreign key reference
    CONSTRAINT refCategorias81 FOREIGN KEY (IdCategoria)
        REFERENCES Categorias (IdCategoria),
    -- add foreign key indexs
    INDEX IX_IdCategoria84 (IdCategoria),
    UNIQUE INDEX UX_Nombre85 (Nombre)
    -- add necessary indexs and unique indexs
    -- add checks


)
    ENGINE = InnoDB;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null,
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS OfertasDelProducto
(
    -- add columns
    IdProducto INT NOT NULL,
    IdOferta   INT NOT NULL,
    -- set primary key
    PRIMARY KEY (IdProducto, IdOferta),
    -- add foreign key reference
    CONSTRAINT refProductos104 FOREIGN KEY (IdProducto)
        REFERENCES Productos (IdProducto),
    CONSTRAINT refOfertas106 FOREIGN KEY (IdOferta)
        REFERENCES Ofertas (IdOferta),
    -- add foreign key indexs
    INDEX IX_IdOferta109 (IdOferta),
    INDEX IX_IdProducto110 (IdProducto)

    -- add necessary indexs and unique indexs
    -- add checks


)
    ENGINE = InnoDB;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null, 
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS Ventas
(
    -- add columns
    IdVenta   INT      NOT NULL,
    Fecha     DATETIME not null DEFAULT now(),
    IdCliente INT      NOT NULL,
    -- set primary key
    PRIMARY KEY (IdVenta),
    -- add foreign key reference
    CONSTRAINT refClientes131 FOREIGN KEY (IdCliente)
        REFERENCES Clientes (IdCliente),
    -- add foreign key indexs
    INDEX IX_IdCliente134 (IdCliente),
    INDEX IX_Fecha135 (Fecha)
    -- add necessary indexs and unique indexs
    -- add checks


)
    ENGINE = InnoDB;

-- si quiero crear una foreign key creo la columna y elijo si es nula o not null, 
-- luego decido si debo o no agregarla como primary key y tambien creo la referencias
CREATE TABLE IF NOT EXISTS Detalles
(
    -- add columns
    IdDetalle  INT            NOT NULL,
    IdVenta    INT            NOT NULL,
    IdProducto INT            not null,
    Cantidad   INT            NOT NULL,
    Precio     DECIMAL(10, 4) not null,
    Descuento  FLOAT          NOT NULL DEFAULT 0,
    IdOferta   INT            not null,
    -- set primary key
    PRIMARY KEY (IdDetalle, IdVenta),
    -- add foreign key reference
    CONSTRAINT refVentas159 FOREIGN KEY (IdVenta)
        REFERENCES Ventas (IdVenta),
    CONSTRAINT refOfertasDelProducto161 FOREIGN KEY (IdProducto, IdOferta)
        REFERENCES OfertasDelProducto (IdProducto, IdOferta),
    -- add foreign key indexs
    INDEX IX_IdVenta162 (IdVenta),
    INDEX IX_IdOferta165 (IdOferta),
    INDEX IX_IdProducto166 (IdProducto),
    INDEX IX_IdOfertaProducto167 (IdProducto, IdOferta)
    -- add necessary indexs and unique indexs

    -- add checks


)
    ENGINE = InnoDB;

DROP PROCEDURE IF EXISTS `sp_CargarProducto`;
DELIMITER //

CREATE PROCEDURE `sp_CargarProducto`(pNombre VARCHAR(50), pColor VARCHAR(15), pPrecio DECIMAL(10, 4), pIdCategoria INT,
                                     out pMensaje varchar(256))
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
            SHOW ERRORS;
            SELECT 'Error en la transacción. Contáctese con el administrador.' AS Mensaje;
            ROLLBACK;
        END;

    IF pNombre IS NULL OR trim(pNombre) = '' OR pPrecio IS NULL THEN
        SET pMensaje = 'Error nombre y precio no pueden ser nulos';
        LEAVE FINAL;
    END IF;

    IF pIdCategoria IS NOT NULL AND NOT EXISTS(SELECT IdCategoria FROM Categorias WHERE IdCategoria = pIdCategoria) THEN
        SET pMensaje = 'No existe la categoria';
        LEAVE FINAL;
    END IF;

    IF EXISTS(SELECT Nombre FROM Productos WHERE Nombre = pNombre) THEN
        SET pMensaje = 'Ya existe producto con ese nombre';
        LEAVE FINAL;
    END IF;

    IF pPrecio <= 0 THEN
        SET pMensaje = 'El precio no puede ser negativo o cero';
        LEAVE FINAL;
    END IF;

    SET vUltimoID = (SELECT COALESCE(MAX(IdProducto), 1) FROM Productos);
    INSERT INTO Productos (IdProducto, Nombre, Color, Precio, IdCategoria)
    VALUES (vUltimoID + 1, pNombre, pColor, pPrecio, pIdCategoria);
    SET pMensaje = 'OK';


END //


DELIMITER ;

-- Prueba SP
CALL sp_CargarProducto('Palta', NULL, 10.2, 10, @mensaje);
SELECT @mensaje;

CALL sp_CargarProducto('Palta', NULL, 10.2, 10, @mensaje);
SELECT @mensaje;

CALL sp_CargarProducto(null, NULL, 10.2, 10, @mensaje);
SELECT @mensaje;

CALL sp_CargarProducto('Pera', NULL, -10.2, 10, @mensaje);
SELECT @mensaje;

CALL sp_CargarProducto('Pera', NULL, 10.2, 1000, @mensaje);
SELECT @mensaje;

CALL sp_CargarProducto('Pera', NULL, 10.2, NULL, @mensaje);
SELECT @mensaje;

-- PUNTO 3

SELECT V.IdVenta,
       V.Fecha,
       C.Apellidos,
       C.Nombres,
       P.Nombre                   AS NombreProducto,
       C2.Nombre                  AS Categoria,
       D.Cantidad,
       D.Precio                   as PrecioUnitario,
       SUM(D.Cantidad * D.Precio) AS Total
FROM Ventas V
         JOIN Clientes C on C.IdCliente = V.IdCliente
         JOIN Detalles D on V.IdVenta = D.IdVenta
         join Productos P on D.IdProducto = P.IdProducto
         JOIN Ofertas O on D.IdOferta = O.IdOferta
         left join Categorias C2 on C2.IdCategoria = P.IdCategoria
GROUP BY V.IdVenta, V.Fecha, C.Apellidos, C.Nombres, P.Nombre, C2.Nombre, D.Cantidad, D.Precio;

CREATE VIEW VTotalVentas AS
(SELECT V.IdVenta                      AS NroVenta,
        DATE_FORMAT(Fecha, '%d/%m/%Y') AS FechaVenta,
        Apellidos,
        Nombres,
        P.Nombre                       AS Producto,
        COALESCE(C2.Nombre, 'S/C')     AS Categoria,
        SUM(Cantidad)                  AS CantidadProductos,
        D.Precio                       AS PrecioUnitario
 FROM Ventas V
          INNER JOIN Clientes C ON V.IdCliente = C.IdCliente
          INNER JOIN Detalles D on V.IdVenta = D.IdVenta
          INNER JOIN Productos P on D.IdProducto = P.IdProducto
          LEFT JOIN Categorias C2 on P.IdCategoria = C2.IdCategoria
 GROUP BY NroVenta, FechaVenta, Apellidos, Nombres, Producto, Categoria, PrecioUnitario)
UNION
(SELECT null,
        null,
        null,
        null,
        null,
        null,
        null,
        SUM(Cantidad * D.Precio) AS ToTal
 FROM Ventas V
          INNER JOIN Clientes C ON V.IdCliente = C.IdCliente
          INNER JOIN Detalles D on V.IdVenta = D.IdVenta
          INNER JOIN Productos P on D.IdProducto = P.IdProducto
          LEFT JOIN Categorias C2 on P.IdCategoria = C2.IdCategoria)
;

SELECT *
from VTotalVentas;
-- PUNTO 4

CREATE TABLE IF NOT EXISTS `aud_Ofertas`
(
    Id             BIGINT       NOT NULL AUTO_INCREMENT,
    FechaAud       DATETIME     NOT NULL,
    UsuarioAud     VARCHAR(30)  NOT NULL,
    IP             VARCHAR(40)  NOT NULL,
    UserAgent      VARCHAR(255) NULL,
    Aplicacion     VARCHAR(50)  NOT NULL,
    Motivo         VARCHAR(100) NULL,
    TipoAud        CHAR(1)      NOT NULL, -- Insercion(I), Borrado(B), Modificacion(A:Antes o D:Despues)
    -- Add up the columns of the table I want to audit.
    IdOferta       INT          NOT NULL,
    Descuento      FLOAT        NOT NULL DEFAULT 0.05,
    FechaInicio    DATETIME     not null DEFAULT NOW(),
    FechaFin       DATETIME     NOT NULL,
    CantidadMinima INT          not null DEFAULT 1,
    CantidadMaxima INT          null,
    PRIMARY KEY (`Id`),
    -- create index of the table i want to audit
    INDEX IX_IdOferta315 (IdOferta),
    INDEX IX_FechaAud316 (FechaAud),
    INDEX IX_FechaInicio317 (FechaInicio),
    INDEX IX_FechaFin317 (FechaFin)
    -- remove examples
) ENGINE = InnoDB;

CREATE TRIGGER AuditarOfertas
    AFTER INSERT
    ON Ofertas
    FOR EACH ROW
BEGIN
    IF NEW.Descuento > 0.1 THEN
        INSERT INTO aud_Ofertas
        VALUES (0, NOW(), SUBSTRING_INDEX(USER(), '@', 1), SUBSTRING_INDEX(USER(), '@', -1), NULL,
                SUBSTRING_INDEX(USER(), '@', -1), NULL, 'I',
                NEW.IdOferta, NEW.Descuento, NEW.FechaInicio,NEW.FechaFin,NEW.CantidadMinima,NEW.CantidadMaxima);
    END IF;

END;

INSERT INTO Ofertas (IdOferta, Descuento, FechaInicio, FechaFin, CantidadMinima, CantidadMaxima)
VALUES (10000,0.12,'2020-1-1','2020-2-23',1,3);

select *
from aud_Ofertas;
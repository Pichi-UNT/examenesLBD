-- Año: 2023
-- Carrizo Avellaneda Agustin
-- Plataforma (SO + Versión): Linux Lubuntu
-- Motor y Versión: MySQL 8.0.33

-- PUNTO 1
DROP SCHEMA IF EXISTS DNI43001683;
CREATE SCHEMA IF NOT EXISTS DNI43001683;
USE DNI43001683;

CREATE TABLE IF NOT EXISTS Productos
(
    -- add columns
    idProducto INT          NOT NULL,
    nombre     VARCHAR(150) NOT NULL,
    precio     FLOAT        NOT NULL,
    -- set primary key
    PRIMARY KEY (idProducto),
    -- add foreign key reference
    -- add foreign key indexs

    -- add necessary indexs and unique indexs
    UNIQUE INDEX UX_nombre23 (nombre),
    -- add checks
    CHECK (precio > 0)


)
    ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS BandasHorarias
(
    -- add columns
    idBandaHoraria INT      NOT NULL,
    nombre         CHAR(13) NOT NULL,
    -- set primary key
    PRIMARY KEY (idBandaHoraria),
    -- add necessary indexs and unique indexs
    UNIQUE INDEX UX_nombre45 (nombre)

)
    ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Sucursales
(
    -- add columns
    idSucursal INT          NOT NULL,
    nombre     VARCHAR(100) NOT NULL,
    domicilio  varchar(100) NOT NULL,
    -- set primary key
    PRIMARY KEY (idSucursal),
    -- add necessary indexs and unique indexs
    UNIQUE INDEX UX_nombre67 (nombre),
    UNIQUE INDEX UX_domicilio68 (domicilio)
    -- add checks


)
    ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Clientes
(
    -- add columns
    idCliente INT          NOT NULL,
    apellidos VARCHAR(50)  NOT NULL,
    nombres   VARCHAR(50)  NOT NULL,
    dni       VARCHAR(10)  NOT NULL,
    domicilio VARCHAR(100) NOT NULL,
    -- set primary key
    PRIMARY KEY (idCliente),

    -- add necessary indexs and unique indexs
    UNIQUE INDEX UX_dni (dni)


)
    ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Pedidos
(
    -- add columns
    idPedido  INT      NOT NULL,
    idCliente INT      NOT NULL,
    fecha     DATETIME NOT NULL,
    -- set primary key
    PRIMARY KEY (idPedido),
    -- add foreign key reference
    CONSTRAINT refClientes105 FOREIGN KEY (idCliente)
        REFERENCES Clientes (idCliente),
    -- add foreign key indexs
    INDEX IX_idCliente108 (idCliente)


)
    ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS ProductoDelPedido
(
    -- add columns
    idPedido   INT   NOT NULL,
    idProducto INT   NOT NULL,
    cantidad   FLOAT NOT NULL,
    precio     FLOAT NOT NULL,
    -- set primary key
    PRIMARY KEY (idPedido, idProducto),
    -- add foreign key reference
    CONSTRAINT refPedidos130 FOREIGN KEY (idPedido)
        REFERENCES Pedidos (idPedido),
    CONSTRAINT refProductos132 FOREIGN KEY (idProducto)
        REFERENCES Productos (idProducto),
    -- add foreign key indexs
    INDEX IX_idPedido135 (idPedido),
    INDEX IX_idProducto136 (idProducto),

    -- add checks
    CHECK (precio > 0)


)
    ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS Entregas
(
    -- add columns
    idEntrega      INT      NOT NULL,
    idSucursal     INT      NOT NULL,
    idPedido       INT      NOT NULL,
    fecha          DATETIME NOT NULL,
    idBandaHoraria INT      NOT NULL,
    -- set primary key
    PRIMARY KEY (idEntrega),
    -- add foreign key reference
    CONSTRAINT refSucursales159 FOREIGN KEY (idSucursal)
        REFERENCES Sucursales (idSucursal),
    CONSTRAINT refPedidos161 FOREIGN KEY (idPedido)
        REFERENCES Pedidos (idPedido),
    CONSTRAINT refBandasHorarias163 FOREIGN KEY (idBandaHoraria)
        REFERENCES BandasHorarias (idBandaHoraria),
    -- add foreign key indexs
    INDEX IX_idSucursal166 (idSucursal),
    INDEX IX_idPedido167 (idPedido),
    INDEX IX_idBandaHoraria168 (idBandaHoraria)


)
    ENGINE = InnoDB;


-- PUNTO 2

DROP VIEW IF EXISTS VEntregas;
create view VEntregas as
select S.nombre                                               AS Sucursal,
       P.idPedido                                             AS Pedido,
       date_format(P.fecha, '%Y-%m-%d')                       as 'F.Pedido',
       date_format(E.fecha, '%Y-%m-%d')                       AS 'F.Entrega',
       BH.nombre                                              as Banda,
       CONCAT(C.apellidos, ', ', C.nombres, ' (', C.dni, ')') AS Cliente
from Sucursales S
         join Entregas E on S.idSucursal = E.idSucursal
         join BandasHorarias BH on BH.idBandaHoraria = E.idBandaHoraria
         join Pedidos P on P.idPedido = E.idPedido
         join Clientes C on C.idCliente = P.idCliente
order by S.nombre, P.fecha, E.fecha;

select *
from VEntregas;

-- PUNTO 3

DROP PROCEDURE IF EXISTS `NuevoProducto`;
DELIMITER //

CREATE PROCEDURE `NuevoProducto`(pNombre VARCHAR(150), pPrecio FLOAT, out pMensaje varchar(256))
FINAL:
BEGIN
    -- Declaraciones
    DECLARE vUltimoID INT;
    -- Exception handler
    DECLARE EXIT HANDLER FOR SQLEXCEPTION -- lo puedo cambiar por el numero de la exception
        BEGIN
            -- SHOW ERRORS;
            SET pMensaje = 'Error en la transacción. Contáctese con el administrador.';
            ROLLBACK;
        END;

    IF pNombre IS NULL OR TRIM(pNombre) = '' THEN
        SET pMensaje = 'Error nombre no puede ser nulo o estar en blanco';
        LEAVE FINAL;
    END IF;

    IF pPrecio IS NULL THEN
        SET pMensaje = 'Error precio no puede ser nulo';
        LEAVE FINAL;
    END IF;

    IF EXISTS(SELECT nombre FROM Productos WHERE nombre = pNombre) THEN
        SET pMensaje = 'Error ya existe producto con ese nombre';
        LEAVE FINAL;
    END IF;

    IF pPrecio <= 0 THEN
        SET pMensaje = 'Precio no puede ser menor o igual a cero';
        LEAVE FINAL;
    END IF;

    SET vUltimoID = (SELECT COALESCE(MAX(idProducto), 0) FROM Productos);

    INSERT INTO Productos (idProducto, nombre, precio)
    VALUES (vUltimoID + 1, pNombre, pPrecio);


    SET pMensaje = 'OK';
END //


DELIMITER ;

-- CASOS ERROR
-- nombre NULL
CALL NuevoProducto(NULL, 120, @mensaje);
select @mensaje;
-- Nombre con cadena vacia
CALL NuevoProducto('  ', 120, @mensaje);
select @mensaje;
-- Precio NULL
CALL NuevoProducto('Computadora aiwaa', NULL, @mensaje);
select @mensaje;
-- Producto existente
CALL NuevoProducto('iPhone 12', 120, @mensaje);
select @mensaje;

-- Producto con precio nulo
CALL NuevoProducto('Computadora aiwaa', -10, @mensaje);
select @mensaje;

-- CASO EXITOSO
CALL NuevoProducto('Computadora aiwaa', 100, @mensaje);
select @mensaje;

-- Compruebo creacion
select *
from Productos;

-- PUNTO 4
DROP PROCEDURE IF EXISTS `BuscarPedidos`;
DELIMITER //

CREATE PROCEDURE `BuscarPedidos`(pIdPedido INT)
FINAL:
BEGIN

    DROP TEMPORARY TABLE IF EXISTS tmp_pedidos;

    CREATE TEMPORARY TABLE tmp_pedidos AS
    (select PDP.idPedido,
            P.idProducto,
            P.nombre                    as nombre,
            P.precio                    AS 'precio lista',
            PDP.cantidad,
            PDP.precio                  as 'precio venta',
            (PDP.precio * PDP.cantidad) AS 'total'
     FROM Productos P
              JOIN ProductoDelPedido PDP on P.idProducto = PDP.idProducto)
    UNION
    (select PE.idPedido,
            'Fecha:',
            date_format(PE.fecha, '%Y-%m-%d'),
            'Cliente:',
            CONCAT(C.apellidos, ', ', C.nombres),
            'Total:',
            SUM(PDP.cantidad * PDP.precio)
     FROM Pedidos PE
              join Clientes C on C.idCliente = PE.idCliente
              join ProductoDelPedido PDP on PE.idPedido = PDP.idPedido
     GROUP BY PE.idPedido)
    ;

    select idProducto,nombre,`precio lista`,cantidad,`precio venta`,total FROM tmp_pedidos WHERE idPedido=pIdPedido;

    DROP TEMPORARY TABLE IF EXISTS tmp_pedidos;

END //
DELIMITER ;

CALL BuscarPedidos(1);

-- PUNTO 5
DROP TRIGGER IF EXISTS `Productos_before_delete`;
DELIMITER //
CREATE TRIGGER Productos_before_delete
    BEFORE DELETE
    ON Productos
    FOR EACH ROW
BEGIN
    IF EXISTS(SELECT ProductoDelPedido.idProducto
              FROM ProductoDelPedido
              WHERE ProductoDelPedido.idProducto = OLD.idProducto) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error el producto que se quiere borrar esta incluido en un pedido';
    END IF;


END //

DELIMITER ;

-- PROBARE BORRANDO EL producto con ID numero 5 que esta asociado al pedido 1
DELETE
FROM Productos
WHERE idProducto = 5;


-- Creo un producto que no esta asociado a ningun pedido
CALL NuevoProducto('Producto a borrar', 100, @mensaje);
select @mensaje;
-- Obtengo el ID del ultimo producto insertado
SET @ultimoId = (select idProducto
                 from Productos
                 ORDER BY idProducto DESC
                 LIMIT 1);
-- SI SE EJECUTO los scripts BIEN HASTA EL MOMENTO DEBERIA SER EL ID 22, COMPRUEBO
select @ultimoId;

delete
from Productos
where idProducto = @ultimoId;

-- Compruebo si se borro
select *
from Productos;
CREATE TABLE IF NOT EXISTS `aud_usuario`
(
    Id         BIGINT       NOT NULL AUTO_INCREMENT,
    FechaAud   DATETIME     NOT NULL,
    UsuarioAud VARCHAR(30)  NOT NULL,
    IP         VARCHAR(40)  NOT NULL,
    UserAgent  VARCHAR(255) NULL,
    Aplicacion VARCHAR(50)  NOT NULL,
    Motivo     VARCHAR(100) NULL,
    TipoAud    CHAR(1)      NOT NULL, -- Insercion(I), Borrado(B), Modificacion(A:Antes o D:Despues)
    IdUsuario    INT,
    Nombre       VARCHAR(120) NOT NULL,
    Apellido     VARCHAR(120) NOT NULL,
    Correo       VARCHAR(256) NOT NULL,
    Telefono     VARCHAR(15),
    Nick         VARCHAR(40)  NOT NULL,
    Pass         CHAR(60)     NOT NULL,
    Estado       CHAR(1)      NOT NULL,
    Rol          CHAR(1)      NOT NULL,
    PRIMARY KEY (`Id`),
    INDEX `IX_FechaAud` (`FechaAud` ASC),
    INDEX `IX_Usuario` (`UsuarioAud` ASC),
    INDEX `IX_IP` (`IP` ASC),
    INDEX `IX_Aplicacion` (`Aplicacion` ASC),
    INDEX `IX_IdComercio` (`IdUsuario` ASC)
) ENGINE = InnoDB;

-- Trigger de insercion
CREATE TRIGGER usuario_AFTER_INSERT
    AFTER INSERT
    ON usuario
    FOR EACH ROW
BEGIN
    INSERT INTO aud_usuario
    VALUES (0, NOW(), SUBSTRING_INDEX(USER(), '@', 1), SUBSTRING_INDEX(USER(), '@', -1), NULL,
            SUBSTRING_INDEX(USER(), '@', -1), NULL, 'I',
            NEW.IdUsuario, NEW.Nombre, NEW.Apellido, NEW.Correo, NEW.Telefono, NEW.Nick, New.Pass, NEW.Estado, NEW.Rol);
END;

-- trigger de borrado
CREATE TRIGGER usuario_AFTER_DELETE
    AFTER DELETE
    ON usuario
    FOR EACH ROW
BEGIN
    INSERT INTO aud_usuario
    VALUES (0, NOW(), SUBSTRING_INDEX(USER(), '@', 1), SUBSTRING_INDEX(USER(), '@', -1), NULL,
            SUBSTRING_INDEX(USER(), '@', -1), NULL, 'B',
            OLD.IdUsuario, OLD.Nombre, OLD.Apellido, OLD.Correo, OLD.Telefono, OLD.Nick, OLD.Pass, OLD.Estado, OLD.Rol);
END;

-- trigger de actualizacion
CREATE TRIGGER usuario_AFTER_UPDATE
    AFTER UPDATE
    ON usuario
    FOR EACH ROW
BEGIN

    INSERT INTO aud_usuario
    VALUES (0, NOW(), SUBSTRING_INDEX(USER(), '@', 1), SUBSTRING_INDEX(USER(), '@', -1), NULL,
            SUBSTRING_INDEX(USER(), '@', -1), NULL, 'A',
            OLD.IdUsuario, OLD.Nombre, OLD.Apellido, OLD.Correo, OLD.Telefono, OLD.Nick, OLD.Pass, OLD.Estado, OLD.Rol);

    INSERT INTO aud_usuario
    VALUES (0, NOW(), SUBSTRING_INDEX(USER(), '@', 1), SUBSTRING_INDEX(USER(), '@', -1), NULL,
            SUBSTRING_INDEX(USER(), '@', -1), NULL, 'D',
            NEW.IdUsuario, NEW.Nombre, NEW.Apellido, NEW.Correo, NEW.Telefono, NEW.Nick, New.Pass, NEW.Estado, NEW.Rol);
END;

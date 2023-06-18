CREATE TABLE usuario
(
    IdUsuario INT AUTO_INCREMENT,
    Nombre    VARCHAR(120) NOT NULL,
    Apellido  VARCHAR(120) NOT NULL,
    Correo    VARCHAR(256) NOT NULL,
    Telefono  VARCHAR(15),
    Nick      VARCHAR(40)  NOT NULL,
    Pass      CHAR(60)     NOT NULL,
    Estado    CHAR(1)      NOT NULL DEFAULT 'A',
    Rol       CHAR(1)      NOT NULL DEFAULT 'U',
    PRIMARY KEY (IdUsuario),
    INDEX IX_ApellidoNombre (Apellido, Nombre),
    UNIQUE INDEX UX_Cuenta (Nick),
    UNIQUE INDEX UX_Correo (Correo)
) ENGINE = INNODB
;

CREATE TABLE componente
(
    IdComponente     INT AUTO_INCREMENT,
    IdUsuario        INT          NOT NULL,
    TituloComponente VARCHAR(150) NOT NULL,
    Observacion      TEXT,
    IdExperiencia    INT,
    IdHabilidad      INT,
    IdFormacion      INT,
    IdProyecto       INT,
    PRIMARY KEY (IdComponente, IdUsuario),
    UNIQUE INDEX UI_IdComponente (IdComponente),
    -- Creo indice de cada una de las claves foraneas
    INDEX Ref831 (IdExperiencia),
    INDEX Ref732 (IdHabilidad),
    INDEX Ref633 (IdFormacion),
    INDEX Ref538 (IdProyecto),
    INDEX Ref239 (IdUsuario),
    CONSTRAINT Refexperiencia31 FOREIGN KEY (IdExperiencia)
        REFERENCES experiencia (IdExperiencia),
    CONSTRAINT Refhabilidad32 FOREIGN KEY (IdHabilidad)
        REFERENCES habilidad (IdHabilidad),
    CONSTRAINT Refformacion33 FOREIGN KEY (IdFormacion)
        REFERENCES formacion (IdFormacion),
    CONSTRAINT Refproyecto38 FOREIGN KEY (IdProyecto)
        REFERENCES proyecto (IdProyecto),
    CONSTRAINT Refusuario39 FOREIGN KEY (IdUsuario)
        REFERENCES usuario (IdUsuario)
) ENGINE = INNODB;

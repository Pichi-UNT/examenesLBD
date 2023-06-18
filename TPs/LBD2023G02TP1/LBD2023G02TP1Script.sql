-- Año: 2023
-- Grupo Nro: 2
-- Integrantes: Carrizo Avellaneda Agustin, Cascales Matias Benjamin
-- Tema: CV online
-- Nombre del Esquema (LBD2023G2)
-- Plataforma (SO + Versión): Windows 10
-- Motor y Versión: MySQL 8.0.26
-- GitHub Repositorio: LBD2023G02
-- GitHub Usuario: Pichi-UNT , bencascales

CREATE SCHEMA IF NOT EXISTS LBD2023G02;
USE LBD2023G02;

# DELETE
# FROM componenteCurriculum;
# DELETE
# FROM componente;
# DELETE FROM componentejson;
# DELETE
# FROM formacion;
# DELETE
# FROM experiencia;
# DELETE
# FROM habilidad;
# DELETE
# FROM proyecto;
# DELETE
# FROM curriculum;
# DELETE
# FROM redSocialUsuario;
# DELETE
# FROM redSocial;
# DELETE
# FROM usuario;

-- Eliminar tablas en el orden correcto para evitar conflictos de clave foránea
DROP TABLE IF EXISTS componenteCurriculum;
DROP TABLE IF EXISTS componente;
DROP TABLE IF EXISTS componentejson;
DROP TABLE IF EXISTS formacion;
DROP TABLE IF EXISTS habilidad;
DROP TABLE IF EXISTS experiencia;
DROP TABLE IF EXISTS proyectoCurriculum;
DROP TABLE IF EXISTS proyecto;
DROP TABLE IF EXISTS curriculum;
DROP TABLE IF EXISTS redSocialUsuario;
DROP TABLE IF EXISTS redSocial;
DROP TABLE IF EXISTS usuario;
--
-- TABLE: experiencia
--

CREATE TABLE experiencia
(
    IdExperiencia INT AUTO_INCREMENT,
    Empresa       VARCHAR(100) NOT NULL,
    FechaInicio   DATE         NOT NULL,
    FechaFin      DATE,
    Descripcion   TEXT,
    Hitos         JSON,
    PRIMARY KEY (IdExperiencia)
) ENGINE = INNODB
;



--
-- TABLE: habilidad
--

CREATE TABLE habilidad
(
    IdHabilidad   INT AUTO_INCREMENT,
    TipoHabilidad ENUM ('Dura','Blanda','Idioma') NOT NULL,
    Escala        TINYINT                         NOT NULL,
    Detalles      JSON,
    PRIMARY KEY (IdHabilidad),
    CHECK (Escala > 0),
    CHECK (Escala <= 5)
) ENGINE = INNODB
;



--
-- TABLE: formacion
--

CREATE TABLE formacion
(
    IdFormacion   INT AUTO_INCREMENT,
    FechaInicio   DATE                                              NOT NULL,
    FechaFin      DATE,
    Institucion   VARCHAR(100)                                      NOT NULL,
    TipoFormacion ENUM ('secundaria', 'curso', 'grado', 'posgrado') NOT NULL,
    PRIMARY KEY (IdFormacion)
) ENGINE = INNODB
;



--
-- TABLE: usuario
--

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



--
-- TABLE: proyecto
--

CREATE TABLE proyecto
(
    IdProyecto  INT AUTO_INCREMENT,
    FechaInicio DATE    NOT NULL,
    FechaFin    DATE,
    Link        VARCHAR(120),
    Estado      CHAR(1) NOT NULL,
    Descripcion TEXT,
    Recursos    JSON,
    PRIMARY KEY (IdProyecto)
) ENGINE = INNODB
;



--
-- TABLE: componente
--

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



--
-- TABLE: curriculum
--

--
-- TABLE: curriculum
--

CREATE TABLE curriculum
(
    IdCurriculum INT AUTO_INCREMENT,
    IdUsuario    INT          NOT NULL,
    Curriculum   VARCHAR(150) NOT NULL,
    Descripcion  TEXT,
    Banner       VARCHAR(80),
    ImagenPerfil VARCHAR(80)  NOT NULL,
    Estado       CHAR(1)      NOT NULL, -- V:Visible I:Invisible
    PRIMARY KEY (IdCurriculum, IdUsuario),
    UNIQUE INDEX UX_IdUsuarioCurriculum (IdUsuario, Curriculum),
    INDEX IX_Curriculum (Curriculum),
    UNIQUE INDEX UX_IdCurriculum (IdCurriculum),
    INDEX Ref240 (IdUsuario),
    CONSTRAINT Refusuario40 FOREIGN KEY (IdUsuario)
        REFERENCES usuario (IdUsuario)
) ENGINE = INNODB
;



--
-- TABLE: componenteCurriculum
--

CREATE TABLE componenteCurriculum
(
    IdCurriculum INT NOT NULL,
    IdComponente INT NOT NULL,
    IdUsuario    INT NOT NULL,
    Orden        INT NOT NULL,
    PRIMARY KEY (IdCurriculum, IdUsuario, IdComponente),
    UNIQUE INDEX UX_IdCurriculumOrden (IdCurriculum, Orden),
    INDEX Ref319 (IdCurriculum, IdUsuario),
    INDEX Ref1436 (IdComponente, IdUsuario),
    CONSTRAINT Refcurriculum19 FOREIGN KEY (IdCurriculum, IdUsuario)
        REFERENCES curriculum (IdCurriculum, IdUsuario),
    CONSTRAINT Refcomponente36 FOREIGN KEY (IdComponente, IdUsuario)
        REFERENCES componente (IdComponente, IdUsuario)
) ENGINE = INNODB
;



--
-- TABLE: redSocial
--

CREATE TABLE redSocial
(
    IdRedSocial INT AUTO_INCREMENT,
    Red         VARCHAR(60) NOT NULL,
    LogoLink    VARCHAR(80),
    PRIMARY KEY (IdRedSocial),
    UNIQUE INDEX UX_Red (Red)
) ENGINE = INNODB
;



--
-- TABLE: redSocialUsuario
--

CREATE TABLE redSocialUsuario
(
    IdRedSocialUsuario INT          NOT NULL,
    IdUsuario          INT          NOT NULL,
    IdRedSocial        INT          NOT NULL,
    LinkRed            VARCHAR(150) NOT NULL,
    PRIMARY KEY (IdRedSocialUsuario),
    INDEX Ref42 (IdRedSocial),
    INDEX Ref224 (IdUsuario),
    CONSTRAINT RefredSocial2 FOREIGN KEY (IdRedSocial)
        REFERENCES redSocial (IdRedSocial),
    CONSTRAINT Refusuario24 FOREIGN KEY (IdUsuario)
        REFERENCES usuario (IdUsuario)
) ENGINE = INNODB
;


USE LBD2023G02;

INSERT INTO usuario (IdUsuario, Nombre, Apellido, Correo, Telefono, Nick, Pass, Estado)
VALUES (1, 'Juan', 'Pérez', 'juan.perez@example.com', '1234567890', 'juanperez', 'password1', 'A'),
       (2, 'María', 'Gómez', 'maria.gomez@example.com', '9876543210', 'mariagomez', 'password2', 'A'),
       (3, 'Pedro', 'Rodríguez', 'pedro.rodriguez@example.com', '5555555555', 'pedrorodriguez', 'password3', 'A'),
       (4, 'Ana', 'Fernández', 'ana.fernandez@example.com', '1111111111', 'anafernandez', 'password4', 'A'),
       (5, 'Carlos', 'Martínez', 'carlos.martinez@example.com', '7777777777', 'carlosmartinez', 'password5', 'B'),
       (6, 'Laura', 'Sánchez', 'laura.sanchez@example.com', '3333333333', 'laurasanchez', 'password6', 'A'),
       (7, 'Javier', 'López', 'javier.lopez@example.com', '8888888888', 'javierlopez', 'password7', 'A'),
       (8, 'Sofía', 'Ramírez', 'sofia.ramirez@example.com', '4444444444', 'sofiaramirez', 'password8', 'A'),
       (9, 'Miguel', 'Hernández', 'miguel.hernandez@example.com', '9999999999', 'miguelhernandez', 'password9', 'A'),
       (10, 'Paola', 'Ortega', 'paola.ortega@example.com', '6666666666', 'paolaortega', 'password10', 'B'),
       (11, 'Diego', 'Gutiérrez', 'diego.gutierrez@example.com', '1010101010', 'diegogutierrez', 'password11', 'B'),
       (12, 'Marcela', 'Chávez', 'marcela.chavez@example.com', '1212121212', 'marcelachavez', 'password12', 'A'),
       (13, 'Roberto', 'Díaz', 'roberto.diaz@example.com', '1313131313', 'robertodiaz', 'password13', 'A'),
       (14, 'Isabel', 'Jiménez', 'isabel.jimenez@example.com', '1414141414', 'isabeljimenez', 'password14', 'A'),
       (15, 'Fernando', 'Rojas', 'fernando.rojas@example.com', '1515151515', 'fernandorojas', 'password15', 'B'),
       (16, 'Lucía', 'Navarro', 'lucia.navarro@example.com', '1616161616', 'lucianavarro', 'password16', 'A'),
       (17, 'Gustavo', 'García', 'gustavo.garcia@example.com', '1717171717', 'gustavogarcia', 'password17', 'A'),
       (18, 'Alejandra', 'Paredes', 'alejandra.paredes@example.com', '1818181818', 'alejandraparedes', 'password18',
        'A'),
       (19, 'Ricardo', 'Vargas', 'ricardo.vargas@example.com', '1919191919', 'ricardovargas', 'password19', 'A'),
       (20, 'Daniela', 'Castro', 'daniela.castro@example.com', '2020202020', 'danielacastro', 'password20', 'B');

INSERT INTO usuario (Nombre, Apellido, Correo, Telefono, Nick, Pass)
VALUES ('Pichi', 'Carrizo', 'pichiz@example.com', '6589898', 'pichino', 'password1');

INSERT INTO usuario (Nombre, Apellido, Correo, Telefono, Nick, Pass, Rol)
VALUES ('admin', 'admin', 'admin@example.com', '8989697968', 'admin1234', '11223344', 'A');

INSERT INTO redSocial (IdRedSocial, Red, LogoLink)
VALUES (1, 'Facebook', 'https://www.example.com/facebook_logo.png'),
       (2, 'Twitter', 'https://www.example.com/twitter_logo.png'),
       (3, 'Instagram', 'https://www.example.com/instagram_logo.png'),
       (4, 'LinkedIn', 'https://www.example.com/linkedin_logo.png'),
       (5, 'YouTube', 'https://www.example.com/youtube_logo.png'),
       (6, 'Pinterest', 'https://www.example.com/pinterest_logo.png'),
       (7, 'Snapchat', 'https://www.example.com/snapchat_logo.png'),
       (8, 'TikTok', 'https://www.example.com/tiktok_logo.png'),
       (9, 'Reddit', 'https://www.example.com/reddit_logo.png'),
       (10, 'WhatsApp', 'https://www.example.com/whatsapp_logo.png'),
       (11, 'RedSocialSinUsuario', 'https://www.example.com/redsocialsinusuario_logo.png');

INSERT INTO redSocialUsuario (IdRedSocialUsuario, IdUsuario, IdRedSocial, LinkRed)
VALUES (1, 1, 5, 'https://www.ejemplo1.com'),
       (2, 3, 1, 'https://www.ejemplo2.com'),
       (3, 7, 8, 'https://www.ejemplo3.com'),
       (4, 2, 4, 'https://www.ejemplo4.com'),
       (5, 11, 9, 'https://www.ejemplo5.com'),
       (6, 22, 2, 'https://www.ejemplo6.com'),
       (7, 4, 3, 'https://www.ejemplo7.com'),
       (8, 15, 10, 'https://www.ejemplo8.com'),
       (9, 1, 1, 'https://www.ejemplo9.com'),
       (10, 9, 6, 'https://www.ejemplo10.com'),
       (11, 5, 8, 'https://www.ejemplo11.com'),
       (12, 18, 2, 'https://www.ejemplo12.com'),
       (13, 6, 1, 'https://www.ejemplo13.com'),
       (14, 20, 7, 'https://www.ejemplo14.com'),
       (15, 12, 4, 'https://www.ejemplo15.com'),
       (16, 8, 9, 'https://www.ejemplo16.com'),
       (17, 10, 1, 'https://www.ejemplo17.com'),
       (18, 13, 5, 'https://www.ejemplo18.com'),
       (19, 19, 3, 'https://www.ejemplo19.com'),
       (20, 14, 6, 'https://www.ejemplo20.com'),
       (21, 21, 7, 'https://www.ejemplo21.com'),
       (22, 17, 10, 'https://www.ejemplo22.com'),
       (23, 16, 2, 'https://www.ejemplo23.com'),
       (24, 16, 10, 'https://www.ejemplo24.com');


INSERT INTO curriculum (IdCurriculum, IdUsuario, curriculum, Descripcion, Banner, ImagenPerfil, Estado)
VALUES (1, 5, 'Desarrollador Java', 'Lorem ipsum dolor', 'banner1.jpg', 'perfil1.jpg', 'V'),
       (2, 5, 'Medico Anestesista', 'Lorem ipsum dolor', 'banner2.jpg', 'perfil2.jpg', 'V'),
       (3, 15, 'Ingeniero de Sistemas', 'Lorem ipsum dolor', 'banner3.jpg', 'perfil3.jpg', 'V'),
       (4, 10, 'Abogado Penalista', 'Lorem ipsum dolor', 'banner4.jpg', 'perfil4.jpg', 'V'),
       (5, 3, 'Psicóloga Clínica', 'Lorem ipsum dolor', 'banner5.jpg', 'perfil5.jpg', 'V'),
       (6, 17, 'Diseñador Gráfico', 'Lorem ipsum dolor', 'banner6.jpg', 'perfil6.jpg', 'V'),
       (7, 9, 'Contador Público', 'Lorem ipsum dolor', 'banner7.jpg', 'perfil7.jpg', 'V'),
       (8, 6, 'Ingeniero Civil', 'Lorem ipsum dolor', 'banner8.jpg', 'perfil8.jpg', 'V'),
       (9, 6, 'Chef Internacional', 'Lorem ipsum dolor', 'banner9.jpg', 'perfil9.jpg', 'V'),
       (10, 14, 'Médico Internista', 'Lorem ipsum dolor', 'banner10.jpg', 'perfil10.jpg', 'V'),
       (11, 2, 'Ingeniero Mecánico', 'Lorem ipsum dolor', 'banner11.jpg', 'perfil11.jpg', 'V'),
       (12, 12, 'Arquitecto', 'Lorem ipsum dolor', 'banner12.jpg', 'perfil12.jpg', 'V'),
       (13, 20, 'Músico', 'Lorem ipsum dolor', 'banner13.jpg', 'perfil13.jpg', 'V'),
       (14, 18, 'Periodista', 'Lorem ipsum dolor', 'banner14.jpg', 'perfil14.jpg', 'V'),
       (15, 13, 'Economista', 'Lorem ipsum dolor', 'banner15.jpg', 'perfil15.jpg', 'V'),
       (16, 1, 'Desarrollador Web', 'Lorem ipsum dolor', 'banner16.jpg', 'perfil16.jpg', 'V'),
       (17, 10, 'Nutricionista', 'Lorem ipsum dolor', 'banner17.jpg', 'perfil17.jpg', 'V'),
       (18, 4, 'Enfermera', 'Lorem ipsum dolor', 'banner18.jpg', 'perfil18.jpg', 'V'),
       (19, 16, 'Pedagogo', 'Lorem ipsum dolor', 'banner19.jpg', 'perfil19.jpg', 'V'),
       (20, 11, 'Abogado Laboralista', 'Lorem ipsum dolor', 'banner20.jpg', 'perfil20.jpg', 'V'),
       (21, 8, 'Abogado Arborista', 'Lorem ipsum dolor', 'banner20.jpg', 'perfil20.jpg', 'V');

INSERT INTO experiencia (IdExperiencia, Empresa, FechaInicio, FechaFin, Descripcion, Hitos)
VALUES (1, 'Microsoft', '2018-01-01', '2019-12-31', 'Desarrollo de plataforma azure', '[
  "Lanzamiento de la versión 1.0",
  "Más de 1000 usuarios registrados"
]'),
       (2, 'Tinkun', '2019-03-15', '2020-11-30', 'Análisis de datos de usuarios', '[
         "Identificación de patrones de uso",
         "Propuesta de mejoras en la interfaz"
       ]'),
       (3, 'Amazon', '2020-06-01', '2021-09-30', 'Desarrollo de aplicaciones móviles con Flutter', '[
         "Lanzamiento de la versión beta",
         "Más de 500 descargas en una semana"
       ]'),
       (4, 'Hospital Ángel C. Padilla', '2017-11-01', '2019-10-31', 'Residencia de traumatologia', '[
         "Desarrollo de una politica hospitalaria para residentes",
         "Guardias nocturnas"
       ]'),
       (5, 'Hospital del Niño Jesús', '2019-08-01', '2020-07-31', 'Cuidado de pacientes', NULL);


INSERT INTO formacion (IdFormacion, FechaInicio, FechaFin, Institucion, TipoFormacion)
VALUES (1, '2014-08-01', NULL, 'FACULTAD DE DERECHO', 'grado'),
       (2, '2016-01-01', NULL, 'INSTITUCION1', 'curso'),
       (3, '2008-05-01', NULL, 'INSTITUCION2', 'posgrado'),
       (4, '2010-09-01', '2011-12-31', 'INSTITUCION3', 'grado'),
       (5, '2017-01-01', '2017-12-31', 'INSTITUCION4', 'curso');

-- definir forma de detalles
INSERT INTO habilidad (IdHabilidad, TipoHabilidad, Escala, Detalles)
VALUES (1, 'Blanda', 1, NULL),
       (2, 'Dura', 1, '[
         "Django",
         "REST",
         "JSON encoders"
       ]'),
       (3, 'Dura', 2, '[
         "Figma",
         "Invision",
         "HTML"
       ]'),
       (4, 'Blanda', 2, NULL),
       (5, 'Dura', 2, '[
         "Responsive Design"
       ]'),
       (6, 'Idioma', 1, NULL),
       (7, 'Idioma', 5, NULL),
       (8, 'Idioma', 3, NULL),
       (9, 'Idioma', 2, NULL),
       (10, 'Idioma', 1, NULL),
       (11, 'Idioma', 4, NULL),
       (12, 'Idioma', 4, NULL),
       (13, 'Idioma', 2, NULL),
       (14, 'Idioma', 3, NULL),
       (15, 'Idioma', 3, NULL);
;


INSERT INTO componente (IdComponente, IdUsuario, TituloComponente, Observacion, IdExperiencia, IdHabilidad, IdFormacion,
                        IdProyecto)
VALUES (1, 4, 'Desarrollador en microsoft', 'Observacion 1', 1, NULL, NULL, NULL),
       (2, 10, 'Ing. Software en Tinkun', NULL, 2, NULL, NULL, NULL),
       (3, 13, 'Programador senior en AWS', 'Observacion 2', 3, NULL, NULL, NULL),
       (4, 5, 'Medico anestesista en hospital padilla', NULL, 4, NULL, NULL, NULL),
       (5, 17, 'Enfermero en hospital de niños', 'Observacion 3', 5, NULL, NULL, NULL),

       (6, 20, 'Bachiller de CS naturales', 'Observacion 4', NULL, 1, NULL, NULL),
       (7, 19, 'Curso de Javascript', NULL, NULL, 2, NULL, NULL),
       (8, 22, 'Curso primeros auxilios', 'Observacion 5', NULL, 3, NULL, NULL),
       (9, 8, 'Congreso de Marketing Digital', 'Observacion 6', NULL, 4, NULL, NULL),
       (10, 3, 'Curso de introduccion de metodologias agiles', 'Observacion 7', NULL, 5, NULL, NULL),
       (11, 6, 'Habilidades en Análisis de Negocios', NULL, NULL, NULL, 1, NULL),
       (12, 1, 'Python', 'Observacion 8', NULL, NULL, 2, NULL),
       (13, 7, 'Diseño de Interfaces de Usuario', NULL, NULL, NULL, 3, NULL),
       (14, 11, 'Programación en Java', 'Observacion 9', NULL, NULL, 4, NULL),
       (15, 15, 'Móbile first', 'Observacion 10', NULL, NULL, 5, NULL);


-- definir forma de recursos
INSERT INTO proyecto (IdProyecto, FechaInicio, FechaFin, Link, Estado, Descripcion, Recursos)
VALUES (1, '2023-04-17', '2023-04-18', 'https://link1.com', 'F', 'Descripción del Proyecto 1', NULL),
       (2, '2023-04-17', '2023-04-18', 'https://link2.com', 'F', 'Descripción del Proyecto 2', NULL),
       (3, '2023-04-17', '2023-04-18', 'https://link3.com', 'F', 'Descripción del Proyecto 3', NULL),
       (4, '2023-04-17', '2023-04-18', 'https://link4.com', 'F', 'Descripción del Proyecto 4', NULL),
       (5, '2023-04-17', '2023-04-18', 'https://link5.com', 'F', 'Descripción del Proyecto 5', NULL),
       (6, '2023-04-17', '2023-04-18', 'https://link6.com', 'F', 'Descripción del Proyecto 6', NULL),
       (7, '2023-04-17', '2023-04-18', 'https://link7.com', 'F', 'Descripción del Proyecto 7', NULL),
       (8, '2023-04-17', '2023-04-18', 'https://link8.com', 'F', 'Descripción del Proyecto 8', NULL),
       (9, '2023-04-17', '2023-04-18', 'https://link9.com', 'F', 'Descripción del Proyecto 9', NULL),
       (10, '2023-04-17', '2023-04-18', 'https://link10.com', 'F', 'Descripción del Proyecto 10', NULL),
       (11, '2023-04-17', '2023-04-18', 'https://link11.com', 'F', 'Descripción del Proyecto 11', NULL),
       (12, '2023-04-17', '2023-04-18', 'https://link12.com', 'F', 'Descripción del Proyecto 12', NULL),
       (13, '2023-04-17', '2023-04-18', 'https://link13.com', 'F', 'Descripción del Proyecto 13', NULL),
       (14, '2023-04-17', '2023-04-18', 'https://link14.com', 'F', 'Descripción del Proyecto 14', NULL),
       (15, '2023-04-17', '2023-04-18', 'https://link15.com', 'F', 'Descripción del Proyecto 15', NULL),
       (16, '2023-04-17', '2023-04-18', 'https://link16.com', 'F', 'Descripción del Proyecto 16', NULL),
       (17, '2023-04-17', '2023-04-18', 'https://link17.com', 'F', 'Descripción del Proyecto 17', NULL),
       (18, '2023-04-17', '2023-04-18', 'https://link18.com', 'F', 'Descripción del Proyecto 18', NULL),
       (19, '2023-04-17', '2023-04-18', 'https://link19.com', 'F', 'Descripción del Proyecto 19', NULL),
       (20, '2023-04-17', '2023-04-18', 'https://link20.com', 'F', 'Descripción del Proyecto 20', NULL);
--
INSERT INTO componente (IdUsuario, TituloComponente, Observacion, IdProyecto)
VALUES (7, 'Plataforma de Gestión de Proyectos', 'Lorem ipsum dolor', 1),
       (12, 'Sistema de Reservas de Hoteles', 'Sit amet consectetur', 2),
       (3, 'Aplicación de Gestión de Tareas', 'Adipiscing elit sed', 3),
       (5, 'Plataforma de Comercio Electrónico', 'Do eiusmod tempor', 4),
       (14, 'Sistema de Gestión de Contabilidad', 'Incididunt ut labore', 5),
       (2, 'Aplicación de Gestión de Inventarios', 'Et dolore magna', 6),
       (9, 'Plataforma de Gestión de Clientes', 'Aliqua Ut enim', 7),
       (3, 'Sistema de Gestión de Tickets de Soporte', 'Minim veniam quis', 8),
       (11, 'Aplicación de Monitoreo de Redes', 'Nostrud exercitation ullamco', 9),
       (6, 'Plataforma de Gestión de Contenidos', 'Laboris nisi ut', 10),
       (16, 'Sistema de Gestión de Procesos', 'Aliquip ex ea', 11),
       (1, 'Aplicación de Gestión de Proyectos', 'Commodo consequat Duis', 12),
       (15, 'Sistema de Gestión de Ventas en Línea', 'Aute irure dolor', 13),
       (20, 'Plataforma de Gestión de Recursos Humanos', 'Reprehenderit in voluptate', 14),
       (4, 'Sistema de Gestión de Contabilidad en la Nube', 'Velit esse cillum', 15),
       (8, 'Aplicación de Gestión de Proyectos Colaborativos', 'Dolore eu fugiat', 16),
       (19, 'Plataforma de Gestión de Inventario de Tienda en Línea', 'Nulla pariatur Excepteur', 17),
       (10, 'Sistema de Gestión de Proyectos de Investigación', 'Sint occaecat cupidatat', 18),
       (13, 'Aplicación de Gestión de Contenido para Redes Sociales', 'Non proident sunt', 19),
       (5, 'Plataforma de Gestión de Ventas en Línea', 'Officia deserunt mollit', 20);
--
INSERT INTO componente (IdUsuario, TituloComponente, Observacion, IdExperiencia, IdHabilidad, IdFormacion,
                        IdProyecto)
VALUES (6, 'Español', 'Observacion 10', NULL, 9, NULL, NULL),
       (8, 'Español', 'Observacion 10', NULL, 10, NULL, NULL),
       (11, 'Ingles', 'Observacion 10', NULL, 6, NULL, NULL),
       (4, 'Ingles', 'Observacion 10', NULL, 7, NULL, NULL),
       (6, 'Ingles', 'Observacion 10', NULL, 8, NULL, NULL),
       (1, 'Frances', 'Observacion 10', NULL, 11, NULL, NULL),
       (3, 'Italiano', 'Observacion 10', NULL, 12, NULL, NULL),
       (4, 'Ingles', 'Observacion 10', NULL, 13, NULL, NULL),
       (9, 'Ingles', 'Observacion 10', NULL, 14, NULL, NULL),
       (7, 'Español', 'Observacion 10', NULL, 15, NULL, NULL);



INSERT INTO componenteCurriculum (IdCurriculum, IdComponente, IdUsuario, Orden)
VALUES (5, 10, 3, 1),
       (5, 18, 3, 2),
       (18, 1, 4, 3),
       (1, 4, 5, 4),
       (2, 19, 5, 5),
       (1, 35, 5, 6),
       (21, 31, 8, 7),
       (21, 9, 8, 8),
       (7, 22, 9, 9),
       (6, 5, 17, 10),
       (12, 17, 12, 11),
       (10, 20, 14, 12),
       (20, 14, 11, 13),
       (9, 11, 6, 14),
       (8, 11, 6, 15),   # -
       (3, 15, 15, 16),
       (18, 30, 4, 17),
       (13, 6, 20, 18),
       (13, 29, 20, 19), # -
       (3, 28, 15, 20);
--
INSERT INTO formacion (IdFormacion, FechaInicio, FechaFin, Institucion, TipoFormacion)
VALUES (6, '2014-11-01', NULL, 'Intituto N', 'grado'),
       (7, '2016-01-01', NULL, 'INSTITUCION1', 'curso'),
       (8, '2008-02-01', NULL, 'INSTITUCION2', 'posgrado'),
       (9, '2011-08-01', '2022-11-21', 'INSTITUCION3', 'grado'),
       (10, '2013-02-01', '2023-12-11', 'INSTITUCION3', 'grado');
--
INSERT INTO componente (IdUsuario, TituloComponente, Observacion, IdFormacion)
VALUES (6, 'Licenciatura en Psicología', 'Observacion 11', 6),
       (6, 'Maestría en Ingeniería Civil', 'Observacion 12', 7),
       (6, 'Diplomado en Marketing Digital', 'Observacion 13', 8),
       (6, 'Curso de Fotografía Avanzada', 'Observacion 14', 9),
       (6, 'Técnico en Reparación de Computadoras', 'Observacion 15', 10);

-- Mas valores de prueba para facilitar la consulta del punto 5 TP2

INSERT INTO proyecto (IdProyecto, FechaInicio, FechaFin, Link, Estado, Descripcion, Recursos)
VALUES (21, '2000-01-17', '2020-10-25', 'https://link21.com/', 'F', 'Descripción del Proyecto 21', NULL),
       (22, '2010-01-17', '2015-10-25', 'https://link22.com/', 'F', 'Descripción del Proyecto 22', NULL),
       (23, '2004-05-20', '2011-11-14', 'https://link23.com/', 'F', 'Descripción del Proyecto 23', NULL),
       (24, '2005-03-07', '2006-12-25', 'https://link24.com/', 'F', 'Descripción del Proyecto 24', NULL);

select *
from habilidad;
INSERT INTO habilidad (IdHabilidad, TipoHabilidad, Escala, Detalles)
VALUES (16, 'Blanda', 1, NULL),
       (17, 'Blanda', 3, NULL),
       (18, 'Dura', 5, NULL),
       (19, 'Blanda', 2, NULL);

INSERT INTO formacion (IdFormacion, FechaInicio, FechaFin, Institucion, TipoFormacion)
VALUES (11, '2021-08-01', NULL, 'FACULTAD DE DERECHO', 'grado'),
       (12, '2014-09-02', NULL, 'FACULTAD DE DERECHO', 'curso'),
       (13, '2021-04-24', '2022-05-04', 'MEDICINA', 'grado'),
       (14, '2002-01-31', '2022-12-31', 'FABRICA DE CHURROS', 'grado');

INSERT INTO experiencia (IdExperiencia, Empresa, FechaInicio, FechaFin, Descripcion, Hitos)
VALUES (11, 'Microsoft', '2018-01-01', '2019-12-31', 'Desarrollo de plataforma azure', '[
  "Lanzamiento de la versión 1.0",
  "Más de 1000 usuarios registrados"
]'),
       (12, 'Globan', '2011-01-01', '2019-02-11', 'Programador de Java', '[
         "Lanzamiento de la versión 16.0",
         "Más de 100000 usuarios registrados"
       ]'),
       (13, 'Systelco', '2000-09-21', '2001-07-01', 'Establecimiento de una aplicacion web', NULL);

INSERT INTO componente (IdComponente, IdUsuario, TituloComponente, Observacion, IdExperiencia, IdHabilidad, IdFormacion,
                        IdProyecto)
VALUES (79, 6, 'NOMBRECOMPONENTE 79', 'Observacion 79', 11, NULL, NULL, NULL),
       (80, 6, 'NOMBRECOMPONENTE 80', 'Observacion 80', 12, NULL, NULL, NULL),
       (81, 6, 'NOMBRECOMPONENTE 81', 'Observacion 81', 13, NULL, NULL, NULL),
       (82, 6, 'NOMBRECOMPONENTE 82', 'Observacion 82', NULL, 16, NULL, NULL),
       (83, 6, 'NOMBRECOMPONENTE 83', 'Observacion 83', NULL, 17, NULL, NULL),
       (84, 6, 'NOMBRECOMPONENTE 84', 'Observacion 84', NULL, 18, NULL, NULL),
       (85, 6, 'NOMBRECOMPONENTE 85', 'Observacion 85', NULL, 19, NULL, NULL),
       (86, 6, 'NOMBRECOMPONENTE546', 'Observacion 86', NULL, NULL, 11, NULL),
       (87, 6, 'NOMBRECOMPONENTE123', 'Observacion 87', NULL, NULL, 12, NULL),
       (88, 6, 'NOMBRECOMPONENTE YOYO', 'Observacion 88', NULL, NULL, 13, NULL),
       (89, 6, 'NOMBRECOMPONENTE 456456', 'Observacion 89', NULL, NULL, 14, NULL),
       (90, 6, 'NOMBRECOMPONENTE AÑGP', 'Observacion 90', NULL, NULL, NULL, 21),
       (91, 6, 'NOMBRECOMPONENTE FSD', 'Observacion 91', NULL, NULL, NULL, 22),
       (92, 6, 'NOMBRECOMPONENTE ZCXCZX', 'Observacion 92', NULL, NULL, NULL, 23),
       (93, 6, 'NOMBRECOMPONENTE ULTIMA', 'Observacion 93', NULL, NULL, NULL, 24);


INSERT INTO componenteCurriculum (IdCurriculum, IdUsuario, IdComponente, Orden)
VALUES (8, 6, 79, 20),
       (8, 6, 80, 21),
       (8, 6, 81, 22),
       (8, 6, 82, 23),
       (8, 6, 83, 24),
       (8, 6, 84, 25),
       (8, 6, 85, 26),
       (8, 6, 86, 27),
       (8, 6, 87, 28),
       (8, 6, 88, 29),
       (8, 6, 90, 30),
       (8, 6, 91, 31),
       (8, 6, 92, 32),
       (8, 6, 93, 33);

select *
from curriculum
where IdUsuario = 6;

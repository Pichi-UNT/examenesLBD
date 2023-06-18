-- OBSERVACION IMPORTANTE: SE REALIZARON ACTUALIZACION EN EL TP1 (MAS INSERTS EN ALGUNAS TABLAS Y LIGEROS CAMBIOS EN MODELO LOGICO)

-- 1. Dado un usuario, listar todas sus formaciones dadas de alta entre un rango de fechas.
SET @IdUsuario = 6;
SET @FechaInicio = '2000-01-01';
SET @FechaFin = '2020-01-01';
SELECT TituloComponente, Observacion, FechaInicio, FechaFin, Institucion, TipoFormacion
FROM componente c
         JOIN formacion f ON c.IdFormacion = f.IdFormacion
WHERE c.IdUsuario = @IdUsuario
  AND FechaInicio BETWEEN @FechaInicio AND @FechaFin;

-- 2. Realizar un listado de todas las redes sociales. Mostrar red, cantidad. Incluir las que no tengan usuarios en cero.
SELECT r.IdRedSocial, r.red, COALESCE(COUNT(ru.IdRedSocial), 0)
FROM redSocial r
         left JOIN redSocialUsuario ru on r.IdRedSocial = ru.IdRedSocial
GROUP BY r.IdRedSocial, r.red;

-- 3. Hacer un ranking con los usuarios que más tiempo permanecen en un puesto laboral.
SELECT DISTINCT Nick, Nombre, Apellido
FROM ((usuario JOIN componente ON usuario.IdUsuario = componente.IdUsuario) JOIN experiencia
      ON componente.IdExperiencia = experiencia.IdExperiencia)
ORDER BY DATEDIFF(FechaFin, FechaInicio) DESC;

-- 4. Dado un usuario, mostrar los curriculum que hizo.
SELECT c.IdCurriculum, c.IdUsuario, c.Curriculum, c.Descripcion, c.Banner, c.ImagenPerfil, c.Estado
FROM usuario u
         JOIN curriculum c on u.IdUsuario = c.IdUsuario
WHERE u.IdUsuario = @IdUsuario;

-- 5. Dado un curriculum. Mostrar sus componentes. Mostrar en el orden: Experiencias, Formaciones, Proyectos y habilidad finalmente.
-- Ordenar cronológicamente en los componentes que tienen esta opción.
SET @IdCurriculum = 8; -- Usamos el cv 8 porque realizamos muchos inserts dentro
SELECT TituloComponente,
       Observacion,
       Empresa,
       experiencia.FechaInicio AS InicoExperencia,
       experiencia.FechaFin    AS FinExperencia,
       experiencia.Descripcion AS DescripcionExperiencia,
       Hitos,
       formacion.FechaInicio   AS InicoFormacion,
       formacion.FechaFin      AS FinFormacion,
       Institucion,
       TipoFormacion,
       proyecto.FechaInicio    AS InicoProyecto,
       proyecto.FechaFin       AS FinProyecto,
       Link,
       proyecto.Estado,
       proyecto.Descripcion,
       Recursos,
       TipoHabilidad,
       Escala,
       Detalles
FROM (
         (
             (
                 (
                     (
                         (curriculum JOIN componenteCurriculum
                          ON curriculum.IdCurriculum = componenteCurriculum.IdCurriculum and
                             curriculum.IdUsuario = componenteCurriculum.IdUsuario)
                             JOIN componente ON componenteCurriculum.IdComponente = componente.IdComponente and
                                                componentecurriculum.IdUsuario = componente.IdUsuario)
                         LEFT JOIN experiencia ON componente.IdExperiencia = experiencia.IdExperiencia)
                     LEFT JOIN formacion ON componente.IdFormacion = formacion.IdFormacion)
                 LEFT JOIN proyecto ON componente.IdProyecto = proyecto.IdProyecto)
             LEFT JOIN habilidad ON componente.IdHabilidad = habilidad.IdHabilidad)
WHERE curriculum.IdCurriculum = @IdCurriculum
ORDER BY habilidad.IdHabilidad, proyecto.FechaInicio, formacion.FechaInicio, experiencia.FechaInicio;

-- 6. Hacer un ranking con los idiomas que más cargan los usuarios.
SELECT c.TituloComponente, COUNT(c.TituloComponente) CantidadUsuariosConIdioma
FROM habilidad h
         join componente c on h.IdHabilidad = c.IdHabilidad
WHERE TipoHabilidad = 'Idioma'
GROUP BY c.TituloComponente
ORDER BY CantidadUsuariosConIdioma DESC;
-- 7. Hacer un ranking con los trabajos que más permanencia tienen.
SELECT DISTINCT TituloComponente AS Trabajo, Empresa, AVG(DATEDIFF(FechaFin, FechaInicio)) AS DuracionEnHoras
FROM (componente JOIN experiencia ON componente.IdExperiencia = experiencia.IdExperiencia)
GROUP BY componente.TituloComponente, experiencia.Empresa
ORDER BY AVG(DATEDIFF(FechaFin, FechaInicio)) DESC;

-- 8. Crear una vista con la funcionalidad del apartado 3. Solo aparece una vez un usuario en el ranking
DROP VIEW IF EXISTS v_RankingUsuariosPuestoLaboral;
CREATE VIEW v_RankingUsuariosPuestoLaboral (Nick, Nombre, Apellido)
AS
SELECT DISTINCT Nick, Nombre, Apellido
FROM ((usuario JOIN componente ON usuario.IdUsuario = componente.IdUsuario) JOIN experiencia
      ON componente.IdExperiencia = experiencia.IdExperiencia)
ORDER BY DATEDIFF(FechaFin, FechaInicio) DESC;

SELECT *
FROM v_RankingUsuariosPuestoLaboral;

-- 9. Crear una copia de la tabla componente, llamada ComponenteJSON, que tenga una
-- columna del tipo JSON para guardar las formaciones. Llenar esta tabla con los mismos
-- datos del TP1 y resolver la consulta del apartado 1 (ambas consultas deben presentar la
-- misma salida).

CREATE TABLE componenteJSON
(
    IdComponente     INT AUTO_INCREMENT,
    IdUsuario        INT          NOT NULL,
    TituloComponente VARCHAR(150) NOT NULL,
    Observacion      TEXT,
    IdExperiencia    INT,
    IdHabilidad      INT,
    Formacion        JSON,
    IdProyecto       INT,
    PRIMARY KEY (IdComponente, IdUsuario),
    UNIQUE INDEX UI_IdComponente (IdComponente),
    INDEX Ref831 (IdExperiencia),
    INDEX Ref732 (IdHabilidad),
    INDEX Ref538 (IdProyecto),
    INDEX Ref239 (IdUsuario),
    CONSTRAINT Refexperiencia100 FOREIGN KEY (IdExperiencia)
        REFERENCES experiencia (IdExperiencia),
    CONSTRAINT Refhabilidad101 FOREIGN KEY (IdHabilidad)
        REFERENCES habilidad (IdHabilidad),
    CONSTRAINT Refproyecto103 FOREIGN KEY (IdProyecto)
        REFERENCES proyecto (IdProyecto),
    CONSTRAINT Refusuario104 FOREIGN KEY (IdUsuario)
        REFERENCES usuario (IdUsuario)
) ENGINE = INNODB;

TRUNCATE componenteJSON;
INSERT INTO componenteJSON (IdComponente, IdUsuario, TituloComponente, Observacion, IdExperiencia, IdHabilidad,
                            formacion,
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
       (10, 3, 'Curso de introduccion de metodologias agiles', 'Observacion 7', NULL, 5, NULL, NULL);

INSERT INTO componenteJSON (IdComponente, IdUsuario, TituloComponente, Observacion, IdExperiencia, IdHabilidad,
                            formacion,
                            IdProyecto)
VALUES (11, 6, 'Habilidades en Análisis de Negocios', NULL, NULL, NULL,
        JSON_OBJECT('FechaInicio', '2014-08-01', 'FechaFin', NULL, 'Institucion', 'FACULTAD DE DERECHO',
                    'TipoFormacion', 'grado'), NULL),
       (12, 1, 'Python', 'Observacion 8', NULL, NULL,
        JSON_OBJECT('FechaInicio', '2016-01-01', 'FechaFin', NULL, 'Institucion', 'INSTITUCION1', 'TipoFormacion',
                    'curso'), NULL),
       (13, 7, 'Diseño de Interfaces de Usuario', NULL, NULL, NULL,
        JSON_OBJECT('FechaInicio', '2008-05-01', 'FechaFin', NULL, 'Institucion', 'INSTITUCION2', 'TipoFormacion',
                    'posgrado'), NULL),
       (14, 11, 'Programación en Java', 'Observacion 9', NULL, NULL,
        JSON_OBJECT('FechaInicio', '2008-05-01', 'FechaFin', NULL, 'Institucion', 'INSTITUCION2', 'TipoFormacion',
                    'posgrado'), NULL),
       (15, 15, 'Móbile first', 'Observacion 10', NULL, NULL,
        JSON_OBJECT('FechaInicio', '2017-01-01', 'FechaFin', '2017-12-31', 'Institucion', 'INSTITUCION4',
                    'TipoFormacion', 'curso'), NULL);

INSERT INTO componenteJSON (IdUsuario, TituloComponente, Observacion, IdProyecto)
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

INSERT INTO componenteJSON (IdUsuario, TituloComponente, Observacion, IdExperiencia, IdHabilidad, formacion,
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

# Persona 6
INSERT INTO componenteJSON (idusuario, titulocomponente, observacion, formacion)
values (6, 'Licenciatura en Psicología', 'Observacion 11',
        JSON_OBJECT('FechaInicio', '2014-11-01', 'FechaFin', NULL, 'Institucion', 'Intituto N', 'TipoFormacion',
                    'grado')),
       (6, 'Maestría en Ingeniería Civil', 'Observacion 12',
        JSON_OBJECT('FechaInicio', '2016-01-01', 'FechaFin', NULL, 'Institucion', 'INSTITUCION1', 'TipoFormacion',
                    'curso')),
       (6, 'Diplomado en Marketing Digital', 'Observacion 13',
        JSON_OBJECT('FechaInicio', '2008-02-01', 'FechaFin', NULL, 'Institucion', 'INSTITUCION2', 'TipoFormacion',
                    'posgrado')),
       (6, 'Curso de Fotografía Avanzada', 'Observacion 14',
        JSON_OBJECT('FechaInicio', '2011-08-01', 'FechaFin', '2022-11-21', 'Institucion', 'INSTITUCION3',
                    'TipoFormacion', 'grado')),
       (6, 'Técnico en Reparación de Computadoras', 'Observacion 15',
        JSON_OBJECT('FechaInicio', '2013-02-01', 'FechaFin', '2023-12-11', 'Institucion', 'INSTITUCION3',
                    'TipoFormacion', 'grado'));
SET @IdUsuario = 6;
SET @FechaInicio = '2000-01-01';
SET @FechaFin = '2020-01-01';
SELECT TituloComponente, Observacion, FechaInicio, FechaFin, Institucion, TipoFormacion
FROM componenteJSON,
     JSON_TABLE(formacion, '$' COLUMNS (
         FechaInicio VARCHAR(50) PATH '$.FechaInicio',
         FechaFin VARCHAR(50) PATH '$.FechaFin',
         Institucion VARCHAR(50) PATH '$.Institucion',
         TipoFormacion VARCHAR(50) PATH '$.TipoFormacion'
         )) AS TablaJSON
WHERE IdUsuario = @IdUsuario
  AND FechaInicio BETWEEN @FechaInicio AND @FechaFin;

-- 10: Realizar una vista que considere importante para su modelo. También dejar escrito el enunciado de la misma.
-- ELABORAR UNA VISTA QUE PERMITA OBTENER LAS REDES SOCIALES DE LOS USUARIOS, DE MANERA DE PODER FILTRAR TODAS LAS REDES DE UN USUARIO DE FORMA MAS SENCILLA
DROP VIEW IF EXISTS v_RedesUsuarios;
CREATE VIEW v_RedesUsuarios
AS
SELECT u.IdUsuario, r.LinkRed, rs.Red, rs.LogoLink
FROM usuario u
         JOIN redSocialUsuario r ON u.IdUsuario = r.IdUsuario
         JOIN redSocial rs
         JOIN redSocial p ON p.IdRedSocial = r.IdRedSocial;

SELECT *
FROM v_RedesUsuarios;

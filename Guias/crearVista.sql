DROP VIEW IF EXISTS v_RankingUsuariosPuestoLaboral;
CREATE VIEW v_RankingUsuariosPuestoLaboral (Nick, Nombre, Apellido)
AS
SELECT DISTINCT Nick, Nombre, Apellido
FROM ((usuario JOIN componente ON usuario.IdUsuario = componente.IdUsuario) JOIN experiencia
      ON componente.IdExperiencia = experiencia.IdExperiencia)
ORDER BY DATEDIFF(FechaFin, FechaInicio) DESC;
-- Funciones
-- 1. Calcular el promedio ponderado de evaluaciones de un camper.
DELIMITER //
CREATE FUNCTION promedio_ponderado(camper_id INT) RETURNS DECIMAL(4,1)
READS SQL DATA
BEGIN
    DECLARE promedio DECIMAL(4,1);
    SELECT AVG(
        (e.theory_score * m.theory_percentage / 100) +
        (e.practice_score * m.practice_percentage / 100) +
        (e.quizzes_score * m.quizzes_percentage / 100)
    ) INTO promedio
    FROM module_evaluations e
    JOIN camper_groups cg ON e.group_id = cg.id
    JOIN modules m ON e.module_id = m.id
    WHERE cg.camper_id = camper_id;
    RETURN IFNULL(promedio, 0);
END //
DELIMITER ;
SELECT promedio_ponderado(1) AS promedio_ponderado_evaluaciones;

-- 2. Determinar si un camper aprueba o no un módulo específico.
DELIMITER //
CREATE FUNCTION camper_aprueba(camper_id INT, modulo_id INT) RETURNS VARCHAR(10)
READS SQL DATA
BEGIN
    DECLARE resultado VARCHAR(10);
    SELECT IF(
        AVG(
            (e.theory_score * m.theory_percentage / 100) +
            (e.practice_score * m.practice_percentage / 100) +
            (e.quizzes_score * m.quizzes_percentage / 100)
        ) > 65, 'Aprueba', 'No aprueba'
    ) INTO resultado
    FROM module_evaluations e
    JOIN camper_groups cg ON e.group_id = cg.id
    JOIN modules m ON e.module_id = m.id
    WHERE cg.camper_id = camper_id AND m.id = modulo_id;
    RETURN IFNULL(resultado, 'No aprueba');
END //
DELIMITER ;
SELECT camper_aprueba(1,1) AS camper_aprueba_modulo;

-- 3. Evaluar el nivel de riesgo de un camper según su rendimiento promedio.
DELIMITER //
CREATE FUNCTION nivel_riesgo(camper_id INT) RETURNS VARCHAR(10)
READS SQL DATA
BEGIN
    DECLARE resultado VARCHAR(10);
    SELECT 
        CASE 
            WHEN AVG(
                (e.theory_score * m.theory_percentage / 100) +
                (e.practice_score * m.practice_percentage / 100) +
                (e.quizzes_score * m.quizzes_percentage / 100)
            ) >= 90 THEN 'Bajo'
            WHEN AVG(
                (e.theory_score * m.theory_percentage / 100) +
                (e.practice_score * m.practice_percentage / 100) +
                (e.quizzes_score * m.quizzes_percentage / 100)
            ) >= 80 THEN 'Medio'
            WHEN AVG(
                (e.theory_score * m.theory_percentage / 100) +
                (e.practice_score * m.practice_percentage / 100) +
                (e.quizzes_score * m.quizzes_percentage / 100)
            ) >= 65 THEN 'Alto'
            ELSE 'Alto'
        END 
    INTO resultado
    FROM module_evaluations e
    JOIN camper_groups cg ON e.group_id = cg.id
    JOIN modules m ON e.module_id = m.id
    WHERE cg.camper_id = camper_id;
    RETURN IFNULL(resultado, 'Alto');
END //
DELIMITER ;
SELECT nivel_riesgo(1) AS riesgo_camper;

-- 4. Obtener el total de campers asignados a una ruta específica.
DELIMITER //
CREATE FUNCTION total_campers(ruta_id INT) RETURNS INT
READS SQL DATA
BEGIN
    DECLARE total INT;
    SELECT COUNT(cg.id) INTO total
    FROM routes r
    JOIN training_groups tg ON r.id = tg.route_id
    JOIN camper_groups cg ON tg.id = cg.group_id
    WHERE r.id = ruta_id;
    RETURN total;
END //
DELIMITER ;
SELECT total_campers(1);

-- 5. Consultar la cantidad de módulos que ha aprobado un camper.
DELIMITER //
CREATE FUNCTION modulos_aprobados(camper_id INT) RETURNS INT
READS SQL DATA
BEGIN
    DECLARE total INT;
    SELECT COUNT(e.id) INTO total
    FROM module_evaluations e
    JOIN camper_groups cg ON e.group_id = cg.id
    WHERE e.final_score > 65 AND cg.camper_id = camper_id;
    RETURN total;
END //
DELIMITER ;
SELECT modulos_aprobados(1);

-- 6. Validar si hay cupos disponibles en una determinada área.
DELIMITER //
CREATE FUNCTION cupos_disponibles(id_classroom INT) RETURNS VARCHAR(20)
READS SQL DATA
BEGIN
    DECLARE cupos VARCHAR(20);
    SELECT IF(c.capacity >= 33, 'No hay cupos', 'Hay cupos disponibles')
    INTO cupos
    FROM classrooms c
    WHERE id = id_classroom;
    RETURN cupos;
END //
DELIMITER ;
SELECT cupos_disponibles(1);

-- 7. Calcular el porcentaje de ocupación de un área de entrenamiento.
DELIMITER //
CREATE FUNCTION calcular_porcentaje_ocupacion(id_classroom INT) RETURNS DECIMAL(5,2)
READS SQL DATA
BEGIN
    DECLARE capacidad INT;
    DECLARE ocupacion INT;
    DECLARE porcentaje DECIMAL(5,2);
    
    SELECT c.capacity INTO capacidad 
    FROM classrooms c
    WHERE c.id = id_classroom;
    
    SELECT COUNT(cg.id) INTO ocupacion
    FROM camper_groups cg
    INNER JOIN training_groups tg ON cg.group_id = tg.id
    WHERE tg.classroom_id = id_classroom
    AND cg.status = 'Activo';
    
    IF capacidad > 0 THEN
        SET porcentaje = (ocupacion / capacidad) * 100;
    ELSE
        SET porcentaje = 0;
    END IF;
    
    RETURN porcentaje;
END //
DELIMITER ;
SELECT calcular_porcentaje_ocupacion(1);

-- 8. Determinar la nota más alta obtenida en un módulo.
DELIMITER //
CREATE FUNCTION nota_modulo(modulo_id INT) RETURNS DECIMAL(4,1)
READS SQL DATA
BEGIN
    DECLARE max_score DECIMAL(4,1);
    
    SELECT MAX(me.final_score) INTO max_score
    FROM module_evaluations me
    WHERE me.module_id = modulo_id;
    
    RETURN IFNULL(max_score, 0);
END //
DELIMITER ;

SELECT nota_modulo(1);

-- 9. Calcular la tasa de aprobación de una ruta.


-- 10. Verificar si un trainer tiene horario disponible.
DELIMITER //
CREATE FUNCTION trainer_horario_disponible(
    trainer_id INT, 
    dia_semana INT, 
    bloque_horario INT
) RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE disponible BOOLEAN;
    
    SELECT ts.is_available INTO disponible
    FROM trainer_schedules ts
    WHERE ts.trainer_id = trainer_id
    AND ts.day_of_week = dia_semana
    AND ts.time_block_id = bloque_horario;
    
    RETURN IFNULL(disponible, FALSE);
END //
DELIMITER ;
SELECT 

-- 11. Obtener el promedio de notas por ruta.
DELIMITER //
CREATE FUNCTION promedio_notas_ruta(ruta_id INT) RETURNS DECIMAL(4,2)
READS SQL DATA
BEGIN
    DECLARE promedio DECIMAL(4,2);
    
    SELECT AVG(g.final_grade) INTO promedio
    FROM graduates g
    WHERE g.route_id = ruta_id;
    
    RETURN IFNULL(promedio, 0);
END //
DELIMITER ;
SELECT promedio_notas_ruta(1);

-- 12. Calcular cuántas rutas tiene asignadas un trainer.
DELIMITER //
CREATE FUNCTION rutas_asignadas_trainer(trainer_id INT) RETURNS INT
READS SQL DATA
BEGIN
    DECLARE total_rutas INT;
    
    SELECT COUNT(DISTINCT tg.route_id) INTO total_rutas
    FROM training_groups tg
    WHERE tg.trainer_id = trainer_id;
    
    RETURN IFNULL(total_rutas, 0);
END //
DELIMITER ;
SELECT rutas_asignadas_trainer(1);

-- 13. Verificar si un camper puede ser graduado.
-- 14. Obtener el estado actual de un camper en función de sus evaluaciones.
-- 15. Calcular la carga horaria semanal de un trainer.
-- 16. Determinar si una ruta tiene módulos pendientes por evaluación.
-- 17. Calcular el promedio general del programa.
DELIMITER //
CREATE FUNCTION promedio_general_programa() RETURNS DECIMAL(4,2)
READS SQL DATA
BEGIN
    DECLARE promedio DECIMAL(4,2);
    
    SELECT AVG(final_grade) INTO promedio
    FROM graduates;
    
    RETURN IFNULL(promedio, 0);
END //
DELIMITER ;
SELECT promedio_general_programa();

-- 18. Verificar si un horario choca con otros entrenadores en el área.
-- 19. Calcular cuántos campers están en riesgo en una ruta específica.
-- 20. Consultar el número de módulos evaluados por un camper.

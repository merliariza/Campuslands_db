-- Consultas
-- Campers 
-- 1. Obtener todos los campers inscritos actualmente
SELECT p.first_name, p.last_name, cs.name AS status
FROM campers c
JOIN persons p ON c.person_id = p.id
JOIN camper_statuses cs ON c.status_id = cs.id
WHERE cs.name = 'Inscrito';

-- 2. Listar los campers con estado "Aprobado"
SELECT p.first_name, p.last_name, cs.name AS status
FROM campers c
JOIN persons p ON c.person_id = p.id
JOIN camper_statuses cs ON c.status_id = cs.id
WHERE cs.name = 'Aprobado';

-- 3. Mostrar los campers que ya están cursando alguna ruta
SELECT p.first_name, p.last_name, r.name AS route_name
FROM campers c
JOIN persons p ON c.person_id = p.id
JOIN camper_groups cg ON c.id = cg.camper_id
JOIN training_groups tg ON cg.group_id = tg.id
JOIN routes r ON tg.route_id = r.id
WHERE c.status_id = (SELECT id FROM camper_statuses WHERE name = 'Cursando');

-- 4. Consultar los campers graduados por cada ruta
SELECT p.first_name, p.last_name, r.name AS route_name, g.final_grade
FROM graduates g
JOIN campers c ON g.camper_id = c.id
JOIN persons p ON c.person_id = p.id
JOIN routes r ON g.route_id = r.id
ORDER BY r.name, g.final_grade DESC;

-- 5. Obtener los campers que se encuentran en estado "Expulsado" o "Retirado"
SELECT p.first_name, p.last_name, cs.name AS status
FROM campers c
JOIN persons p ON c.person_id = p.id
JOIN camper_statuses cs ON c.status_id = cs.id
WHERE cs.name IN ('Expulsado', 'Retirado');

-- 6. Listar campers con nivel de riesgo "Alto"
SELECT p.first_name, p.last_name, rl.name AS risk_level
FROM campers c
JOIN persons p ON c.person_id = p.id
JOIN risk_levels rl ON c.risk_level_id = rl.id
WHERE rl.name = 'Alto';

-- 7. Mostrar el total de campers por cada nivel de riesgo
SELECT rl.name AS risk_level, COUNT(c.id) AS total_campers
FROM campers c
JOIN risk_levels rl ON c.risk_level_id = rl.id
GROUP BY rl.name
ORDER BY total_campers DESC;

-- 8. Obtener campers con más de un número telefónico registrado
SELECT p.first_name, p.last_name, COUNT(pp.id) AS phone_count
FROM persons p
JOIN person_phones pp ON p.id = pp.person_id
JOIN campers c ON p.id = c.person_id
GROUP BY p.id, p.first_name, p.last_name
HAVING COUNT(pp.id) > 1;

-- 9. Listar los campers y sus respectivos acudientes y teléfonos
SELECT 
    p.first_name AS camper_first_name,
    p.last_name AS camper_last_name,
    gp.first_name AS guardian_first_name,
    gp.last_name AS guardian_last_name,
    g.relationship,
    pp.number AS guardian_phone
FROM campers c
JOIN persons p ON c.person_id = p.id
JOIN guardians g ON c.id = g.camper_id
JOIN persons gp ON g.person_id = gp.id
JOIN person_phones pp ON gp.id = pp.person_id;

-- 10. Mostrar campers que aún no han sido asignados a una ruta
SELECT p.first_name, p.last_name
FROM campers c
JOIN persons p ON c.person_id = p.id
WHERE c.id NOT IN (SELECT camper_id FROM camper_groups WHERE status = 'Activo')
AND c.status_id IN (SELECT id FROM camper_statuses WHERE name IN ('Aprobado', 'Inscrito'));

-- Evaluaciones 
-- 1. Obtener las notas teóricas, prácticas y quizzes de cada camper por módulo.
SELECT 
    p.first_name, 
    p.last_name, 
    m.name AS modulo,
    MAX(CASE WHEN et.name = 'Teórica' THEN es.score ELSE NULL END) AS nota_teorica,
    MAX(CASE WHEN et.name = 'Práctica' THEN es.score ELSE NULL END) AS nota_practica,
    MAX(CASE WHEN et.name = 'Quiz' THEN es.score ELSE NULL END) AS nota_quiz
FROM evaluation_scores es
JOIN evaluations e ON es.evaluation_id = e.id
JOIN evaluation_types et ON e.evaluation_type_id = et.id
JOIN modules m ON e.module_id = m.id
JOIN campers c ON es.camper_id = c.id
JOIN persons p ON c.person_id = p.id
GROUP BY p.first_name, p.last_name, m.name;

-- 2. Calcular la nota final de cada camper por módulo.
SELECT 
    p.first_name, 
    p.last_name, 
    m.name AS modulo,
    SUM(es.score * et.weight_percentage / 100) AS nota_final
FROM evaluation_scores es
JOIN evaluations e ON es.evaluation_id = e.id
JOIN evaluation_types et ON e.evaluation_type_id = et.id
JOIN modules m ON e.module_id = m.id
JOIN campers c ON es.camper_id = c.id
JOIN persons p ON c.person_id = p.id
GROUP BY p.first_name, p.last_name, m.id, m.name;

-- 3. Mostrar los campers que reprobaron algún módulo (nota < 60).
SELECT DISTINCT 
    p.first_name, 
    p.last_name, 
    m.name AS modulo,
    SUM(es.score * et.weight_percentage / 100) AS nota_final
FROM evaluation_scores es
JOIN evaluations e ON es.evaluation_id = e.id
JOIN evaluation_types et ON e.evaluation_type_id = et.id
JOIN modules m ON e.module_id = m.id
JOIN campers c ON es.camper_id = c.id
JOIN persons p ON c.person_id = p.id
GROUP BY p.first_name, p.last_name, m.id, m.name
HAVING SUM(es.score * et.weight_percentage / 100) < 60;

-- 4. Listar los módulos con más campers en bajo rendimiento.
SELECT 
    m.name AS modulo, 
    SUM(CASE WHEN nota_final < 60 THEN 1 ELSE 0 END) AS campers_bajo_rendimiento
FROM (
    SELECT 
        m.id AS modulo_id,
        m.name,
        es.camper_id,
        SUM(es.score * et.weight_percentage / 100) AS nota_final
    FROM evaluation_scores es
    JOIN evaluations e ON es.evaluation_id = e.id
    JOIN evaluation_types et ON e.evaluation_type_id = et.id
    JOIN modules m ON e.module_id = m.id
    GROUP BY m.id, m.name, es.camper_id
) AS notas_finales
JOIN modules m ON notas_finales.modulo_id = m.id
GROUP BY m.name
ORDER BY campers_bajo_rendimiento DESC;

-- 5. Obtener el promedio de notas finales por cada módulo.
SELECT 
    m.name AS modulo,
    AVG(nota_final) AS promedio_nota
FROM (
    SELECT 
        m.id AS modulo_id,
        es.camper_id,
        SUM(es.score * et.weight_percentage / 100) AS nota_final
    FROM evaluation_scores es
    JOIN evaluations e ON es.evaluation_id = e.id
    JOIN evaluation_types et ON e.evaluation_type_id = et.id
    JOIN modules m ON e.module_id = m.id
    GROUP BY m.id, es.camper_id
) AS notas_finales
JOIN modules m ON notas_finales.modulo_id = m.id
GROUP BY m.name;

-- 6. Consultar el rendimiento general por ruta de entrenamiento.
SELECT 
    r.name AS ruta,
    AVG(nota_final) AS rendimiento_promedio
FROM (
    SELECT 
        tg.route_id,
        es.camper_id,
        m.id AS modulo_id,
        SUM(es.score * et.weight_percentage / 100) AS nota_final
    FROM evaluation_scores es
    JOIN evaluations e ON es.evaluation_id = e.id
    JOIN evaluation_types et ON e.evaluation_type_id = et.id
    JOIN modules m ON e.module_id = m.id
    JOIN training_groups tg ON e.group_id = tg.id
    GROUP BY tg.route_id, es.camper_id, m.id
) AS notas_finales
JOIN routes r ON notas_finales.route_id = r.id
GROUP BY r.name;

-- 7. Mostrar los trainers responsables de campers con bajo rendimiento.
SELECT DISTINCT 
    p.first_name AS trainer_nombre, 
    p.last_name AS trainer_apellido
FROM trainers t
JOIN persons p ON t.person_id = p.id
JOIN training_groups tg ON t.id = tg.trainer_id
WHERE tg.id IN (
    SELECT DISTINCT e.group_id
    FROM evaluations e
    JOIN evaluation_scores es ON e.id = es.evaluation_id
    JOIN evaluation_types et ON e.evaluation_type_id = et.id
    GROUP BY e.group_id, es.camper_id
    HAVING SUM(es.score * et.weight_percentage / 100) < 60
);

-- 8. Comparar el promedio de rendimiento por trainer.
SELECT 
    p.first_name AS trainer_nombre, 
    p.last_name AS trainer_apellido,
    AVG(nota_final) AS promedio_rendimiento
FROM (
    SELECT 
        tg.trainer_id,
        es.camper_id,
        m.id AS modulo_id,
        SUM(es.score * et.weight_percentage / 100) AS nota_final
    FROM evaluation_scores es
    JOIN evaluations e ON es.evaluation_id = e.id
    JOIN evaluation_types et ON e.evaluation_type_id = et.id
    JOIN modules m ON e.module_id = m.id
    JOIN training_groups tg ON e.group_id = tg.id
    GROUP BY tg.trainer_id, es.camper_id, m.id
) AS notas_finales
JOIN trainers t ON notas_finales.trainer_id = t.id
JOIN persons p ON t.person_id = p.id
GROUP BY p.first_name, p.last_name
ORDER BY promedio_rendimiento DESC;

-- 9. Listar los mejores 5 campers por nota final en cada ruta.
WITH mejores_campers AS (
    SELECT 
        r.id AS ruta_id,
        r.name AS ruta_nombre,
        p.first_name,
        p.last_name,
        AVG(nota_final) AS promedio_final,
        ROW_NUMBER() OVER (PARTITION BY r.id ORDER BY AVG(nota_final) DESC) AS rn
    FROM (
        SELECT 
            tg.route_id,
            es.camper_id,
            SUM(es.score * et.weight_percentage / 100) AS nota_final
        FROM evaluation_scores es
        JOIN evaluations e ON es.evaluation_id = e.id
        JOIN evaluation_types et ON e.evaluation_type_id = et.id
        JOIN training_groups tg ON e.group_id = tg.id
        GROUP BY tg.route_id, es.camper_id, e.module_id
    ) AS notas_finales
    JOIN routes r ON notas_finales.route_id = r.id
    JOIN campers c ON notas_finales.camper_id = c.id
    JOIN persons p ON c.person_id = p.id
    GROUP BY r.id, r.name, p.first_name, p.last_name
)
SELECT ruta_nombre, first_name, last_name, promedio_final
FROM mejores_campers
WHERE rn <= 5
ORDER BY ruta_nombre, rn;

-- 10. Mostrar cuántos campers pasaron cada módulo por ruta.
SELECT 
    r.name AS ruta,
    m.name AS modulo,
    SUM(CASE WHEN nota_final >= 60 THEN 1 ELSE 0 END) AS campers_aprobados
FROM (
    SELECT 
        tg.route_id,
        e.module_id,
        es.camper_id,
        SUM(es.score * et.weight_percentage / 100) AS nota_final
    FROM evaluation_scores es
    JOIN evaluations e ON es.evaluation_id = e.id
    JOIN evaluation_types et ON e.evaluation_type_id = et.id
    JOIN training_groups tg ON e.group_id = tg.id
    GROUP BY tg.route_id, e.module_id, es.camper_id
) AS notas_finales
JOIN routes r ON notas_finales.route_id = r.id
JOIN modules m ON notas_finales.module_id = m.id
GROUP BY r.name, m.name;

-- Rutas y Áreas de Entrenamiento 
-- 1. Mostrar todas las rutas de entrenamiento disponibles
SELECT name, description FROM routes;

-- 2. Obtener las rutas con su SGDB principal y alternativo
SELECT 
    r.name AS route_name,
    MAX(CASE WHEN rs.is_primary = TRUE THEN s.name END) AS primary_db,
    MAX(CASE WHEN rs.is_primary = FALSE THEN s.name END) AS secondary_db
FROM routes r
JOIN route_sgdb rs ON r.id = rs.route_id
JOIN sgdb s ON rs.database_id = s.id
GROUP BY r.name;

-- 3. Listar los módulos asociados a cada ruta
SELECT 
    r.name AS route_name,
    m.name AS module_name,
    rm.route_order
FROM routes r
JOIN route_modules rm ON r.id = rm.route_id
JOIN modules m ON rm.module_id = m.id
ORDER BY r.name, rm.route_order;

-- 4. Consultar cuántos campers hay en cada ruta
SELECT 
    r.name AS route_name,
    COUNT(cg.camper_id) AS camper_count
FROM routes r
JOIN training_groups tg ON r.id = tg.route_id
JOIN camper_groups cg ON tg.id = cg.group_id
WHERE cg.status = 'Activo'
GROUP BY r.name
ORDER BY camper_count DESC;

-- 5. Mostrar las áreas de entrenamiento y su capacidad máxima
SELECT 
    b.name AS branch_name,
    c.name AS classroom_name,
    c.capacity
FROM classrooms c
JOIN branches b ON c.campus_id = b.id
ORDER BY b.name, c.name;

-- 6. Obtener las áreas que están ocupadas al 100%
SELECT 
    b.name AS branch_name,
    c.name AS classroom_name,
    c.capacity,
    COUNT(cg.camper_id) AS current_occupancy
FROM classrooms c
JOIN branches b ON c.campus_id = b.id
JOIN training_groups tg ON c.id = tg.classroom_id
JOIN camper_groups cg ON tg.id = cg.group_id
WHERE cg.status = 'Activo'
GROUP BY b.name, c.name, c.capacity
HAVING COUNT(cg.camper_id) >= c.capacity;

-- 7. Verificar la ocupación actual de cada área
SELECT 
    b.name AS branch_name,
    c.name AS classroom_name,
    c.capacity,
    COUNT(cg.camper_id) AS current_occupancy,
    (COUNT(cg.camper_id) * 100.0 / c.capacity) AS occupancy_percentage
FROM classrooms c
JOIN branches b ON c.campus_id = b.id
LEFT JOIN training_groups tg ON c.id = tg.classroom_id
LEFT JOIN camper_groups cg ON tg.id = cg.group_id AND cg.status = 'Activo'
GROUP BY b.name, c.name, c.capacity
ORDER BY (COUNT(cg.camper_id) * 100.0 / c.capacity) DESC;

-- 8. Consultar los horarios disponibles por cada área
SELECT 
    b.name AS branch_name,
    c.name AS classroom_name,
    tb.name AS time_block,
    tb.start_time,
    tb.end_time
FROM classrooms c
JOIN branches b ON c.campus_id = b.id
JOIN training_groups tg ON c.id = tg.classroom_id
JOIN schedules s ON tg.schedule_id = s.id
JOIN time_blocks tb ON s.block_id = tb.id
ORDER BY b.name, c.name, tb.start_time;

-- 9. Mostrar las áreas con más campers asignados
SELECT 
    b.name AS branch_name,
    c.name AS classroom_name,
    COUNT(cg.camper_id) AS camper_count
FROM classrooms c
JOIN branches b ON c.campus_id = b.id
JOIN training_groups tg ON c.id = tg.classroom_id
JOIN camper_groups cg ON tg.id = cg.group_id
WHERE cg.status = 'Activo'
GROUP BY b.name, c.name
ORDER BY camper_count DESC
LIMIT 5;

-- 10. Listar las rutas con sus respectivos trainers y áreas asignadas
SELECT 
    r.name AS ruta,
    p.first_name AS trainer_nombre,
    p.last_name AS trainer_apellido,
    c.name AS salon
FROM routes r
JOIN training_groups tg ON r.id = tg.route_id
JOIN trainers t ON tg.trainer_id = t.id
JOIN persons p ON t.person_id = p.id
JOIN classrooms c ON tg.classroom_id = c.id
GROUP BY r.name, p.first_name, p.last_name, c.name;

-- Trainers 
-- 1. Listar todos los entrenadores registrados
SELECT 
    p.first_name,
    p.last_name,
    t.acronym,
    b.name AS campus_name
FROM trainers t
JOIN persons p ON t.person_id = p.id
JOIN branches b ON t.campus_id = b.id;

-- 2. Mostrar los trainers con sus horarios asignados
SELECT 
    p.first_name,
    p.last_name,
    tb.name AS time_block,
    tb.start_time,
    tb.end_time,
    ts.day_of_week,
    CASE ts.day_of_week 
        WHEN 1 THEN 'Domingo'
        WHEN 2 THEN 'Lunes'
        WHEN 3 THEN 'Martes'
        WHEN 4 THEN 'Miércoles'
        WHEN 5 THEN 'Jueves'
        WHEN 6 THEN 'Viernes'
        WHEN 7 THEN 'Sábado'
    END AS day_name
FROM trainers t
JOIN persons p ON t.person_id = p.id
JOIN trainer_schedules ts ON t.id = ts.trainer_id
JOIN time_blocks tb ON ts.time_block_id = tb.id
ORDER BY p.last_name, ts.day_of_week, tb.start_time;

-- 3. Consultar los trainers asignados a más de una ruta
SELECT 
    p.first_name,
    p.last_name,
    COUNT(DISTINCT tg.route_id) AS route_count
FROM trainers t
JOIN persons p ON t.person_id = p.id
JOIN training_groups tg ON t.id = tg.trainer_id
GROUP BY p.first_name, p.last_name
HAVING COUNT(DISTINCT tg.route_id) > 1
ORDER BY route_count DESC;

-- 4. Obtener el número de campers por trainer
SELECT 
    p.first_name,
    p.last_name,
    COUNT(cg.camper_id) AS camper_count
FROM trainers t
JOIN persons p ON t.person_id = p.id
JOIN training_groups tg ON t.id = tg.trainer_id
JOIN camper_groups cg ON tg.id = cg.group_id
WHERE cg.status = 'Activo'
GROUP BY p.first_name, p.last_name
ORDER BY camper_count DESC;

-- 5. Mostrar las áreas en las que trabaja cada trainer
SELECT 
    p.first_name,
    p.last_name,
    b.name AS branch_name,
    c.name AS classroom_name
FROM trainers t
JOIN persons p ON t.person_id = p.id
JOIN training_groups tg ON t.id = tg.trainer_id
JOIN classrooms c ON tg.classroom_id = c.id
JOIN branches b ON c.campus_id = b.id
GROUP BY p.first_name, p.last_name, b.name, c.name
ORDER BY p.last_name, b.name;

-- 6. Listar los trainers sin asignación de área o ruta
SELECT 
    p.first_name,
    p.last_name
FROM trainers t
JOIN persons p ON t.person_id = p.id
WHERE t.id NOT IN (SELECT trainer_id FROM training_groups)
ORDER BY p.last_name;

-- 7. Mostrar cuántos módulos están a cargo de cada trainer
SELECT 
    p.first_name,
    p.last_name,
    COUNT(DISTINCT mt.module_id) AS module_count
FROM trainers t
JOIN persons p ON t.person_id = p.id
LEFT JOIN module_trainers mt ON t.id = mt.trainer_id
GROUP BY p.first_name, p.last_name
ORDER BY module_count DESC;

-- 8. Obtener el trainer con mejor rendimiento promedio de campers
SELECT 
    p.first_name,
    p.last_name,
    AVG(nota_final) AS rendimiento_promedio
FROM (
    SELECT 
        tg.trainer_id,
        es.camper_id,
        AVG(es.score * et.weight_percentage / 100) AS nota_final
    FROM evaluation_scores es
    JOIN evaluations e ON es.evaluation_id = e.id
    JOIN evaluation_types et ON e.evaluation_type_id = et.id
    JOIN training_groups tg ON e.group_id = tg.id
    GROUP BY tg.trainer_id, es.camper_id
) AS notas_finales
JOIN trainers t ON notas_finales.trainer_id = t.id
JOIN persons p ON t.person_id = p.id
GROUP BY p.first_name, p.last_name
ORDER BY rendimiento_promedio DESC
LIMIT 1;

-- 9. Consultar los horarios ocupados por cada trainer
SELECT 
    p.first_name,
    p.last_name,
    ss.date,
    ss.start_time,
    ss.end_time,
    s.name AS sesion
FROM trainers t
JOIN persons p ON t.person_id = p.id
JOIN session_schedules ss ON t.id = ss.trainer_id
JOIN sessions s ON ss.session_id = s.id;

-- 10. Mostrar la disponibilidad semanal de cada trainer
SELECT 
    p.first_name,
    p.last_name,
    ts.day_of_week,
    CASE ts.day_of_week 
        WHEN 1 THEN 'Domingo'
        WHEN 2 THEN 'Lunes'
        WHEN 3 THEN 'Martes'
        WHEN 4 THEN 'Miércoles'
        WHEN 5 THEN 'Jueves'
        WHEN 6 THEN 'Viernes'
        WHEN 7 THEN 'Sábado'
    END AS day_name,
    GROUP_CONCAT(
        CONCAT(tb.name, ' (', tb.start_time, '-', tb.end_time, ')')
        SEPARATOR ', '
    ) AS available_blocks
FROM trainers t
JOIN persons p ON t.person_id = p.id
JOIN trainer_schedules ts ON t.id = ts.trainer_id
JOIN time_blocks tb ON ts.time_block_id = tb.id
WHERE ts.is_available = TRUE
GROUP BY p.first_name, p.last_name, ts.day_of_week
ORDER BY p.last_name, ts.day_of_week;

-- Consultas con Subconsultas y Cálculos Avanzados
-- 1. Obtener los campers con la nota más alta en cada módulo.
SELECT e.module_id, c.id AS camper_id, p.first_name, p.last_name, es.score
FROM evaluation_scores es
JOIN evaluations e ON es.evaluation_id = e.id
JOIN campers c ON es.camper_id = c.id
JOIN persons p ON c.person_id = p.id
WHERE es.score = (
    SELECT MAX(es2.score)
    FROM evaluation_scores es2
    JOIN evaluations e2 ON es2.evaluation_id = e2.id
    WHERE e2.module_id = e.module_id
);

-- 2. Mostrar el promedio general de notas por ruta y comparar con el promedio global.
SELECT r.id AS route_id, r.name AS route_name, 
       AVG(es.score) AS avg_route_score,
       (SELECT AVG(es2.score) FROM evaluation_scores es2) AS global_avg_score
FROM routes r
JOIN training_groups tg ON r.id = tg.route_id
JOIN evaluations e ON tg.id = e.group_id
JOIN evaluation_scores es ON e.id = es.evaluation_id
GROUP BY r.id, r.name;

-- 3. Listar las áreas con más del 80% de ocupación.
SELECT c.id AS classroom_id, c.name AS classroom_name, c.capacity,
       COUNT(tg.id) AS occupied_seats,
       (COUNT(tg.id) / c.capacity) * 100 AS occupancy_percentage
FROM classrooms c
JOIN training_groups tg ON c.id = tg.classroom_id
GROUP BY c.id, c.name, c.capacity
HAVING occupancy_percentage > 80;

-- 4. Mostrar los trainers con menos del 70% de rendimiento promedio.
SELECT t.id, t.acronym, AVG(es.score) AS avg_score
FROM trainers t
JOIN module_trainers mt ON t.id = mt.trainer_id
JOIN module_competencias mc ON mt.module_id = mc.module_id
JOIN evaluation_scores es ON mc.competencia_id = es.evaluation_id
GROUP BY t.id
HAVING avg_score < 70;

-- 5. Consultar los campers cuyo promedio está por debajo del promedio general.
SELECT es.camper_id, AVG(es.score) AS camper_avg
FROM evaluation_scores es
GROUP BY es.camper_id
HAVING camper_avg < (SELECT AVG(score) FROM evaluation_scores);

-- 6. Obtener los módulos con la menor tasa de aprobación.
SELECT m.id, m.name,
       (SUM(CASE WHEN es.score >= 60 THEN 1 ELSE 0 END) / COUNT(es.id)) * 100 AS pass_rate
FROM modules m
JOIN module_competencias mc ON m.id = mc.module_id
JOIN evaluation_scores es ON mc.competencia_id = es.evaluation_id
GROUP BY m.id
HAVING pass_rate < 50;

-- 7. Listar los campers que han aprobado todos los módulos de su ruta.
SELECT 
    p.first_name,
    p.last_name,
    r.name AS route_name,
    COUNT(DISTINCT m.id) AS modules_passed,
    (SELECT COUNT(DISTINCT rms.module_id) 
     FROM route_modules rms 
     WHERE rms.route_id = r.id) AS total_modules
FROM campers c
JOIN persons p ON c.person_id = p.id
JOIN camper_groups cg ON c.id = cg.camper_id
JOIN training_groups tg ON cg.group_id = tg.id
JOIN routes r ON tg.route_id = r.id
JOIN route_modules rm ON r.id = rm.route_id
JOIN modules m ON rm.module_id = m.id
WHERE (
    SELECT SUM(es.score * et.weight_percentage) / 100
    FROM evaluation_scores es
    JOIN evaluations e ON es.evaluation_id = e.id
    JOIN evaluation_types et ON e.evaluation_type_id = et.id
    WHERE e.module_id = m.id AND es.camper_id = c.id
    GROUP BY es.camper_id, e.module_id
) >= 60
GROUP BY p.first_name, p.last_name, r.name, r.id
HAVING COUNT(DISTINCT m.id) = (SELECT COUNT(DISTINCT rms.module_id) 
                              FROM route_modules rms 
                              WHERE rms.route_id = r.id)
ORDER BY p.last_name;

-- 8. Mostrar rutas con más de 10 campers en bajo rendimiento.
SELECT 
    r.name AS route_name,
    COUNT(DISTINCT c.id) AS low_performance_campers
FROM routes r
JOIN training_groups tg ON r.id = tg.route_id
JOIN camper_groups cg ON tg.id = cg.group_id
JOIN campers c ON cg.camper_id = c.id
WHERE EXISTS (
    SELECT 1
    FROM evaluation_scores es
    JOIN evaluations e ON es.evaluation_id = e.id
    JOIN evaluation_types et ON e.evaluation_type_id = et.id
    JOIN modules m ON e.module_id = m.id
    JOIN route_modules rm ON m.id = rm.module_id
    WHERE rm.route_id = r.id 
    AND es.camper_id = c.id
    GROUP BY es.camper_id, e.module_id
    HAVING SUM(es.score * et.weight_percentage) / 100 < 60
)
GROUP BY r.name
HAVING COUNT(DISTINCT c.id) > 10
ORDER BY low_performance_campers DESC;

-- 9. Calcular el promedio de rendimiento por SGDB principal.
SELECT r.name AS sgdb_name, AVG(es.score) AS avg_performance
FROM route_sgdb rs
JOIN sgdb r ON rs.database_id = r.id
JOIN route_modules rm ON rs.route_id = rm.route_id
JOIN evaluation_scores es ON rm.module_id = es.evaluation_id
GROUP BY r.name;

-- 10. Listar los módulos con al menos un 30% de campers reprobados
SELECT 
    m.name AS module_name,
    COUNT(cg.camper_id) AS total_campers,
    SUM(CASE WHEN (
        SELECT SUM(es.score * et.weight_percentage) / 100
        FROM evaluation_scores es
        JOIN evaluations e ON es.evaluation_id = e.id
        JOIN evaluation_types et ON e.evaluation_type_id = et.id
        WHERE e.module_id = m.id AND es.camper_id = cg.camper_id
        GROUP BY es.camper_id, e.module_id
    ) < 60 THEN 1 ELSE 0 END) AS failed_count,
    (SUM(CASE WHEN (
        SELECT SUM(es.score * et.weight_percentage) / 100
        FROM evaluation_scores es
        JOIN evaluations e ON es.evaluation_id = e.id
        JOIN evaluation_types et ON e.evaluation_type_id = et.id
        WHERE e.module_id = m.id AND es.camper_id = cg.camper_id
        GROUP BY es.camper_id, e.module_id
    ) < 60 THEN 1 ELSE 0 END) * 100.0 / COUNT(cg.camper_id)) AS fail_percentage
FROM modules m
JOIN route_modules rm ON m.id = rm.module_id
JOIN training_groups tg ON rm.route_id = tg.route_id
JOIN camper_groups cg ON tg.id = cg.group_id
GROUP BY m.name
HAVING (SUM(CASE WHEN (
        SELECT SUM(es.score * et.weight_percentage) / 100
        FROM evaluation_scores es
        JOIN evaluations e ON es.evaluation_id = e.id
        JOIN evaluation_types et ON e.evaluation_type_id = et.id
        WHERE e.module_id = m.id AND es.camper_id = cg.camper_id
        GROUP BY es.camper_id, e.module_id
    ) < 60 THEN 1 ELSE 0 END) * 100.0 / COUNT(cg.camper_id)) >= 30
ORDER BY fail_percentage DESC;

-- 11. Mostrar el módulo más cursado por campers con riesgo alto.
SELECT m.id, m.name
FROM modules m
JOIN module_competencias mc ON m.id = mc.module_id
JOIN evaluation_scores es ON mc.competencia_id = es.evaluation_id
JOIN campers c ON es.camper_id = c.id
WHERE c.risk_level_id = (SELECT id FROM risk_levels WHERE name = 'Alto')
GROUP BY m.id
ORDER BY COUNT(es.camper_id) DESC
LIMIT 1;

-- 12. Consultar los trainers con más de 3 rutas asignadas.
SELECT t.id, t.acronym, COUNT(DISTINCT tg.route_id) AS assigned_routes
FROM trainers t
JOIN module_trainers mt ON t.id = mt.trainer_id
JOIN training_groups tg ON mt.module_id = tg.id
GROUP BY t.id
HAVING assigned_routes > 3;

-- 13. Listar los horarios más ocupados por áreas.
SELECT tb.name AS time_block, COUNT(tg.id) AS num_groups
FROM time_blocks tb
JOIN trainer_schedules ts ON tb.id = ts.time_block_id
JOIN training_groups tg ON ts.trainer_id = tg.trainer_id
GROUP BY tb.name
ORDER BY num_groups DESC
LIMIT 1;

-- 14. Consultar las rutas con el mayor número de módulos.
SELECT tg.route_id, COUNT(rm.module_id) AS num_modules
FROM training_groups tg
JOIN route_modules rm ON tg.route_id = rm.route_id
GROUP BY tg.route_id
ORDER BY num_modules DESC
LIMIT 1;

-- 15. Obtener los campers que han cambiado de estado más de una vez.
SELECT sh.camper_id
FROM status_history sh
GROUP BY sh.camper_id
HAVING COUNT(sh.id) > 1;

-- 16. Mostrar las evaluaciones donde la nota teórica sea mayor a la práctica.
SELECT e.name, e.id
FROM evaluations e
JOIN evaluation_scores es_theory ON e.id = es_theory.evaluation_id
JOIN evaluation_scores es_practice ON e.id = es_practice.evaluation_id
WHERE es_theory.score > es_practice.score;

-- 17. Listar los módulos donde la media de quizzes supera el 9.
SELECT 
    m.name AS module_name,
    AVG(es.score) AS average_quiz_score
FROM evaluation_scores es
JOIN evaluations e ON es.evaluation_id = e.id
JOIN evaluation_types et ON e.evaluation_type_id = et.id
JOIN modules m ON e.module_id = m.id
WHERE et.name = 'Quizzes'
GROUP BY m.name
HAVING AVG(es.score) > 9
ORDER BY average_quiz_score DESC;

-- 18. Consultar la ruta con mayor tasa de graduación.
SELECT 
    r.name AS route_name,
    COUNT(DISTINCT g.camper_id) AS graduates_count,
    COUNT(DISTINCT cg.camper_id) AS total_campers,
    (COUNT(DISTINCT g.camper_id) * 100.0 / COUNT(DISTINCT cg.camper_id)) AS graduation_rate
FROM routes r
JOIN training_groups tg ON r.id = tg.route_id
JOIN camper_groups cg ON tg.id = cg.group_id
LEFT JOIN graduates g ON r.id = g.route_id AND cg.camper_id = g.camper_id
GROUP BY r.name
ORDER BY graduation_rate DESC
LIMIT 1;

-- 19. Mostrar los módulos cursados por campers de nivel de riesgo medio o alto.
SELECT DISTINCT
    m.name AS module_name,
    rl.name AS risk_level,
    COUNT(DISTINCT c.id) AS campers_count
FROM modules m
JOIN evaluations e ON m.id = e.module_id
JOIN evaluation_scores es ON e.id = es.evaluation_id
JOIN campers c ON es.camper_id = c.id
JOIN risk_levels rl ON c.risk_level_id = rl.id
WHERE rl.name IN ('Medio', 'Alto')
GROUP BY m.name, rl.name
ORDER BY campers_count DESC;

-- 20. Obtener la diferencia entre capacidad y ocupación en cada área.
SELECT 
    b.name AS branch_name,
    c.name AS classroom_name,
    c.capacity,
    COUNT(DISTINCT cg.camper_id) AS current_occupancy,
    (c.capacity - COUNT(DISTINCT cg.camper_id)) AS available_spaces,
    (COUNT(DISTINCT cg.camper_id) * 100.0 / c.capacity) AS occupancy_percentage
FROM classrooms c
JOIN branches b ON c.campus_id = b.id
LEFT JOIN training_groups tg ON c.id = tg.classroom_id
LEFT JOIN camper_groups cg ON tg.id = cg.group_id AND cg.status = 'Activo'
GROUP BY b.name, c.name, c.capacity
ORDER BY available_spaces DESC;

--JOINs Básicos (INNER JOIN, LEFT JOIN, etc.)
-- 1. Obtener los nombres completos de los campers junto con el nombre de la ruta a la que están inscritos.
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS camper_name,
    r.name AS route_name
FROM campers c
JOIN persons p ON c.person_id = p.id
JOIN camper_groups cg ON c.id = cg.camper_id
JOIN training_groups tg ON cg.group_id = tg.id
JOIN routes r ON tg.route_id = r.id
WHERE cg.status = 'Activo';

-- 2. Mostrar los campers con sus evaluaciones (nota teórica, práctica, quizzes y nota final) por cada módulo.
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS camper_name,
    m.name AS module_name,
    MAX(CASE WHEN et.name = 'Teórica' THEN es.score END) AS theory_score,
    MAX(CASE WHEN et.name = 'Práctica' THEN es.score END) AS practice_score,
    MAX(CASE WHEN et.name = 'Quizzes' THEN es.score END) AS quizzes_score,
    (SUM(es.score * et.weight_percentage) / 100) AS final_score
FROM evaluation_scores es
JOIN evaluations e ON es.evaluation_id = e.id
JOIN evaluation_types et ON e.evaluation_type_id = et.id
JOIN campers c ON es.camper_id = c.id
JOIN persons p ON c.person_id = p.id
JOIN modules m ON e.module_id = m.id
GROUP BY p.first_name, p.last_name, m.name;

-- 3. Listar todos los módulos que componen cada ruta de entrenamiento.
SELECT 
    r.name AS route_name,
    m.name AS module_name,
    rm.route_order
FROM routes r
JOIN route_modules rm ON r.id = rm.route_id
JOIN modules m ON rm.module_id = m.id
ORDER BY r.name, rm.route_order;

-- 4.  Consultar las rutas con sus trainers asignados y las áreas en las que imparten clases.
SELECT 
    r.name AS route_name,
    CONCAT(p.first_name, ' ', p.last_name) AS trainer_name,
    b.name AS branch_name,
    c.name AS classroom_name
FROM routes r
JOIN training_groups tg ON r.id = tg.route_id
JOIN trainers t ON tg.trainer_id = t.id
JOIN persons p ON t.person_id = p.id
JOIN classrooms c ON tg.classroom_id = c.id
JOIN branches b ON c.campus_id = b.id;

-- 5.  Mostrar los campers junto con el trainer responsable de su ruta actual
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS camper_name,
    CONCAT(pt.first_name, ' ', pt.last_name) AS trainer_name,
    r.name AS route_name
FROM campers c
JOIN persons p ON c.person_id = p.id
JOIN camper_groups cg ON c.id = cg.camper_id
JOIN training_groups tg ON cg.group_id = tg.id
JOIN routes r ON tg.route_id = r.id
JOIN trainers t ON tg.trainer_id = t.id
JOIN persons pt ON t.person_id = pt.id
WHERE cg.status = 'Activo';

-- 6. Obtener el listado de evaluaciones realizadas con nombre de camper, módulo y ruta.
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS camper_name,
    m.name AS module_name,
    r.name AS route_name,
    et.name AS evaluation_type,
    es.score
FROM evaluation_scores es
JOIN evaluations e ON es.evaluation_id = e.id
JOIN evaluation_types et ON e.evaluation_type_id = et.id
JOIN campers c ON es.camper_id = c.id
JOIN persons p ON c.person_id = p.id
JOIN modules m ON e.module_id = m.id
JOIN route_modules rm ON m.id = rm.module_id
JOIN routes r ON rm.route_id = r.id;

-- 7. Listar los trainers y los horarios en que están asignados a las áreas de entrenamiento.
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS trainer_name,
    tb.name AS time_block,
    tb.start_time,
    tb.end_time,
    CASE ts.day_of_week
        WHEN 1 THEN 'Domingo' WHEN 2 THEN 'Lunes' WHEN 3 THEN 'Martes'
        WHEN 4 THEN 'Miércoles' WHEN 5 THEN 'Jueves' WHEN 6 THEN 'Viernes'
        WHEN 7 THEN 'Sábado'
    END AS day_name
FROM trainers t
JOIN persons p ON t.person_id = p.id
JOIN trainer_schedules ts ON t.id = ts.trainer_id
JOIN time_blocks tb ON ts.time_block_id = tb.id
WHERE ts.is_available = FALSE;

-- 8.  Consultar todos los campers junto con su estado actual y el nivel de riesgo
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS camper_name,
    cs.name AS status,
    rl.name AS risk_level
FROM campers c
JOIN persons p ON c.person_id = p.id
JOIN camper_statuses cs ON c.status_id = cs.id
JOIN risk_levels rl ON c.risk_level_id = rl.id;

-- 9. Obtener todos los módulos de cada ruta junto con su porcentaje teórico, práctico y de quizzes.
SELECT 
    m.name AS module_name,
    MAX(CASE WHEN et.name = 'Teórica' THEN et.weight_percentage END) AS theory_percentage,
    MAX(CASE WHEN et.name = 'Práctica' THEN et.weight_percentage END) AS practice_percentage,
    MAX(CASE WHEN et.name = 'Quizzes' THEN et.weight_percentage END) AS quizzes_percentage
FROM modules m
JOIN evaluations e ON m.id = e.module_id
JOIN evaluation_types et ON e.evaluation_type_id = et.id
GROUP BY m.name;

-- 10.  Mostrar los nombres de las áreas junto con los nombres de los campers que están asistiendo en esos espacios.
SELECT 
    c.name AS classroom_name,
    CONCAT(p.first_name, ' ', p.last_name) AS camper_name
FROM classrooms c
JOIN training_groups tg ON c.id = tg.classroom_id
JOIN camper_groups cg ON tg.id = cg.group_id
JOIN campers cam ON cg.camper_id = cam.id
JOIN persons p ON cam.person_id = p.id
WHERE cg.status = 'Activo';

--JOINs con condiciones específicas
-- 1. Listar los campers que han aprobado todos los módulos de su ruta (nota_final >= 60).
WITH CamperModuleResults AS (
    SELECT 
        c.id AS camper_id,
        r.id AS route_id,
        m.id AS module_id,
        (SUM(es.score * et.weight_percentage) / 100) AS final_score
    FROM campers c
    JOIN camper_groups cg ON c.id = cg.camper_id
    JOIN training_groups tg ON cg.group_id = tg.id
    JOIN routes r ON tg.route_id = r.id
    JOIN route_modules rm ON r.id = rm.route_id
    JOIN modules m ON rm.module_id = m.id
    LEFT JOIN evaluations e ON m.id = e.module_id
    LEFT JOIN evaluation_scores es ON e.id = es.evaluation_id AND es.camper_id = c.id
    LEFT JOIN evaluation_types et ON e.evaluation_type_id = et.id
    GROUP BY c.id, r.id, m.id
)
SELECT DISTINCT
    CONCAT(p.first_name, ' ', p.last_name) AS camper_name,
    r.name AS route_name
FROM CamperModuleResults cmr
JOIN campers c ON cmr.camper_id = c.id
JOIN persons p ON c.person_id = p.id
JOIN routes r ON cmr.route_id = r.id
GROUP BY camper_name, route_name, cmr.camper_id, cmr.route_id
HAVING MIN(cmr.final_score) >= 60;

-- 2. Mostrar las rutas que tienen más de 10 campers inscritos actualmente.
SELECT 
    r.name AS route_name,
    COUNT(cg.camper_id) AS camper_count
FROM routes r
JOIN training_groups tg ON r.id = tg.route_id
JOIN camper_groups cg ON tg.id = cg.group_id
WHERE cg.status = 'Activo'
GROUP BY r.name
HAVING COUNT(cg.camper_id) > 10;

-- 3. Consultar las áreas que superan el 80% de su capacidad con el número actual de campers asignados.
SELECT 
    c.name AS classroom_name,
    c.capacity,
    COUNT(cg.camper_id) AS current_occupancy,
    (COUNT(cg.camper_id) * 100.0 / c.capacity) AS occupancy_percentage
FROM classrooms c
JOIN training_groups tg ON c.id = tg.classroom_id
JOIN camper_groups cg ON tg.id = cg.group_id
WHERE cg.status = 'Activo'
GROUP BY c.name, c.capacity
HAVING (COUNT(cg.camper_id) * 100.0 / c.capacity) > 80;

-- 4. Obtener los trainers que imparten más de una ruta diferente.
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS trainer_name,
    COUNT(DISTINCT tg.route_id) AS route_count
FROM trainers t
JOIN persons p ON t.person_id = p.id
JOIN training_groups tg ON t.id = tg.trainer_id
GROUP BY trainer_name
HAVING COUNT(DISTINCT tg.route_id) > 1;

-- 5. Listar las evaluaciones donde la nota práctica es mayor que la nota teórica
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS camper_name,
    m.name AS module_name,
    MAX(CASE WHEN et.name = 'Teórica' THEN es.score END) AS theory_score,
    MAX(CASE WHEN et.name = 'Práctica' THEN es.score END) AS practice_score
FROM evaluation_scores es
JOIN evaluations e ON es.evaluation_id = e.id
JOIN evaluation_types et ON e.evaluation_type_id = et.id
JOIN campers c ON es.camper_id = c.id
JOIN persons p ON c.person_id = p.id
JOIN modules m ON e.module_id = m.id
GROUP BY camper_name, module_name
HAVING MAX(CASE WHEN et.name = 'Práctica' THEN es.score END) > 
       MAX(CASE WHEN et.name = 'Teórica' THEN es.score END);

-- 6. Mostrar campers que están en rutas cuyo SGDB principal es MySQL.
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS camper_name,
    r.name AS route_name,
    s.name AS primary_db
FROM campers c
JOIN persons p ON c.person_id = p.id
JOIN camper_groups cg ON c.id = cg.camper_id
JOIN training_groups tg ON cg.group_id = tg.id
JOIN routes r ON tg.route_id = r.id
JOIN route_sgdb rs ON r.id = rs.route_id AND rs.is_primary = TRUE
JOIN sgdb s ON rs.database_id = s.id
WHERE s.name = 'MySQL' AND cg.status = 'Activo';

-- 7. Obtener los nombres de los módulos donde los campers han tenido bajo rendimiento
SELECT 
    m.name AS module_name,
    AVG(es.score) AS average_score
FROM evaluation_scores es
JOIN evaluations e ON es.evaluation_id = e.id
JOIN modules m ON e.module_id = m.id
GROUP BY m.name
HAVING AVG(es.score) < 60;

-- 8. Consultar las rutas con más de 3 módulos asociados.
SELECT 
    r.name AS route_name,
    COUNT(rm.module_id) AS module_count
FROM routes r
JOIN route_modules rm ON r.id = rm.route_id
GROUP BY r.name
HAVING COUNT(rm.module_id) > 3;

-- 9. Listar las inscripciones realizadas en los últimos 30 días con sus respectivos campers y rutas
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS camper_name,
    r.name AS route_name,
    cg.entry_date
FROM camper_groups cg
JOIN campers c ON cg.camper_id = c.id
JOIN persons p ON c.person_id = p.id
JOIN training_groups tg ON cg.group_id = tg.id
JOIN routes r ON tg.route_id = r.id
WHERE cg.entry_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- 10. Obtener los trainers que están asignados a rutas con campers en estado de “Alto Riesgo”.
SELECT DISTINCT
    CONCAT(p.first_name, ' ', p.last_name) AS trainer_name,
    r.name AS route_name
FROM trainers t
JOIN persons p ON t.person_id = p.id
JOIN training_groups tg ON t.id = tg.trainer_id
JOIN routes r ON tg.route_id = r.id
JOIN camper_groups cg ON tg.id = cg.group_id
JOIN campers c ON cg.camper_id = c.id
JOIN risk_levels rl ON c.risk_level_id = rl.id
WHERE rl.name = 'Alto' AND cg.status = 'Activo';

--JOINs con funciones de agregación
-- 1. Obtener el promedio de nota final por módulo.
SELECT 
    m.name AS module_name,
    AVG(es.score) AS average_score
FROM evaluation_scores es
JOIN evaluations e ON es.evaluation_id = e.id
JOIN modules m ON e.module_id = m.id
GROUP BY m.name;

-- 2. Calcular la cantidad total de campers por ruta.
SELECT 
    r.name AS route_name,
    COUNT(DISTINCT cg.camper_id) AS camper_count
FROM routes r
JOIN training_groups tg ON r.id = tg.route_id
JOIN camper_groups cg ON tg.id = cg.group_id
WHERE cg.status = 'Activo'
GROUP BY r.name;

-- 3. Mostrar la cantidad de evaluaciones realizadas por cada trainer (según las rutas que imparte).
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS trainer_name,
    COUNT(e.id) AS evaluation_count
FROM trainers t
JOIN persons p ON t.person_id = p.id
JOIN training_groups tg ON t.id = tg.trainer_id
JOIN routes r ON tg.route_id = r.id
JOIN route_modules rm ON r.id = rm.route_id
JOIN modules m ON rm.module_id = m.id
JOIN evaluations e ON m.id = e.module_id
GROUP BY trainer_name;

-- 4. Consultar el promedio general de rendimiento por cada área de entrenamiento.
SELECT 
    c.name AS classroom_name,
    AVG(es.score) AS average_performance
FROM classrooms c
JOIN training_groups tg ON c.id = tg.classroom_id
JOIN camper_groups cg ON tg.id = cg.group_id
JOIN evaluation_scores es ON cg.camper_id = es.camper_id
WHERE cg.status = 'Activo'
GROUP BY c.name;

-- 5. Obtener la cantidad de módulos asociados a cada ruta de entrenamiento.
SELECT 
    r.name AS route_name,
    COUNT(rm.module_id) AS module_count
FROM routes r
JOIN route_modules rm ON r.id = rm.route_id
GROUP BY r.name;

-- 6. Mostrar el promedio de nota final de los campers en estado “Cursando”.
SELECT 
    AVG(es.score) AS average_score
FROM evaluation_scores es
JOIN campers c ON es.camper_id = c.id
JOIN camper_statuses cs ON c.status_id = cs.id
WHERE cs.name = 'Cursando';

-- 7. Listar el número de campers evaluados en cada módulo.
SELECT 
    m.name AS module_name,
    COUNT(DISTINCT es.camper_id) AS camper_count
FROM evaluation_scores es
JOIN evaluations e ON es.evaluation_id = e.id
JOIN modules m ON e.module_id = m.id
GROUP BY m.name;

-- 8. Consultar el porcentaje de ocupación actual por cada área de entrenamiento.
SELECT 
    c.name AS classroom_name,
    c.capacity,
    COUNT(cg.camper_id) AS current_occupancy,
    (COUNT(cg.camper_id) * 100.0 / c.capacity) AS occupancy_percentage
FROM classrooms c
LEFT JOIN training_groups tg ON c.id = tg.classroom_id
LEFT JOIN camper_groups cg ON tg.id = cg.group_id AND cg.status = 'Activo'
GROUP BY c.name, c.capacity;

-- 9. Mostrar cuántos trainers tiene asignados cada área.
SELECT 
    c.name AS classroom_name,
    COUNT(DISTINCT tg.trainer_id) AS trainer_count
FROM classrooms c
JOIN training_groups tg ON c.id = tg.classroom_id
GROUP BY c.name;

-- 10. Listar las rutas que tienen más campers en riesgo alto.
SELECT 
    r.name AS route_name,
    COUNT(DISTINCT c.id) AS high_risk_campers
FROM routes r
JOIN training_groups tg ON r.id = tg.route_id
JOIN camper_groups cg ON tg.id = cg.group_id
JOIN campers c ON cg.camper_id = c.id
JOIN risk_levels rl ON c.risk_level_id = rl.id
WHERE rl.name = 'Alto' AND cg.status = 'Activo'
GROUP BY r.name
ORDER BY high_risk_campers DESC;
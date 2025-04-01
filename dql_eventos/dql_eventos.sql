-- Eventos
-- JOINs Básicos (INNER JOIN, LEFT JOIN, etc.)

-- 1. Obtener los nombres completos de los campers junto con el nombre de la ruta a la que están inscritos.
SELECT CONCAT(p.first_name, ' ', p.last_name) AS camper_name,
    r.name AS route_name
FROM campers c
JOIN persons p ON c.person_id = p.id
JOIN camper_groups cg ON c.id = cg.camper_id
JOIN training_groups tg ON cg.group_id = tg.id
JOIN routes r ON tg.route_id = r.id;

-- 2. Mostrar los campers con sus evaluaciones (nota teórica, práctica, quizzes y nota final) por cada módulo.
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS camper_name,
    m.name AS module_name,
    me.theory_score,
    me.practice_score,
    me.quizzes_score,
    me.final_score
FROM module_evaluations me
JOIN campers c ON me.camper_id = c.id
JOIN persons p ON c.person_id = p.id
JOIN modules m ON me.module_id = m.id;

-- 3. Listar todos los módulos que componen cada ruta de entrenamiento.
SELECT r.name AS route_name,m.name AS module_name, rm.route_order
FROM routes r
JOIN route_modules rm ON r.id = rm.route_id
JOIN modules m ON rm.module_id = m.id
ORDER BY r.name, rm.route_order;

-- 4. Consultar las rutas con sus trainers asignados y las áreas en las que imparten clases.
SELECT 
    r.name AS route_name,
    CONCAT(p.first_name, ' ', p.last_name) AS trainer_name,
    b.name AS branch_name,
    cl.name AS classroom_name
FROM training_groups tg
JOIN routes r ON tg.route_id = r.id
JOIN trainers t ON tg.trainer_id = t.id
JOIN persons p ON t.person_id = p.id
JOIN classrooms cl ON tg.classroom_id = cl.id
JOIN branches b ON cl.campus_id = b.id;

-- 5. Mostrar los campers junto con el trainer responsable de su ruta actual.
SELECT 
    CONCAT(p_camper.first_name, ' ', p_camper.last_name) AS camper_name,
    CONCAT(p_trainer.first_name, ' ', p_trainer.last_name) AS trainer_name,
    r.name AS route_name
FROM camper_groups cg
JOIN campers c ON cg.camper_id = c.id
JOIN persons p_camper ON c.person_id = p_camper.id
JOIN training_groups tg ON cg.group_id = tg.id
JOIN routes r ON tg.route_id = r.id
JOIN trainers t ON tg.trainer_id = t.id
JOIN persons p_trainer ON t.person_id = p_trainer.id;

-- 6. Obtener el listado de evaluaciones realizadas con nombre de camper, módulo y ruta.
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS camper_name,
    m.name AS module_name,
    r.name AS route_name,
    me.final_score
FROM module_evaluations me
JOIN campers c ON me.camper_id = c.id
JOIN persons p ON c.person_id = p.id
JOIN modules m ON me.module_id = m.id
JOIN training_groups tg ON me.group_id = tg.id
JOIN routes r ON tg.route_id = r.id;

-- 7. Listar los trainers y los horarios en que están asignados a las áreas de entrenamiento.
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS trainer_name,
    b.name AS branch_name,
    cl.name AS classroom_name,
    tb.name AS time_block,
    tb.start_time,
    tb.end_time
FROM trainer_schedules ts
JOIN trainers t ON ts.trainer_id = t.id
JOIN persons p ON t.person_id = p.id
JOIN time_blocks tb ON ts.time_block_id = tb.id
JOIN training_groups tg ON t.id = tg.trainer_id
JOIN classrooms cl ON tg.classroom_id = cl.id
JOIN branches b ON cl.campus_id = b.id;

-- 8. Consultar todos los campers junto con su estado actual y el nivel de riesgo.
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
    r.name AS route_name,
    m.name AS module_name,
    m.theory_percentage,
    m.practice_percentage,
    m.quizzes_percentage
FROM route_modules rm
JOIN routes r ON rm.route_id = r.id
JOIN modules m ON rm.module_id = m.id
ORDER BY r.name, rm.route_order;

-- 10. Mostrar los nombres de las áreas junto con los nombres de los campers que están asistiendo en esos espacios.
SELECT 
    b.name AS branch_name,
    cl.name AS classroom_name,
    CONCAT(p.first_name, ' ', p.last_name) AS camper_name
FROM camper_groups cg
JOIN campers c ON cg.camper_id = c.id
JOIN persons p ON c.person_id = p.id
JOIN training_groups tg ON cg.group_id = tg.id
JOIN classrooms cl ON tg.classroom_id = cl.id
JOIN branches b ON cl.campus_id = b.id;


-- JOINs con condiciones específicas

-- 1. Listar los campers que han aprobado todos los módulos de su ruta (nota_final >= 60).
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS camper_name,
    r.name AS route_name
FROM campers c
JOIN persons p ON c.person_id = p.id
JOIN camper_groups cg ON c.id = cg.camper_id
JOIN training_groups tg ON cg.group_id = tg.id
JOIN routes r ON tg.route_id = r.id
WHERE 
    NOT EXISTS (
        SELECT 1 
        FROM module_evaluations me 
        WHERE me.camper_id = c.id 
        AND me.group_id = tg.id 
        AND me.final_score < 60
    );

-- 2. Mostrar las rutas que tienen más de 10 campers inscritos actualmente.
SELECT 
    r.name AS route_name,
    COUNT(cg.camper_id) AS campers_count
FROM routes r
JOIN training_groups tg ON r.id = tg.route_id
JOIN camper_groups cg ON tg.id = cg.group_id
GROUP BY r.name
HAVING COUNT(cg.camper_id) > 10;

-- 3. Consultar las áreas que superan el 80% de su capacidad con el número actual de campers asignados.
SELECT 
    cl.name AS classroom_name,
    cl.capacity,
    COUNT(cg.camper_id) AS current_campers,
    (COUNT(cg.camper_id) / cl.capacity * 100) AS occupancy_percentage
FROM classrooms cl
JOIN training_groups tg ON cl.id = tg.classroom_id
JOIN camper_groups cg ON tg.id = cg.group_id
GROUP BY cl.id, cl.name, cl.capacity
HAVING (COUNT(cg.camper_id) / cl.capacity * 100) > 80;

-- 4. Obtener los trainers que imparten más de una ruta diferente.
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS trainer_name,
    COUNT(DISTINCT tg.route_id) AS routes_count
FROM trainers t
JOIN persons p ON t.person_id = p.id
JOIN training_groups tg ON t.id = tg.trainer_id
GROUP BY t.id, p.first_name, p.last_name
HAVING COUNT(DISTINCT tg.route_id) > 1;

-- 5. Listar las evaluaciones donde la nota práctica es mayor que la nota teórica.
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS camper_name,
    m.name AS module_name,
    me.theory_score,
    me.practice_score
FROM module_evaluations me
JOIN campers c ON me.camper_id = c.id
JOIN persons p ON c.person_id = p.id
JOIN modules m ON me.module_id = m.id
WHERE me.practice_score > me.theory_score;

-- 6. Mostrar campers que están en rutas cuyo SGDB principal es MySQL.
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS camper_name,
    r.name AS route_name,
    s.name AS sgdb_name
FROM campers c
JOIN persons p ON c.person_id = p.id
JOIN camper_groups cg ON c.id = cg.camper_id
JOIN training_groups tg ON cg.group_id = tg.id
JOIN routes r ON tg.route_id = r.id
JOIN route_sgdb rs ON r.id = rs.route_id
JOIN sgdb s ON rs.database_id = s.id
WHERE 
    s.name = 'MySQL' AND rs.is_primary = TRUE;

-- 7. Obtener los nombres de los módulos donde los campers han tenido bajo rendimiento.
SELECT 
    m.name AS module_name,
    AVG(me.final_score) AS average_score
FROM 
    module_evaluations me
JOIN 
    modules m ON me.module_id = m.id
GROUP BY 
    m.name
HAVING 
    AVG(me.final_score) < 60;

-- 8. Consultar las rutas con más de 3 módulos asociados.
SELECT 
    r.name AS route_name,
    COUNT(rm.module_id) AS modules_count
FROM 
    routes r
JOIN 
    route_modules rm ON r.id = rm.route_id
GROUP BY 
    r.name
HAVING 
    COUNT(rm.module_id) > 3;

-- 9. Listar las inscripciones realizadas en los últimos 30 días con sus respectivos campers y rutas.
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS camper_name,
    r.name AS route_name,
    cg.entry_date
FROM 
    camper_groups cg
JOIN 
    campers c ON cg.camper_id = c.id
JOIN 
    persons p ON c.person_id = p.id
JOIN 
    training_groups tg ON cg.group_id = tg.id
JOIN 
    routes r ON tg.route_id = r.id
WHERE 
    cg.entry_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- 10. Obtener los trainers que están asignados a rutas con campers en estado de "Alto Riesgo".
SELECT DISTINCT
    CONCAT(p.first_name, ' ', p.last_name) AS trainer_name,
    r.name AS route_name
FROM 
    trainers t
JOIN 
    persons p ON t.person_id = p.id
JOIN 
    training_groups tg ON t.id = tg.trainer_id
JOIN 
    routes r ON tg.route_id = r.id
JOIN 
    camper_groups cg ON tg.id = cg.group_id
JOIN 
    campers c ON cg.camper_id = c.id
JOIN 
    risk_levels rl ON c.risk_level_id = rl.id
WHERE 
    rl.name = 'Alto';


-- JOINs con funciones de agregación

-- 1. Obtener el promedio de nota final por módulo.
SELECT 
    m.name AS module_name,
    AVG(me.final_score) AS average_final_score
FROM 
    module_evaluations me
JOIN 
    modules m ON me.module_id = m.id
GROUP BY 
    m.name;

-- 2. Calcular la cantidad total de campers por ruta.
SELECT 
    r.name AS route_name,
    COUNT(cg.camper_id) AS campers_count
FROM 
    routes r
JOIN 
    training_groups tg ON r.id = tg.route_id
JOIN 
    camper_groups cg ON tg.id = cg.group_id
GROUP BY 
    r.name;

-- 3. Mostrar la cantidad de evaluaciones realizadas por cada trainer (según las rutas que imparte).
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS trainer_name,
    COUNT(me.id) AS evaluations_count
FROM 
    trainers t
JOIN 
    persons p ON t.person_id = p.id
JOIN 
    training_groups tg ON t.id = tg.trainer_id
JOIN 
    camper_groups cg ON tg.id = cg.group_id
JOIN 
    module_evaluations me ON cg.camper_id = me.camper_id AND tg.id = me.group_id
GROUP BY 
    t.id, p.first_name, p.last_name;

-- 4. Consultar el promedio general de rendimiento por cada área de entrenamiento.
SELECT 
    b.name AS branch_name,
    cl.name AS classroom_name,
    AVG(me.final_score) AS average_score
FROM 
    module_evaluations me
JOIN 
    training_groups tg ON me.group_id = tg.id
JOIN 
    classrooms cl ON tg.classroom_id = cl.id
JOIN 
    branches b ON cl.campus_id = b.id
GROUP BY 
    b.name, cl.name;

-- 5. Obtener la cantidad de módulos asociados a cada ruta de entrenamiento.
SELECT 
    r.name AS route_name,
    COUNT(rm.module_id) AS modules_count
FROM 
    routes r
JOIN 
    route_modules rm ON r.id = rm.route_id
GROUP BY 
    r.name;

-- 6. Mostrar el promedio de nota final de los campers en estado "Cursando".
SELECT 
    cs.name AS status,
    AVG(me.final_score) AS average_score
FROM 
    module_evaluations me
JOIN 
    campers c ON me.camper_id = c.id
JOIN 
    camper_statuses cs ON c.status_id = cs.id
WHERE 
    cs.name = 'Cursando'
GROUP BY 
    cs.name;

-- 7. Listar el número de campers evaluados en cada módulo.
SELECT 
    m.name AS module_name,
    COUNT(DISTINCT me.camper_id) AS campers_evaluated
FROM 
    module_evaluations me
JOIN 
    modules m ON me.module_id = m.id
GROUP BY 
    m.name;

-- 8. Consultar el porcentaje de ocupación actual por cada área de entrenamiento.
SELECT 
    cl.name AS classroom_name,
    cl.capacity,
    COUNT(cg.camper_id) AS current_campers,
    (COUNT(cg.camper_id) / cl.capacity * 100) AS occupancy_percentage
FROM 
    classrooms cl
JOIN 
    training_groups tg ON cl.id = tg.classroom_id
JOIN 
    camper_groups cg ON tg.id = cg.group_id
GROUP BY 
    cl.id, cl.name, cl.capacity;

-- 9. Mostrar cuántos trainers tiene asignados cada área.
SELECT 
    b.name AS branch_name,
    COUNT(DISTINCT t.id) AS trainers_count
FROM 
    trainers t
JOIN 
    branches b ON t.campus_id = b.id
GROUP BY 
    b.name;

-- 10. Listar las rutas que tienen más campers en riesgo alto.
SELECT 
    r.name AS route_name,
    COUNT(c.id) AS high_risk_campers
FROM 
    routes r
JOIN 
    training_groups tg ON r.id = tg.route_id
JOIN 
    camper_groups cg ON tg.id = cg.group_id
JOIN 
    campers c ON cg.camper_id = c.id
JOIN 
    risk_levels rl ON c.risk_level_id = rl.id
WHERE 
    rl.name = 'Alto'
GROUP BY 
    r.name
ORDER BY 
    COUNT(c.id) DESC;
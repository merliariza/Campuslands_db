-- Procedimientos almacenados
-- 1. Registrar un nuevo camper con toda su información personal y estado inicial.
DELIMITER //
CREATE PROCEDURE register_camper(
    IN p_document_type_id INT,
    IN p_document_number VARCHAR(20),
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_email VARCHAR(80),
    IN p_address_id INT,
    IN p_status_id INT,
    IN p_risk_level_id INT)
BEGIN
    DECLARE v_person_id INT;
    INSERT INTO persons (document_type_id, document_number, first_name, last_name, email, address_id)
    VALUES (p_document_type_id, p_document_number, p_first_name, p_last_name, p_email, p_address_id);
    SET v_person_id = LAST_INSERT_ID();
    INSERT INTO campers (person_id, status_id, risk_level_id, entry_date)
    VALUES (v_person_id, p_status_id, p_risk_level_id, CURDATE());
END //
DELIMITER ;

CALL register_camper(1, '123456789', 'Juan', 'Perez', 'juan@example.com', 1, 1, 1);
SELECT id, first_name, last_name FROM persons WHERE document_number = '123456789';
SELECT id, person_id, status_id FROM campers WHERE person_id = LAST_INSERT_ID();

-- 2. Actualizar el estado de un camper luego de completar el proceso de ingreso.
DELIMITER //
CREATE PROCEDURE sp_update_camper_status(
    IN p_camper_id INT,
    IN p_new_status_id INT
)
BEGIN
    DECLARE v_current_status_id INT;
    SELECT status_id INTO v_current_status_id FROM campers WHERE id = p_camper_id;
    UPDATE campers SET status_id = p_new_status_id WHERE id = p_camper_id;
    INSERT INTO status_history (camper_id, previous_status_id, new_status_id, change_date)
    VALUES (p_camper_id, v_current_status_id, p_new_status_id, NOW());
END //
DELIMITER ;

-- 3. Procesar la inscripción de un camper a una ruta específica.
DELIMITER //
CREATE PROCEDURE sp_enroll_camper_to_route(
    IN p_camper_id INT,
    IN p_route_id INT,
    IN p_group_id INT
)
BEGIN
    DECLARE v_current_status INT;
    DECLARE v_group_capacity INT;
    DECLARE v_current_count INT;

    SELECT status_id INTO v_current_status FROM campers WHERE id = p_camper_id;
    
    SELECT c.capacity INTO v_group_capacity 
    FROM training_groups tg
    JOIN classrooms c ON tg.classroom_id = c.id
    WHERE tg.id = p_group_id;
    
    SELECT COUNT(camper_id) INTO v_current_count 
    FROM camper_groups 
    WHERE group_id = p_group_id AND status = 'Activo';
    
    IF v_current_status NOT IN (2, 3) THEN 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El camper no está en estado válido para inscripción';
    ELSEIF v_current_count >= v_group_capacity THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El grupo ha alcanzado su capacidad máxima';
    ELSE
        INSERT INTO camper_groups (camper_id, group_id, entry_date, status)

        VALUES (p_camper_id, p_group_id, CURDATE(), 'Activo');
        IF v_current_status = 3 THEN 
            CALL sp_update_camper_status(p_camper_id, 4); 
        END IF;
    END IF;
END //
DELIMITER ;

-- 4. Registrar una evaluación completa (teórica, práctica y quizzes) para un camper.
DELIMITER //
CREATE PROCEDURE sp_record_evaluation(
    IN p_module_id INT,
    IN p_group_id INT,
    IN p_camper_id INT,
    IN p_evaluation_type_id INT,
    IN p_score DECIMAL(4,1))
BEGIN
    DECLARE v_evaluation_id INT;
    
    INSERT INTO evaluations (module_id, group_id, evaluation_type_id, name)
    VALUES (p_module_id, p_group_id, p_evaluation_type_id, 'Evaluation');
    
    SET v_evaluation_id = LAST_INSERT_ID();
    
    INSERT IGNORE INTO skills (id, name) VALUES (1, 'Default Skill');
    
    INSERT INTO evaluation_scores (evaluation_id, camper_id, score)
    VALUES (v_evaluation_id, p_camper_id, p_score);
END //
DELIMITER ;

CALL sp_record_evaluation(1, 1, 1, 1, 85.5);
SELECT e.id, es.score 
FROM evaluations e
JOIN evaluation_scores es ON e.id = es.evaluation_id
WHERE e.module_id = 1 AND e.group_id = 1 AND es.camper_id = 1;

-- 5. Calcular y registrar automáticamente la nota final de un módulo.
DELIMITER //
CREATE PROCEDURE sp_calculate_final_grade(
    IN p_camper_id INT,
    IN p_module_id INT,
    IN p_group_id INT)
BEGIN
    DECLARE v_final_grade DECIMAL(4,1);
    
    SELECT AVG(es.score) INTO v_final_grade
    FROM evaluation_scores es
    JOIN evaluations e ON es.evaluation_id = e.id
    WHERE e.module_id = p_module_id 
    AND e.group_id = p_group_id
    AND es.camper_id = p_camper_id;
    
    UPDATE camper_groups 
    SET final_grade = v_final_grade
    WHERE camper_id = p_camper_id AND group_id = p_group_id;
END //
DELIMITER ;

ALTER TABLE camper_groups ADD COLUMN final_grade DECIMAL(4,1) DEFAULT NULL;

CALL sp_calculate_final_grade(1, 1, 1);
SELECT camper_id, final_grade FROM camper_groups WHERE camper_id = 1 AND group_id = 1;

-- 6. Asignar campers aprobados a una ruta de acuerdo con la disponibilidad del área.
DELIMITER //
CREATE PROCEDURE sp_assign_approved_campers_to_route(
    IN p_route_id INT,
    IN p_area_id INT)
BEGIN
    DECLARE v_area_capacity INT;
    DECLARE v_current_count INT;

    SELECT capacity INTO v_area_capacity 
    FROM training_areas 
    WHERE id = p_area_id;

    SELECT COUNT(camper_id) INTO v_current_count 
    FROM camper_routes 
    WHERE route_id = p_route_id AND area_id = p_area_id;

    IF v_current_count < v_area_capacity THEN
        INSERT INTO camper_routes (camper_id, route_id, area_id, assigned_date)
        SELECT c.id, p_route_id, p_area_id, CURDATE()
        FROM campers c
        JOIN camper_groups cg ON c.id = cg.camper_id
        WHERE cg.final_grade >= 70 AND c.id NOT IN (
            SELECT camper_id FROM camper_routes WHERE route_id = p_route_id
        );
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La capacidad del área ha sido excedida';
    END IF;
END //
DELIMITER ;

CALL sp_assign_approved_campers_to_route(1, 1);
SELECT camper_id, route_id, area_id FROM camper_routes WHERE route_id = 1 AND area_id = 1;

-- 7. Asignar un trainer a una ruta y área específica, validando el horario.
DELIMITER //
CREATE PROCEDURE sp_assign_trainer_to_route(
    IN p_trainer_id INT,
    IN p_route_id INT,
    IN p_area_id INT)
BEGIN
    DECLARE v_schedule_conflict INT;

    SELECT COUNT(ta.id) INTO v_schedule_conflict
    FROM trainer_areas ta
    WHERE ta.trainer_id = p_trainer_id
    AND ta.area_id = p_area_id
    AND ta.route_id = p_route_id;

    IF v_schedule_conflict > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El trainer ya tiene asignado un horario en esta ruta y área';
    ELSE
        INSERT INTO trainer_areas (trainer_id, route_id, area_id, assigned_date)
        VALUES (p_trainer_id, p_route_id, p_area_id, CURDATE());
    END IF;
END //
DELIMITER ;

CALL sp_assign_trainer_to_route(1, 1, 1);
SELECT trainer_id, route_id, area_id FROM trainer_areas WHERE route_id = 1 AND area_id = 1;

-- 8. Registrar una nueva ruta con sus módulos y SGDB asociados.
DELIMITER //
CREATE PROCEDURE sp_register_route_with_modules(
    IN p_route_name VARCHAR(100),
    IN p_sgdb_id INT,
    IN p_modules JSON)
BEGIN
    DECLARE v_route_id INT;

    INSERT INTO routes (name, sgdb_id, created_at)
    VALUES (p_route_name, p_sgdb_id, NOW());

    SET v_route_id = LAST_INSERT_ID();

    INSERT INTO route_modules (route_id, module_id)
    SELECT v_route_id, JSON_UNQUOTE(JSON_EXTRACT(p_modules, CONCAT('$[', idx.i, ']')))
    FROM (SELECT 0 AS i UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4) idx
    WHERE JSON_UNQUOTE(JSON_EXTRACT(p_modules, CONCAT('$[', idx.i, ']'))) IS NOT NULL;
END //
DELIMITER ;

CALL sp_register_route_with_modules('Data Science', 1, JSON_ARRAY(1, 2, 3));
SELECT id, name FROM routes WHERE name = 'Data Science';

-- 9. Registrar una nueva área de entrenamiento con su capacidad y horarios.
DELIMITER //
CREATE PROCEDURE sp_register_training_area(
    IN p_area_name VARCHAR(100),
    IN p_capacity INT,
    IN p_schedule VARCHAR(50))
BEGIN
    INSERT INTO training_areas (name, capacity, schedule, created_at)
    VALUES (p_area_name, p_capacity, p_schedule, NOW());
END //
DELIMITER ;

CALL sp_register_training_area('Machine Learning', 30, '08:00-12:00');
SELECT id, name, capacity, schedule FROM training_areas WHERE name = 'Machine Learning';

-- 10. Consultar disponibilidad de horario en un área determinada.
DELIMITER //
CREATE PROCEDURE sp_check_area_schedule(
    IN p_area_id INT)
BEGIN
    SELECT name, schedule, capacity - COUNT(route_id) AS available_slots
    FROM training_areas ta
    LEFT JOIN training_groups tg ON ta.id = tg.area_id
    WHERE ta.id = p_area_id
    GROUP BY ta.id, ta.name, ta.schedule, ta.capacity;
END //
DELIMITER ;

CALL sp_check_area_schedule(1);
SELECT name, schedule, available_slots FROM training_areas WHERE id = 1;

-- 11. Reasignar a un camper a otra ruta en caso de bajo rendimiento.
DELIMITER //
CREATE PROCEDURE sp_reassign_camper(
    IN p_camper_id INT,
    IN p_new_route_id INT)
BEGIN
    DECLARE v_current_route_id INT;

    SELECT route_id INTO v_current_route_id
    FROM camper_routes
    WHERE camper_id = p_camper_id;

    IF v_current_route_id IS NOT NULL THEN
        UPDATE camper_routes
        SET route_id = p_new_route_id, reassigned_date = CURDATE()
        WHERE camper_id = p_camper_id;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El camper no está asignado a ninguna ruta';
    END IF;
END //
DELIMITER ;

CALL sp_reassign_camper(1, 2);
SELECT camper_id, route_id FROM camper_routes WHERE camper_id = 1;

-- 12. Cambiar el estado de un camper a “Graduado” al finalizar todos los módulos.
DELIMITER //
CREATE PROCEDURE sp_graduate_camper(
    IN p_camper_id INT)
BEGIN
    DECLARE v_completed_modules INT;
    DECLARE v_total_modules INT;

    SELECT COUNT(DISTINCT e.module_id) INTO v_completed_modules
    FROM evaluation_scores es
    JOIN evaluations e ON es.evaluation_id = e.id
    WHERE es.camper_id = p_camper_id AND es.score >= 70;

    SELECT COUNT(id) INTO v_total_modules
    FROM modules;

    IF v_completed_modules = v_total_modules THEN
        UPDATE campers
        SET status_id = (SELECT id FROM statuses WHERE name = 'Graduado')
        WHERE id = p_camper_id;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El camper no ha completado todos los módulos';
    END IF;
END //
DELIMITER ;

CALL sp_graduate_camper(1);
SELECT id, status_id FROM campers WHERE id = 1;

-- 13. Consultar y exportar todos los datos de rendimiento de un camper.
DELIMITER //
CREATE PROCEDURE sp_export_camper_performance(
    IN p_camper_id INT)
BEGIN
    SELECT p.first_name, p.last_name, r.name AS route, m.name AS module, es.score
    FROM evaluation_scores es
    JOIN evaluations e ON es.evaluation_id = e.id
    JOIN modules m ON e.module_id = m.id
    JOIN camper_routes cr ON es.camper_id = cr.camper_id
    JOIN routes r ON cr.route_id = r.id
    JOIN persons p ON cr.camper_id = p.id
    WHERE es.camper_id = p_camper_id;
END //
DELIMITER ;

CALL sp_export_camper_performance(1);
SELECT first_name, last_name, route, module, score FROM persons WHERE id = 1;

-- 14. Registrar la asistencia a clases por área y horario.
DELIMITER //
CREATE PROCEDURE sp_register_attendance(
    IN p_camper_id INT,
    IN p_area_id INT,
    IN p_date DATE)
BEGIN
    INSERT INTO attendance (camper_id, area_id, attendance_date)
    VALUES (p_camper_id, p_area_id, p_date);
END //
DELIMITER ;

CALL sp_register_attendance(1, 1, CURDATE());
SELECT camper_id, area_id, attendance_date FROM attendance WHERE camper_id = 1;
-- 15. Generar reporte mensual de notas por ruta.
DELIMITER //
CREATE PROCEDURE sp_generate_monthly_report(
    IN p_month INT,
    IN p_year INT)
BEGIN
    SELECT r.name AS route, p.first_name, p.last_name, AVG(es.score) AS avg_score
    FROM evaluation_scores es
    JOIN evaluations e ON es.evaluation_id = e.id
    JOIN training_groups tg ON e.group_id = tg.id
    JOIN routes r ON tg.route_id = r.id
    JOIN campers c ON es.camper_id = c.id
    JOIN persons p ON c.person_id = p.id
    WHERE MONTH(e.created_at) = p_month AND YEAR(e.created_at) = p_year
    GROUP BY r.name, p.first_name, p.last_name;
END //
DELIMITER ;

CALL sp_generate_monthly_report(MONTH(CURDATE()), YEAR(CURDATE()));

-- 16. Validar y registrar la asignación de un salón a una ruta sin exceder la capacidad.
DELIMITER //
CREATE PROCEDURE sp_assign_classroom_to_route(
    IN p_route_id INT,
    IN p_classroom_id INT)
BEGIN
    DECLARE v_classroom_capacity INT;
    DECLARE v_current_count INT;

    SELECT capacity INTO v_classroom_capacity 
    FROM classrooms 
    WHERE id = p_classroom_id;

    SELECT COUNT(route_id) INTO v_current_count 
    FROM training_groups 
    WHERE classroom_id = p_classroom_id;

    IF v_current_count >= v_classroom_capacity THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La capacidad del salón ha sido excedida';
    ELSE
        INSERT INTO training_groups (route_id, classroom_id, created_at)
        VALUES (p_route_id, p_classroom_id, NOW());
    END IF;
END //
DELIMITER ;

CALL sp_assign_classroom_to_route(1, 1);
SELECT * FROM training_groups WHERE route_id = 1 AND classroom_id = 1;

-- 17. Registrar cambio de horario de un trainer.
DELIMITER //
CREATE PROCEDURE sp_change_trainer_schedule(
    IN p_trainer_id INT,
    IN p_new_schedule VARCHAR(50))
BEGIN
    UPDATE trainers
    SET schedule = p_new_schedule
    WHERE id = p_trainer_id;
END //
DELIMITER ;

CALL sp_change_trainer_schedule(1, 'Lunes a Viernes 8:00-12:00');

SELECT t.id, p.first_name, p.last_name, t.schedule 
FROM trainers t
JOIN persons p ON t.person_id = p.id
WHERE t.id = 1;

-- 18. Eliminar la inscripción de un camper a una ruta (en caso de retiro).
DELIMITER //
CREATE PROCEDURE sp_remove_camper_enrollment(
    IN p_camper_id INT,
    IN p_route_id INT)
BEGIN
    DELETE FROM camper_routes
    WHERE camper_id = p_camper_id AND route_id = p_route_id;
END //
DELIMITER ;

CALL sp_remove_camper_enrollment(5, 3);

SELECT cr.camper_id, p.first_name, p.last_name, cr.route_id, r.name AS route_name
FROM camper_routes cr
JOIN campers c ON cr.camper_id = c.id
JOIN persons p ON c.person_id = p.id
JOIN routes r ON cr.route_id = r.id
WHERE cr.camper_id = 5 AND cr.route_id = 3;

SELECT cr.camper_id, p.first_name, p.last_name, cr.route_id, r.name AS route_name
FROM camper_routes cr
JOIN campers c ON cr.camper_id = c.id
JOIN persons p ON c.person_id = p.id
JOIN routes r ON cr.route_id = r.id
WHERE cr.camper_id = 5 AND cr.route_id = 3;

-- 19. Recalcular el estado de todos los campers según su rendimiento acumulado.
DELIMITER //
CREATE PROCEDURE sp_recalculate_camper_status()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE camper_id INT;
    DECLARE camper_cursor CURSOR FOR SELECT id FROM campers;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN camper_cursor;

    read_loop: LOOP
        FETCH camper_cursor INTO camper_id;
        IF done THEN
            LEAVE read_loop;
        END IF;

        CALL sp_graduate_camper(camper_id);
    END LOOP;

    CLOSE camper_cursor;
END //
DELIMITER ;

SELECT id, status_id FROM campers WHERE status_id = 1;
FROM campers c
JOIN persons p ON c.person_id = p.id
WHERE c.status_id = 1;

CALL sp_recalculate_camper_status();

SELECT c.id, p.first_name, p.last_name, c.status_id
FROM campers c  
JOIN persons p ON c.person_id = p.id
WHERE c.status_id = 1;

-- 20. Asignar horarios automáticamente a trainers disponibles según sus áreas.
DELIMITER //
DROP PROCEDURE IF EXISTS sp_auto_assign_trainer_schedule;

CREATE PROCEDURE sp_auto_assign_trainer_schedule(
    IN p_area_id INT,
    IN p_schedule VARCHAR(50))
BEGIN
    UPDATE trainers
    SET schedule = p_schedule
    WHERE id IN (
        SELECT trainer_id
        FROM trainer_areas
        WHERE area_id = p_area_id
    ) AND schedule IS NULL;
END //
DELIMITER ;

SELECT t.id, p.first_name, p.last_name, t.schedule
FROM trainers t
JOIN persons p ON t.person_id = p.id
WHERE t.schedule IS NULL;

CALL sp_auto_assign_trainer_schedule(1, 'Lunes a Viernes 8:00-12:00');

SELECT t.id, p.first_name, p.last_name, t.schedule
FROM trainers t 
JOIN persons p ON t.person_id = p.id
WHERE t.schedule = 'Lunes a Viernes 8:00-12:00';
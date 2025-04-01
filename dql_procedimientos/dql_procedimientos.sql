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

CALL sp_calculate_final_grade(1, 1, 1);
SELECT camper_id, final_grade FROM camper_groups WHERE camper_id = 1 AND group_id = 1;

-- 6. Asignar campers aprobados a una ruta de acuerdo con la disponibilidad del área.
-- 7. Asignar un trainer a una ruta y área específica, validando el horario.
-- 8. Registrar una nueva ruta con sus módulos y SGDB asociados.
-- 9. Registrar una nueva área de entrenamiento con su capacidad y horarios.
-- 10. Consultar disponibilidad de horario en un área determinada.
-- 11. Reasignar a un camper a otra ruta en caso de bajo rendimiento.
-- 12. Cambiar el estado de un camper a “Graduado” al finalizar todos los módulos.
-- 13. Consultar y exportar todos los datos de rendimiento de un camper.
-- 14. Registrar la asistencia a clases por área y horario.
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
-- 17. Registrar cambio de horario de un trainer.
-- 18. Eliminar la inscripción de un camper a una ruta (en caso de retiro).
-- 19. Recalcular el estado de todos los campers según su rendimiento acumulado.
-- 20. Asignar horarios automáticamente a trainers disponibles según sus áreas
-- Triggers-- Triggers
-- 1. Al insertar una evaluación, calcular automáticamente la nota final.
DELIMITER //
CREATE TRIGGER tr_calculate_final_grade
AFTER INSERT ON evaluation_scores       
FOR EACH ROW

BEGIN
    DECLARE v_final_grade DECIMAL(4,1);
    DECLARE v_module_id INT;
    
    SELECT e.module_id INTO v_module_id
    FROM evaluations e
    WHERE e.id = NEW.evaluation_id;
    
    SELECT SUM(es.score * et.weight_percentage) / 100 INTO v_final_grade
    FROM evaluation_scores es
    JOIN evaluations e ON es.evaluation_id = e.id
    JOIN evaluation_types et ON e.evaluation_type_id = et.id
    WHERE es.camper_id = NEW.camper_id AND e.module_id = v_module_id;
    
    UPDATE camper_skills 
    SET skill_id = v_final_grade 
    WHERE camper_id = NEW.camper_id AND skill_id = (SELECT skill_id FROM modules WHERE id = v_module_id);
END //
DELIMITER ;

INSERT INTO evaluation_scores (evaluation_id, camper_id, score)
SELECT 1, 1, 85.5
WHERE NOT EXISTS (
    SELECT 1 FROM evaluation_scores 
    WHERE evaluation_id = 1 AND camper_id = 1
);
SELECT e.id, es.score
FROM evaluations e
JOIN evaluation_scores es ON e.id = es.evaluation_id
WHERE e.module_id = 1 AND e.group_id = 1 AND es.camper_id = 1;

-- 2. Al actualizar la nota final de un módulo, verificar si el camper aprueba o reprueba.
DELIMITER //
CREATE TRIGGER tr_check_module_approval
AFTER UPDATE ON camper_skills
FOR EACH ROW
BEGIN
    DECLARE v_approved_status_id INT;
    DECLARE v_failed_status_id INT;
    DECLARE v_min_passing_score DECIMAL(4,1);
    
    SET v_min_passing_score = 60.0;
    
    SELECT id INTO v_approved_status_id FROM camper_statuses WHERE name = 'Aprobado';
    SELECT id INTO v_failed_status_id FROM camper_statuses WHERE name = 'Reprobado';
    
    IF NEW.skill_id >= v_min_passing_score AND NEW.skill_id != OLD.skill_id THEN
        UPDATE campers 
        SET status_id = v_approved_status_id 
        WHERE id = NEW.camper_id;
    ELSEIF NEW.skill_id < v_min_passing_score AND NEW.skill_id != OLD.skill_id THEN
        UPDATE campers 
        SET status_id = v_failed_status_id 
        WHERE id = NEW.camper_id;
    END IF;
END //
DELIMITER ;

ALTER TABLE camper_skills ADD COLUMN final_grade DECIMAL(4,1);

INSERT INTO camper_skills (camper_id, skill_id, final_grade)
SELECT 1, 1, 85.5
WHERE NOT EXISTS (
    SELECT 1 FROM camper_skills 
    WHERE camper_id = 1 AND skill_id = 1
);
SELECT cs.camper_id, cs.skill_id, cs.final_grade
FROM camper_skills cs
WHERE cs.camper_id = 1 AND cs.skill_id = 1;

-- 3. Al insertar una inscripción, cambiar el estado del camper a "Inscrito".
DELIMITER //
CREATE TRIGGER tr_update_camper_status_on_enrollment
AFTER INSERT ON camper_groups
FOR EACH ROW
BEGIN
    DECLARE v_inscribed_status_id INT;
    
    SELECT id INTO v_inscribed_status_id FROM camper_statuses WHERE name = 'Inscrito';
    
    UPDATE campers 
    SET status_id = v_inscribed_status_id 
    WHERE id = NEW.camper_id;
END //
DELIMITER ;

ALTER TABLE camper_groups ADD COLUMN enrollment_date DATE;

INSERT INTO camper_groups (camper_id, group_id, enrollment_date, status)
SELECT 1, 1, CURDATE(), 'Inscrito'
WHERE NOT EXISTS (
    SELECT 1 FROM camper_groups 
    WHERE camper_id = 1 AND group_id = 1
);
SELECT cg.camper_id, cg.group_id, cg.status
FROM camper_groups cg
WHERE cg.camper_id = 1 AND cg.group_id = 1;

-- 4. Al actualizar una evaluación, recalcular su promedio inmediatamente.
DELIMITER //
CREATE TRIGGER tr_recalculate_average_on_update
AFTER UPDATE ON evaluation_scores
FOR EACH ROW
BEGIN
    DECLARE v_final_score DECIMAL(4,1);
    DECLARE v_module_id INT;
    
    SELECT e.module_id INTO v_module_id
    FROM evaluations e
    WHERE e.id = NEW.evaluation_id;
    
    SELECT SUM(es.score * et.weight_percentage) / 100 INTO v_final_score
    FROM evaluation_scores es
    JOIN evaluations e ON es.evaluation_id = e.id
    JOIN evaluation_types et ON e.evaluation_type_id = et.id
    WHERE es.camper_id = NEW.camper_id AND e.module_id = v_module_id;
    
    UPDATE camper_skills 
    SET skill_id = (SELECT skill_id FROM modules WHERE id = v_module_id)
    WHERE camper_id = NEW.camper_id AND skill_id = (SELECT skill_id FROM modules WHERE id = v_module_id);
END //
DELIMITER ;

INSERT INTO evaluation_scores (evaluation_id, camper_id, score)
SELECT 1, 1, 85.5
WHERE NOT EXISTS (
    SELECT 1 FROM evaluation_scores 
    WHERE evaluation_id = 1 AND camper_id = 1
); 
SELECT es.camper_id, es.score
FROM evaluation_scores es
WHERE es.camper_id = 1 AND es.evaluation_id = 1;

-- 5. Al eliminar una inscripción, marcar al camper como "Retirado".
DELIMITER //
CREATE TRIGGER tr_mark_camper_withdrawn_on_delete
AFTER DELETE ON camper_groups
FOR EACH ROW
BEGIN
    DECLARE v_withdrawn_status_id INT;
    DECLARE v_other_groups INT;
    
    SELECT COUNT(id) INTO v_other_groups
    FROM camper_groups
    WHERE camper_id = OLD.camper_id AND status = 'Activo';
    
    IF v_other_groups = 0 THEN
        SELECT id INTO v_withdrawn_status_id FROM camper_statuses WHERE name = 'Retirado';
        
        UPDATE campers 
        SET status_id = v_withdrawn_status_id 
        WHERE id = OLD.camper_id;
    END IF;
END //
DELIMITER ;

INSERT INTO camper_groups (camper_id, group_id, status)
SELECT 1, 1, 'Activo'
WHERE NOT EXISTS (
    SELECT 1 FROM camper_groups 
    WHERE camper_id = 1 AND group_id = 1
);
SELECT cg.camper_id, cg.group_id, cg.status
FROM camper_groups cg
WHERE cg.camper_id = 1 AND cg.group_id = 1;

-- 6. Al insertar un nuevo módulo, registrar automáticamente su SGDB asociado.
DELIMITER //
CREATE TRIGGER tr_assign_default_sgdb_to_module
AFTER INSERT ON modules
FOR EACH ROW
BEGIN
    DECLARE v_database_category_id INT;
    DECLARE v_mysql_id INT;
    
    SELECT id INTO v_database_category_id 
    FROM module_categories 
    WHERE name = 'Bases de Datos';
    
    SELECT id INTO v_mysql_id 
    FROM sgdb 
    WHERE name = 'MySQL';
    
    IF NEW.category_id = v_database_category_id THEN
        INSERT INTO module_sgdb (module_id, database_id, is_primary)
        VALUES (NEW.id, v_mysql_id, TRUE);
    END IF;
END //
DELIMITER ;

CREATE TABLE IF NOT EXISTS module_sgdb (
    id INT AUTO_INCREMENT PRIMARY KEY,
    module_id INT NOT NULL,
    database_id INT NOT NULL,
    is_primary BOOLEAN NOT NULL,
    FOREIGN KEY (module_id) REFERENCES modules(id),
    FOREIGN KEY (database_id) REFERENCES sgdb(id)
);

ALTER TABLE modules MODIFY skill_id INT DEFAULT NULL;
ALTER TABLE modules MODIFY duration_weeks INT DEFAULT 0;

INSERT INTO modules (name, category_id, description, duration_weeks)
SELECT 'Nuevo Módulo', 1, 'Descripción del nuevo módulo', 0
WHERE NOT EXISTS (
    SELECT 1 FROM modules 
    WHERE name = 'Nuevo Módulo' AND category_id = 1
);
SELECT m.id, m.name, ms.database_id
FROM modules m
JOIN module_sgdb ms ON m.id = ms.module_id
WHERE m.name = 'Nuevo Módulo' AND m.category_id = 1;

-- 7. Al insertar un nuevo trainer, verificar duplicados por identificación.
DELIMITER //
CREATE TRIGGER tr_check_duplicate_trainer
BEFORE INSERT ON trainers
FOR EACH ROW
BEGIN
    DECLARE v_person_count INT;
    DECLARE v_document_number VARCHAR(20);
    
    SELECT document_number INTO v_document_number 
    FROM persons 
    WHERE id = NEW.person_id;
    
    SELECT COUNT(p.id) INTO v_person_count
    FROM persons p
    JOIN trainers t ON p.id = t.person_id
    WHERE p.document_number = v_document_number;
    
    IF v_person_count > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Ya existe un trainer registrado con este número de documento';
    END IF;
END //
DELIMITER ;

ALTER TABLE trainers ADD COLUMN status_id INT;

INSERT INTO trainers (person_id, acronym, status_id)
SELECT 1, 'T1', 1
WHERE NOT EXISTS (
    SELECT 1 FROM trainers 
    WHERE person_id = 1 AND acronym = 'T1'
);
SELECT t.id, t.acronym, p.document_number
FROM trainers t
JOIN persons p ON t.person_id = p.id
WHERE t.acronym = 'T1' AND p.document_number = '123456789';

-- 8. Al asignar un área, validar que no exceda su capacidad.
DELIMITER //
CREATE TRIGGER tr_validate_classroom_capacity
BEFORE INSERT ON training_groups
FOR EACH ROW
BEGIN
    DECLARE v_capacity INT;
    DECLARE v_current_occupancy INT;
    
    SELECT capacity INTO v_capacity 
    FROM classrooms 
    WHERE id = NEW.classroom_id;
    
    SELECT COUNT(cg.id) INTO v_current_occupancy
    FROM camper_groups cg
    JOIN training_groups tg ON cg.group_id = tg.id
    WHERE tg.classroom_id = NEW.classroom_id AND cg.status = 'Activo';
    
    IF v_current_occupancy >= v_capacity THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El aula ha alcanzado su capacidad máxima';
    END IF;
END //
DELIMITER ;

INSERT INTO training_groups (classroom_id, route_id, trainer_id, start_date, end_date)
SELECT 1, 1, 1, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 4 WEEK)
WHERE NOT EXISTS (
    SELECT 1 FROM training_groups 
    WHERE classroom_id = 1 AND route_id = 1
);
SELECT tg.id, tg.classroom_id, c.capacity
FROM training_groups tg
JOIN classrooms c ON tg.classroom_id = c.id
WHERE tg.classroom_id = 1 AND tg.route_id = 1;

-- 9. Al insertar una evaluación con nota < 60, marcar al camper como "Bajo rendimiento".
DELIMITER //
CREATE TRIGGER tr_mark_low_performance
AFTER INSERT ON evaluation_scores
FOR EACH ROW
BEGIN
    DECLARE v_final_score DECIMAL(4,1);
    DECLARE v_module_id INT;
    DECLARE v_low_performance_status INT;
    DECLARE v_evaluation_type VARCHAR(50);
    
    SELECT et.name INTO v_evaluation_type
    FROM evaluation_types et
    JOIN evaluations e ON et.id = e.evaluation_type_id
    WHERE e.id = NEW.evaluation_id;
    
    IF v_evaluation_type IN ('Teórica', 'Práctica', 'Quizzes') THEN
        SELECT e.module_id INTO v_module_id
        FROM evaluations e
        WHERE e.id = NEW.evaluation_id;
        
        SELECT SUM(es.score * et.weight_percentage) / 100 INTO v_final_score
        FROM evaluation_scores es
        JOIN evaluations e ON es.evaluation_id = e.id
        JOIN evaluation_types et ON e.evaluation_type_id = et.id
        WHERE es.camper_id = NEW.camper_id AND e.module_id = v_module_id;
        
        IF v_final_score < 60 THEN
            SELECT id INTO v_low_performance_status FROM camper_statuses WHERE name = 'Bajo rendimiento';
            
            UPDATE campers 
            SET status_id = v_low_performance_status 
            WHERE id = NEW.camper_id;
        END IF;
    END IF;
END //
DELIMITER ;

INSERT INTO evaluation_scores (evaluation_id, camper_id, score)
SELECT 1, 1, 55.0
WHERE NOT EXISTS (
    SELECT 1 FROM evaluation_scores 
    WHERE evaluation_id = 1 AND camper_id = 1
);
SELECT es.camper_id, es.score
FROM evaluation_scores es
WHERE es.camper_id = 1 AND es.evaluation_id = 1;

-- 10. Al cambiar de estado a "Graduado", mover registro a la tabla de egresados.
DELIMITER //
CREATE TRIGGER tr_move_to_graduates
AFTER UPDATE ON campers
FOR EACH ROW
BEGIN
    DECLARE v_graduated_status_id INT;
    DECLARE v_route_id INT;
    DECLARE v_final_grade DECIMAL(4,1);
    
    SELECT id INTO v_graduated_status_id FROM camper_statuses WHERE name = 'Graduado';
    
    IF NEW.status_id = v_graduated_status_id AND OLD.status_id != v_graduated_status_id THEN
        SELECT tg.route_id INTO v_route_id
        FROM training_groups tg 
        JOIN camper_groups cg ON tg.id = cg.group_id 
        WHERE cg.camper_id = NEW.id
        LIMIT 1;
        
        SELECT AVG(cs.skill_id) INTO v_final_grade
        FROM camper_skills cs 
        JOIN modules m ON cs.skill_id = m.skill_id 
        JOIN route_modules rm ON m.id = rm.module_id 
        WHERE rm.route_id = v_route_id AND cs.camper_id = NEW.id;
        
        IF NOT EXISTS (SELECT 1 FROM graduates WHERE camper_id = NEW.id AND route_id = v_route_id) THEN
            INSERT INTO graduates (camper_id, route_id, final_grade)
            VALUES (NEW.id, v_route_id, v_final_grade);
        END IF;
    END IF;
END //
DELIMITER ;

INSERT INTO campers (person_id, status_id)
SELECT 1, 1
WHERE NOT EXISTS (
    SELECT 1 FROM campers 
    WHERE person_id = 1 AND status_id = 1
);
SELECT c.id, c.status_id, g.route_id
FROM campers c
JOIN graduates g ON c.id = g.camper_id
WHERE c.status_id = 1 AND g.route_id = 1;

-- 11. Al modificar horarios de trainer, verificar solapamiento con otros.
ALTER TABLE trainer_schedules 
ADD COLUMN start_time TIME NOT NULL, 
ADD COLUMN end_time TIME NOT NULL, 
MODIFY COLUMN day_of_week VARCHAR(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL;

DELIMITER //
CREATE TRIGGER tr_check_schedule_overlap
BEFORE UPDATE ON trainer_schedules
FOR EACH ROW
BEGIN
    DECLARE v_overlap_count INT;
    
    SELECT COUNT(id) INTO v_overlap_count
    FROM trainer_schedules
    WHERE trainer_id = NEW.trainer_id
      AND day_of_week = NEW.day_of_week
      AND ((start_time <= NEW.start_time AND end_time > NEW.start_time)
        OR (start_time < NEW.end_time AND end_time >= NEW.end_time)
        OR (start_time >= NEW.start_time AND end_time <= NEW.end_time))
      AND id != NEW.id;
    
    IF v_overlap_count > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El horario se solapa con otro ya existente para este trainer';
    END IF;
END //
DELIMITER ;

INSERT INTO trainer_schedules (trainer_id, day_of_week, start_time, end_time)
SELECT 1, 'Lunes', '08:00:00', '10:00:00'
WHERE NOT EXISTS (
    SELECT 1 FROM trainer_schedules 
    WHERE trainer_id = 1 AND day_of_week = 'Lunes' AND start_time = '08:00:00' AND end_time = '10:00:00'
);
SELECT ts.trainer_id, ts.day_of_week, ts.start_time, ts.end_time
FROM trainer_schedules ts
WHERE ts.trainer_id = 1 AND ts.day_of_week = 'Lunes' AND ts.start_time = '08:00:00' AND ts.end_time = '10:00:00';

-- 12. Al eliminar un trainer, liberar sus horarios y rutas asignadas.
DELIMITER //
CREATE TRIGGER tr_release_trainer_resources
AFTER DELETE ON trainers
FOR EACH ROW
BEGIN
    DECLARE v_temp_trainer_id INT;
    
    SELECT id INTO v_temp_trainer_id 
    FROM trainers 
    WHERE acronym = 'M' 
    LIMIT 1;
    
    DELETE FROM trainer_schedules WHERE trainer_id = OLD.id;
    
    UPDATE training_groups 
    SET trainer_id = v_temp_trainer_id
    WHERE trainer_id = OLD.id;
END //
DELIMITER ;

INSERT INTO trainers (person_id, acronym, status_id)
SELECT 1, 'M', 1
WHERE NOT EXISTS (
    SELECT 1 FROM trainers 
    WHERE person_id = 1 AND acronym = 'M'
);
SELECT t.id, t.acronym, ts.trainer_id
FROM trainers t
JOIN trainer_schedules ts ON t.id = ts.trainer_id
WHERE t.acronym = 'M' AND ts.trainer_id = 1;

-- 13. Al cambiar la ruta de un camper, actualizar automáticamente sus módulos.
DELIMITER //
CREATE TRIGGER tr_update_modules_on_route_change
AFTER UPDATE ON training_groups
FOR EACH ROW
BEGIN
    DECLARE v_evaluation_type_id INT;
    
    IF NEW.route_id != OLD.route_id THEN
        DELETE es FROM evaluation_scores es
        JOIN evaluations e ON es.evaluation_id = e.id
        JOIN modules m ON e.module_id = m.id
        JOIN route_modules rm ON m.id = rm.module_id
        WHERE rm.route_id = OLD.route_id AND es.camper_id IN (
            SELECT camper_id FROM camper_groups WHERE group_id = NEW.id
        );
        
        INSERT INTO evaluations (module_id, group_id, evaluation_type_id, name)
        SELECT rm.module_id, NEW.id, et.id, CONCAT(et.name, ' - ', m.name)
        FROM route_modules rm
        JOIN modules m ON rm.module_id = m.id
        CROSS JOIN evaluation_types et
        WHERE rm.route_id = NEW.route_id AND et.name IN ('Teórica', 'Práctica', 'Quizzes');
    END IF;
END //
DELIMITER ;
INSERT INTO routes (id, name, description)
VALUES (100, 'Ruta de Prueba', 'Ruta para probar el trigger de cambio');

INSERT INTO route_modules (route_id, module_id, route_order)
VALUES (100, 100, 1);

UPDATE training_groups
SET route_id = 100
WHERE id = 100;

SELECT e.id, e.name, e.module_id, e.group_id, et.name AS evaluation_type
FROM evaluations e
JOIN evaluation_types et ON e.evaluation_type_id = et.id
WHERE e.group_id = 100 AND e.module_id = 100;

-- 14. Al insertar un nuevo camper, verificar si ya existe por número de documento.
DELIMITER //
CREATE TRIGGER tr_check_duplicate_camper
BEFORE INSERT ON campers
FOR EACH ROW
BEGIN
    DECLARE v_person_count INT;
    DECLARE v_document_number VARCHAR(20);
    
    SELECT document_number INTO v_document_number 
    FROM persons 
    WHERE id = NEW.person_id;
    
    SELECT COUNT(p.id) INTO v_person_count
    FROM persons p
    JOIN campers c ON p.id = c.person_id
    WHERE p.document_number = v_document_number;
    
    IF v_person_count > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Ya existe un camper registrado con este número de documento';
    END IF;
END //
DELIMITER ;

INSERT INTO persons (document_number, first_name, last_name)
SELECT '123456789', 'Juan', 'Pérez'
WHERE NOT EXISTS (
    SELECT 1 FROM persons 
    WHERE document_number = '123456789'
);
SELECT p.id, p.document_number, c.status_id
FROM persons p
JOIN campers c ON p.id = c.person_id
WHERE p.document_number = '123456789' AND c.status_id = 1;

-- 15. Al actualizar la nota final, recalcular el estado del módulo automáticamente.
CREATE TABLE IF NOT EXISTS module_status (
    camper_id INT NOT NULL,
    module_id INT NOT NULL,
    status VARCHAR(20) NOT NULL,
    PRIMARY KEY (camper_id, module_id),
    FOREIGN KEY (camper_id) REFERENCES campers(id),
    FOREIGN KEY (module_id) REFERENCES modules(id)
);

DELIMITER //
CREATE TRIGGER tr_recalculate_module_status
AFTER UPDATE ON camper_skills
FOR EACH ROW
BEGIN
    DECLARE v_module_status VARCHAR(20);
    DECLARE v_module_id INT;
    DECLARE v_status_id INT;
    
    SELECT id INTO v_module_id
    FROM modules
    WHERE skill_id = NEW.skill_id
    LIMIT 1;
    
    IF NEW.skill_id >= 60 THEN
        SET v_module_status = 'Aprobado';
        SELECT id INTO v_status_id FROM camper_statuses WHERE name = 'Aprobado';
    ELSE
        SET v_module_status = 'Reprobado';
        SELECT id INTO v_status_id FROM camper_statuses WHERE name = 'Reprobado';
    END IF;
    
    UPDATE module_status
    SET status = v_module_status
    WHERE camper_id = NEW.camper_id AND module_id = v_module_id;
    
    IF NOT EXISTS (SELECT 1 FROM module_status WHERE camper_id = NEW.camper_id AND module_id = v_module_id) THEN
        INSERT INTO module_status (camper_id, module_id, status)
        VALUES (NEW.camper_id, v_module_id, v_module_status);
    END IF;
END //
DELIMITER ;

INSERT INTO module_status (camper_id, module_id, status)
SELECT 1, 1, 'Aprobado'
WHERE NOT EXISTS (
    SELECT 1 FROM module_status 
    WHERE camper_id = 1 AND module_id = 1
);
SELECT ms.camper_id, ms.module_id, ms.status
FROM module_status ms
WHERE ms.camper_id = 1 AND ms.module_id = 1;

-- 16. Al asignar un módulo, verificar que el trainer tenga ese conocimiento.
ALTER TABLE module_trainers ADD COLUMN status VARCHAR(20) NOT NULL DEFAULT 'Activo';

DELIMITER //
CREATE TRIGGER tr_validate_trainer_competence
BEFORE INSERT ON module_trainers
FOR EACH ROW
BEGIN
    DECLARE v_competence_count INT;
    
    SELECT COUNT(tc.trainer_id) INTO v_competence_count
    FROM trainer_competencias tc
    JOIN competencias c ON tc.competencia_id = c.id
    JOIN module_competencias mc ON c.id = mc.competencia_id
    WHERE tc.trainer_id = NEW.trainer_id AND mc.module_id = NEW.module_id;
    
    IF v_competence_count = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El trainer no tiene las competencias requeridas para este módulo';
    END IF;
END //
DELIMITER ;

INSERT INTO module_trainers (module_id, trainer_id, status)
SELECT 1, 1, 'Activo'
WHERE NOT EXISTS (
    SELECT 1 FROM module_trainers 
    WHERE module_id = 1 AND trainer_id = 1
);
SELECT mt.module_id, mt.trainer_id, mt.status
FROM module_trainers mt
WHERE mt.module_id = 1 AND mt.trainer_id = 1;

-- 17. Al cambiar el estado de un área a inactiva, liberar campers asignados.
ALTER TABLE classrooms ADD COLUMN status VARCHAR(20) NOT NULL DEFAULT 'Activa';

DELIMITER //
CREATE TRIGGER tr_free_campers_on_inactive_classroom
AFTER UPDATE ON classrooms
FOR EACH ROW
BEGIN
    DECLARE v_available_classroom_id INT;
    
    IF NEW.status = 'Inactiva' AND OLD.status != 'Inactiva' THEN
        SELECT id INTO v_available_classroom_id
        FROM classrooms
        WHERE status = 'Activa' AND id != NEW.id
        LIMIT 1;
        
        IF v_available_classroom_id IS NOT NULL THEN
            UPDATE training_groups
            SET classroom_id = v_available_classroom_id
            WHERE classroom_id = NEW.id;
            
            INSERT INTO notifications (message, created_at)
            SELECT CONCAT('El aula ', NEW.name, ' ha sido marcada como inactiva. Los grupos han sido trasladados al aula ID: ', v_available_classroom_id), NOW();
        ELSE
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'No hay aulas disponibles para reasignar los grupos';
        END IF;
    END IF;
END //
DELIMITER ;

INSERT INTO classrooms (name, capacity, status, campus_id) 
SELECT 'Aula 1', 30, 'Activa', 1
WHERE NOT EXISTS (
    SELECT 1 FROM classrooms 
    WHERE name = 'Aula 1' AND status = 'Activa'
);
SELECT c.id, c.name, c.capacity, c.status
FROM classrooms c
WHERE c.name = 'Aula 1' AND c.status = 'Activa';

-- 18. Al crear una nueva ruta, clonar la plantilla base de módulos y SGDBs.
DELIMITER //
CREATE TRIGGER tr_clone_template_on_route_creation
AFTER INSERT ON routes
FOR EACH ROW
BEGIN
    DECLARE v_template_route_id INT;
    
    SET v_template_route_id = 1; 
    
    INSERT INTO route_modules (route_id, module_id, route_order)
    SELECT NEW.id, module_id, route_order
    FROM route_modules
    WHERE route_id = v_template_route_id;
    
    INSERT INTO route_sgdb (route_id, database_id, is_primary)
    SELECT NEW.id, database_id, is_primary
    FROM route_sgdb
    WHERE route_id = v_template_route_id;
    
    INSERT INTO notifications (message, created_at)
    VALUES (CONCAT('Nueva ruta creada: ', NEW.name, '. Módulos y SGDBs plantilla clonados.'), NOW());
END //
DELIMITER ;

ALTER TABLE routes MODIFY COLUMN trainer_id INT DEFAULT NULL;

INSERT INTO routes (name, description, campus_id, trainer_id)
SELECT 'Ruta de Prueba', 'Descripción de la ruta de prueba', 1, NULL
WHERE NOT EXISTS (
    SELECT 1 FROM routes 
    WHERE name = 'Ruta de Prueba' AND campus_id = 1
);

SELECT r.id, r.name, rm.module_id, rs.database_id
FROM routes r
LEFT JOIN route_modules rm ON r.id = rm.route_id
LEFT JOIN route_sgdb rs ON r.id = rs.route_id
WHERE r.name = 'Ruta de Prueba' AND r.campus_id = 1;

-- 19. Al registrar la nota práctica, verificar que no supere 60% del total.
DELIMITER //
CREATE TRIGGER tr_validate_practice_score
BEFORE INSERT ON evaluation_scores
FOR EACH ROW
BEGIN
    DECLARE v_evaluation_type VARCHAR(30);
    DECLARE v_max_score DECIMAL(4,1);
    
    SELECT et.name INTO v_evaluation_type
    FROM evaluation_types et
    JOIN evaluations e ON et.id = e.evaluation_type_id
    WHERE e.id = NEW.evaluation_id;
    
    IF v_evaluation_type = 'Práctica' THEN
        SELECT weight_percentage INTO v_max_score
        FROM evaluation_types
        WHERE name = 'Práctica';
        
        IF NEW.score > v_max_score THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'La nota práctica no puede superar el 60% del total';
        END IF;
    END IF;
END //
DELIMITER ;

INSERT INTO evaluation_scores (evaluation_id, camper_id, score)
SELECT 1, 1, 70.0
WHERE NOT EXISTS (
    SELECT 1 FROM evaluation_scores 
    WHERE evaluation_id = 1 AND camper_id = 1
);
SELECT es.camper_id, es.score
FROM evaluation_scores es
WHERE es.camper_id = 1 AND es.evaluation_id = 1;

-- 20. Al modificar una ruta, notificar cambios a los trainers asignados.
DELIMITER //
CREATE TRIGGER tr_notify_trainers_on_route_change
AFTER UPDATE ON routes
FOR EACH ROW
BEGIN
    IF NEW.name != OLD.name OR NEW.description != OLD.description THEN
        INSERT INTO notifications (trainer_id, message, created_at)
        SELECT DISTINCT trainer_id, 
               CONCAT('La ruta ', OLD.name, ' ha sido modificada. Nuevo nombre: ', NEW.name), 
               NOW()
        FROM training_groups 
        WHERE route_id = NEW.id;
    END IF;
END //
DELIMITER ;

INSERT INTO routes (name, description, campus_id, trainer_id)
SELECT 'Ruta de Modificación', 'Descripción de la ruta de modificación', 1, NULL
WHERE NOT EXISTS (
    SELECT 1 FROM routes 
    WHERE name = 'Ruta de Modificación' AND campus_id = 1
);
SELECT r.id, r.name, r.description
FROM routes r
WHERE r.name = 'Ruta de Modificación' AND r.campus_id = 1;

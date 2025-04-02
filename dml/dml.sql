-- Inserciones de datos
-- 1. Tabla countries
INSERT INTO countries (name) VALUES 
('Colombia'), ('Estados Unidos'), ('México'), ('Argentina'), ('España'),
('Brasil'), ('Chile'), ('Perú'), ('Ecuador'), ('Venezuela');

-- 2. Tabla states
INSERT INTO states (country_id, name) VALUES 
(1, 'Antioquia'), (1, 'Cundinamarca'), (1, 'Valle del Cauca'),
(2, 'California'), (2, 'Texas'), (3, 'Ciudad de México'),
(4, 'Buenos Aires'), (5, 'Madrid'), (6, 'São Paulo'), (7, 'Santiago');

-- 3. Tabla cities
INSERT INTO cities (state_id, name) VALUES 
(1, 'Medellín'), (1, 'Envigado'), (2, 'Bogotá'), (2, 'Soacha'),
(3, 'Cali'), (4, 'Los Ángeles'), (5, 'Houston'), (6, 'CDMX'),
(7, 'La Plata'), (8, 'Madrid');

-- 4. Tabla addresses
INSERT INTO addresses (street, neighborhood, postal_code, city_id) VALUES 
('Calle 10 #45-20', 'El Poblado', '050021', 1),
('Carrera 15 #12-30', 'Centro', '110321', 3),
('Avenida 6N #15-45', 'Granada', '760043', 5),
('Main Street 123', 'Downtown', '90012', 6),
('5th Avenue 100', 'Midtown', '77002', 7),
('Reforma 222', 'Juárez', '06600', 8),
('Calle 7 #23-45', 'La Candelaria', '110311', 3),
('Diagonal 25 #34-10', 'Belén', '050022', 1),
('Avenida Boyacá #15-60', 'Nariño', '760044', 5),
('Gran Vía 80', 'Centro', '28013', 10);

-- 5. Tabla company
INSERT INTO company (name, nit, address_id) VALUES 
('CampusLands', '901234567-8', 1),
('CampusLands Bogotá', '902345678-9', 2),
('CampusLands Cali', '903456789-0', 3),
('CampusLands USA', '123456789', 4),
('CampusLands México', '987654321', 6),
('CampusLands Medellín', '904567890-1', 8),
('CampusLands Internacional', '112233445', 9),
('CampusLands Educación', '556677889', 10),
('CampusLands Tech', '998877665', 5),
('CampusLands Academy', '443322110', 7);

-- 6. Tabla branches
INSERT INTO branches (company_id, name, address_id) VALUES 
(1, 'Sede Principal Medellín', 1),
(2, 'Sede Bogotá Chapinero', 2),
(3, 'Sede Cali Granada', 3),
(4, 'Sede Los Ángeles', 4),
(5, 'Sede CDMX', 6),
(6, 'Sede Medellín Belén', 8),
(7, 'Sede Cali Nariño', 9),
(8, 'Sede Madrid', 10),
(9, 'Sede Houston', 5),
(10, 'Sede Bogotá Candelaria', 7);

-- 7. Tabla classrooms
INSERT INTO classrooms (campus_id, name, capacity) VALUES 
(1, 'Aula 101', 33), (1, 'Aula 102', 33), (2, 'Aula 201', 33),
(2, 'Aula 202', 33), (3, 'Aula 301', 33), (3, 'Aula 302', 33),
(4, 'Aula 401', 33), (5, 'Aula 501', 33), (6, 'Aula 601', 33),
(7, 'Aula 701', 33);

-- 8. Tabla document_types
INSERT INTO document_types (name, abbreviation) VALUES 
('Cédula de Ciudadanía', 'CC'),
('Tarjeta de Identidad', 'TI'),
('Cédula de Extranjería', 'CE'),
('Pasaporte', 'PA'),
('Registro Civil', 'RC'),
('NIT', 'NIT'),
('Permiso Especial', 'PE'),
('Documento Nacional de Identidad', 'DNI'),
('Carné Diplomático', 'CD'),
('Permiso por Protección Temporal', 'PPT');

-- 9. Tabla persons

INSERT INTO persons (document_type_id, document_number, first_name, last_name, email, address_id, birth_date) VALUES 
(1, '1234567890', 'Juan', 'Pérez', 'juan.perez@email.com', 1, '1995-05-15'),
(1, '9876543210', 'María', 'Gómez', 'maria.gomez@email.com', 2, '1998-08-20'),
(2, '4567890123', 'Carlos', 'Rodríguez', 'carlos.rod@email.com', 3, '2000-02-10'),
(3, '7890123456', 'Ana', 'Martínez', 'ana.martinez@email.com', 4, '1997-11-25'),
(4, '3216549870', 'Luis', 'García', 'luis.garcia@email.com', 5, '1996-07-30'),
(1, '6543210987', 'Sofía', 'López', 'sofia.lopez@email.com', 6, '1999-04-12'),
(2, '2109876543', 'Pedro', 'Hernández', 'pedro.hernandez@email.com', 7, '2001-09-18'),
(3, '5432109876', 'Laura', 'Díaz', 'laura.diaz@email.com', 8, '1994-12-05'),
(4, '8765432109', 'Andrés', 'Moreno', 'andres.moreno@email.com', 9, '1993-06-22'),
(1, '1098765432', 'Camila', 'Torres', 'camila.torres@email.com', 10, '2002-03-08');

-- 10. Tabla phone_types

INSERT INTO phone_types (name) VALUES 
('Móvil'), ('Fijo'), ('Trabajo'), ('Emergencia'), ('WhatsApp'),
('Fax'), ('Secundario'), ('Casa'), ('Oficina'), ('Otro');

-- 11. Tabla person_phones

INSERT INTO person_phones (person_id, phone_type_id, number) VALUES 
(1, 1, '3101234567'), (1, 2, '6041234567'), (2, 1, '3209876543'),
(3, 1, '3154567890'), (4, 1, '3001239876'), (5, 1, '3186543210'),
(6, 1, '3197890123'), (7, 1, '3178901234'), (8, 1, '3145678901'),
(9, 1, '3123456789');

-- 12. Tabla camper_statuses

INSERT INTO camper_statuses (name) VALUES 
('En proceso de ingreso'), ('Inscrito'), ('Aprobado'),
('Cursando'), ('Graduado'), ('Expulsado'),
('Retirado'), ('Suspendido'), ('En pausa'), ('Transferido');

-- 13. Tabla risk_levels
INSERT INTO risk_levels (name) VALUES 
('Bajo'), ('Medio'), ('Alto'), ('Crítico'), ('Ninguno'),
('Monitorizado'), ('Estable'), ('Inestable'), ('Mejorando'), ('Empeorando');

-- 14. Tabla campers
INSERT INTO campers (person_id, status_id, risk_level_id, entry_date) VALUES 
(1, 4, 1, '2023-01-15'), (2, 4, 1, '2023-02-20'), (3, 3, 2, '2023-03-10'),
(4, 4, 1, '2023-04-05'), (5, 2, 3, '2023-05-12'), (6, 4, 1, '2023-06-18'),
(7, 1, 1, '2023-07-22'), (8, 4, 2, '2023-08-30'), (9, 5, 1, '2023-09-14'),
(10, 6, 4, '2023-10-25');

-- 15. Tabla guardians
INSERT INTO guardians (camper_id, person_id, relationship) VALUES 
(1, 2, 'Madre'), (2, 1, 'Padre'), (3, 4, 'Tío'),
(4, 3, 'Hermano'), (5, 6, 'Madre'), (6, 5, 'Padre'),
(7, 8, 'Tía'), (8, 7, 'Hermana'), (9, 10, 'Madre'),
(10, 9, 'Padre');

-- 16. Tabla trainers

INSERT INTO trainers (person_id, campus_id, acronym) VALUES 
(1, 1, 'J'), (2, 2, 'M'), (3, 3, 'C'),
(4, 4, 'A'), (5, 5, 'L'), (6, 1, 'S'),
(7, 2, 'P'), (8, 3, 'L'), (9, 4, 'A'),
(10, 5, 'C');

-- 17. Tabla competencias

INSERT INTO competencias (name, description) VALUES 
('Programación Python', 'Habilidades en desarrollo con Python'),
('Desarrollo Web', 'Conocimientos en HTML, CSS y JavaScript'),
('Bases de Datos', 'Manejo de sistemas de gestión de bases de datos'),
('Java Avanzado', 'Programación orientada a objetos con Java'),
('Node.js', 'Desarrollo backend con Node.js'),
('Spring Boot', 'Framework para desarrollo Java'),
('NetCore', 'Desarrollo con .NET Core'),
('MongoDB', 'Manejo de bases de datos NoSQL'),
('PostgreSQL', 'Bases de datos relacionales avanzadas'),
('C#', 'Programación con C#');

-- 18. Tabla trainer_competencias
INSERT INTO trainer_competencias (trainer_id, competencia_id) VALUES 
(1, 1), (1, 2), (2, 3), (2, 4), (3, 5),
(3, 6), (4, 7), (4, 8), (5, 9), (5, 10);

-- 19. Tabla skills
INSERT INTO skills (name, type, description) VALUES 
('Algoritmia', 'Fundamentos', 'Lógica de programación'),
('PSeInt', 'Fundamentos', 'Pseudocódigo'),
('HTML5', 'Web', 'Estructura web'),
('CSS3', 'Web', 'Estilos web'),
('Bootstrap', 'Web', 'Framework frontend'),
('JavaScript', 'Web', 'Programación frontend'),
('Java', 'Formal', 'POO con Java'),
('C#', 'Formal', 'POO con C#'),
('MySQL', 'Bases de Datos', 'SQL relacional'),
('MongoDB', 'Bases de Datos', 'NoSQL');

-- 20. Tabla module_categories
INSERT INTO module_categories (name) VALUES 
('Fundamentos'), ('Programación Web'), ('Programación Formal'),
('Bases de Datos'), ('Backend'), ('Frontend Avanzado'),
('DevOps'), ('Seguridad'), ('Proyectos'), ('Habilidades Blandas');

-- 21. Tabla modules
INSERT INTO modules (category_id, skill_id, name, description, duration_weeks) VALUES 
(1, 1, 'Introducción a la Algoritmia', 'Conceptos básicos de programación', 2),
(1, 2, 'PSeInt', 'Pseudocódigo para principiantes', 2),
(2, 3, 'HTML', 'Estructura de páginas web', 3),
(2, 4, 'CSS', 'Estilos para web', 3),
(2, 5, 'Bootstrap', 'Diseño responsive', 2),
(3, 7, 'Java Básico', 'POO con Java', 4),
(3, 8, 'C# Básico', 'POO con C#', 4),
(4, 9, 'MySQL', 'Bases de datos relacionales', 4),
(4, 10, 'MongoDB', 'Bases de datos NoSQL', 3),
(5, 6, 'Node.js', 'JavaScript en el servidor', 5);

-- 22. Tabla routes
INSERT INTO routes (name, description) VALUES 
('Fundamentos de Programación', 'Ruta inicial para principiantes'),
('Programación Web', 'Desarrollo frontend'),
('Programación Formal', 'Java y C#'),
('Bases de Datos', 'SQL y NoSQL'),
('Backend', 'Node.js, Spring Boot y NetCore'),
('FullStack', 'Combinación de frontend y backend'),
('Data Science', 'Análisis de datos'),
('DevOps', 'Infraestructura y despliegue'),
('Seguridad Informática', 'Ciberseguridad'),
('Inteligencia Artificial', 'Machine Learning');

-- 23. Tabla sgdb
INSERT INTO sgdb (name, type) VALUES 
('MySQL', 'Relacional'), ('PostgreSQL', 'Relacional'), ('MongoDB', 'NoSQL'),
('SQL Server', 'Relacional'), ('Oracle', 'Relacional'), ('SQLite', 'Relacional'),
('MariaDB', 'Relacional'), ('Firebase', 'NoSQL'), ('DynamoDB', 'NoSQL'), ('Cassandra', 'NoSQL');

-- 24. Tabla route_sgdb
INSERT INTO route_sgdb (route_id, database_id, is_primary) VALUES 
(1, 1, TRUE), (1, 2, FALSE), (2, 1, TRUE), (2, 3, FALSE),
(3, 4, TRUE), (3, 1, FALSE), (4, 2, TRUE), (4, 3, FALSE),
(5, 1, TRUE), (5, 8, FALSE);

-- 25. Tabla route_modules
INSERT INTO route_modules (route_id, module_id, route_order) VALUES 
(1, 1, 1), (1, 2, 2), (2, 3, 1), (2, 4, 2),
(2, 5, 3), (3, 6, 1), (3, 7, 2), (4, 8, 1),
(4, 9, 2), (5, 10, 1);

-- 26. Tabla time_blocks
INSERT INTO time_blocks (name, start_time, end_time) VALUES 
('Mañana', '08:00:00', '12:00:00'), ('Tarde', '13:00:00', '17:00:00'),
('Noche', '18:00:00', '22:00:00'), ('Weekend Mañana', '09:00:00', '13:00:00'),
('Weekend Tarde', '14:00:00', '18:00:00'), ('Intensivo Mañana', '07:00:00', '11:00:00'),
('Intensivo Tarde', '12:00:00', '16:00:00'), ('Intensivo Noche', '17:00:00', '21:00:00'),
('Flex Mañana', '09:00:00', '11:00:00'), ('Flex Tarde', '15:00:00', '17:00:00');

-- 27. Tabla schedules
INSERT INTO schedules (block_id) VALUES 
(1), (2), (3), (4), (5), (6), (7), (8), (9), (10);

-- 28. Tabla trainer_schedules
INSERT INTO trainer_schedules (trainer_id, day_of_week, time_block_id, is_available) VALUES 
(1, 1, 1, TRUE), (1, 2, 1, TRUE), (2, 3, 2, TRUE),
(2, 4, 2, TRUE), (3, 5, 3, TRUE), (4, 1, 4, TRUE),
(5, 2, 5, TRUE), (6, 3, 6, TRUE), (7, 4, 7, TRUE),
(8, 5, 8, TRUE);

-- 29. Tabla training_groups

INSERT INTO training_groups (route_id, trainer_id, classroom_id, schedule_id, name, start_date, end_date) VALUES 
(1, 1, 1, 1, 'Grupo A', '2023-01-10', '2023-06-15'),
(2, 2, 2, 2, 'Grupo B', '2023-02-15', '2023-07-20'),
(3, 3, 3, 3, 'Grupo C', '2023-03-20', '2023-08-25'),
(4, 4, 4, 4, 'Grupo D', '2023-04-25', '2023-09-30'),
(5, 5, 5, 5, 'Grupo E', '2023-05-30', '2023-10-05'),
(1, 6, 6, 6, 'Grupo F', '2023-06-05', '2023-11-10'),
(2, 7, 7, 7, 'Grupo G', '2023-07-10', '2023-12-15'),
(3, 8, 8, 8, 'Grupo H', '2023-08-15', '2024-01-20'),
(4, 9, 9, 9, 'Grupo I', '2023-09-20', '2024-02-25'),
(5, 10, 10, 10, 'Grupo J', '2023-10-25', '2024-03-30');

-- 30. Tabla camper_groups
INSERT INTO camper_groups (camper_id, group_id, entry_date, status) VALUES 
(1, 1, '2023-01-15', 'Activo'), (2, 2, '2023-02-20', 'Activo'),
(3, 3, '2023-03-10', 'Activo'), (4, 4, '2023-04-05', 'Activo'),
(5, 5, '2023-05-12', 'Activo'), (6, 6, '2023-06-18', 'Activo'),
(7, 7, '2023-07-22', 'Activo'), (8, 8, '2023-08-30', 'Activo'),
(9, 9, '2023-09-14', 'Graduado'), (10, 10, '2023-10-25', 'Retirado');

-- 31. Tabla module_trainers
INSERT INTO module_trainers (module_id, trainer_id, assigned_date) VALUES 
(1, 1, '2023-01-05'), (2, 2, '2023-01-10'), (3, 3, '2023-02-01'),
(4, 4, '2023-02-15'), (5, 5, '2023-03-01'), (6, 6, '2023-03-15'),
(7, 7, '2023-04-01'), (8, 8, '2023-04-15'), (9, 9, '2023-05-01'),
(10, 10, '2023-05-15');

-- 32. Tabla sessions

INSERT INTO sessions (module_id, name, description) VALUES 
(1, 'Introducción a algoritmos', 'Conceptos básicos de algoritmia'),
(1, 'Diagramas de flujo', 'Creación de diagramas de flujo'),
(2, 'Pseudocódigo básico', 'Estructuras básicas en PSeInt'),
(2, 'Estructuras de control', 'Condicionales y bucles'),
(3, 'HTML básico', 'Estructura de documentos HTML'),
(3, 'Formularios HTML', 'Creación de formularios web'),
(4, 'CSS básico', 'Estilos básicos con CSS'),
(4, 'Flexbox y Grid', 'Diseño avanzado con CSS'),
(5, 'Introducción a Bootstrap', 'Componentes básicos de Bootstrap'),
(5, 'Diseño responsive', 'Adaptación a diferentes dispositivos');

-- 33. Tabla session_schedules
INSERT INTO session_schedules (session_id, group_id, trainer_id, date, classroom_id, start_time, end_time) VALUES 
(1, 1, 1, '2023-01-16', 1, '08:00:00', '10:00:00'),
(2, 1, 1, '2023-01-18', 1, '08:00:00', '10:00:00'),
(3, 2, 2, '2023-02-21', 2, '13:00:00', '15:00:00'),
(4, 2, 2, '2023-02-23', 2, '13:00:00', '15:00:00'),
(5, 3, 3, '2023-03-11', 3, '18:00:00', '20:00:00'),
(6, 3, 3, '2023-03-13', 3, '18:00:00', '20:00:00'),
(7, 4, 4, '2023-04-06', 4, '09:00:00', '11:00:00'),
(8, 4, 4, '2023-04-08', 4, '09:00:00', '11:00:00'),
(9, 5, 5, '2023-05-13', 5, '14:00:00', '16:00:00'),
(10, 5, 5, '2023-05-15', 5, '14:00:00', '16:00:00');

-- 34. Tabla session_attendance
INSERT INTO session_attendance (session_schedule_id, camper_id, attendance_status, arrival_time) VALUES 
(1, 1, 'Presente', '08:00:00'), (2, 1, 'Presente', '08:05:00'),
(3, 2, 'Presente', '13:00:00'), (4, 2, 'Presente', '13:02:00'),
(5, 3, 'Presente', '18:00:00'), (6, 3, 'Tarde', '18:15:00'),
(7, 4, 'Presente', '09:00:00'), (8, 4, 'Ausente', NULL),
(9, 5, 'Presente', '14:00:00'), (10, 5, 'Tarde', '14:10:00');

-- 35. Tabla evaluation_types
INSERT INTO evaluation_types (name, weight_percentage, description) VALUES 
('Teórica', 30.0, 'Examen de conceptos'),
('Práctica', 60.0, 'Desarrollo de proyecto'),
('Quizzes', 10.0, 'Pequeñas evaluaciones'),
('Participación', 5.0, 'Contribución en clase'),
('Tareas', 15.0, 'Ejercicios semanales'),
('Proyecto Final', 40.0, 'Proyecto integrador'),
('Presentación', 10.0, 'Exposición de temas'),
('Código Limpio', 5.0, 'Buenas prácticas'),
('Trabajo en Equipo', 10.0, 'Colaboración'),
('Autoevaluación', 5.0, 'Reflexión personal');

-- 36. Tabla evaluations
INSERT INTO evaluations (module_id, group_id, evaluation_type_id, name) VALUES 
(1, 1, 1, 'Examen teórico algoritmia'),
(1, 1, 2, 'Proyecto práctico algoritmia'),
(2, 2, 1, 'Examen teórico PSeInt'),
(2, 2, 2, 'Proyecto práctico PSeInt'),
(3, 3, 1, 'Examen teórico HTML'),
(3, 3, 2, 'Proyecto práctico HTML'),
(4, 4, 1, 'Examen teórico CSS'),
(4, 4, 2, 'Proyecto práctico CSS'),
(5, 5, 1, 'Examen teórico Bootstrap'),
(5, 5, 2, 'Proyecto práctico Bootstrap');

-- 37. Tabla evaluation_scores
INSERT INTO evaluation_scores (evaluation_id, camper_id, score) VALUES 
(1, 1, 85.5), (2, 1, 90.0), (3, 2, 78.0),
(4, 2, 82.5), (5, 3, 92.0), (6, 3, 88.5),
(7, 4, 76.0), (8, 4, 81.0), (9, 5, 89.5),
(10, 5, 93.0);

-- 38. Tabla camper_skills
INSERT INTO camper_skills (camper_id, skill_id) VALUES 
(1, 1), (1, 2), (2, 3), (2, 4),
(3, 5), (3, 6), (4, 7), (4, 8),
(5, 9), (5, 10);

-- 39. Tabla graduates
INSERT INTO graduates (camper_id, route_id, final_grade) VALUES 
(9, 1, 88.5), (9, 2, 92.0), (9, 3, 85.0),
(9, 4, 89.5), (9, 5, 91.0);

-- 40. Tabla status_history
INSERT INTO status_history (camper_id, previous_status_id, new_status_id, change_date) VALUES 
(1, 1, 2, '2023-01-05 10:00:00'), (1, 2, 3, '2023-01-10 09:30:00'),
(1, 3, 4, '2023-01-15 08:15:00'), (2, 1, 2, '2023-02-01 11:00:00'),
(2, 2, 3, '2023-02-10 10:45:00'), (2, 3, 4, '2023-02-20 09:00:00'),
(3, 1, 2, '2023-03-01 14:30:00'), (3, 2, 3, '2023-03-05 13:15:00'),
(3, 3, 4, '2023-03-10 08:00:00'), (9, 4, 5, '2023-09-14 16:00:00');

-- 41. Tabla notifications
INSERT INTO notifications (trainer_id, message) VALUES 
(1, 'Recordatorio: Reunión de profesores mañana a las 10am'),
(2, 'Nuevo material disponible para el módulo de HTML'),
(3, 'Evaluaciones pendientes por calificar'),
(4, 'Cambio de aula para el grupo D'),
(5, 'Recordatorio: Entrega de notas finales'),
(6, 'Taller de capacitación el próximo viernes'),
(7, 'Actualización del plan de estudios'),
(8, 'Problemas reportados con el aula virtual'),
(9, 'Encuesta de satisfacción disponible'),
(10, 'Recordatorio: Entrega de certificados');

-- 42. Tabla module_competencias
INSERT INTO module_competencias (module_id, competencia_id) VALUES 
(1, 1), (2, 1), (3, 2), (4, 2),
(5, 2), (6, 4), (7, 10), (8, 3),
(9, 8), (10, 5);
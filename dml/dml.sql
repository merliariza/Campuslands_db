-- Inserciones de datos
-- 1. countries
INSERT INTO countries (name) VALUES 
('Colombia'),
('Estados Unidos'),
('México'),
('Argentina'),
('España'),
('Francia'),
('Alemania'),
('Brasil'),
('Chile'),
('Perú');

-- 2. states
INSERT INTO states (country_id, name) VALUES 
(1, 'Antioquia'),
(1, 'Cundinamarca'),
(1, 'Valle del Cauca'),
(1, 'Santander'),
(1, 'Bolívar'),
(2, 'California'),
(2, 'Texas'),
(2, 'Florida'),
(3, 'Ciudad de México'),
(3, 'Jalisco');

-- 3. cities
INSERT INTO cities (state_id, name) VALUES 
(1, 'Medellín'),
(1, 'Envigado'),
(2, 'Bogotá'),
(2, 'Soacha'),
(3, 'Cali'),
(3, 'Palmira'),
(6, 'Los Ángeles'),
(6, 'San Francisco'),
(7, 'Houston'),
(7, 'Austin');

-- 4. addresses
INSERT INTO addresses (street, neighborhood, postal_code, city_id) VALUES 
('Carrera 45 #20-10', 'El Poblado', '050021', 1),
('Calle 10 #5-30', 'La Candelaria', '110311', 3),
('Avenida 6N #15-20', 'Granada', '760043', 5),
('Diagonal 25 #40-55', 'Cabecera', '680003', 4),
('Calle 80 #12-45', 'Chapinero', '110221', 3),
('Carrera 70 #50-30', 'Belén', '050022', 1),
('Avenida Siempre Viva 742', 'Springfield', '90001', 7),
('Calle Falsa 123', 'Downtown', '75001', 9),
('Avenida Juárez 100', 'Centro', '06050', 9),
('Paseo de la Reforma 500', 'Polanco', '11560', 9);

-- 5. company
INSERT INTO company (name, nit, address_id) VALUES 
('CampusLands SAS', '900123456-1', 1),
('Tech Education Inc', '800987654-2', 7),
('Aprendizaje Digital', '700456789-3', 8),
('Educación Futura', '600321654-4', 9),
('Código Abierto SA', '500789123-5', 10),
('Innovación Educativa', '400654987-6', 2),
('Desarrollo Tech', '300987321-7', 3),
('Programación Global', '200456123-8', 4),
('Aprende Coding', '100789456-9', 5),
('Digital Campus', '000321987-0', 6);

-- 6. branches
INSERT INTO branches (company_id, name, address_id) VALUES 
(1, 'Sede Medellín', 1),
(1, 'Sede Bogotá', 2),
(1, 'Sede Cali', 3),
(2, 'Sede Los Ángeles', 7),
(2, 'Sede Houston', 8),
(3, 'Sede CDMX', 9),
(4, 'Sede Polanco', 10),
(5, 'Sede Chapinero', 5),
(6, 'Sede Belén', 6),
(7, 'Sede Granada', 3);

-- 7. classrooms 
INSERT INTO classrooms (campus_id, name, capacity) VALUES 
(1, 'Aula 101', 33),
(1, 'Aula 102', 33),
(2, 'Aula 201', 33),
(2, 'Aula 202', 33),
(3, 'Aula 301', 33),
(3, 'Aula 302', 33),
(4, 'Aula 401', 33),
(5, 'Aula 501', 33),
(6, 'Aula 601', 33),
(7, 'Aula 701', 33);

-- 8. document_types
INSERT INTO document_types (name, abbreviation) VALUES 
('Cédula de Ciudadanía', 'CC'),
('Tarjeta de Identidad', 'TI'),
('Cédula de Extranjería', 'CE'),
('Pasaporte', 'PA'),
('Registro Civil', 'RC'),
('Documento Nacional de Identidad', 'DNI'),
('Social Security Number', 'SSN'),
('Permiso Especial de Permanencia', 'PEP'),
('Número de Identificación Tributaria', 'NIT'),
('Licencia de Conducción', 'LC');

-- 9. persons 
INSERT INTO persons (document_type_id, document_number, first_name, last_name, email, address_id, birth_date) VALUES 
(1, '123456789', 'Juan', 'Pérez', 'juan.perez@email.com', 1, '1990-05-15'),
(1, '987654321', 'María', 'Gómez', 'maria.gomez@email.com', 2, '1992-08-20'),
(2, '456789123', 'Carlos', 'Rodríguez', 'carlos.rod@email.com', 3, '1995-03-10'),
(3, '789123456', 'Ana', 'Martínez', 'ana.martinez@email.com', 4, '1988-11-25'),
(4, '321654987', 'Luis', 'García', 'luis.garcia@email.com', 5, '1993-07-30'),
(5, '654987321', 'Laura', 'López', 'laura.lopez@email.com', 6, '1991-09-12'),
(6, '147258369', 'Pedro', 'Hernández', 'pedro.hernandez@email.com', 7, '1985-04-05'),
(7, '258369147', 'Sofía', 'Díaz', 'sofia.diaz@email.com', 8, '1994-12-18'),
(8, '369147258', 'Diego', 'Moreno', 'diego.moreno@email.com', 9, '1996-02-28'),
(9, '159357486', 'Elena', 'Torres', 'elena.torres@email.com', 10, '1989-06-22');

-- 10. phone_types 
INSERT INTO phone_types (name) VALUES 
('Móvil'),
('Casa'),
('Trabajo'),
('Fax'),
('Otro'),
('WhatsApp'),
('Telegram'),
('Móvil Empresarial'),
('Casa Secundaria'),
('Trabajo Secundario');

-- 11. person_phones 
INSERT INTO person_phones (person_id, phone_type_id, number) VALUES 
(1, 1, '3001234567'),
(1, 2, '6041234567'),
(2, 1, '3102345678'),
(3, 1, '3203456789'),
(3, 3, '6023456789'),
(4, 1, '3504567890'),
(5, 1, '3015678901'),
(6, 1, '3116789012'),
(7, 1, '3127890123'),
(8, 1, '3138901234');

-- 12. camper_statuses
INSERT INTO camper_statuses (name) VALUES 
('En proceso de ingreso'),
('Inscrito'),
('Aprobado'),
('Cursando'),
('Graduado'),
('Expulsado'),
('Retirado'),
('Baja temporal'),
('Baja definitiva'),
('En práctica');

-- 13. risk_levels 
INSERT INTO risk_levels (name) VALUES 
('Bajo'),
('Medio'),
('Alto'),
('Crítico'),
('Ninguno'),
('Bajo-Monitoreo'),
('Medio-Supervisado'),
('Alto-Intervención'),
('Crítico-Aislamiento'),
('Recuperación');

-- 14. campers 
INSERT INTO campers (person_id, status_id, risk_level_id, entry_date) VALUES 
(1, 4, 1, '2023-01-15'),  
(2, 3, 2, '2023-02-20'),  
(3, 5, 1, '2022-11-10'),  
(4, 7, 3, '2023-03-05'), 
(5, 4, 1, '2023-04-18'), 
(6, 6, 4, '2022-12-22'),  
(7, 4, 2, '2023-05-30'), 
(8, 1, 3, '2023-06-11'),  
(9, 2, 1, '2023-07-25'),  
(10, 5, 1, '2022-10-08'); 

-- 15. guardians
INSERT INTO guardians (camper_id, person_id, relationship) VALUES 
(1, 2, 'Madre'),
(2, 1, 'Padre'),
(3, 4, 'Tío'),
(4, 3, 'Hermano'),
(5, 6, 'Madre'),
(6, 5, 'Padre'),
(7, 8, 'Tía'),
(8, 7, 'Hermana'),
(9, 10, 'Abuelo'),
(10, 9, 'Abuela');

-- 16. status_history 
INSERT INTO status_history (camper_id, previous_status_id, new_status_id, change_date) VALUES 
(1, 1, 2, '2023-01-16 08:30:00'),
(1, 2, 3, '2023-01-20 09:15:00'),
(1, 3, 4, '2023-02-01 10:45:00'),
(2, 1, 2, '2023-02-21 09:15:00'),
(2, 2, 3, '2023-02-25 14:20:00'),
(3, 1, 2, '2022-11-11 11:10:00'),
(3, 2, 3, '2022-11-15 16:30:00'),
(3, 3, 4, '2022-11-20 13:25:00'),
(3, 4, 5, '2023-05-10 15:40:00'),
(4, 1, 7, '2023-03-06 10:00:00');

-- 17. trainers 
INSERT INTO trainers (person_id, campus_id, acronym) VALUES 
(1, 1, 'JAP'),
(2, 2, 'MAG'),
(3, 3, 'CAR'),
(4, 4, 'ANM'),
(5, 5, 'LUG'),
(6, 6, 'LAL'),
(7, 7, 'PEH'),
(8, 8, 'SOD'),
(9, 9, 'DIM'),
(10, 10, 'ELT');

-- 18. competencias
INSERT INTO competencias (name, description) VALUES 
('Fundamentos de Programación', 'Algoritmos y lógica de programación'),
('Programación Web', 'Desarrollo frontend con HTML, CSS'),
('Programación Formal', 'Lenguajes estructurados como Java, C#'),
('Bases de Datos', 'Diseño y gestión de bases de datos'),
('Backend', 'Desarrollo de servidores y APIs'),
('Cloud Computing', 'Servicios y aplicaciones en la nube'),
('DevOps', 'Integración y despliegue continuo'),
('Seguridad', 'Principios de seguridad informática'),
('Testing', 'Pruebas de software'),
('Metodologías Ágiles', 'SCRUM, Kanban, etc.');

-- 19. trainer_competencias 
INSERT INTO trainer_competencias (trainer_id, competencia_id) VALUES 
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(3, 5),
(3, 6),
(4, 7),
(4, 8),
(5, 9),
(5, 10),
(6, 1),
(6, 3),
(7, 2),
(7, 4),
(8, 5),
(8, 7),
(9, 6),
(9, 8),
(10, 9),
(10, 10);

-- 20. skills 
INSERT INTO skills (name, type, description) VALUES 
('PSeInt', 'Técnica', 'Herramienta para aprender algoritmos'),
('Python', 'Técnica', 'Lenguaje de programación inicial'),
('HTML', 'Técnica', 'Estructura web'),
('CSS', 'Técnica', 'Estilos web'),
('Bootstrap', 'Técnica', 'Framework frontend'),
('Java', 'Técnica', 'Lenguaje formal'),
('JavaScript', 'Técnica', 'Lenguaje frontend/backend'),
('C#', 'Técnica', 'Lenguaje formal'),
('MySQL', 'Técnica', 'Base de datos relacional'),
('MongoDB', 'Técnica', 'Base de datos NoSQL'),
('PostgreSQL', 'Técnica', 'Base de datos relacional avanzada'),
('NetCore', 'Técnica', 'Framework backend'),
('Spring Boot', 'Técnica', 'Framework Java backend'),
('NodeJS', 'Técnica', 'Runtime JavaScript'),
('Express', 'Técnica', 'Framework backend JavaScript'),
('Comunicación', 'Blanda', 'Habilidad interpersonal'),
('Trabajo en equipo', 'Blanda', 'Colaboración efectiva'),
('Resolución problemas', 'Blanda', 'Pensamiento lógico'),
('Adaptabilidad', 'Blanda', 'Ajuste a cambios'),
('Liderazgo', 'Blanda', 'Guía de equipos');

-- 21. module_categories
INSERT INTO module_categories (name) VALUES 
('Fundamentos'),
('Programación Web'),
('Programación Formal'),
('Bases de Datos'),
('Backend'),
('Cloud'),
('DevOps'),
('Seguridad'),
('Testing'),
('Metodologías');

-- 22. modules 
INSERT INTO modules (category_id, skill_id, name, description, duration_weeks, theory_percentage, practice_percentage, quizzes_percentage) VALUES 
(1, 1, 'Introducción a la Algoritmia', 'Conceptos básicos de algoritmos con PSeInt', 4, 30.0, 60.0, 10.0),
(1, 2, 'Python Básico', 'Introducción a la programación con Python', 5, 25.0, 65.0, 10.0),

(2, 3, 'HTML y CSS', 'Estructura y estilos web', 4, 20.0, 70.0, 10.0),
(2, 5, 'Bootstrap', 'Framework para diseño responsive', 3, 15.0, 75.0, 10.0),

(3, 6, 'Java Básico', 'Fundamentos de programación en Java', 6, 30.0, 60.0, 10.0),
(3, 8, 'C# Fundamentos', 'Introducción a C#', 5, 25.0, 65.0, 10.0),

(4, 9, 'MySQL', 'Bases de datos relacionales', 4, 30.0, 60.0, 10.0),
(4, 10, 'MongoDB', 'Bases de datos NoSQL', 3, 25.0, 65.0, 10.0),
(4, 11, 'PostgreSQL', 'Bases de datos avanzadas', 4, 30.0, 60.0, 10.0),

(5, 12, '.Net Core', 'Desarrollo backend con .Net', 6, 20.0, 70.0, 10.0),
(5, 13, 'Spring Boot', 'Framework Java para backend', 6, 20.0, 70.0, 10.0),
(5, 14, 'NodeJS y Express', 'JavaScript en el servidor', 5, 25.0, 65.0, 10.0);

-- 23. module_competencias 
INSERT INTO module_competencias (module_id, competencia_id) VALUES 
(1, 1),
(2, 1),
(3, 2),
(4, 2),
(5, 3),
(6, 3),
(7, 4),
(8, 4),
(9, 4),
(10, 5),
(11, 5),
(12, 5);

-- 24. module_trainers
INSERT INTO module_trainers (module_id, trainer_id, assigned_date) VALUES 
(1, 1, '2023-01-10'),
(2, 1, '2023-02-15'),
(3, 2, '2023-03-20'),
(4, 2, '2023-04-05'),
(5, 3, '2023-05-12'),
(6, 3, '2023-06-18'),
(7, 4, '2023-07-22'),
(8, 4, '2023-08-30'),
(9, 5, '2023-09-05'),
(10, 5, '2023-10-10'),
(11, 6, '2023-11-15'),
(12, 6, '2023-12-20');

-- 25. sessions
INSERT INTO sessions (module_id, name, description) VALUES 
(1, 'Variables y Operadores', 'Introducción a variables y operadores básicos'),
(1, 'Estructuras de Control', 'Condicionales y bucles'),
(2, 'Funciones en Python', 'Definición y uso de funciones'),
(2, 'Listas y Diccionarios', 'Estructuras de datos en Python'),
(3, 'Estructura HTML', 'Etiquetas básicas de HTML'),
(3, 'Estilos con CSS', 'Selectores y propiedades CSS'),
(4, 'Grid System', 'Sistema de rejilla de Bootstrap'),
(4, 'Componentes', 'Componentes preconstruidos'),
(5, 'POO en Java', 'Programación Orientada a Objetos'),
(5, 'Colecciones', 'Listas, Sets y Mapas');

-- 26. routes
INSERT INTO routes (name, description) VALUES 
('FullStack Java', 'Ruta completa con Java/Spring Boot y Angular'),
('FullStack .Net', 'Ruta completa con .Net Core y React'),
('FullStack Node', 'Ruta completa con Node/Express y Vue'),
('Backend Java', 'Especialización en backend con Java'),
('Backend .Net', 'Especialización en backend con .Net'),
('Backend Node', 'Especialización en backend con Node'),
('Frontend Angular', 'Especialización frontend con Angular'),
('Frontend React', 'Especialización frontend con React'),
('Frontend Vue', 'Especialización frontend con Vue'),
('Data Science', 'Especialización en ciencia de datos');

-- 27. route_modules 
INSERT INTO route_modules (route_id, module_id, route_order) VALUES 
(1, 1, 1),
(1, 2, 2),
(1, 5, 3),
(1, 7, 4),
(1, 11, 5),
(1, 3, 6),
(1, 4, 7),

(2, 1, 1),
(2, 2, 2),
(2, 6, 3),
(2, 7, 4),
(2, 10, 5),
(2, 3, 6),
(2, 4, 7),

(3, 1, 1),
(3, 2, 2),
(3, 12, 3),
(3, 8, 4),
(3, 3, 5),
(3, 4, 6);

-- 28. sgdb 
INSERT INTO sgdb (name, type) VALUES 
('MySQL', 'Relacional'),
('PostgreSQL', 'Relacional'),
('MongoDB', 'NoSQL'),
('SQL Server', 'Relacional'),
('Oracle', 'Relacional'),
('MariaDB', 'Relacional'),
('Redis', 'NoSQL'),
('Cassandra', 'NoSQL'),
('Firebase', 'NoSQL'),
('DynamoDB', 'NoSQL');

INSERT INTO route_sgdb (route_id, database_id, is_primary) VALUES 
(1, 1, TRUE),
(1, 3, FALSE),

(2, 4, TRUE),
(2, 2, FALSE),

(3, 3, TRUE),
(3, 1, FALSE),

(4, 2, TRUE),
(4, 3, FALSE),

(5, 4, TRUE),
(5, 5, FALSE);

-- 30. time_blocks 
INSERT INTO time_blocks (name, start_time, end_time) VALUES 
('Mañana', '08:00:00', '12:00:00'),
('Tarde', '13:00:00', '17:00:00'),
('Noche', '18:00:00', '22:00:00'),
('Intensivo Mañana', '07:00:00', '12:00:00'),
('Intensivo Tarde', '13:00:00', '18:00:00'),
('Sabatino Mañana', '08:00:00', '12:00:00'),
('Sabatino Tarde', '13:00:00', '17:00:00'),
('Dominical', '09:00:00', '13:00:00'),
('Fin de Semana Intensivo', '08:00:00', '17:00:00'),
('Personalizado 4h', '14:00:00', '18:00:00');

-- 31. schedules
INSERT INTO schedules (block_id) VALUES 
(1),
(2),
(3),
(4),
(5),
(6),
(7),
(8),
(9),
(10);

-- 32. trainer_schedules 
INSERT INTO trainer_schedules (trainer_id, day_of_week, time_block_id, is_available) VALUES 
(1, 1, 1, TRUE),  
(1, 3, 1, TRUE), 
(2, 2, 2, TRUE),  
(2, 4, 2, TRUE), 
(3, 5, 3, TRUE),  
(4, 1, 4, TRUE),  
(5, 2, 5, TRUE), 
(6, 6, 6, TRUE), 
(7, 0, 7, TRUE),  
(8, 1, 1, FALSE); 

-- 33. training_groups 
INSERT INTO training_groups (route_id, trainer_id, classroom_id, schedule_id, name, start_date, end_date) VALUES 
(1, 1, 1, 1, 'FSJ-01', '2023-01-15', '2023-06-15'),
(2, 2, 2, 2, 'FSN-01', '2023-02-20', '2023-07-20'),
(3, 3, 3, 3, 'FSNO-01', '2023-03-10', '2023-08-10'),
(4, 4, 4, 4, 'BJ-01', '2023-04-05', '2023-09-05'),
(5, 5, 5, 5, 'BN-01', '2023-05-12', '2023-10-12'),
(6, 6, 6, 6, 'BNO-01', '2023-06-18', '2023-11-18'),
(7, 7, 7, 7, 'FA-01', '2023-07-22', '2023-12-22'),
(8, 8, 8, 8, 'FR-01', '2023-08-30', '2024-01-30'),
(9, 9, 9, 9, 'FV-01', '2023-09-05', '2024-02-05'),
(10, 10, 10, 10, 'DS-01', '2023-10-10', '2024-03-10');

-- 34. camper_groups 
INSERT INTO camper_groups (camper_id, group_id, entry_date, status) VALUES 
(1, 1, '2023-01-15', 'Activo'),
(2, 2, '2023-02-20', 'Activo'),
(3, 3, '2023-03-10', 'Graduado'),
(4, 4, '2023-04-05', 'Retirado'),
(5, 5, '2023-05-12', 'Activo'),
(6, 6, '2023-06-18', 'Expulsado'),
(7, 7, '2023-07-22', 'Activo'),
(8, 8, '2023-08-30', 'Activo'),
(9, 9, '2023-09-05', 'Activo'),
(10, 10, '2023-10-10', 'Graduado');

-- 35. session_schedules
INSERT INTO session_schedules (session_id, group_id, trainer_id, date, classroom_id, start_time, end_time) VALUES 
(1, 1, 1, '2023-01-16', 1, '08:00:00', '12:00:00'),
(2, 1, 1, '2023-01-18', 1, '08:00:00', '12:00:00'),
(3, 2, 2, '2023-02-21', 2, '13:00:00', '17:00:00'),
(4, 2, 2, '2023-02-23', 2, '13:00:00', '17:00:00'),
(5, 3, 3, '2023-03-11', 3, '18:00:00', '22:00:00'),
(6, 3, 3, '2023-03-13', 3, '18:00:00', '22:00:00'),
(7, 4, 4, '2023-04-06', 4, '07:00:00', '12:00:00'),
(8, 4, 4, '2023-04-08', 4, '07:00:00', '12:00:00'),
(9, 5, 5, '2023-05-13', 5, '13:00:00', '18:00:00'),
(10, 5, 5, '2023-05-15', 5, '13:00:00', '18:00:00');

-- 36. session_attendance 
INSERT INTO session_attendance (session_schedule_id, camper_id, attendance_status, arrival_time) VALUES 
(1, 1, 'Presente', '07:55:00'),
(2, 1, 'Presente', '07:58:00'),
(3, 2, 'Presente', '12:55:00'),
(4, 2, 'Ausente', NULL),
(5, 3, 'Presente', '17:50:00'),
(6, 3, 'Tardío', '18:15:00'),
(7, 4, 'Presente', '06:55:00'),
(8, 4, 'Presente', '06:58:00'),
(9, 5, 'Presente', '12:55:00'),
(10, 5, 'Ausente', NULL);

-- 37. module_evaluations 
INSERT INTO module_evaluations (camper_id, module_id, group_id, theory_score, practice_score, quizzes_score, final_score, evaluation_date) VALUES 
(1, 1, 1, 28.5, 57.0, 9.5, 95.0, '2023-02-15'),
(1, 2, 1, 27.0, 54.0, 9.0, 90.0, '2023-03-20'),
(2, 1, 2, 25.5, 51.0, 8.5, 85.0, '2023-03-25'),
(2, 3, 2, 24.0, 48.0, 8.0, 80.0, '2023-04-30'),
(3, 1, 3, 22.5, 45.0, 7.5, 75.0, '2023-04-10'),
(3, 7, 3, 21.0, 42.0, 7.0, 70.0, '2023-05-15'),
(4, 1, 4, 19.5, 39.0, 6.5, 65.0, '2023-05-05'),
(5, 1, 5, 18.0, 36.0, 6.0, 60.0, '2023-06-12'),


(6, 1, 6, 15.0, 30.0, 5.0, 50.0, '2023-07-18'),
(7, 1, 7, 12.0, 24.0, 4.0, 40.0, '2023-08-22');

-- 38. camper_skills 
INSERT INTO camper_skills (camper_id, skill_id) VALUES 
(1, 1),
(1, 2),
(1, 3),
(2, 4),
(2, 5),
(2, 6),
(3, 7),
(3, 8),
(3, 9),
(4, 10),
(4, 11),
(4, 12),
(5, 13),
(5, 14),
(5, 15),
(6, 16),
(6, 17),
(7, 18),
(7, 19),
(8, 20),
(9, 1),
(9, 6),
(10, 11),
(10, 16);

-- 39. graduates 
INSERT INTO graduates (camper_id, route_id, final_grade) VALUES 
(3, 3, 92.5),
(10, 10, 88.0),
(3, 1, 85.5),
(10, 2, 90.0),
(3, 5, 87.5),
(10, 7, 89.0),
(3, 8, 86.5),
(10, 9, 91.0),
(3, 4, 84.0),
(10, 6, 93.5);
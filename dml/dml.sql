-- 1. Tabla countries
INSERT INTO countries (name) VALUES 
('Colombia');

-- 2. Tabla states
INSERT INTO states (country_id, name) VALUES 
(1, 'Norte de Santander'),
(1, 'Bogotá D.C.'),
(1, 'Santander');

-- 3. Tabla cities
INSERT INTO cities (state_id, name) VALUES 
(1, 'Cúcuta'),
(2, 'Bogotá'),
(3, 'Bucaramanga');

-- 4. Tabla addresses
INSERT INTO addresses (street, neighborhood, postal_code, city_id) VALUES 
('Calle 10 #5-20', 'Centro', '540001', 1),
('Carrera 15 #32-45', 'Chapinero', '110231', 2),
('Avenida 27 #15-30', 'Cabecera', '680003', 3),
('Calle 20 #8-15', 'La Playa', '540002', 1),
('Carrera 7 #22-10', 'Usaquén', '110011', 2),
('Avenida 33 #25-40', 'García Rovira', '680004', 3),
('Calle 15 #10-25', 'San Miguel', '540003', 1),
('Carrera 11 #45-12', 'Teusaquillo', '110321', 2),
('Avenida 30 #20-15', 'Provenza', '680005', 3),
('Calle 25 #12-30', 'Atalaya', '540004', 1),
('Carrera 19 #35-20', 'La Candelaria', '110141', 2),
('Avenida 36 #18-22', 'San Francisco', '680006', 3),
('Calle 30 #5-10', 'Vergel', '540005', 1),
('Carrera 13 #28-15', 'Santa Bárbara', '110221', 2),
('Avenida 40 #12-30', 'Mutis', '680007', 3),
('Calle 35 #8-25', 'La Libertad', '540006', 1),
('Carrera 9 #40-10', 'La Macarena', '110311', 2),
('Avenida 45 #15-18', 'Alvarez', '680008', 3),
('Calle 40 #10-35', 'Los Patios', '540007', 1),
('Carrera 5 #32-20', 'Las Cruces', '110121', 2),
('Avenida 50 #22-15', 'Morrorico', '680009', 3),
('Calle 45 #15-40', 'Villa del Rosario', '540008', 1),
('Carrera 17 #38-12', 'La Perseverancia', '110411', 2),
('Avenida 55 #28-20', 'Pedregosa', '680010', 3),
('Calle 50 #20-10', 'San Rafael', '540009', 1),
('Carrera 21 #42-15', 'La Soledad', '110511', 2),
('Avenida 60 #32-25', 'San Alonso', '680011', 3),
('Calle 55 #25-30', 'Juan Atalaya', '540010', 1),
('Carrera 23 #45-18', 'Las Nieves', '110611', 2),
('Avenida 65 #35-12', 'Cañaveral', '680012', 3),
('Calle 60 #30-15', 'La Parada', '540011', 1),
('Carrera 25 #48-20', 'La Peña', '110711', 2),
('Avenida 70 #38-10', 'Ruitoque', '680013', 3),
('Calle 65 #35-25', 'San José', '540012', 1),
('Carrera 27 #50-12', 'Las Aguas', '110811', 2),
('Avenida 75 #42-15', 'Floridablanca', '680014', 3),
('Calle 70 #40-20', 'San Martín', '540013', 1),
('Carrera 29 #52-10', 'La Merced', '110911', 2),
('Avenida 80 #45-18', 'Girón', '680015', 3),
('Calle 75 #45-30', 'San Pablo', '540014', 1),
('Carrera 31 #55-15', 'La Concordia', '111011', 2),
('Avenida 85 #48-12', 'Piedecuesta', '680016', 3),
('Calle 80 #50-25', 'San Pedro', '540015', 1),
('Carrera 33 #58-20', 'Las Ferias', '111111', 2),
('Avenida 90 #52-15', 'Lebrija', '680017', 3),
('Calle 85 #55-30', 'San Luis', '540016', 1),
('Carrera 35 #60-12', 'La Esmeralda', '111211', 2),
('Avenida 95 #55-18', 'Zapatoca', '680018', 3),
('Calle 90 #60-20', 'San Simón', '540017', 1);

-- 5. Tabla company
INSERT INTO company (name, nit, address_id) VALUES 
('CampusLands', '901234567-8', 1);

-- 6. Tabla branches
INSERT INTO branches (company_id, name, address_id) VALUES 
(1, 'Campus Cúcuta', 1),
(1, 'Campus Bogotá', 2),
(1, 'Campus Bucaramanga', 3);

-- 7. Tabla classrooms (6 por sede)
INSERT INTO classrooms (campus_id, name, capacity) VALUES 
-- Cúcuta
(1, 'Aula 101', 33),
(1, 'Aula 102', 33),
(1, 'Aula 103', 33),
(1, 'Laboratorio 101', 20),
(1, 'Auditorio', 100),
(1, 'Sala de reuniones', 15),

-- Bogotá
(2, 'Aula 201', 33),
(2, 'Aula 202', 33),
(2, 'Aula 203', 33),
(2, 'Laboratorio 201', 20),
(2, 'Auditorio', 120),
(2, 'Sala de reuniones', 15),

-- Bucaramanga
(3, 'Aula 301', 33),
(3, 'Aula 302', 33),
(3, 'Aula 303', 33),
(3, 'Laboratorio 301', 20),
(3, 'Auditorio', 80),
(3, 'Sala de reuniones', 15);

-- 8. Tabla document_types
INSERT INTO document_types (name, abbreviation) VALUES 
('Tarjeta de Identidad', 'TI'),
('Cédula de Ciudadanía', 'CC'),
('Cédula de Extranjería', 'CE'),
('Pasaporte', 'PA');

-- 9. Tabla phone_types
INSERT INTO phone_types (name) VALUES 
('Móvil'),
('Fijo');

-- 10. Tabla camper_statuses
INSERT INTO camper_statuses (name) VALUES 
('En proceso de ingreso'),
('Inscrito'),
('Aprobado'),
('Cursando'),
('Graduado'),
('Expulsado'),
('Retirado');

-- 11. Tabla risk_levels
INSERT INTO risk_levels (name) VALUES 
('Bajo'),
('Medio'),
('Alto');

-- 12. Tabla skills
INSERT INTO skills (name, type, description) VALUES 
('Programación', 'Software', 'Habilidades en desarrollo de software'),
('Bases de datos', 'Software', 'Manejo de sistemas gestores de bases de datos'),
('Inglés', 'Idioma', 'Competencias en el idioma inglés'),
('Ser', 'Habilidades blandas', 'Desarrollo personal y habilidades interpersonales'),
('Algoritmia', 'Software', 'Fundamentos de programación y lógica'),
('Python', 'Software', 'Lenguaje de programación Python'),
('PSeInt', 'Software', 'Herramienta para aprender algoritmos'),
('HTML', 'Software', 'Lenguaje de marcado para la web'),
('CSS', 'Software', 'Lenguaje de estilos para la web'),
('Bootstrap', 'Software', 'Framework para diseño web responsive'),
('Java', 'Software', 'Lenguaje de programación Java'),
('JavaScript', 'Software', 'Lenguaje de programación para la web'),
('C#', 'Software', 'Lenguaje de programación C#'),
('MySQL', 'Software', 'Sistema gestor de bases de datos relacional'),
('MongoDB', 'Software', 'Sistema gestor de bases de datos NoSQL'),
('PostgreSQL', 'Software', 'Sistema gestor de bases de datos relacional avanzado'),
('NetCore', 'Software', 'Framework para desarrollo backend'),
('Spring Boot', 'Software', 'Framework para desarrollo Java backend'),
('NodeJS', 'Software', 'Entorno de ejecución para JavaScript'),
('Express', 'Software', 'Framework para NodeJS');

-- 13. Tabla time_blocks (horarios)
INSERT INTO time_blocks (name, start_time, end_time) VALUES 
('Mañana temprano', '06:00:00', '09:00:00'),
('Mañana tarde', '10:00:00', '13:00:00'),
('Tarde', '14:00:00', '17:00:00'),
('Noche', '18:00:00', '21:00:00');

-- 14. Tabla schedules
INSERT INTO schedules (block_id) VALUES 
(1), (2), (3), (4);

-- 15. Tabla routes
INSERT INTO routes (name, description) VALUES 
('Fundamentos de programación', 'Introducción a la algoritmia, PSeInt y Python'),
('Programación Web', 'HTML, CSS y Bootstrap'),
('Programación formal', 'Java, JavaScript, C#'),
('Bases de datos', 'MySQL, MongoDB y PostgreSQL'),
('Backend', 'NetCore, Spring Boot, NodeJS y Express'),
('Inglés Básico', 'Curso de inglés nivel básico'),
('Inglés Intermedio', 'Curso de inglés nivel intermedio'),
('Inglés Avanzado', 'Curso de inglés nivel avanzado'),
('Ser', 'Desarrollo personal y habilidades blandas');

-- 16. Tabla module_categories
INSERT INTO module_categories (name) VALUES 
('Fundamentos'),
('Desarrollo Web'),
('Programación Avanzada'),
('Bases de Datos'),
('Backend'),
('Idiomas'),
('Habilidades Blandas');

-- 17. Tabla modules
INSERT INTO modules (category_id, skill_id, name, description, duration_weeks) VALUES 
-- Fundamentos de programación
(1, 5, 'Algoritmia', 'Introducción a la lógica de programación', 4),
(1, 6, 'Python Básico', 'Fundamentos del lenguaje Python', 4),
(1, 7, 'PSeInt', 'Herramienta para aprender algoritmos', 2),

-- Programación Web
(2, 8, 'HTML', 'Estructura de páginas web', 3),
(2, 9, 'CSS', 'Estilos para páginas web', 3),
(2, 10, 'Bootstrap', 'Framework para diseño responsive', 2),

-- Programación formal
(3, 11, 'Java', 'Programación orientada a objetos con Java', 6),
(3, 12, 'JavaScript', 'Programación para la web', 4),
(3, 13, 'C#', 'Lenguaje de programación C#', 4),

-- Bases de datos
(4, 14, 'MySQL', 'Bases de datos relacionales', 4),
(4, 15, 'MongoDB', 'Bases de datos NoSQL', 3),
(4, 16, 'PostgreSQL', 'Bases de datos relacional avanzado', 3),

-- Backend
(5, 17, 'NetCore', 'Desarrollo backend con .NET', 5),
(5, 18, 'Spring Boot', 'Desarrollo backend con Java', 5),
(5, 19, 'NodeJS', 'JavaScript en el servidor', 4),
(5, 20, 'Express', 'Framework para NodeJS', 3),

-- Inglés
(6, 3, 'Inglés Básico', 'Nivel A1-A2', 8),
(6, 3, 'Inglés Intermedio', 'Nivel B1-B2', 8),
(6, 3, 'Inglés Avanzado', 'Nivel C1-C2', 8),

-- Ser
(7, 4, 'Comunicación efectiva', 'Habilidades de comunicación', 2),
(7, 4, 'Trabajo en equipo', 'Colaboración efectiva', 2),
(7, 4, 'Liderazgo', 'Habilidades de liderazgo', 2),
(7, 4, 'Gestión del tiempo', 'Organización personal', 2);

-- 18. Tabla route_modules
INSERT INTO route_modules (route_id, module_id, route_order) VALUES 
-- Fundamentos de programación
(1, 1, 1),
(1, 2, 2),
(1, 3, 3),

-- Programación Web
(2, 4, 1),
(2, 5, 2),
(2, 6, 3),

-- Programación formal
(3, 7, 1),
(3, 8, 2),
(3, 9, 3),

-- Bases de datos
(4, 10, 1),
(4, 11, 2),
(4, 12, 3),

-- Backend
(5, 13, 1),
(5, 14, 2),
(5, 15, 3),
(5, 16, 4),

-- Inglés Básico
(6, 17, 1),

-- Inglés Intermedio
(7, 18, 1),

-- Inglés Avanzado
(8, 19, 1),

-- Ser
(9, 20, 1),
(9, 21, 2),
(9, 22, 3),
(9, 23, 4);

-- 19. Tabla sgdb
INSERT INTO sgdb (name, type) VALUES 
('MySQL', 'Relacional'),
('MongoDB', 'NoSQL'),
('PostgreSQL', 'Relacional');

-- 20. Tabla route_sgdb
INSERT INTO route_sgdb (route_id, database_id, is_primary) VALUES 
(1, 1, 1), (1, 3, 0),  -- Fundamentos (MySQL primario, PostgreSQL alternativo)
(2, 1, 1), (2, 3, 0),  -- Web (MySQL primario, PostgreSQL alternativo)
(3, 1, 1), (3, 2, 0),  -- Formal (MySQL primario, MongoDB alternativo)
(4, 1, 1), (4, 2, 0), (4, 3, 0),  -- Bases de datos (MySQL primario, otros alternativos)
(5, 1, 1), (5, 3, 0);  -- Backend (MySQL primario, PostgreSQL alternativo)

-- 21. Tabla persons (50 registros)
INSERT INTO persons (document_type_id, document_number, first_name, last_name, email, address_id, birth_date) VALUES 
-- Trainers Bucaramanga (3)
(2, '12345678', 'Jholver', 'Pardo', 'jholver.pardo@campuslands.com', 3, '1985-05-15'),
(2, '87654321', 'Adrian', 'Suarez', 'adrian.suarez@campuslands.com', 3, '1988-07-22'),
(2, '13579246', 'Juan', 'Nariño', 'juan.nariño@campuslands.com', 3, '1990-11-30'),

-- Trainers Bogotá (3)
(2, '24681357', 'Carlos', 'Mendoza', 'carlos.mendoza@campuslands.com', 2, '1987-03-18'),
(2, '98765432', 'Laura', 'Gómez', 'laura.gomez@campuslands.com', 2, '1991-09-25'),
(2, '86420975', 'Ricardo', 'Fernández', 'ricardo.fernandez@campuslands.com', 2, '1983-12-05'),

-- Trainers Cúcuta (3)
(2, '75395182', 'María', 'Rodríguez', 'maria.rodriguez@campuslands.com', 1, '1986-08-14'),
(2, '15935728', 'Pedro', 'Martínez', 'pedro.martinez@campuslands.com', 1, '1989-04-20'),
(2, '35715926', 'Ana', 'López', 'ana.lopez@campuslands.com', 1, '1992-01-10'),

-- Campers (41)
(1, '1000000001', 'Sofía', 'García', 'sofia.garcia@example.com', 4, '2000-02-15'),
(1, '1000000002', 'Juan', 'Pérez', 'juan.perez@example.com', 5, '2001-03-20'),
(1, '1000000003', 'María', 'Rodríguez', 'maria.rodriguez@example.com', 6, '1999-05-10'),
(1, '1000000004', 'Carlos', 'Martínez', 'carlos.martinez@example.com', 7, '2000-07-25'),
(1, '1000000005', 'Laura', 'López', 'laura.lopez@example.com', 8, '2001-09-30'),
(1, '1000000006', 'Andrés', 'González', 'andres.gonzalez@example.com', 9, '1999-11-05'),
(1, '1000000007', 'Ana', 'Hernández', 'ana.hernandez@example.com', 10, '2000-01-12'),
(1, '1000000008', 'David', 'Díaz', 'david.diaz@example.com', 11, '2001-04-18'),
(1, '1000000009', 'Paula', 'Moreno', 'paula.moreno@example.com', 12, '1999-06-22'),
(1, '1000000010', 'Javier', 'Álvarez', 'javier.alvarez@example.com', 13, '2000-08-28'),
(1, '1000000011', 'Daniela', 'Romero', 'daniela.romero@example.com', 14, '2001-10-03'),
(1, '1000000012', 'Alejandro', 'Sánchez', 'alejandro.sanchez@example.com', 15, '1999-12-08'),
(1, '1000000013', 'Valentina', 'Torres', 'valentina.torres@example.com', 16, '2000-02-14'),
(1, '1000000014', 'Sebastián', 'Ramírez', 'sebastian.ramirez@example.com', 17, '2001-04-19'),
(1, '1000000015', 'Camila', 'Flórez', 'camila.florez@example.com', 18, '1999-06-24'),
(1, '1000000016', 'Mateo', 'Rojas', 'mateo.rojas@example.com', 19, '2000-08-29'),
(1, '1000000017', 'Isabella', 'Vargas', 'isabella.vargas@example.com', 20, '2001-11-02'),
(1, '1000000018', 'Samuel', 'Molina', 'samuel.molina@example.com', 21, '1999-01-07'),
(1, '1000000019', 'Valeria', 'Castro', 'valeria.castro@example.com', 22, '2000-03-13'),
(1, '1000000020', 'Nicolás', 'Gutiérrez', 'nicolas.gutierrez@example.com', 23, '2001-05-18'),
(1, '1000000021', 'Mariana', 'Ortiz', 'mariana.ortiz@example.com', 24, '1999-07-23'),
(1, '1000000022', 'Diego', 'Jiménez', 'diego.jimenez@example.com', 25, '2000-09-27'),
(1, '1000000023', 'Gabriela', 'Ruiz', 'gabriela.ruiz@example.com', 26, '2001-12-01'),
(1, '1000000024', 'Miguel', 'Silva', 'miguel.silva@example.com', 27, '1999-02-06'),
(1, '1000000025', 'Sara', 'Méndez', 'sara.mendez@example.com', 28, '2000-04-11'),
(1, '1000000026', 'Jorge', 'Herrera', 'jorge.herrera@example.com', 29, '2001-06-16'),
(1, '1000000027', 'Lucía', 'Ríos', 'lucia.rios@example.com', 30, '1999-08-21'),
(1, '1000000028', 'Felipe', 'Córdoba', 'felipe.cordoba@example.com', 31, '2000-10-26'),
(1, '1000000029', 'Catalina', 'Peña', 'catalina.pena@example.com', 32, '2001-12-31'),
(1, '1000000030', 'Daniel', 'Aguilar', 'daniel.aguilar@example.com', 33, '1999-03-05'),
(1, '1000000031', 'Juliana', 'Santos', 'juliana.santos@example.com', 34, '2000-05-10'),
(1, '1000000032', 'Esteban', 'Guerrero', 'esteban.guerrero@example.com', 35, '2001-07-15'),
(1, '1000000033', 'Carolina', 'Navarro', 'carolina.navarro@example.com', 36, '1999-09-20'),
(1, '1000000034', 'Oscar', 'Salazar', 'oscar.salazar@example.com', 37, '2000-11-25'),
(1, '1000000035', 'Fernanda', 'Vega', 'fernanda.vega@example.com', 38, '2001-01-30'),
(1, '1000000036', 'Gustavo', 'Campos', 'gustavo.campos@example.com', 39, '1999-04-04'),
(1, '1000000037', 'Adriana', 'Fuentes', 'adriana.fuentes@example.com', 40, '2000-06-09'),
(1, '1000000038', 'Hugo', 'Reyes', 'hugo.reyes@example.com', 41, '2001-08-14'),
(1, '1000000039', 'Patricia', 'Acosta', 'patricia.acosta@example.com', 42, '1999-10-19'),
(1, '1000000040', 'Raúl', 'Medina', 'raul.medina@example.com', 43, '2000-12-24'),
(1, '1000000041', 'Tatiana', 'Paredes', 'tatiana.paredes@example.com', 44, '2001-02-28');

-- 22. Tabla person_phones
INSERT INTO person_phones (person_id, phone_type_id, number) VALUES 
-- Trainers Bucaramanga
(1, 1, '3171234567'),
(2, 1, '3182345678'),
(3, 1, '3193456789'),

-- Trainers Bogotá
(4, 1, '3104567890'),
(5, 1, '3115678901'),
(6, 1, '3126789012'),

-- Trainers Cúcuta
(7, 1, '3137890123'),
(8, 1, '3148901234'),
(9, 1, '3159012345'),

-- Campers (3 números cada uno)
(10, 1, '3001234567'), (10, 2, '5761234'),
(11, 1, '3012345678'), (11, 2, '5762345'),
(12, 1, '3023456789'), (12, 2, '5763456'),
(13, 1, '3034567890'), (13, 2, '5764567'),
(14, 1, '3045678901'), (14, 2, '5765678'),
(15, 1, '3056789012'), (15, 2, '5766789'),
(16, 1, '3067890123'), (16, 2, '5767890'),
(17, 1, '3078901234'), (17, 2, '5768901'),
(18, 1, '3089012345'), (18, 2, '5769012'),
(19, 1, '3090123456'), (19, 2, '5760123'),
(20, 1, '3101234567'), (20, 2, '5761234'),
(21, 1, '3112345678'), (21, 2, '5762345'),
(22, 1, '3123456789'), (22, 2, '5763456'),
(23, 1, '3134567890'), (23, 2, '5764567'),
(24, 1, '3145678901'), (24, 2, '5765678'),
(25, 1, '3156789012'), (25, 2, '5766789'),
(26, 1, '3167890123'), (26, 2, '5767890'),
(27, 1, '3178901234'), (27, 2, '5768901'),
(28, 1, '3189012345'), (28, 2, '5769012'),
(29, 1, '3190123456'), (29, 2, '5760123'),
(30, 1, '3201234567'), (30, 2, '5761234'),
(31, 1, '3212345678'), (31, 2, '5762345'),
(32, 1, '3223456789'), (32, 2, '5763456'),
(33, 1, '3234567890'), (33, 2, '5764567'),
(34, 1, '3245678901'), (34, 2, '5765678'),
(35, 1, '3256789012'), (35, 2, '5766789'),
(36, 1, '3267890123'), (36, 2, '5767890'),
(37, 1, '3278901234'), (37, 2, '5768901'),
(38, 1, '3289012345'), (38, 2, '5769012'),
(39, 1, '3290123456'), (39, 2, '5760123'),
(40, 1, '3301234567'), (40, 2, '5761234'),
(41, 1, '3312345678'), (41, 2, '5762345'),
(42, 1, '3323456789'), (42, 2, '5763456'),
(43, 1, '3334567890'), (43, 2, '5764567'),
(44, 1, '3345678901'), (44, 2, '5765678'),
(45, 1, '3356789012'), (45, 2, '5766789'),
(46, 1, '3367890123'), (46, 2, '5767890'),
(47, 1, '3378901234'), (47, 2, '5768901'),
(48, 1, '3389012345'), (48, 2, '5769012'),
(49, 1, '3390123456'), (49, 2, '5760123'),
(50, 1, '3401234567'), (50, 2, '5761234');

-- 23. Tabla trainers
INSERT INTO trainers (person_id, campus_id, acronym) VALUES 
(1, 3, 'J'),  -- Bucaramanga
(2, 3, 'A'),
(3, 3, 'J'),
(4, 2, 'C'),  -- Bogotá
(5, 2, 'L'),
(6, 2, 'R'),
(7, 1, 'M'),  -- Cúcuta
(8, 1, 'P'),
(9, 1, 'A');

-- 24. Tabla campers
INSERT INTO campers (person_id, status_id, risk_level_id, entry_date) VALUES 
(10, 4, 1, '2023-01-10'),
(11, 4, 1, '2023-01-10'),
(12, 4, 2, '2023-01-10'),
(13, 4, 1, '2023-01-10'),
(14, 4, 1, '2023-01-10'),
(15, 4, 3, '2023-01-10'),
(16, 4, 1, '2023-01-10'),
(17, 4, 2, '2023-01-10'),
(18, 4, 1, '2023-01-10'),
(19, 4, 1, '2023-01-10'),
(20, 4, 1, '2023-01-10'),
(21, 4, 2, '2023-01-10'),
(22, 4, 1, '2023-01-10'),
(23, 4, 1, '2023-01-10'),
(24, 4, 3, '2023-01-10'),
(25, 4, 1, '2023-01-10'),
(26, 4, 1, '2023-01-10'),
(27, 4, 1, '2023-01-10'),
(28, 4, 2, '2023-01-10'),
(29, 4, 1, '2023-01-10'),
(30, 4, 1, '2023-01-10'),
(31, 4, 1, '2023-01-10'),
(32, 4, 3, '2023-01-10'),
(33, 4, 1, '2023-01-10'),
(34, 4, 1, '2023-01-10'),
(35, 4, 2, '2023-01-10'),
(36, 4, 1, '2023-01-10'),
(37, 4, 1, '2023-01-10'),
(38, 4, 1, '2023-01-10'),
(39, 4, 2, '2023-01-10'),
(40, 4, 1, '2023-01-10'),
(41, 4, 1, '2023-01-10'),
(42, 4, 3, '2023-01-10'),
(43, 4, 1, '2023-01-10'),
(44, 4, 1, '2023-01-10'),
(45, 4, 1, '2023-01-10'),
(46, 4, 2, '2023-01-10'),
(47, 4, 1, '2023-01-10'),
(48, 4, 1, '2023-01-10'),
(49, 4, 1, '2023-01-10'),
(50, 4, 3, '2023-01-10');

-- 25. Tabla guardians
INSERT INTO guardians (camper_id, person_id, relationship) VALUES 
(1, 10, 'Padre'),
(2, 11, 'Madre'),
(3, 12, 'Padre'),
(4, 13, 'Madre'),
(5, 14, 'Padre'),
(6, 15, 'Madre'),
(7, 16, 'Padre'),
(8, 17, 'Madre'),
(9, 18, 'Padre'),
(10, 19, 'Madre'),
(11, 20, 'Padre'),
(12, 21, 'Madre'),
(13, 22, 'Padre'),
(14, 23, 'Madre'),
(15, 24, 'Padre'),
(16, 25, 'Madre'),
(17, 26, 'Padre'),
(18, 27, 'Madre'),
(19, 28, 'Padre'),
(20, 29, 'Madre'),
(21, 30, 'Padre'),
(22, 31, 'Madre'),
(23, 32, 'Padre'),
(24, 33, 'Madre'),
(25, 34, 'Padre'),
(26, 35, 'Madre'),
(27, 36, 'Padre'),
(28, 37, 'Madre'),
(29, 38, 'Padre'),
(30, 39, 'Madre'),
(31, 40, 'Padre'),
(32, 41, 'Madre'),
(33, 42, 'Padre'),
(34, 43, 'Madre'),
(35, 44, 'Padre'),
(36, 45, 'Madre'),
(37, 46, 'Padre'),
(38, 47, 'Madre'),
(39, 48, 'Padre'),
(40, 49, 'Madre'),
(41, 50, 'Padre');

-- 26. Tabla status_history
INSERT INTO status_history (camper_id, previous_status_id, new_status_id, change_date) VALUES 
(1, 1, 2, '2022-12-01 10:00:00'),
(1, 2, 3, '2022-12-15 14:30:00'),
(1, 3, 4, '2023-01-10 08:00:00'),
(2, 1, 2, '2022-12-02 11:00:00'),
(2, 2, 3, '2022-12-16 15:30:00'),
(2, 3, 4, '2023-01-10 08:00:00'),
(3, 1, 2, '2022-12-03 09:00:00'),
(3, 2, 3, '2022-12-17 16:00:00'),
(3, 3, 4, '2023-01-10 08:00:00'),
(4, 1, 2, '2022-12-04 10:30:00'),
(4, 2, 3, '2022-12-18 14:00:00'),
(4, 3, 4, '2023-01-10 08:00:00'),
(5, 1, 2, '2022-12-05 11:30:00'),
(5, 2, 3, '2022-12-19 15:00:00'),
(5, 3, 4, '2023-01-10 08:00:00'),
(6, 1, 2, '2022-12-06 09:30:00'),
(6, 2, 3, '2022-12-20 16:30:00'),
(6, 3, 4, '2023-01-10 08:00:00'),
(7, 1, 2, '2022-12-07 10:00:00'),
(7, 2, 3, '2022-12-21 14:00:00'),
(7, 3, 4, '2023-01-10 08:00:00'),
(8, 1, 2, '2022-12-08 11:00:00'),
(8, 2, 3, '2022-12-22 15:00:00'),
(8, 3, 4, '2023-01-10 08:00:00'),
(9, 1, 2, '2022-12-09 09:00:00'),
(9, 2, 3, '2022-12-23 16:00:00'),
(9, 3, 4, '2023-01-10 08:00:00'),
(10, 1, 2, '2022-12-10 10:30:00'),
(10, 2, 3, '2022-12-24 14:30:00'),
(10, 3, 4, '2023-01-10 08:00:00'),
(11, 1, 2, '2022-12-11 11:30:00'),
(11, 2, 3, '2022-12-25 15:30:00'),
(11, 3, 4, '2023-01-10 08:00:00'),
(12, 1, 2, '2022-12-12 09:30:00'),
(12, 2, 3, '2022-12-26 16:30:00'),
(12, 3, 4, '2023-01-10 08:00:00'),
(13, 1, 2, '2022-12-13 10:00:00'),
(13, 2, 3, '2022-12-27 14:00:00'),
(13, 3, 4, '2023-01-10 08:00:00'),
(14, 1, 2, '2022-12-14 11:00:00'),
(14, 2, 3, '2022-12-28 15:00:00'),
(14, 3, 4, '2023-01-10 08:00:00'),
(15, 1, 2, '2022-12-15 09:00:00'),
(15, 2, 3, '2022-12-29 16:00:00'),
(15, 3, 4, '2023-01-10 08:00:00'),
(16, 1, 2, '2022-12-16 10:30:00'),
(16, 2, 3, '2022-12-30 14:30:00'),
(16, 3, 4, '2023-01-10 08:00:00'),
(17, 1, 2, '2022-12-17 11:30:00'),
(17, 2, 3, '2022-12-31 15:30:00'),
(17, 3, 4, '2023-01-10 08:00:00'),
(18, 1, 2, '2022-12-18 09:30:00'),
(18, 2, 3, '2023-01-01 16:30:00'),
(18, 3, 4, '2023-01-10 08:00:00'),
(19, 1, 2, '2022-12-19 10:00:00'),
(19, 2, 3, '2023-01-02 14:00:00'),
(19, 3, 4, '2023-01-10 08:00:00'),
(20, 1, 2, '2022-12-20 11:00:00'),
(20, 2, 3, '2023-01-03 15:00:00'),
(20, 3, 4, '2023-01-10 08:00:00'),
(21, 1, 2, '2022-12-21 09:00:00'),
(21, 2, 3, '2023-01-04 16:00:00'),
(21, 3, 4, '2023-01-10 08:00:00'),
(22, 1, 2, '2022-12-22 10:30:00'),
(22, 2, 3, '2023-01-05 14:30:00'),
(22, 3, 4, '2023-01-10 08:00:00'),
(23, 1, 2, '2022-12-23 11:30:00'),
(23, 2, 3, '2023-01-06 15:30:00'),
(23, 3, 4, '2023-01-10 08:00:00'),
(24, 1, 2, '2022-12-24 09:30:00'),
(24, 2, 3, '2023-01-07 16:30:00'),
(24, 3, 4, '2023-01-10 08:00:00'),
(25, 1, 2, '2022-12-25 10:00:00'),
(25, 2, 3, '2023-01-08 14:00:00'),
(25, 3, 4, '2023-01-10 08:00:00'),
(26, 1, 2, '2022-12-26 11:00:00'),
(26, 2, 3, '2023-01-09 15:00:00'),
(26, 3, 4, '2023-01-10 08:00:00'),
(27, 1, 2, '2022-12-27 09:00:00'),
(27, 2, 3, '2023-01-10 16:00:00'),
(27, 3, 4, '2023-01-10 08:00:00'),
(28, 1, 2, '2022-12-28 10:30:00'),
(28, 2, 3, '2023-01-11 14:30:00'),
(28, 3, 4, '2023-01-10 08:00:00'),
(29, 1, 2, '2022-12-29 11:30:00'),
(29, 2, 3, '2023-01-12 15:30:00'),
(29, 3, 4, '2023-01-10 08:00:00'),
(30, 1, 2, '2022-12-30 09:30:00'),
(30, 2, 3, '2023-01-13 16:30:00'),
(30, 3, 4, '2023-01-10 08:00:00'),
(31, 1, 2, '2022-12-31 10:00:00'),
(31, 2, 3, '2023-01-14 14:00:00'),
(31, 3, 4, '2023-01-10 08:00:00'),
(32, 1, 2, '2023-01-01 11:00:00'),
(32, 2, 3, '2023-01-15 15:00:00'),
(32, 3, 4, '2023-01-10 08:00:00'),
(33, 1, 2, '2023-01-02 09:00:00'),
(33, 2, 3, '2023-01-16 16:00:00'),
(33, 3, 4, '2023-01-10 08:00:00'),
(34, 1, 2, '2023-01-03 10:30:00'),
(34, 2, 3, '2023-01-17 14:30:00'),
(34, 3, 4, '2023-01-10 08:00:00'),
(35, 1, 2, '2023-01-04 11:30:00'),
(35, 2, 3, '2023-01-18 15:30:00'),
(35, 3, 4, '2023-01-10 08:00:00'),
(36, 1, 2, '2023-01-05 09:30:00'),
(36, 2, 3, '2023-01-19 16:30:00'),
(36, 3, 4, '2023-01-10 08:00:00'),
(37, 1, 2, '2023-01-06 10:00:00'),
(37, 2, 3, '2023-01-20 14:00:00'),
(37, 3, 4, '2023-01-10 08:00:00'),
(38, 1, 2, '2023-01-07 11:00:00'),
(38, 2, 3, '2023-01-21 15:00:00'),
(38, 3, 4, '2023-01-10 08:00:00'),
(39, 1, 2, '2023-01-08 09:00:00'),
(39, 2, 3, '2023-01-22 16:00:00'),
(39, 3, 4, '2023-01-10 08:00:00'),
(40, 1, 2, '2023-01-09 10:30:00'),
(40, 2, 3, '2023-01-23 14:30:00'),
(40, 3, 4, '2023-01-10 08:00:00'),
(41, 1, 2, '2023-01-10 11:30:00'),
(41, 2, 3, '2023-01-24 15:30:00'),
(41, 3, 4, '2023-01-10 08:00:00');

-- 27. Tabla competencias
INSERT INTO competencias (name, description) VALUES 
('Programación Orientada a Objetos', 'Dominio de los principios de POO'),
('Desarrollo Web Frontend', 'Habilidades en desarrollo de interfaces web'),
('Desarrollo Backend', 'Habilidades en desarrollo de servidores y APIs'),
('Bases de Datos Relacionales', 'Manejo de sistemas relacionales'),
('Bases de Datos NoSQL', 'Manejo de sistemas no relacionales'),
('Metodologías Ágiles', 'Conocimiento de Scrum y Kanban'),
('Inglés Técnico', 'Comprensión de documentación técnica en inglés'),
('Trabajo en Equipo', 'Habilidad para colaborar efectivamente'),
('Resolución de Problemas', 'Capacidad analítica para resolver problemas complejos'),
('Algoritmos y Estructuras de Datos', 'Conocimiento de algoritmos fundamentales');

-- 28. Tabla trainer_competencias
INSERT INTO trainer_competencias (trainer_id, competencia_id) VALUES 
-- Trainers Bucaramanga
(1, 1), (1, 3), (1, 4), (1, 9),
(2, 2), (2, 3), (2, 5), (2, 7),
(3, 1), (3, 6), (3, 8), (3, 10),

-- Trainers Bogotá
(4, 1), (4, 4), (4, 9), (4, 10),
(5, 2), (5, 3), (5, 5), (5, 7),
(6, 1), (6, 6), (6, 8), (6, 10),

-- Trainers Cúcuta
(7, 2), (7, 3), (7, 4), (7, 7),
(8, 1), (8, 5), (8, 6), (8, 9),
(9, 2), (9, 3), (9, 8), (9, 10);

-- 29. Tabla notifications
INSERT INTO notifications (trainer_id, message, created_at) VALUES 
(1, 'Recordatorio: Reunión de profesores mañana a las 10am', '2023-03-15 16:30:00'),
(2, 'Nuevo material disponible para el módulo de Python', '2023-03-16 09:15:00'),
(3, 'Cambio de aula para la clase del viernes', '2023-03-17 11:45:00'),
(4, 'Evaluación de progreso pendiente', '2023-03-18 14:20:00'),
(5, 'Taller de actualización el próximo lunes', '2023-03-19 10:00:00'),
(6, 'Recordatorio enviar calificaciones', '2023-03-20 15:30:00'),
(7, 'Problemas con el servidor de bases de datos', '2023-03-21 08:45:00'),
(8, 'Revisión de currículo programada', '2023-03-22 13:10:00'),
(9, 'Encuesta de satisfacción disponible', '2023-03-23 17:00:00'),
(1, 'Actualización del sistema este fin de semana', '2023-03-24 09:30:00'),
(2, 'Capacitación en nuevas tecnologías', '2023-03-25 11:20:00'),
(3, 'Cambios en el horario de clases', '2023-03-26 14:50:00'),
(4, 'Recordatorio: Entrega de informes', '2023-03-27 10:15:00'),
(5, 'Nuevos recursos disponibles en la plataforma', '2023-03-28 16:40:00'),
(6, 'Problemas con el acceso a Moodle', '2023-03-29 08:30:00'),
(7, 'Reunión de coordinación académica', '2023-03-30 12:00:00'),
(8, 'Actualización de políticas de evaluación', '2023-03-31 15:20:00'),
(9, 'Encuesta de necesidades de formación', '2023-04-01 09:45:00'),
(1, 'Mantenimiento programado del sistema', '2023-04-02 14:10:00'),
(2, 'Taller de metodologías ágiles', '2023-04-03 17:30:00');

-- 30. Tabla module_competencias
INSERT INTO module_competencias (module_id, competencia_id) VALUES 
-- Fundamentos
(1, 9), (1, 10),
(2, 1), (2, 9),
(3, 10),

-- Web
(4, 2), (5, 2), (6, 2),

-- Programación formal
(7, 1), (7, 9),
(8, 1), (8, 2),
(9, 1),

-- Bases de datos
(10, 4), (11, 5), (12, 4),

-- Backend
(13, 3), (14, 3), (15, 3), (16, 3),

-- Inglés
(17, 7), (18, 7), (19, 7),

-- Ser
(20, 8), (21, 8), (22, 8), (23, 8);

-- 31. Tabla module_trainers
INSERT INTO module_trainers (module_id, trainer_id, assigned_date) VALUES 
-- Trainers Bucaramanga
(1, 1, '2023-01-05'), (2, 1, '2023-01-05'), (7, 1, '2023-01-05'),
(4, 2, '2023-01-05'), (5, 2, '2023-01-05'), (8, 2, '2023-01-05'),
(3, 3, '2023-01-05'), (6, 3, '2023-01-05'), (9, 3, '2023-01-05'),

-- Trainers Bogotá
(10, 4, '2023-01-05'), (11, 4, '2023-01-05'), (12, 4, '2023-01-05'),
(13, 5, '2023-01-05'), (14, 5, '2023-01-05'), (15, 5, '2023-01-05'),
(16, 6, '2023-01-05'), (17, 6, '2023-01-05'), (18, 6, '2023-01-05'),

-- Trainers Cúcuta
(19, 7, '2023-01-05'), (20, 7, '2023-01-05'), (21, 7, '2023-01-05'),
(22, 8, '2023-01-05'), (23, 8, '2023-01-05'), (1, 8, '2023-01-05'),
(2, 9, '2023-01-05'), (3, 9, '2023-01-05'), (4, 9, '2023-01-05');

-- 32. Tabla sessions
INSERT INTO sessions (module_id, name, description) VALUES 
-- Algoritmia
(1, 'Introducción a algoritmos', 'Conceptos básicos de algoritmos y diagramas de flujo'),
(1, 'Estructuras secuenciales', 'Algoritmos con entrada, proceso y salida'),
(1, 'Estructuras condicionales', 'Uso de if, else y switch'),

-- Python
(2, 'Sintaxis básica', 'Variables, tipos de datos y operadores'),
(2, 'Estructuras de control', 'Bucles y condicionales en Python'),
(2, 'Funciones', 'Definición y uso de funciones'),

-- PSeInt
(3, 'Introducción a PSeInt', 'Interfaz y herramientas básicas'),
(3, 'Práctica con algoritmos', 'Implementación de algoritmos en PSeInt'),

-- HTML
(4, 'Estructura HTML', 'Etiquetas básicas y estructura de documento'),
(4, 'Formularios', 'Creación de formularios HTML'),

-- CSS
(5, 'Selectores y propiedades', 'Fundamentos de CSS'),
(5, 'Diseño responsive', 'Media queries y flexbox'),

-- Bootstrap
(6, 'Introducción a Bootstrap', 'Grid system y componentes'),
(6, 'Componentes avanzados', 'Navbars, cards y modals'),

-- Java
(7, 'POO en Java', 'Clases y objetos'),
(7, 'Herencia y polimorfismo', 'Conceptos avanzados de POO'),

-- JavaScript
(8, 'JS en el navegador', 'DOM manipulation'),
(8, 'Eventos', 'Manejo de eventos en JS'),

-- C#
(9, 'Fundamentos de C#', 'Sintaxis básica'),
(9, 'Windows Forms', 'Desarrollo de aplicaciones de escritorio'),

-- MySQL
(10, 'Consultas básicas', 'SELECT, INSERT, UPDATE, DELETE'),
(10, 'Joins y relaciones', 'Consultas con múltiples tablas'),

-- MongoDB
(11, 'Introducción a NoSQL', 'Conceptos de bases de datos documentales'),
(11, 'Consultas en MongoDB', 'Operaciones CRUD'),

-- PostgreSQL
(12, 'Características avanzadas', 'Funciones y procedimientos'),
(12, 'Optimización', 'Índices y consultas eficientes'),

-- NetCore
(13, 'Introducción a .NET', 'Creación de APIs'),
(13, 'Entity Framework', 'ORM para .NET'),

-- Spring Boot
(14, 'Configuración inicial', 'Creación de proyecto Spring'),
(14, 'Spring Data JPA', 'Acceso a datos con JPA'),

-- NodeJS
(15, 'Introducción a Node', 'Módulos y NPM'),
(15, 'Express.js', 'Creación de servidores web'),

-- Express
(16, 'Rutas y middlewares', 'Estructura de aplicaciones Express'),
(16, 'Autenticación', 'JWT y sesiones'),

-- Inglés
(17, 'Saludos y presentaciones', 'Vocabulario básico'),
(17, 'Gramática básica', 'Verbo to be y presente simple'),

-- Ser
(20, 'Comunicación efectiva', 'Escucha activa y feedback'),
(21, 'Trabajo en equipo', 'Roles y dinámicas de grupo');

-- 33. Tabla trainer_schedules
INSERT INTO trainer_schedules (trainer_id, day_of_week, time_block_id, is_available) VALUES 
-- Trainer 1 (Lunes a Viernes, mañana y tarde)
(1, 1, 1, 1), (1, 1, 2, 1), (1, 1, 3, 0), (1, 1, 4, 0),
(1, 2, 1, 1), (1, 2, 2, 1), (1, 2, 3, 0), (1, 2, 4, 0),
(1, 3, 1, 1), (1, 3, 2, 1), (1, 3, 3, 0), (1, 3, 4, 0),
(1, 4, 1, 1), (1, 4, 2, 1), (1, 4, 3, 0), (1, 4, 4, 0),
(1, 5, 1, 1), (1, 5, 2, 1), (1, 5, 3, 0), (1, 5, 4, 0),

-- Trainer 2 (Lunes, Miércoles, Viernes - tarde y noche)
(2, 1, 1, 0), (2, 1, 2, 0), (2, 1, 3, 1), (2, 1, 4, 1),
(2, 3, 1, 0), (2, 3, 2, 0), (2, 3, 3, 1), (2, 3, 4, 1),
(2, 5, 1, 0), (2, 5, 2, 0), (2, 5, 3, 1), (2, 5, 4, 1),

-- Trainer 3 (Martes y Jueves - mañana y tarde)
(3, 2, 1, 1), (3, 2, 2, 1), (3, 2, 3, 1), (3, 2, 4, 0),
(3, 4, 1, 1), (3, 4, 2, 1), (3, 4, 3, 1), (3, 4, 4, 0),

-- Trainer 4 (Lunes a Viernes - mañana)
(4, 1, 1, 1), (4, 1, 2, 1), (4, 1, 3, 0), (4, 1, 4, 0),
(4, 2, 1, 1), (4, 2, 2, 1), (4, 2, 3, 0), (4, 2, 4, 0),
(4, 3, 1, 1), (4, 3, 2, 1), (4, 3, 3, 0), (4, 3, 4, 0),
(4, 4, 1, 1), (4, 4, 2, 1), (4, 4, 3, 0), (4, 4, 4, 0),
(4, 5, 1, 1), (4, 5, 2, 1), (4, 5, 3, 0), (4, 5, 4, 0),

-- Trainer 5 (Lunes a Jueves - tarde)
(5, 1, 1, 0), (5, 1, 2, 0), (5, 1, 3, 1), (5, 1, 4, 0),
(5, 2, 1, 0), (5, 2, 2, 0), (5, 2, 3, 1), (5, 2, 4, 0),
(5, 3, 1, 0), (5, 3, 2, 0), (5, 3, 3, 1), (5, 3, 4, 0),
(5, 4, 1, 0), (5, 4, 2, 0), (5, 4, 3, 1), (5, 4, 4, 0),

-- Trainer 6 (Viernes - todo el día)
(6, 5, 1, 1), (6, 5, 2, 1), (6, 5, 3, 1), (6, 5, 4, 1),

-- Trainer 7 (Lunes, Miércoles - mañana y noche)
(7, 1, 1, 1), (7, 1, 2, 0), (7, 1, 3, 0), (7, 1, 4, 1),
(7, 3, 1, 1), (7, 3, 2, 0), (7, 3, 3, 0), (7, 3, 4, 1),

-- Trainer 8 (Martes, Jueves - tarde)
(8, 2, 1, 0), (8, 2, 2, 0), (8, 2, 3, 1), (8, 2, 4, 0),
(8, 4, 1, 0), (8, 4, 2, 0), (8, 4, 3, 1), (8, 4, 4, 0),

-- Trainer 9 (Lunes a Viernes - noche)
(9, 1, 1, 0), (9, 1, 2, 0), (9, 1, 3, 0), (9, 1, 4, 1),
(9, 2, 1, 0), (9, 2, 2, 0), (9, 2, 3, 0), (9, 2, 4, 1),
(9, 3, 1, 0), (9, 3, 2, 0), (9, 3, 3, 0), (9, 3, 4, 1),
(9, 4, 1, 0), (9, 4, 2, 0), (9, 4, 3, 0), (9, 4, 4, 1),
(9, 5, 1, 0), (9, 5, 2, 0), (9, 5, 3, 0), (9, 5, 4, 1);

-- 34. Tabla training_groups
INSERT INTO training_groups (route_id, trainer_id, classroom_id, schedule_id, name, start_date, end_date) VALUES 
-- Cúcuta
(1, 7, 1, 1, 'FPC-01', '2023-01-10', '2023-04-10'),
(2, 8, 2, 2, 'PWB-01', '2023-01-10', '2023-04-10'),
(4, 9, 3, 3, 'DB-01', '2023-01-10', '2023-05-15'),

-- Bogotá
(3, 4, 7, 1, 'PFR-01', '2023-01-10', '2023-05-20'),
(5, 5, 8, 2, 'BK-01', '2023-01-10', '2023-06-01'),
(6, 6, 9, 3, 'ENG-01', '2023-01-10', '2023-03-30'),

-- Bucaramanga
(1, 1, 13, 1, 'FPC-02', '2023-01-10', '2023-04-10'),
(3, 2, 14, 2, 'PFR-02', '2023-01-10', '2023-05-20'),
(5, 3, 15, 3, 'BK-02', '2023-01-10', '2023-06-01');

-- 35. Tabla camper_groups
INSERT INTO camper_groups (camper_id, group_id, entry_date, status) VALUES 
-- Grupo FPC-01 (Cúcuta)
(1, 1, '2023-01-10', 'Activo'),
(2, 1, '2023-01-10', 'Activo'),
(3, 1, '2023-01-10', 'Activo'),
(4, 1, '2023-01-10', 'Activo'),
(5, 1, '2023-01-10', 'Activo'),
(6, 1, '2023-01-10', 'Activo'),
(7, 1, '2023-01-10', 'Activo'),
(8, 1, '2023-01-10', 'Activo'),
(9, 1, '2023-01-10', 'Activo'),
(10, 1, '2023-01-10', 'Activo'),

-- Grupo PWB-01 (Cúcuta)
(11, 2, '2023-01-10', 'Activo'),
(12, 2, '2023-01-10', 'Activo'),
(13, 2, '2023-01-10', 'Activo'),
(14, 2, '2023-01-10', 'Activo'),
(15, 2, '2023-01-10', 'Activo'),

-- Grupo DB-01 (Cúcuta)
(16, 3, '2023-01-10', 'Activo'),
(17, 3, '2023-01-10', 'Activo'),
(18, 3, '2023-01-10', 'Activo'),
(19, 3, '2023-01-10', 'Activo'),
(20, 3, '2023-01-10', 'Activo'),

-- Grupo PFR-01 (Bogotá)
(21, 4, '2023-01-10', 'Activo'),
(22, 4, '2023-01-10', 'Activo'),
(23, 4, '2023-01-10', 'Activo'),
(24, 4, '2023-01-10', 'Activo'),
(25, 4, '2023-01-10', 'Activo'),
(26, 4, '2023-01-10', 'Activo'),
(27, 4, '2023-01-10', 'Activo'),
(28, 4, '2023-01-10', 'Activo'),
(29, 4, '2023-01-10', 'Activo'),
(30, 4, '2023-01-10', 'Activo'),

-- Grupo BK-01 (Bogotá)
(31, 5, '2023-01-10', 'Activo'),
(32, 5, '2023-01-10', 'Activo'),
(33, 5, '2023-01-10', 'Activo'),
(34, 5, '2023-01-10', 'Activo'),
(35, 5, '2023-01-10', 'Activo'),

-- Grupo ENG-01 (Bogotá)
(36, 6, '2023-01-10', 'Activo'),
(37, 6, '2023-01-10', 'Activo'),
(38, 6, '2023-01-10', 'Activo'),
(39, 6, '2023-01-10', 'Activo'),
(40, 6, '2023-01-10', 'Activo'),
(41, 6, '2023-01-10', 'Activo');

-- 36. Tabla session_schedules
INSERT INTO session_schedules (session_id, group_id, trainer_id, date, classroom_id, start_time, end_time) VALUES 
-- Sesiones para FPC-01 (Cúcuta)
(1, 1, 7, '2023-01-10', 1, '06:00:00', '09:00:00'),
(2, 1, 7, '2023-01-12', 1, '06:00:00', '09:00:00'),
(4, 1, 7, '2023-01-17', 1, '06:00:00', '09:00:00'),
(5, 1, 7, '2023-01-19', 1, '06:00:00', '09:00:00'),

-- Sesiones para PWB-01 (Cúcuta)
(9, 2, 8, '2023-01-10', 2, '10:00:00', '13:00:00'),
(10, 2, 8, '2023-01-12', 2, '10:00:00', '13:00:00'),
(11, 2, 8, '2023-01-17', 2, '10:00:00', '13:00:00'),
(12, 2, 8, '2023-01-19', 2, '10:00:00', '13:00:00'),

-- Sesiones para DB-01 (Cúcuta)
(22, 3, 9, '2023-01-11', 3, '14:00:00', '17:00:00'),
(23, 3, 9, '2023-01-13', 3, '14:00:00', '17:00:00'),
(24, 3, 9, '2023-01-18', 3, '14:00:00', '17:00:00'),
(25, 3, 9, '2023-01-20', 3, '14:00:00', '17:00:00'),

-- Sesiones para PFR-01 (Bogotá)
(16, 4, 4, '2023-01-10', 7, '06:00:00', '09:00:00'),
(17, 4, 4, '2023-01-12', 7, '06:00:00', '09:00:00'),
(18, 4, 4, '2023-01-17', 7, '06:00:00', '09:00:00'),
(19, 4, 4, '2023-01-19', 7, '06:00:00', '09:00:00'),

-- Sesiones para BK-01 (Bogotá)
(28, 5, 5, '2023-01-11', 8, '10:00:00', '13:00:00'),
(29, 5, 5, '2023-01-13', 8, '10:00:00', '13:00:00'),
(30, 5, 5, '2023-01-18', 8, '10:00:00', '13:00:00'),
(31, 5, 5, '2023-01-20', 8, '10:00:00', '13:00:00'),

-- Sesiones para ENG-01 (Bogotá)
(32, 6, 6, '2023-01-11', 9, '14:00:00', '17:00:00'),
(33, 6, 6, '2023-01-13', 9, '14:00:00', '17:00:00'),
(34, 6, 6, '2023-01-18', 9, '14:00:00', '17:00:00'),
(35, 6, 6, '2023-01-20', 9, '14:00:00', '17:00:00'),

-- Sesiones para FPC-02 (Bucaramanga)
(1, 7, 1, '2023-01-10', 13, '06:00:00', '09:00:00'),
(2, 7, 1, '2023-01-12', 13, '06:00:00', '09:00:00'),
(4, 7, 1, '2023-01-17', 13, '06:00:00', '09:00:00'),
(5, 7, 1, '2023-01-19', 13, '06:00:00', '09:00:00'),

-- Sesiones para PFR-02 (Bucaramanga)
(16, 8, 2, '2023-01-11', 14, '10:00:00', '13:00:00'),
(17, 8, 2, '2023-01-13', 14, '10:00:00', '13:00:00'),
(18, 8, 2, '2023-01-18', 14, '10:00:00', '13:00:00'),
(19, 8, 2, '2023-01-20', 14, '10:00:00', '13:00:00'),

-- Sesiones para BK-02 (Bucaramanga)
(28, 9, 3, '2023-01-11', 15, '14:00:00', '17:00:00'),
(29, 9, 3, '2023-01-13', 15, '14:00:00', '17:00:00'),
(30, 9, 3, '2023-01-18', 15, '14:00:00', '17:00:00'),
(31, 9, 3, '2023-01-20', 15, '14:00:00', '17:00:00');

-- 37. Tabla session_attendance
INSERT INTO session_attendance (session_schedule_id, camper_id, attendance_status, arrival_time) VALUES 
-- Asistencia para FPC-01
(1, 1, 'Asistió', '06:05:00'),
(1, 2, 'Asistió', '06:00:00'),
(1, 3, 'Asistió', '06:10:00'),
(1, 4, 'Asistió', '06:02:00'),
(1, 5, 'Asistió', '06:15:00'),
(1, 6, 'Falta justificada', NULL),
(1, 7, 'Asistió', '06:20:00'),
(1, 8, 'Asistió', '06:01:00'),
(1, 9, 'Falta injustificada', NULL),
(1, 10, 'Asistió', '06:08:00'),

-- Asistencia para PWB-01
(5, 11, 'Asistió', '10:05:00'),
(5, 12, 'Asistió', '10:00:00'),
(5, 13, 'Falta justificada', NULL),
(5, 14, 'Asistió', '10:10:00'),
(5, 15, 'Asistió', '10:15:00'),

-- Asistencia para DB-01
(9, 16, 'Asistió', '14:00:00'),
(9, 17, 'Asistió', '14:05:00'),
(9, 18, 'Asistió', '14:10:00'),
(9, 19, 'Falta injustificada', NULL),
(9, 20, 'Asistió', '14:02:00'),

-- Asistencia para PFR-01
(13, 21, 'Asistió', '06:00:00'),
(13, 22, 'Asistió', '06:05:00'),
(13, 23, 'Asistió', '06:10:00'),
(13, 24, 'Asistió', '06:15:00'),
(13, 25, 'Falta justificada', NULL),
(13, 26, 'Asistió', '06:02:00'),
(13, 27, 'Asistió', '06:20:00'),
(13, 28, 'Falta injustificada', NULL),
(13, 29, 'Asistió', '06:01:00'),
(13, 30, 'Asistió', '06:08:00'),

-- Asistencia para BK-01
(17, 31, 'Asistió', '10:05:00'),
(17, 32, 'Asistió', '10:00:00'),
(17, 33, 'Asistió', '10:10:00'),
(17, 34, 'Falta justificada', NULL),
(17, 35, 'Asistió', '10:15:00'),

-- Asistencia para ENG-01
(21, 36, 'Asistió', '14:00:00'),
(21, 37, 'Asistió', '14:05:00'),
(21, 38, 'Falta injustificada', NULL),
(21, 39, 'Asistió', '14:10:00'),
(21, 40, 'Asistió', '14:02:00'),
(21, 41, 'Asistió', '14:15:00');

-- 38. Tabla evaluation_types
INSERT INTO evaluation_types (name, weight_percentage, description) VALUES 
('Teórica', 30.0, 'Evaluación de conocimientos teóricos'),
('Práctica', 60.0, 'Evaluación de habilidades prácticas'),
('Trabajos/Quizzes', 10.0, 'Evaluación continua mediante trabajos y quizzes');

-- 39. Tabla evaluations
INSERT INTO evaluations (module_id, group_id, evaluation_type_id, name) VALUES 
-- Evaluaciones para FPC-01
(1, 1, 1, 'Examen teórico de algoritmia'),
(1, 1, 2, 'Proyecto final de algoritmia'),
(1, 1, 3, 'Quizzes de algoritmia'),

-- Evaluaciones para PWB-01
(4, 2, 1, 'Examen teórico de HTML'),
(4, 2, 2, 'Proyecto de página web'),
(4, 2, 3, 'Tareas de HTML/CSS'),

-- Evaluaciones para DB-01
(10, 3, 1, 'Examen teórico de MySQL'),
(10, 3, 2, 'Proyecto de base de datos'),
(10, 3, 3, 'Ejercicios prácticos'),

-- Evaluaciones para PFR-01
(7, 4, 1, 'Examen teórico de Java'),
(7, 4, 2, 'Proyecto Java'),
(7, 4, 3, 'Ejercicios de POO'),

-- Evaluaciones para BK-01
(13, 5, 1, 'Examen teórico de NetCore'),
(13, 5, 2, 'API REST con NetCore'),
(13, 5, 3, 'Tareas de backend'),

-- Evaluaciones para ENG-01
(17, 6, 1, 'Examen teórico de inglés'),
(17, 6, 2, 'Presentación oral'),
(17, 6, 3, 'Tareas de vocabulario'),

-- Evaluaciones para FPC-02
(1, 7, 1, 'Examen teórico de algoritmia'),
(1, 7, 2, 'Proyecto final de algoritmia'),
(1, 7, 3, 'Quizzes de algoritmia'),

-- Evaluaciones para PFR-02
(7, 8, 1, 'Examen teórico de Java'),
(7, 8, 2, 'Proyecto Java'),
(7, 8, 3, 'Ejercicios de POO'),

-- Evaluaciones para BK-02
(13, 9, 1, 'Examen teórico de NetCore'),
(13, 9, 2, 'API REST con NetCore'),
(13, 9, 3, 'Tareas de backend');

-- 40. Tabla evaluation_scores
INSERT INTO evaluation_scores (evaluation_id, camper_id, score) VALUES 
-- Notas para FPC-01
(1, 1, 85.5), (2, 1, 90.0), (3, 1, 95.0),
(1, 2, 78.0), (2, 2, 82.5), (3, 2, 88.0),
(1, 3, 92.0), (2, 3, 87.5), (3, 3, 90.0),
(1, 4, 65.0), (2, 4, 70.0), (3, 4, 75.0),
(1, 5, 88.5), (2, 5, 85.0), (3, 5, 92.0),
(1, 6, 72.0), (2, 6, 68.0), (3, 6, 80.0),
(1, 7, 95.0), (2, 7, 92.5), (3, 7, 98.0),
(1, 8, 81.0), (2, 8, 79.0), (3, 8, 85.0),
(1, 9, 60.0), (2, 9, 55.0), (3, 9, 65.0),
(1, 10, 77.0), (2, 10, 80.0), (3, 10, 82.0),

-- Notas para PWB-01
(4, 11, 85.0), (5, 11, 90.0), (6, 11, 88.0),
(4, 12, 78.0), (5, 12, 82.0), (6, 12, 80.0),
(4, 13, 92.0), (5, 13, 88.0), (6, 13, 90.0),
(4, 14, 65.0), (5, 14, 70.0), (6, 14, 68.0),
(4, 15, 88.0), (5, 15, 85.0), (6, 15, 90.0),

-- Notas para DB-01
(7, 16, 85.0), (8, 16, 90.0), (9, 16, 88.0),
(7, 17, 78.0), (8, 17, 82.0), (9, 17, 80.0),
(7, 18, 92.0), (8, 18, 88.0), (9, 18, 90.0),
(7, 19, 65.0), (8, 19, 70.0), (9, 19, 68.0),
(7, 20, 88.0), (8, 20, 85.0), (9, 20, 90.0),

-- Notas para PFR-01
(10, 21, 85.0), (11, 21, 90.0), (12, 21, 88.0),
(10, 22, 78.0), (11, 22, 82.0), (12, 22, 80.0),
(10, 23, 92.0), (11, 23, 88.0), (12, 23, 90.0),
(10, 24, 65.0), (11, 24, 70.0), (12, 24, 68.0),
(10, 25, 88.0), (11, 25, 85.0), (12, 25, 90.0),
(10, 26, 72.0), (11, 26, 75.0), (12, 26, 78.0),
(10, 27, 95.0), (11, 27, 92.0), (12, 27, 98.0),
(10, 28, 81.0), (11, 28, 79.0), (12, 28, 85.0),
(10, 29, 60.0), (11, 29, 65.0), (12, 29, 62.0),
(10, 30, 77.0), (11, 30, 80.0), (12, 30, 82.0),

-- Notas para BK-01
(13, 31, 85.0), (14, 31, 90.0), (15, 31, 88.0),
(13, 32, 78.0), (14, 32, 82.0), (15, 32, 80.0),
(13, 33, 92.0), (14, 33, 88.0), (15, 33, 90.0),
(13, 34, 65.0), (14, 34, 70.0), (15, 34, 68.0),
(13, 35, 88.0), (14, 35, 85.0), (15, 35, 90.0),

-- Notas para ENG-01
(16, 36, 85.0), (17, 36, 90.0), (18, 36, 88.0),
(16, 37, 78.0), (17, 37, 82.0), (18, 37, 80.0),
(16, 38, 92.0), (17, 38, 88.0), (18, 38, 90.0),
(16, 39, 65.0), (17, 39, 70.0), (18, 39, 68.0),
(16, 40, 88.0), (17, 40, 85.0), (18, 40, 90.0),
(16, 41, 72.0), (17, 41, 75.0), (18, 41, 78.0),

-- Notas para FPC-02
(19, 1, 85.0), (20, 1, 90.0), (21, 1, 88.0),
(19, 2, 78.0), (20, 2, 82.0), (21, 2, 80.0),
(19, 3, 92.0), (20, 3, 88.0), (21, 3, 90.0),
(19, 4, 65.0), (20, 4, 70.0), (21, 4, 68.0),
(19, 5, 88.0), (20, 5, 85.0), (21, 5, 90.0),

-- Notas para PFR-02
(22, 6, 85.0), (23, 6, 90.0), (24, 6, 88.0),
(22, 7, 78.0), (23, 7, 82.0), (24, 7, 80.0),
(22, 8, 92.0), (23, 8, 88.0), (24, 8, 90.0),
(22, 9, 65.0), (23, 9, 70.0), (24, 9, 68.0),
(22, 10, 88.0), (23, 10, 85.0), (24, 10, 90.0),

-- Notas para BK-02
(25, 11, 85.0), (26, 11, 90.0), (27, 11, 88.0),
(25, 12, 78.0), (26, 12, 82.0), (27, 12, 80.0),
(25, 13, 92.0), (26, 13, 88.0), (27, 13, 90.0),
(25, 14, 65.0), (26, 14, 70.0), (27, 14, 68.0),
(25, 15, 88.0), (26, 15, 85.0), (27, 15, 90.0);

-- 41. Tabla camper_skills
INSERT INTO camper_skills (camper_id, skill_id) VALUES 
(1, 1), (1, 5), (1, 6),
(2, 1), (2, 5), (2, 6),
(3, 1), (3, 5), (3, 6),
(4, 1), (4, 5), (4, 6),
(5, 1), (5, 5), (5, 6),
(6, 1), (6, 5), (6, 6),
(7, 1), (7, 5), (7, 6),
(8, 1), (8, 5), (8, 6),
(9, 1), (9, 5), (9, 6),
(10, 1), (10, 5), (10, 6),
(11, 2), (11, 8), (11, 9),
(12, 2), (12, 8), (12, 9),
(13, 2), (13, 8), (13, 9),
(14, 2), (14, 8), (14, 9),
(15, 2), (15, 8), (15, 9),
(16, 2), (16, 14), (16, 15),
(17, 2), (17, 14), (17, 15),
(18, 2), (18, 14), (18, 15),
(19, 2), (19, 14), (19, 15),
(20, 2), (20, 14), (20, 15),
(21, 1), (21, 11), (21, 12),
(22, 1), (22, 11), (22, 12),
(23, 1), (23, 11), (23, 12),
(24, 1), (24, 11), (24, 12),
(25, 1), (25, 11), (25, 12),
(26, 1), (26, 11), (26, 12),
(27, 1), (27, 11), (27, 12),
(28, 1), (28, 11), (28, 12),
(29, 1), (29, 11), (29, 12),
(30, 1), (30, 11), (30, 12),
(31, 3), (31, 17), (31, 18),
(32, 3), (32, 17), (32, 18),
(33, 3), (33, 17), (33, 18),
(34, 3), (34, 17), (34, 18),
(35, 3), (35, 17), (35, 18),
(36, 3), (36, 3), (36, 4),
(37, 3), (37, 3), (37, 4),
(38, 3), (38, 3), (38, 4),
(39, 3), (39, 3), (39, 4),
(40, 3), (40, 3), (40, 4),
(41, 3), (41, 3), (41, 4);

-- 42. Tabla graduates
INSERT INTO graduates (camper_id, route_id, final_grade) VALUES 
(1, 6, 89.5),
(2, 6, 78.0),
(3, 6, 92.5),
(4, 6, 65.0),
(5, 6, 88.0),
(6, 7, 85.0),
(7, 7, 78.0),
(8, 7, 92.0),
(9, 7, 65.0),
(10, 7, 88.0),
(11, 8, 85.0),
(12, 8, 78.0),
(13, 8, 92.0),
(14, 8, 65.0),
(15, 8, 88.0),
(16, 9, 85.0),
(17, 9, 78.0),
(18, 9, 92.0),
(19, 9, 65.0),
(20, 9, 88.0);
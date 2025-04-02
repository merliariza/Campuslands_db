## ddl.sql
```sql
-- Creación de la base de datos
CREATE DATABASE campuslands_db;
USE campuslands_db;

-- Tabla countries
CREATE TABLE countries (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);

-- Tabla states
CREATE TABLE states (
    id INT PRIMARY KEY AUTO_INCREMENT,
    country_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    FOREIGN KEY (country_id) REFERENCES countries(id)
);

-- Tabla cities
CREATE TABLE cities (
    id INT PRIMARY KEY AUTO_INCREMENT,
    state_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    FOREIGN KEY (state_id) REFERENCES states(id)
);

-- Tabla addresses
CREATE TABLE addresses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    street VARCHAR(50) NOT NULL,
    neighborhood VARCHAR(50),
    postal_code VARCHAR(20),
    city_id INT NOT NULL,
    FOREIGN KEY (city_id) REFERENCES cities(id)
);

-- Tabla company
CREATE TABLE company (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    nit VARCHAR(12) NOT NULL,
    address_id INT NOT NULL,
    FOREIGN KEY (address_id) REFERENCES addresses(id)
);

-- Tabla branches
CREATE TABLE branches (
    id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    address_id INT NOT NULL,
    FOREIGN KEY (company_id) REFERENCES company(id),
    FOREIGN KEY (address_id) REFERENCES addresses(id)
);

-- Tabla classrooms
CREATE TABLE classrooms (
    id INT PRIMARY KEY AUTO_INCREMENT,
    campus_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    capacity INT NOT NULL,
    FOREIGN KEY (campus_id) REFERENCES branches(id)
);

-- Tabla document_types
CREATE TABLE document_types (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    abbreviation VARCHAR(3) NOT NULL
);

-- Tabla persons
CREATE TABLE persons (
    id INT PRIMARY KEY AUTO_INCREMENT,
    document_type_id INT NOT NULL,
    document_number VARCHAR(20) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(80) NOT NULL,
    address_id INT NOT NULL,
    birth_date DATE,
    FOREIGN KEY (document_type_id) REFERENCES document_types(id),
    FOREIGN KEY (address_id) REFERENCES addresses(id),
    UNIQUE (document_type_id, document_number)
);

-- Tabla phone_types
CREATE TABLE phone_types (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL UNIQUE
);

-- Tabla person_phones
CREATE TABLE person_phones (
    id INT PRIMARY KEY AUTO_INCREMENT,
    person_id INT NOT NULL,
    phone_type_id INT NOT NULL,
    number VARCHAR(20) NOT NULL,
    FOREIGN KEY (person_id) REFERENCES persons(id),
    FOREIGN KEY (phone_type_id) REFERENCES phone_types(id),
    UNIQUE(person_id, number)
);

-- Tabla camper_statuses
CREATE TABLE camper_statuses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);

-- Tabla risk_levels
CREATE TABLE risk_levels (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL
);

-- Tabla campers
CREATE TABLE campers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    person_id INT NOT NULL,
    status_id INT NOT NULL,
    risk_level_id INT NOT NULL,
    entry_date DATE NOT NULL,
    FOREIGN KEY (person_id) REFERENCES persons(id),
    FOREIGN KEY (status_id) REFERENCES camper_statuses(id),
    FOREIGN KEY (risk_level_id) REFERENCES risk_levels(id)
);

-- Tabla guardians
CREATE TABLE guardians (
    id INT PRIMARY KEY AUTO_INCREMENT,
    camper_id INT NOT NULL,
    person_id INT NOT NULL,
    relationship VARCHAR(20) NOT NULL,
    FOREIGN KEY (camper_id) REFERENCES campers(id),
    FOREIGN KEY (person_id) REFERENCES persons(id)
);

-- Tabla status_history
CREATE TABLE status_history (
    id INT PRIMARY KEY AUTO_INCREMENT,
    camper_id INT NOT NULL,
    previous_status_id INT NOT NULL,
    new_status_id INT NOT NULL,
    change_date TIMESTAMP NOT NULL,
    FOREIGN KEY (camper_id) REFERENCES campers(id),
    FOREIGN KEY (previous_status_id) REFERENCES camper_statuses(id),
    FOREIGN KEY (new_status_id) REFERENCES camper_statuses(id)
);

-- Tabla trainers
CREATE TABLE trainers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    person_id INT NOT NULL,
    campus_id INT NOT NULL,
    acronym VARCHAR(1) NOT NULL,
    FOREIGN KEY (person_id) REFERENCES persons(id),
    FOREIGN KEY (campus_id) REFERENCES branches(id)
);

-- Tabla competencias
CREATE TABLE competencias (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    description TEXT
);

-- Tabla trainer_competencias
CREATE TABLE trainer_competencias (
    id INT PRIMARY KEY AUTO_INCREMENT,
    trainer_id INT NOT NULL,
    competencia_id INT NOT NULL,
    FOREIGN KEY (trainer_id) REFERENCES trainers(id),
    FOREIGN KEY (competencia_id) REFERENCES competencias(id)
);

-- Tabla notifications
CREATE TABLE notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    trainer_id INT NOT NULL,
    message TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (trainer_id) REFERENCES trainers(id)
);

-- Tabla skills 
CREATE TABLE skills (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    type VARCHAR(30) NOT NULL, 
    description TEXT
);

-- Tabla module_categories
CREATE TABLE module_categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);

-- Tabla modules
CREATE TABLE modules (
    id INT PRIMARY KEY AUTO_INCREMENT,
    category_id INT NOT NULL,
    skill_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    description TEXT,
    duration_weeks INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES module_categories(id),
    FOREIGN KEY (skill_id) REFERENCES skills(id)
);

-- Tabla module_competencias 
CREATE TABLE module_competencias (
    id INT PRIMARY KEY AUTO_INCREMENT,
    module_id INT NOT NULL,
    competencia_id INT NOT NULL,
    FOREIGN KEY (module_id) REFERENCES modules(id),
    FOREIGN KEY (competencia_id) REFERENCES competencias(id)
);

-- Tabla module_trainers
CREATE TABLE module_trainers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    module_id INT NOT NULL,
    trainer_id INT NOT NULL,
    assigned_date DATE NOT NULL,
    FOREIGN KEY (module_id) REFERENCES modules(id),
    FOREIGN KEY (trainer_id) REFERENCES trainers(id),
    UNIQUE (module_id, trainer_id)
);

-- Tabla sessions 
CREATE TABLE sessions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    module_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    FOREIGN KEY (module_id) REFERENCES modules(id)
);

-- Tabla routes
CREATE TABLE routes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    description TEXT
);

-- Tabla route_modules
CREATE TABLE route_modules (
    id INT PRIMARY KEY AUTO_INCREMENT,
    route_id INT NOT NULL,
    module_id INT NOT NULL,
    route_order INT NOT NULL,
    FOREIGN KEY (route_id) REFERENCES routes(id),
    FOREIGN KEY (module_id) REFERENCES modules(id)
);

-- Tabla sgdb
CREATE TABLE sgdb (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    type VARCHAR(50) NOT NULL
);

-- Tabla route_sgdb
CREATE TABLE route_sgdb (
    id INT PRIMARY KEY AUTO_INCREMENT,
    route_id INT NOT NULL,
    database_id INT NOT NULL,
    is_primary BOOLEAN NOT NULL,
    FOREIGN KEY (route_id) REFERENCES routes(id),
    FOREIGN KEY (database_id) REFERENCES sgdb(id)
);

-- Tabla time_blocks
CREATE TABLE time_blocks (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL
);

-- Tabla schedules
CREATE TABLE schedules (
    id INT PRIMARY KEY AUTO_INCREMENT,
    block_id INT NOT NULL,
    FOREIGN KEY (block_id) REFERENCES time_blocks(id)
);

-- Tabla trainer_schedules
CREATE TABLE trainer_schedules (
    id INT PRIMARY KEY AUTO_INCREMENT,
    trainer_id INT NOT NULL,
    day_of_week INT NOT NULL, 
    time_block_id INT NOT NULL,
    is_available BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (trainer_id) REFERENCES trainers(id),
    FOREIGN KEY (time_block_id) REFERENCES time_blocks(id)
);

-- Tabla training_groups
CREATE TABLE training_groups (
    id INT PRIMARY KEY AUTO_INCREMENT,
    route_id INT NOT NULL,
    trainer_id INT NOT NULL,
    classroom_id INT NOT NULL,
    schedule_id INT NOT NULL,
    name VARCHAR(20) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    FOREIGN KEY (route_id) REFERENCES routes(id),
    FOREIGN KEY (trainer_id) REFERENCES trainers(id),
    FOREIGN KEY (classroom_id) REFERENCES classrooms(id),
    FOREIGN KEY (schedule_id) REFERENCES schedules(id)
);

-- Tabla camper_groups
CREATE TABLE camper_groups (
    id INT PRIMARY KEY AUTO_INCREMENT,
    camper_id INT NOT NULL,
    group_id INT NOT NULL,
    entry_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL,
    FOREIGN KEY (camper_id) REFERENCES campers(id),
    FOREIGN KEY (group_id) REFERENCES training_groups(id)
);

-- Tabla session_schedules
CREATE TABLE session_schedules (
    id INT PRIMARY KEY AUTO_INCREMENT,
    session_id INT NOT NULL,
    group_id INT NOT NULL,
    trainer_id INT NOT NULL,
    date DATE NOT NULL,
    classroom_id INT NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    FOREIGN KEY (session_id) REFERENCES sessions(id),
    FOREIGN KEY (group_id) REFERENCES training_groups(id),
    FOREIGN KEY (trainer_id) REFERENCES trainers(id),
    FOREIGN KEY (classroom_id) REFERENCES classrooms(id)
);

-- Tabla session_attendance
CREATE TABLE session_attendance (
    id INT PRIMARY KEY AUTO_INCREMENT,
    session_schedule_id INT NOT NULL,
    camper_id INT NOT NULL,
    attendance_status VARCHAR(20) NOT NULL,
    arrival_time TIME,
    FOREIGN KEY (session_schedule_id) REFERENCES session_schedules(id),
    FOREIGN KEY (camper_id) REFERENCES campers(id),
    UNIQUE (session_schedule_id, camper_id)
);

-- Tabla evaluation_types
CREATE TABLE evaluation_types (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL,
    weight_percentage DECIMAL(4,1) NOT NULL,
    description TEXT
);

-- Tabla evaluations
CREATE TABLE evaluations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    module_id INT NOT NULL,
    group_id INT NOT NULL,
    evaluation_type_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    FOREIGN KEY (module_id) REFERENCES modules(id),
    FOREIGN KEY (group_id) REFERENCES training_groups(id),
    FOREIGN KEY (evaluation_type_id) REFERENCES evaluation_types(id)
);

-- Tabla evaluation_scores 
CREATE TABLE evaluation_scores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    evaluation_id INT NOT NULL,
    camper_id INT NOT NULL,
    score DECIMAL(4,1) NOT NULL,
    FOREIGN KEY (evaluation_id) REFERENCES evaluations(id),
    FOREIGN KEY (camper_id) REFERENCES campers(id),
    UNIQUE (evaluation_id, camper_id)
);

-- Tabla camper_skills
CREATE TABLE camper_skills (
    id INT PRIMARY KEY AUTO_INCREMENT,
    camper_id INT NOT NULL,
    skill_id INT NOT NULL,
    FOREIGN KEY (camper_id) REFERENCES campers(id),
    FOREIGN KEY (skill_id) REFERENCES skills(id)
);

-- Tabla graduates
CREATE TABLE graduates (
    id INT PRIMARY KEY AUTO_INCREMENT,
    camper_id INT NOT NULL,
    route_id INT NOT NULL,
    final_grade DECIMAL(4,1),
    FOREIGN KEY (camper_id) REFERENCES campers(id),
    FOREIGN KEY (route_id) REFERENCES routes(id),
    UNIQUE (camper_id, route_id)
);
```

## dml.sql
```sql
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
-- Graduados de rutas anteriores
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
```

## dql_select.sql
```sql
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
```

## dql_procedimientos.sql
```sql
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
```

## dql_funciones.sql
```sql
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
DELIMITER //
CREATE FUNCTION tasa_aprobacion_ruta(
    p_route_id INT,
    p_nota_minima DECIMAL(4,1)
) RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE total_campers INT;
    DECLARE aprobados INT;
    DECLARE tasa DECIMAL(5,2);
    
    SELECT COUNT(DISTINCT cg.camper_id) INTO total_campers
    FROM camper_groups cg
    JOIN training_groups tg ON cg.group_id = tg.id
    WHERE tg.route_id = p_route_id;
    
    SELECT COUNT(DISTINCT g.camper_id) INTO aprobados
    FROM graduates g
    WHERE g.route_id = p_route_id AND g.final_grade >= p_nota_minima;
    
    SET tasa = (aprobados * 100.0 / NULLIF(total_campers, 0));
    
    RETURN IFNULL(tasa, 0);
END //
DELIMITER ;
SELECT tasa_aprobacion_ruta(1, 65) AS tasa_aprobacion;

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
SELECT trainer_horario_disponible(1, 2, 3) AS horario_disponible;

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
DELIMITER //
CREATE FUNCTION puede_graduarse(
    p_camper_id INT,
    p_route_id INT,
    p_nota_minima DECIMAL(4,1)
) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE modulos_ruta INT;
    DECLARE modulos_aprobados INT;
    DECLARE graduado BOOLEAN;
    
    SELECT COUNT(*) INTO modulos_ruta
    FROM route_modules
    WHERE route_id = p_route_id;
    
    SELECT COUNT(DISTINCT e.module_id) INTO modulos_aprobados
    FROM evaluation_scores es
    JOIN evaluations e ON es.evaluation_id = e.id
    JOIN route_modules rm ON e.module_id = rm.module_id
    WHERE es.camper_id = p_camper_id
    AND rm.route_id = p_route_id
    GROUP BY e.module_id
    HAVING AVG(es.score) >= p_nota_minima;
    
    SET graduado = (modulos_aprobados = modulos_ruta);
    
    RETURN graduado;
END //
DELIMITER ;
SELECT puede_graduarse(1, 1, 65) AS puede_graduarse;

-- 14. Obtener el estado actual de un camper en función de sus evaluaciones.
DELIMITER //
CREATE FUNCTION estado_camper(
    p_camper_id INT,
    p_nota_minima DECIMAL(4,1)
) RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(4,1);
    DECLARE estado VARCHAR(50);
    
    SELECT AVG(es.score) INTO promedio
    FROM evaluation_scores es
    JOIN evaluations e ON es.evaluation_id = e.id
    WHERE es.camper_id = p_camper_id;
    
    IF promedio IS NULL THEN
        SET estado = 'Sin evaluaciones';
    ELSEIF promedio >= p_nota_minima THEN
        SET estado = 'Aprobado';
    ELSEIF promedio >= (p_nota_minima - 10) THEN
        SET estado = 'En riesgo';
    ELSE
        SET estado = 'Reprobado';
    END IF;
    
    RETURN estado;
END //
DELIMITER ;
SELECT estado_camper(1, 65) AS estado_camper;

-- 15. Calcular la carga horaria semanal de un trainer.
DELIMITER //
CREATE FUNCTION carga_horaria_trainer(
    p_trainer_id INT
) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE horas INT;
    
    SELECT COUNT(*) * 
    (SELECT TIME_TO_SEC(TIMEDIFF(tb.end_time, tb.start_time))/3600 
     FROM time_blocks tb LIMIT 1) INTO horas
    FROM trainer_schedules ts
    JOIN time_blocks tb ON ts.time_block_id = tb.id
    WHERE ts.trainer_id = p_trainer_id AND ts.is_available = FALSE;
    
    RETURN IFNULL(horas, 0);
END //
DELIMITER ;
SELECT carga_horaria_trainer(1) AS carga_horaria_semanal;

-- 16. Determinar si una ruta tiene módulos pendientes por evaluación.
DELIMITER //
CREATE FUNCTION modulos_pendientes_evaluacion(
    p_route_id INT,
    p_group_id INT
) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE modulos_ruta INT;
    DECLARE modulos_evaluados INT;
    DECLARE pendientes BOOLEAN;
    
    SELECT COUNT(*) INTO modulos_ruta
    FROM route_modules
    WHERE route_id = p_route_id;
    
    SELECT COUNT(DISTINCT e.module_id) INTO modulos_evaluados
    FROM evaluations e
    WHERE e.group_id = p_group_id;
    
    SET pendientes = (modulos_evaluados < modulos_ruta);
    
    RETURN pendientes;
END //
DELIMITER ;
SELECT modulos_pendientes_evaluacion(1, 1) AS modulos_pendientes;

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
DELIMITER //
CREATE FUNCTION horario_choca(
    p_trainer_id INT,
    p_classroom_id INT,
    p_dia_semana INT,
    p_bloque_horario INT
) RETURNS BOOLEAN
DETERMINISTIC   

BEGIN   
    DECLARE choca BOOLEAN;
    SELECT COUNT(*) INTO choca
    FROM trainer_schedules ts
    JOIN time_blocks tb ON ts.time_block_id = tb.id
    WHERE ts.trainer_id != p_trainer_id
    AND ts.classroom_id = p_classroom_id
    AND ts.day_of_week = p_dia_semana
    AND ts.time_block_id = p_bloque_horario
    AND ts.is_available = FALSE;
    RETURN IFNULL(choca, FALSE);
END //
DELIMITER ;
SELECT horario_choca(1, 1, 2, 3) AS horario_choca;

-- 19. Calcular cuántos campers están en riesgo en una ruta específica.
DELIMITER //
CREATE FUNCTION campers_en_riesgo_ruta(
    p_route_id INT,
    p_nota_minima DECIMAL(4,1)
) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE en_riesgo INT;
    
    SELECT COUNT(DISTINCT cg.camper_id) INTO en_riesgo
    FROM camper_groups cg
    JOIN training_groups tg ON cg.group_id = tg.id
    WHERE tg.route_id = p_route_id
    AND cg.status = 'Activo'
    AND estado_camper(cg.camper_id, p_nota_minima) = 'En riesgo';
    
    RETURN IFNULL(en_riesgo, 0);
END //
DELIMITER ;
SELECT campers_en_riesgo_ruta(1, 65) AS campers_en_riesgo;

-- 20. Consultar el número de módulos evaluados por un camper.
DELIMITER //
CREATE FUNCTION modulos_evaluados_camper(
    p_camper_id INT
) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE evaluados INT;
    
    SELECT COUNT(DISTINCT e.module_id) INTO evaluados
    FROM evaluation_scores es
    JOIN evaluations e ON es.evaluation_id = e.id
    WHERE es.camper_id = p_camper_id;
    
    RETURN IFNULL(evaluados, 0);
END //
DELIMITER ;

SELECT modulos_evaluados_camper(1) AS modulos_evaluados;
```

## dql_triggers.sql
```sql
-- Triggers
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
SELECT 1, 'T', 1
WHERE NOT EXISTS (
    SELECT 1 FROM trainers 
    WHERE person_id = 1 AND acronym = 'T'
);
SELECT t.id, t.acronym, p.document_number
FROM trainers t
JOIN persons p ON t.person_id = p.id
WHERE t.acronym = 'T' AND p.document_number = '123456789';

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
ALTER TABLE routes ADD COLUMN campus_id INT;
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
```
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
    acronym VARCHAR(3) NOT NULL,
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
    theory_percentage DECIMAL(4,1) NOT NULL,
    practice_percentage DECIMAL(4,1) NOT NULL,
    quizzes_percentage DECIMAL(4,1) NOT NULL,
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

--Tabla theory_score 

-- Tabla module_evaluations
CREATE TABLE module_evaluations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    camper_id INT NOT NULL,
    module_id INT NOT NULL,
    group_id INT NOT NULL,
    theory_score DECIMAL(4,1) NOT NULL,
    practice_score DECIMAL(4,1) NOT NULL,
    quizzes_score DECIMAL(4,1) NOT NULL,
    final_score DECIMAL(4,1) NOT NULL,
    evaluation_date DATE NOT NULL,
    FOREIGN KEY (camper_id) REFERENCES campers(id),
    FOREIGN KEY (module_id) REFERENCES modules(id),
    FOREIGN KEY (group_id) REFERENCES training_groups(id)
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
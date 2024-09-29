
DROP DATABASE IF EXISTS Test_Keepcoding_PostgreSQL;
CREATE DATABASE Test_Keepcoding_PostgreSQL;

CREATE TABLE Students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    registration_date DATE NOT NULL,
    enrollment_status VARCHAR(20)
);

CREATE TABLE Bootcamps (
    bootcamp_id SERIAL PRIMARY KEY,
    bootcamp_name VARCHAR(100) NOT NULL,
    description TEXT,
    duration INT,
    price DECIMAL(10, 2),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);

CREATE TABLE Modules (
    module_id SERIAL PRIMARY KEY,
    module_name VARCHAR(100) NOT NULL,
    bootcamp_id INT NOT NULL,
    module_duration INT,
    module_description TEXT,
    CONSTRAINT fk_bootcamp FOREIGN KEY (bootcamp_id) REFERENCES Bootcamps(bootcamp_id)
);

CREATE TABLE Professors (
    professor_id SERIAL PRIMARY KEY,
    professor_name VARCHAR(50) NOT NULL,
    specialty VARCHAR(100),
    professor_email VARCHAR(100) UNIQUE NOT NULL,
    module_id INT,
    CONSTRAINT fk_module FOREIGN KEY (module_id) REFERENCES Modules(module_id)
);

CREATE TABLE Enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INT NOT NULL,
    bootcamp_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
    enrollment_status VARCHAR(20),
    CONSTRAINT fk_student FOREIGN KEY (student_id) REFERENCES Students(student_id),
    CONSTRAINT fk_bootcamp_enrollment FOREIGN KEY (bootcamp_id) REFERENCES Bootcamps(bootcamp_id)
);

CREATE TABLE Evaluations (
    evaluation_id SERIAL PRIMARY KEY,
    student_id INT NOT NULL,
    module_id INT NOT NULL,
    grade DECIMAL(5, 2),
    CONSTRAINT fk_student_eval FOREIGN KEY (student_id) REFERENCES Students(student_id),
    CONSTRAINT fk_module_eval FOREIGN KEY (module_id) REFERENCES Modules(module_id)
);

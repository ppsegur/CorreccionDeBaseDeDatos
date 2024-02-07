DROP TABLE IF EXISTS empresa;
DROP TABLE IF EXISTS alumno;
DROP TABLE IF EXISTS curso;
DROP TABLE IF EXISTS alumno_asistencia;
DROP TABLE IF EXISTS profesor;
DROP TABLE IF EXISTS tipo_curso;


CREATE TABLE empresa (
	cif VARCHAR(10),
	nombre VARCHAR(150) NOT NULL,
	direccion VARCHAR(200), 
	telefono TEXT NOT NULL,
	CONSTRAINT pk_empresa PRIMARY KEY(cif)
);
CREATE TABLE alumno(
	dni VARCHAR(10),
	nombre VARCHAR(150) NOT NULL,
	direccion VARCHAR(200),
	telefono TEXT NOT NULL,
	edad INTEGER NOT NULL,
	empresa TEXT NOT NULL,
	CONSTRAINT pk_alumno PRIMARY KEY(dni)
);
CREATE TABLE alumno_asistencia(
	dni VARCHAR(10),
	n_concreto INTEGER,
	CONSTRAINT pk_alumno_asistencia PRIMARY KEY(dni, n_concreto)
);
CREATE TABLE curso(
	n_concreto INTEGER,
	fecha_inicio DATE NOT NULL,
	fecha_fin    DATE NOT NULL,
	dni_profesor VARCHAR(10) NOT NULL,
	tipo_curso   INTEGER NOT NULL,
	CONSTRAINT pk_curso PRIMARY KEY(n_concreto)
);
CREATE TABLE profesor(
	dni VARCHAR(10),
	nombre VARCHAR(150) NOT NULL,
	apellido VARCHAR(200) NOT NULL,
	telefono TEXT NOT NULL,
	direccion VARCHAR(300),
	CONSTRAINT pk_profesor PRIMARY KEY(dni)
);
CREATE TABLE tipo_curso(
	cod_curso INTEGER,
	duracion INTEGER, 
	programa VARCHAR(150),
	titulo  VARCHAR(100),
	CONSTRAINT pk_tipo_curso PRIMARY KEY(cod_curso)
);
ALTER TABLE curso
ADD CONSTRAINT fk_curso_profesor FOREIGN KEY(dni_profesor) REFERENCES profesor(dni) ON DELETE CASCADE,
ADD CONSTRAINT fk_curso_tipo_curso FOREIGN KEY(tipo_curso) REFERENCES tipo_curso(cod_curso) ON DELETE CASCADE;
ALTER TABLE alumno_asistencia 
ADD CONSTRAINT fk_alumno_asistencia_alumno FOREIGN KEY(dni) REFERENCES alumno(dni) ON DELETE  CASCADE,
ADD CONSTRAINT fk_alumno_asistencia_curso FOREIGN KEY(n_concreto) REFERENCES curso(n_concreto) ON DELETE CASCADE;
ALTER TABLE alumno ADD CONSTRAINT fk_alumno_empresa FOREIGN KEY(empresa) REFERENCES empresa(cif) ON DELETE CASCADE;

/*serta datos de ejemplo en todos las tablas. Al menos:
3 empresas
5 o 6 alumnos por empresa
4 tipos de cursos y 20 cursos
Un profesor diferente por curso
La asistencia de 8-10 alumnos por curso
*/
INSERT INTO empresa VALUES ('A79520656', 'Toysurus', ' Avenida de la Prensa numero 30 ,Sevilla','954571780');
INSERT INTO empresa VALUES ('B12345678', 'ElectroTech', 'Calle Innovación número 15, Barcelona', '900345678');
INSERT INTO empresa VALUES ('C98765432', 'Sofitec', 'Paseo de la Moda número 5, Madrid', '91012111');

INSERT INTO alumno VALUES ('12345678A', 'Juan Pérez', 'Calle Estudiante número 10, Sevilla', '612345678', 17, 'A79520656');
INSERT INTO alumno VALUES ('23456789B', 'María Gómez', 'Carrera del Saber número 25, Barcelona', '678123456', 12, 'B12345678');
INSERT INTO alumno VALUES ('34567890C', 'Carlos Rodríguez', 'Plaza del Conocimiento número 7, Madrid', '645987123', 16, 'C98765432');
INSERT INTO alumno VALUES ('56789023D', 'Carlos Ruiz', 'Calle Manuel Mantera 4, Sevilla', '654987123', 19, 'C98765432');
INSERT INTO alumno VALUES ('23456788F', 'Maricarmen', 'Plaza Era 28, Granada ', '606795933', 15, 'A79520656');



INSERT INTO alumno_asistencia VALUES ('12345678A', 4);
INSERT INTO alumno_asistencia VALUES ('23456789B', 5);
INSERT INTO alumno_asistencia VALUES ('34567890C', 4);
INSERT INTO alumno_asistencia VALUES ('56789023D', 6);
INSERT INTO alumno_asistencia VALUES ('23456788F', 7);
INSERT INTO alumno_asistencia VALUES ('55555555E', 6);
INSERT INTO alumno_asistencia VALUES ('66666666F', 8);
INSERT INTO alumno_asistencia VALUES ('11111111A', 9);
INSERT INTO alumno_asistencia VALUES ('22222222B', 10);
INSERT INTO alumno_asistencia VALUES ('33333333C', 11);


INSERT INTO curso VALUES (4, '2023-01-10', '2023-03-20', '98765432X', 1);
INSERT INTO curso VALUES (2, '2023-02-15', '2023-04-25', '87654321Y', 2);
INSERT INTO curso VALUES (3, '2023-03-20', '2023-05-30', '76543210Z', 3);
INSERT INTO curso VALUES (4, '2023-04-01', '2023-06-10', '98765432X', 4);
INSERT INTO curso VALUES (5, '2023-05-01', '2023-07-10', '87654321Y', 2);
INSERT INTO curso VALUES (6, '2023-06-01', '2023-08-10', '76543210Z', 3);
INSERT INTO curso VALUES (7, '2023-07-01', '2023-09-10', '98765432X', 1);
INSERT INTO curso VALUES (8, '2023-08-01', '2023-10-10', '87654321Y', 2);
INSERT INTO curso VALUES (9, '2023-09-01', '2023-11-10', '76543210Z', 3);
INSERT INTO curso VALUES (10, '2023-10-01', '2023-12-10', '98765432X', 1);
INSERT INTO curso VALUES (11, '2023-11-01', '2024-01-10', '87654321Y', 2);
INSERT INTO curso VALUES (12, '2023-12-01', '2024-02-10', '76543210Z', 3);
INSERT INTO curso VALUES (13, '2024-01-01', '2024-03-10', '98765432X', 1);
INSERT INTO curso VALUES (14, '2024-02-01', '2024-04-10', '87654321Y', 2);
INSERT INTO curso VALUES (15, '2024-03-01', '2024-05-10', '76543210Z', 3);
INSERT INTO curso VALUES (16, '2024-04-01', '2024-06-10', '98765432X', 1);
INSERT INTO curso VALUES (17, '2024-05-01', '2024-07-10', '87654321Y', 2);
INSERT INTO curso VALUES (18, '2024-06-01', '2024-08-10', '76543210Z', 3);
INSERT INTO curso VALUES (19, '2024-07-01', '2024-09-10', '98765432X', 1);
INSERT INTO curso VALUES (20, '2024-08-01', '2024-10-10', '87654321Y', 2);



INSERT INTO profesor VALUES ('98765432X', 'Ana', 'Martínez', '600123456', 'Calle del Conocimiento número 3, Sevilla');
INSERT INTO profesor VALUES ('87654321Y', 'David', 'López', '601234567', 'Avenida de la Innovación número 8, Barcelona');
INSERT INTO profesor VALUES ('76543210Z', 'Elena', 'García', '602345678', 'Plaza del Saber número 12, Madrid');

--
INSERT INTO tipo_curso VALUES (1, 30, 'Introducción a la Informática', 'Informática Básica');
INSERT INTO tipo_curso VALUES (2, 40, 'Desarrollo Web', 'Programación Web');
INSERT INTO tipo_curso VALUES (3, 50, 'Marketing Digital', 'Marketing en Internet');



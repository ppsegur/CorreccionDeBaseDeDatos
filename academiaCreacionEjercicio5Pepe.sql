CREATE TABLE empresa (
	cif VARCHAR(10);
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
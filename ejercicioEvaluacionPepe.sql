

DROP TABLE IF EXISTS alumno;
DROP TABLE IF EXISTS asignacion_act;
DROP TABLE IF EXISTS asistencia_act;
DROP TABLE IF EXISTS docente;
DROP TABLE IF EXISTS actividad;
CREATE TABLE docente(
	dni 			VARCHAR(10) NOT NULL,
	nombre 			VARCHAR(150) NOT NULL,
	telefono		TEXT NOT NULL,
	anio_ingreso 	TIMESTAMP NOT NULL,
	CONSTRAINT pk_docente PRIMARY KEY(dni)
);
CREATE TABLE actividad(
	id_act  SERIAL,
	nombre  VARCHAR(150) NOT NULL,
	duracion TIMESTAMP WITH TIME ZONE NOT NULL, --Para tener un intervalo de timepo mucho mas definido
	CONSTRAINT pk_actividad PRIMARY KEY(id_act)
);
CREATE TABLE alumno(
	cod_alumno  SERIAL,
	nombre      VARCHAR(150) NOT NULL,
	telefono    TEXT NOT NULL,
	nivel		VARCHAR(30) NOT NULL,--He elegido cadena de caracteres en vez de integer por lo que el nivel seria dado por "2 años"
	CONSTRAINT pk_alumno PRIMARY KEY(cod_alumno)
);

CREATE TABLE asignacion_act(
	id_doc  VARCHAR(10),
	id_act  SERIAL,
	dia_semana  TIMESTAMP ,
	hora        TIMESTAMP WITH TIME ZONE ,
	CONSTRAINT pk_asignacion_act PRIMARY KEY(id_doc,id_act,dia_semana,hora)
);
CREATE TABLE asistencia_act(
	id_alumno    SERIAL,
	id_actividad SERIAL,
	id_docente   VARCHAR(10),
	CONSTRAINT pk_asistencia_act PRIMARY KEY(id_alumno,id_actividad)
);
ALTER TABLE asignacion_act ADD CONSTRAINT fk_asignacion_docente FOREIGN KEY(id_doc) REFERENCES docente(dni) ON DELETE CASCADE;
ALTER TABLE asignacion_act ADD CONSTRAINT fk_asignacion_actividad FOREIGN KEY(id_act) REFERENCES actividad(id_act) ON DELETE CASCADE;
ALTER TABLE asistencia_act ADD CONSTRAINT fk_asistencia_act_docente FOREIGN KEY(id_docente) REFERENCES docente(dni) ON DELETE CASCADE;
ALTER TABLE asistencia_act ADD CONSTRAINT fk_asistencia_act_actividad FOREIGN KEY(id_actividad) REFERENCES actividad(id_act) ON DELETE CASCADE;
ALTER TABLE asistencia_act ADD CONSTRAINT fk_asistencia_act_alumno FOREIGN KEY(id_alumno) REFERENCES alumno(cod_alumno) ON DELETE CASCADE;
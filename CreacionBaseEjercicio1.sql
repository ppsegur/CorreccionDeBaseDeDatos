

CREATE TABLE autor(
 dni VARCHAR(10),
 nombre TEXT NOT NULL,
 nacionalidad  VARCHAR(100),
CONSTRAINT pk_autor PRIMARY KEY(dni)
); 
CREATE TABLE genero(
	id_genero SERIAL,
	nombre TEXT NOT NULL ,
	descripcion VARCHAR(400),
	CONSTRAINT pk_genero  PRIMARY KEY(id_genero)
);
CREATE TABLE editorial(
	cod_editorial SERIAL,
	nombre TEXT NOT NULL,
	direccion VARCHAR(100),
	poblacion VARCHAR(100),
	CONSTRAINT pk_editorial PRIMARY KEY(cod_editorial)
);

CREATE TABLE libro(
	isbn VARCHAR(25),
	titulo VARCHAR(100) NOT NULL,
	dni_autor  VARCHAR(10) NOT NULL,
	cod_genero INTEGER NOT NULL,
	cod_editorial INTEGER NOT NULL,
	CONSTRAINT pk_libro PRIMARY KEY(isbn),
	CONSTRAINT fk_libro_autor FOREIGN KEY(dni_autor) REFERENCES autor(dni),
	CONSTRAINT fk_libro_genero FOREIGN KEY(cod_genero) REFERENCES genero(id_genero),
	CONSTRAINT fk_libro_editorial FOREIGN KEY (cod_editorial) REFERENCES editorial(cod_editorial)
	
);

CREATE TABLE edicion (
	isbn VARCHAR(25),
	fecha_publicacion DATE,
	cantidad INTEGER, 
	CONSTRAINT pk_edicion PRIMARY KEY(isbn, fecha_publicacion),
	CONSTRAINT fk_edicion_libro FOREIGN KEY(isbn) REFERENCES libro,
	CONSTRAINT ck_cantidad_positiva CHECK (cantidad>0)
);

--8 de Enero
/*Comando de creacion de base de datos */
CREATE DATABASE prueba;
/*Creacion de tabla en una base de datos*/
CREATE TABLE my_first_table (
	first_column text,
	second_column integer
);

CREATE TABLE producto(
	num_producto integer,
	nombre text,
	precio numeric DEFAULT 9.99 
);
-- DEFAULT es para dar un valor por defecto (si le damos otro valor en el insert al precio machaá el respectivo por default )
-- crea una tabla en la base de datos con dos columnas y sus respectivos tipos de datos 

/*Para borrar una base de datos u otro*/ DROP DATABASE prueba;
--Si haces algun cambio en una tabla para cammbiarlo en al base de datos tendriamos que borrar primero la tabla y depsués volverla a correr

--9 de Enero 
/*Cuando nos de un error al intentar borrar una tabla usaremos el siguiente comando */ DROP TABLE IF EXISTS nombre_de_la_tabla; 
--Un comando que no en todos los ides podemoe usarlo

/**/
SELECT (1/2.0)::real ;--Devolvería 0.5

CREATE TABLE producto_serial(
	id_producto SERIAL,
	nombre TEXT
) ;
INSERT INTO producto_serial (nombre)
VALUES ('Macnook Pro'),('Dell ');
--como podemos ver el valor que se le da es el nombre, al hacer refresh cojiendo la siguiente linea podemso ver qeu el mismo pgAdmin haya añadido 
--los valores de id_producto automaticamente 
SELECT * FROM producto_serial;

CREATE TABLE producto_prueba_pepe(
	id_producto SERIAL,
	nombre TEXT,
	precio NUMERIC,
	fecha_caducida DATE,
	en_stock BOOLEAN,
	medida_producto CHAR(1),
	CONSTRAINT precio_positivo CHECK (precio>0)
);
INSERT INTO producto_prueba_pepe (nombre, precio , en_stock, medida_producto)
VALUES ('pan',1, true, 'a');
DROP TABLE producto_prueba_pepe;
SELECT * FROM producto_prueba_pepe;


CREATE TABLE alumno(
	cod_alumno SERIAL, --Con smallSerial seria suficeinte para una o dos clases (unos  100 alumnos  o +)
	nombre VARCHAR(150),
	apellido1 VARCHAR(150),
	apellido2 VARCHAR(150),
	nombre_completo VARCHAR(500)
		GENERATED ALWAYS AS 
	( nombre|| ' '||apellido1|| ' '||apellido2) STORED ,
	fecha_nacimiento DATE,
	edad_31_diciembre SMALLINT,
	email VARCHAR(320)
);
INSERT INTO alumno(nombre,apellido1,apellido2,fecha_nacimiento,edad_31_diciembre,email)
VALUES('Pepe','Segura','Rodriguez','2003-02-02', 20, 'pepesegurarodriguez@gmail.com');
SELECT * FROM alumno;
DROP TABLE alumno;
--TODO queda por hacer en VALUES la fecha de nacimiento que desconocemos el formato para escribir la fecha 


-- 10 de Enero de 2024	(Restricciones):
CREATE TABLE producto2 (
	num_producto   SERIAL,
	precio 		NUMERIC,
	nombre 	TEXT,
	CONSTRAINT pk_producto2 PRIMARY KEY (num_producto),
	CONSTRAINT precio_positivo CHECK (precio>0)
);
CREATE TABLE pedido(
	id_pedido SERIAL,
	num_producto INTEGER,
	cantidad INTEGER,
	CONSTRAINT pk_pedido PRIMARY KEY(id_pedido),
	CONSTRAINT fk_pedido_producto FOREIGN KEY(num_producto) REFERENCES producto2(num_producto)
);
CREATE TABLE alumno2(
	num_alumno SERIAL,
	nombre TEXT
	CONSTRAINT pk_alumno PRIMARY KEY(num_alumno)
);
CREATE TABLE asignatura2(
	id_asignatura SERIAL,
	nombre VARCHAR(100),
	profesor VARCHAR(200),
	CONSTRAINT pk_asignatura PRIMARY KEY (id_asignatura)
);
CREATE TABLE matricula(
	id_alumno SERIAL,
	id_asignatura SERIAL,
	anio_escolar VARCHAR(200),
	CONSTRAINT pk_matricula PRIMARY KEY (id_alumno, id_asignatura, anio_escolar),
	CONSTRAINT fk_matricula_alumno FOREIGN KEY(id_alumno) REFERENCES alumno (id_alumno),
	CONSTRAINT fk_matricula_asignatura FOREIGN KEY(id_asignatura) REFERENCES asignatura(id_asignatura)
);
CREATE TABLE nota(
	id_alumno SERIAL,
	id_asignatura SERIAL,
	anio_escolar VARCHAR(200),
	tipo_evaluacion VARCHAR(1),
	nota NUMERIC(4,2),
	CONSTRAINT pk_nota PRIMARY KEY(id_alumno, id_asignatura,anio_escolar,tipo_evaluacion),
	CONSTRAINT ck_nota_tipo_evaluacion CHECK (tipo_evaluacion IN ('1','2','3','F')),
	CONSTRAINT fk_nota_matricula FOREIGN KEY (id_alumno,id_asignatura,anio_escolar) REFERENCES matricula2(id_alumno, id_asignatura, anio_escolar)
);

--el tipo de dato de las claves externas tiene que ser compatible(igual) al de las claves primarias.

--17 de enero de 2024
-- Manipulaciión de datos
--Insertar un dato en una tabla
INSERT INTO producto VALUES (1, 'Queso', 9.99);
--Insertar varios datos en una misma sentencia 
INSERT INTO productos (num_producto, nombre, precio) VALUES
(1, 'Queso', 9.99),
(2, 'Pan', 0.99),
(3, 'Leche', 1.25);

-- Si le damos el valor CURRENTTIMESTAMP se guarda la fecha del dia actual
INSERT INTO productos (num_producto, nombre, precio) VALUES
(1, 'Queso', 9.99),
(2, 'Pan', 0.99),
(3, 'Leche', 1.25);
DROP TABLE IF EXISTS producto;
CREATE TABLE producto(
	num_producto  SERIAL,
	nombre        TEXT,
	precio    NUMERIC(4,2),
	CONSTRAINT pk_producto PRIMARY KEY(num_producto)
);
INSERT INTO producto (nombre, precio) VALUES
	('Filete de pollo', 5.69),
	('Mango',0.50),
	('Sandia', 6.23);
	
	SELECT * FROM producto;
	
	ALTER SEQUENCE producto_num_producto_seq RESTART WITH 1000 ;--INCREMENT BY 10(Para que en vez de uno en uno vaya de diez en diez);
	--Resetea todas las secuencias para que el proximo insert empieze por el número de 1000
	INSERT INTO producto(nombre,precio)  VALUES ('Melva',4);
	INSERT INTO producto(nombre,precio)  VALUES ('Melon',3.2);
	INSERT INTO producto(nombre,precio)  VALUES ('Chucherias',0.20);


CREATE TABLE temperatura_jaen(
	fecha DATE,
	estacion TEXT,
	provincia TEXT,
	temperatura_media  NUMERIC,
	CONSTRAINT pk_temperatura_jaen PRIMARY KEY(fecha, estacion)
);
--Para insertar datos de una tabla en otra 
INSERT INTO temperatura_jaen 
SELECT fecha, estacion, provincia, temperatura_media
FROM climatologia 
WHERE provincia = 'Jaén';

--Para actualizar la base de datos 
UPDATE producto SET precio = precio*2;
UPDATE producto SET precio = 10 WHERE precio = 5;

ALTER TABLE producto ADD COLUMN disponible boolean;
UPDATE producto SET disponible = true;
UPDATE producto SET nombre = 'Melon agridulce' , precio = 5.2 WHERE num_producto = 1001;
UPDATE producto SET precio = precio-(precio * (10.0/100)) WHERE precio > 10;
ALTER TABLE nombre_de_la_tabla DROP COLUMN nombre_de_la_columna;--Para borrar una columna 
--Para borrar los datos de una columna 
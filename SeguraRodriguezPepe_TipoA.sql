--Eliminar tablas 
DROP TABLE  IF EXISTS empleado ; 
DROP TABLE  IF EXISTS cliente ; 
DROP TABLE IF EXISTS venta ; 
DROP TABLE IF EXISTS linea_venta ; 
DROP TABLE IF EXISTS producto ; 
DROP TABLE IF EXISTS categoria ; 


--Creacion de tablas 
CREATE TABLE empleado(
	num_empleado SERIAL,
	nombre 	VARCHAR(150) NOT NULL,
	apellidos VARCHAR(150) NOT NULL,
	email 	VARCHAR(320),
	cuenta_corriente  VARCHAR(24),
	pass		VARCHAR(8),
	CONSTRAINT pk_empleado PRIMARY KEY(num_empleado),
	CONSTRAINT ck_email_empleado CHECK (email ILIKE '%@%'),
	CONSTRAINT ck_cuenta_corriente CHECK( cuenta_corriente  LIKE 'ES%'),
	CONSTRAINT ck_pass CHECK(pass NOT LIKE '% %')
);
CREATE TABLE cliente(
	dni VARCHAR(10),
	nombre  VARCHAR(150) NOT NULL,
	apellidos VARCHAR(300) NOT NULL,
	direccion VARCHAR(100),
	email	VARCHAR(320),
	fecha_alta 	DATE,
	CONSTRAINT pk_cliente PRIMARY KEY(dni),
	CONSTRAINT ck_email_cliente CHECK (email ILIKE '%@%')
);

CREATE TABLE venta(
	id_venta		SERIAL,
	fecha			DATE NOT NULL,
	empleado		INTEGER NOT NULL,
	cliente			VARCHAR(10) NOT NULL,
	CONSTRAINT pk_venta PRIMARY KEY(id_venta)
);
CREATE TABLE linea_venta(
	id_venta	SERIAL,
	id_linea	SERIAL,
	cantidad	INTEGER,
	producto	INTEGER,
	precio		NUMERIC(6,2) DEFAULT 9.99,
	CONSTRAINT pk_linea_venta PRIMARY KEY(id_venta, id_linea),
	CONSTRAINT ck_cantidad CHECK(cantidad>0)
);
CREATE TABLE producto(
	cup 	SERIAL,
	nombre  VARCHAR(150) NOT NULL,
	descripcion  VARCHAR(300),
	pvp			NUMERIC(6,2) NOT NULL, --6 en vez de 4 para que no diese problema en insertar datos como el de 799
	categoria	INTEGER,
	CONSTRAINT pk_producto PRIMARY KEY(cup)
);
CREATE TABLE categoria(
	id_categoria		SERIAL,
	nombre  			VARCHAR(150) NOT NULL,
	descripcion 		VARCHAR(300),
	CONSTRAINT pk_categoria PRIMARY KEY(id_categoria) 
);
--Claves foráneas
ALTER TABLE venta ADD CONSTRAINT fk_venta_empleado FOREIGN KEY(empleado) REFERENCES empleado(num_empleado) ON DELETE CASCADE;
ALTER TABLE venta ADD CONSTRAINT fk_venta_cliente FOREIGN KEY(cliente) REFERENCES cliente(dni) ON DELETE CASCADE;
ALTER TABLE linea_venta ADD CONSTRAINT fk_linea_venta_venta FOREIGN KEY(id_venta) REFERENCES venta(id_venta) ON DELETE SET NULL;
ALTER TABLE linea_venta ADD CONSTRAINT  fk_linea_venta_producto FOREIGN KEY(producto) REFERENCES producto(cup) ON DELETE RESTRICT;
ALTER TABLE producto ADD CONSTRAINT fk_producto_categoria FOREIGN KEY(categoria ) REFERENCES categoria(id_categoria) ON DELETE RESTRICT;

--Insercción de datos
--JESUS
INSERT INTO categoria(id_categoria,nombre,descripcion) VALUES (1,'Apple','Gran compañia, conocida mundialmente');
INSERT INTO cliente(dni,nombre,apellidos,email) VALUES ('11111111A','Jesus', 'Casanova','jesus.casanova@mitienda.com');
INSERT INTO producto(cup,nombre,descripcion,pvp,categoria)  VALUES (4,'Mac Mini M2','portatil de 256 GB de disco duro',799,1);
INSERT INTO empleado(num_empleado,nombre, apellidos, email, cuenta_corriente ) VALUES (1,'Miguel', 'Campos','mcampos@mitienda.com','ES1200000000000012345678');
INSERT INTO venta(id_venta,fecha,empleado,cliente) VALUES(5,'25-6-2022',1,'11111111A');
INSERT INTO linea_venta(id_venta, cantidad, producto ,precio ) VALUES (5,1,4,799);
--RAFA
INSERT INTO cliente(dni,nombre, apellidos,email,direccion,fecha_alta) VALUES ('22222222A','Rafael','Villar','rafael.villar@correo.com','Calle Rue del Percebe 13','24-01-2024');
INSERT INTO producto(cup,nombre, descripcion, pvp, categoria) VALUES (6,'Apple Wacth Nike+','reloj digital colaboracion Apple x Nike',499,1);
INSERT INTO empleado(num_empleado,nombre,apellidos,email,cuenta_corriente) VALUES(2,'Ángel', 'Naranjo','anaranjo@mitienda,com','ES2100000000000087654321');
INSERT INTO venta(id_venta,fecha, empleado, cliente) VALUES(6,'24-01-2024',2,'22222222A');
INSERT INTO linea_venta(id_venta,cantidad, producto, precio) VALUES (6,1,6,499);
--Damos un valor a los serial para que no haya errores(pgAdmin le da valores a los serial automaticamente)
SELECT * FROM producto;
 UPDATE producto(pvp = pvp-(pvp*0.1));
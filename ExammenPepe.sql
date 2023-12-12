--Consulta 1
SELECT c.nombre, v.nombre 
FROM vendedor v JOIN operacion  o USING(id_vendedor)
				JOIN comprador  c USING(id_cliente)
				JOIN inmueble  i USING(id_inmueble)
				JOIN tipo t ON (tipo_inmueble = id_tipo)
WHERE i.provincia IN ('Sevilla', 'Córdoba', 'Jaén')
AND i.tipo_operacion = 'Alquiler'
AND t.nombre = 'Piso'
AND i.superficie < 100
AND (EXTRACT(MONTH FROM o.fecha_operacion) = 9
	 AND TO_CHAR(o.fecha_operacion,'ID')= '2' OR EXTRACT(MONTH FROM o.fecha_operacion) = 10
	 AND TO_CHAR(o.fecha_operacion,'ID')= '1');
--Consulta 2 
SELECT ROUND(AVG(o.precio_final),2)
FROM operacion o JOIN inmueble i USING(id_inmueble)
WHERE i.tipo_operacion = 'Venta'	
AND i.provincia IN ('Jaén', 'Granada')
AND AGE(o.fecha_operacion,i.fecha_alta) < '3 months';

--Consulta 3
SELECT i.*
FROM inmueble i   JOIN operacion USING(id_inmueble)
WHERE AGE(fecha_alta) > '6 months'
AND tipo_operacion = 'Alquiler'
AND fecha_operacion > CURRENT_TIMESTAMP;
AND fecha_operacion IS NOT NULL;

--Consulta 4 
SELECT ROUND(COALESCE(precio-(precio_final))*precio/100
FROM inmueble JOIN operacion USING (id_inmueble)
WHERE tipo_operacion = 'Alquiler'
AND TO_CHAR(fecha_operacion,'DD/MM') >'21/03'
AND TO_CHAR(fecha_operacion,'DD/MM') < '20/06';





--Consulta 5 
SELECT c.*, v.*, o.* , t.*
FROM vendedor v JOIN operacion  o USING(id_vendedor)
				JOIN comprador  c USING(id_cliente)
				JOIN inmueble  i USING(id_inmueble)
				JOIN tipo t ON (tipo_inmueble = id_tipo)
WHERE t.nombre NOT ILIKE 'Piso' 
AND t.nombre NOT ILIKE 'Casa'
AND (
	 EXTRACT(MONTH FROM fecha_operacion) IN (1,3,5,7,9,11)
	AND AGE(fecha_operacion, fecha_alta)>'90 days');

SELECT * 
FROM tipo;
SELECT *
FROM inmueble JOIN tipo ON (id_tipo = tipo_inmueble);
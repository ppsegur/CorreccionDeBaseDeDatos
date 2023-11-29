--Ejercicio 6 Boletin 1 Tema 4
/*Selecciona el top 3 de pisos vendidos más caros en Sevilla a lo largo del año 2019 (puedes investigar el uso de LIMIT para hacerlo)
*/
SELECT  precio_final, id_inmueble, nombre
FROM inmueble JOIN tipo t ON(tipo_inmueble = id_tipo) 
			JOIN operacion USING (id_inmueble)
WHERE t.nombre = 'Piso'
	--AND tipo_operacion = 'Venta'
	AND provincia = 'Sevilla'
	AND EXTRACT(YEAR FROM fecha_operacion) = 2021
	ORDER BY precio_final DESC
	LIMIT 3;
	/*Selecciona el precio medio de los alquileres en Málaga en los meses de Julio y Agosto (da igual de qué año).
*/
--Consulta nº 2 añadiendo que no se hayan alquilado aun
--Cuando halla algo raro pero sin que ver con las fechas se suele utilizar un join lateral
	SELECT AVG(precio)
FROM inmueble LEFT JOIN  operacion o USING (id_inmueble)
WHERE tipo_operacion = 'Alquiler'
	AND provincia = 'Málaga'
	AND EXTRACT(MONTH FROM fecha_alta) IN (7,8)
	AND o.id_inmueble IS NULL;--BETWEEN 7 AND 8;
/*Selecciona los inmuebles que se han vendido en Jaén y Córdoba en los últimos 3 meses del año 2019 o 2020.
**/
SELECT i.*
FROM inmueble i JOIN operacion o USING(id_inmueble)
WHERE tipo_operacion = 'Venta'
AND provincia IN ('Jaén', 'Córdoba')
AND EXTRACT(MONTH FROM fecha_operacion) BETWEEN 2 AND 3
AND EXTRACT(DAY FROM fecha_operacion) BETWEEN 2019 AND 2020
/*AND EXTRACT(MONTH FROM fecha_operacion) BETWEEN 10 AND 12
AND EXTRACT(YEAR FROM fecha_operacion) BETWEEN 2019 AND 2020;
--EXTRACT(MONTH FROM fecha_operacion) IN (10,11,12);*/

/*Selecciona los inmuebles que se han vendido en jaén y córdoba 
del 15 de Enero al 15 de MArzo da igual el año*/
SELECT i.*, o.*
FROM inmueble i JOIN operacion o USING(id_inmueble)
WHERE provincia IN ('Jaén', 'Córdoba')
AND tipo_operacion = 'Venta'
AND EXTRACT(MONTH FROM fecha_operacion)IN (1)
AND EXTRACT (DAY FROM   fecha_operacion)BETWEEN 15 AND 31
OR (provincia IN ('Jaén', 'Córdoba')
AND tipo_operacion = 'Venta'
AND EXTRACT(MONTH FROM fecha_operacion)IN (2))
OR 
(provincia IN ('Jaén', 'Córdoba')
AND tipo_operacion = 'Venta'
AND EXTRACT(MONTH FROM fecha_operacion)IN (3)
AND EXTRACT (DAY FROM fecha_operacion)BETWEEN 1 AND 15);
/*Selecciona el precio medio de las ventas de Parking en 
la provincia de Huelva para aquellas operaciones que se 
realizaran entre semana (de Lunes a Viernes).
*/




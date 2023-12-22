--Ejercicio 1

SELECT c.nombre, provincia, tipo_operacion
FROM comprador c JOIN operacion USING(id_cliente)
				JOIN inmueble USING(id_inmueble)	
WHERE provincia IN ('Granada', 'Almeria')
AND c.nombre  NOT IN (
	SELECT c.nombre
	FROM comprador c JOIN operacion USING(id_cliente)
				JOIN inmueble USING(id_inmueble)
	WHERE tipo_operacion = 'Venta'
)


--Ejercicio 5 
WITH precio_medioT AS (
	SELECT AVG(precio_final* superficie) as "precio_medio_superficie", TO_CHAR(fecha_operacion, 'MM/YY') as "fecha"
	FROM inmueble JOIN operacion USING(id_inmueble)
	WHERE tipo_operacion = 'Alquiler'
	GROUP BY TO_CHAR(fecha_operacion, 'MM/YY')
), precio_medioF AS
(SELECT AVG(precio_final) as "precio_medio", TO_CHAR(fecha_operacion, 'MM/YY') as "fecha"
	FROM inmueble JOIN operacion USING(id_inmueble)
	WHERE tipo_operacion = 'Alquiler'
	GROUP BY TO_CHAR(fecha_operacion, 'MM/YY'))
SELECT ROUND(precio_medio_superficie,2), fecha
FROM precio_medioT
UNION 
SELECT ROUND(precio_medio,2),fecha 
FROM precio_medioF;

--Ejercicio 4
With alquiler AS(
	SELECT ROUND(COALESCE((precio_final/COUNT(*) )*100),2 ) as "alquileres_por" ,provincia
	FROM inmueble JOIN operacion USING(id_inmueble)
	WHERE tipo_operacion = 'Alquiler'
	AND EXTRACT(year FROM fecha_operacion) IN (2022)
	GROUP BY precio_final, provincia
), ventas AS (
	SELECT ROUND(COALESCE((precio_final/COUNT(*) )*100),2) as "ventas_por", provincia
	FROM inmueble JOIN operacion USING(id_inmueble)
	WHERE tipo_operacion = 'Venta'
	AND EXTRACT(year FROM fecha_operacion) IN (2022)
	GROUP BY precio_final, provincia
)
SELECT AVG(alquileres_por) as "alquiler", provincia,  AVG(ventas_por) as "venta", provincia
FROM alquiler JOIN ventas USING (provincia)
GROUP BY provincia



--EJERCICIO 2
SELECT c.nombre, COUNT(*)
	FROM comprador c JOIN operacion USING (id_cliente)
	JOIN inmueble USING(id_inmueble)
WHERE tipo_operacion ='Alquiler'
AND precio > ALL (
SELECT SUM)

LIMIT 2;


--Ejer. 3 
SELECT id_inmueble
FROM inmueble JOIN operacion USING(id_inmueble)
WHERE tipo_operacion= 'Venta'
	
	AND precio < ALL (
		SELECT AVG(precio)
		FROM inmueble 
		WHERE tipo_operacion = 'Venta'

);
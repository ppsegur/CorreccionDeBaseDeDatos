/*Selecciona, agrupando por vendedor, el precio final medio de pisos y casas que se han vendido en cada provincia. Debe aparecer el nombre del vendedor, 
la provincia y el precio medio.*/
WITH precio_final_medio_pisos AS (
        SELECT AVG(precio_final) AS "media_precio_pisos", provincia, id_vendedor
        FROM operacion JOIN inmueble USING(id_inmueble)
                       JOIN tipo t ON(tipo_inmueble = id_tipo)
        WHERE tipo_operacion = 'Venta'
            AND t.nombre = 'Piso'
        GROUP BY provincia, id_vendedor
), precio_final_medio_casas AS (
        SELECT AVG(precio_final) AS "media_precio_casas", provincia, id_vendedor
        FROM operacion JOIN inmueble USING(id_inmueble)
                       JOIN tipo t ON(tipo_inmueble = id_tipo)
        WHERE tipo_operacion = 'Venta'
            AND t.nombre = 'Casa'
        GROUP BY provincia, id_vendedor
)
SELECT id_vendedor, ROUND(media_precio_pisos,2), ROUND(media_precio_casas,2)
FROM precio_final_medio_pisos pfmp JOIN precio_final_medio_casas pfmc USING(id_vendedor)
GROUP BY id_vendedor, media_precio_pisos, media_precio_casas;


/*Seleccionar la suma del precio final, agrupado por provincia, de aquellos locales donde su precio sea superior
al producto del número de metros cuadrados de ese local por el precio medio del metro cuadrado de los locales de esa provincia*/
SELECT provincia, SUM(precio_final) AS "suma_precio_final"
FROM inmueble i1 JOIN operacion USING(id_inmueble)
              JOIN tipo t ON (tipo_inmueble = id_tipo)
WHERE t.nombre = 'Local'
    AND precio > ALL (
        SELECT (superficie * AVG(superficie))
        FROM inmueble i2 
        WHERE i2.tipo_inmueble = i1.tipo_inmueble
        GROUP BY superficie
                      )
GROUP BY provincia;
--Corrección de Luismi
SELECT  provincia, SUM(precio_final)
FROM inmueble i1 JOIN operacion USING (id_inmueble)
		JOIN tipo ON (tipo_inmueble= id_tipo)
WHERE tipo.nombre = 'Local'
AND (precio_final/superficie) > (
	SELECT AVG(precio_final/ superficie)
	FROM inmueble i2 JOIN operacion USING (id_inmueble)
		
	WHERE i1.provincia = i2.provincia
	AND i1.tipo_operacion = i2.tipo_operacion
	AND i1.tipo_inmueble = i2.tipo_inmueble
)
GROUP BY provincia;
/*Selecciona la media de pisos vendidos al día que se han vendido en cada provincia. Es decir, debes calcular
primero el número de pisos que se han vendido cada día de la semana en cada provincia, y después, sobre eso, calcular la media por provincia.*/

WITH pisos_por_dia AS (
    SELECT provincia,
    EXTRACT(isodow FROM fecha_operacion) as "dia",
    COUNT(*) as "cantidad"        
    FROM inmueble JOIN operacion USING (id_inmueble)
        JOIN tipo ON (tipo_inmueble = id_tipo)
    WHERE tipo.nombre = 'Piso'
      AND tipo_operacion = 'Venta'
    GROUP BY provincia, dia
)
SELECT provincia, AVG(cantidad)
FROM pisos_por_dia
GROUP BY provincia;





/*Selecciona el cliente que ha comprado más barato cada tipo de inmueble (casa, piso, local, …). Debe aparecer el nombre del cliente, la provincia del inmueble,
la fecha de operación, el precio final y el nombre del tipo de inmueble. ¿Te ves capaz de modificar la consulta para que en lugar de que salga el más barato,
salgan los 3 más baratos?*/
SELECT c.nombre, i.provincia, o.fecha_operacion, o.precio_final, t.nombre
FROM comprador c JOIN operacion o USING(id_cliente)
                 JOIN inmueble i USING(id_inmueble)
                 JOIN tipo t ON(tipo_inmueble = id_tipo)
WHERE precio_final < ALL (
        SELECT MIN(precio_final)
        FROM operacion JOIN inmueble USING(id_inmueble)
                       JOIN tipo t ON(tipo_inmueble = id_tipo)
        WHERE tipo_operacion = 'Venta'
        GROUP BY t.nombre;

	--Corrección de luismi 
	SELECT c.nombre, provincia, fecha_operacion, precio_final , t.nombre
	FROM comprador c JOIN operacion o USING(id_cliente)
                 JOIN inmueble i1 USING(id_inmueble)
                 JOIN tipo t ON(tipo_inmueble = id_tipo)
	WHERE tipo_operacion = 'Venta' AND precio_final <= ALL (
	SELECT precio_final 
		FROM inmueble i2 JOIN operacion USING(id_inmueble)
		WHERE tipo_operacion = 'Venta'
			AND i1.tipo_inmueble = i2.tipo_inmueble
	);
/*De entre todos los clientes que han comprado un piso en Sevilla, selecciona a los que no han realizado ninguna compra en fin de semana.*/
SELECT c.nombre 
FROM comprador c 
WHERE id_cliente NOT IN (
SELECT id_cliente
FROM comprador
	JOIN operacion USING (id_cliente)
JOIN inmueble i USING(id_inmueble)
JOIN tipo t ON id_tipo = i.tipo_inmueble
WHERE EXTRACT(dow FROM fecha_operacion) NOT IN (6,7)
	AND provincia = 'Sevilla'
	AND t.nombre = 'Piso'
);
--Corrección de luismi
	WITH comprador_por_sevilla AS (
	SELECT c.nombre
	FROM comprador c JOIN operacion USING (id_cliente)
	JOIN inmueble USING(id_inmueble) 
	JOIN tipo t ON (tipo_inmueble = id_tipo)
	WHERE tipo_operacion = 'Venta'
		AND provincia = 'Sevilla'
		AND t.nombre = 'Piso'
)
SELECT id_cliente, nombre 
	FROM comprador_por_sevilla
	WHERE id_cliente NOT IN (
	SELECT id_cliente 
		FROM xomprador_por_sevilla
		WHERE EXTRACT(isodow FROM fecha_operacion) BETWEEN 1 AND 5
);
/**El responsable de la inmobiliaria quiere saber el rendimiento de operaciones de alquiler que realiza cada vendedor durante
	los días de la semana (de lunes a sábado). Se debe mostrar el nombre del vendedor, el % del número de operaciones de alquiler
	que ha realizado en ese día de la semana ese vendedor y el precio medio por metro cuadrado de las operaciones de alquiler que 
	ha realizado ese vendedor en ese día de la semana.*/

SELECT v.nombre AS nombre_vendedor, TO_CHAR(o.fecha_operacion, 'Day') as dia_semana,
    COUNT() / (
        SELECT COUNT() 
        FROM operacion JOIN inmueble USING(id_inmueble)
        WHERE tipo_operacion = 'Alquiler'
    ) * 100 AS porcentaje_operaciones,
    AVG(i.precio / i.superficie) AS precio_medio_metro_cuadrado
FROM vendedor v JOIN operacion o USING(id_vendedor)
                JOIN inmueble i USING(id_inmueble)
WHERE i.tipo_operacion = 'Alquiler'
GROUP BY v.nombre, TO_CHAR(o.fecha_operacion, 'Day');
	
	--Correccioón de luismi 
SELECT v.nombre, EXTRACT(isodow FROM fecha_operacion),
	FROM vendedor v JOIN operacion USING(id_vendedor)
		JOIN inmueble USING(id_inmueble)
	WHERE tipo_operacion = 'Alquiler'
	AND EXTRACT(isodow FROM fecha_operacion) != 7
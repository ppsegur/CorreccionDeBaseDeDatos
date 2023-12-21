
/*Seleccionar el nombre, apellidos y gasto total de aquellos clientes
que gastaron menos que la media de gasto por cliente
.*/
--Opción sin WITH
SELECT nombre, apellido1, apellido2,
        SUM(precio * 1 -
                       (COALESCE(descuento,0)
                            / 100.0)) as "gasto"
FROM vuelo JOIN reserva USING (id_vuelo)
        JOIN cliente USING (id_cliente)
GROUP BY nombre, apellido1, apellido2
HAVING SUM(precio * 1 -
               (COALESCE(descuento,0)
                    / 100.0)) < (
            SELECT AVG(gasto)
            FROM (
                SELECT SUM(precio * 1 -
                           (COALESCE(descuento,0)
                                / 100.0)) as "gasto"
                FROM vuelo JOIN reserva USING (id_vuelo)
                GROUP BY id_cliente
            )
        )
     --Opción con With 
WITH gasto_por_cliente AS (
    SELECT nombre, apellido1, apellido2,
            SUM(precio * 1 -
                           (COALESCE(descuento,0)
                                / 100.0)) as "gasto"
    FROM vuelo JOIN reserva USING (id_vuelo)
            JOIN cliente USING (id_cliente)
    GROUP BY nombre, apellido1, apellido2
), media_gasto_por_cliente AS (
    SELECT AVG(gasto) as "media"
    FROM gasto_por_cliente
)
SELECT *
FROM gasto_por_cliente
WHERE gasto < (
        SELECT media
        FROM media_gasto_por_cliente
    );
	
/*Selecciona la media, agrupada por nombre de aeropuerto de salida, del % de ocupación de los vuelos. PISTA: tendrás
que incluir una subconsulta dentro de otra y, en la interior, usar una subconsulta en el select :S (o bien usar WITH)
*/

WITH PorcentajeOcupacion AS (
    SELECT
        a.nombre AS aeropuerto_salida,
        COUNT(v.id_vuelo) AS total_vuelos,
        MAX(a2.max_pasajeros) AS max_pasajeros
    FROM
        vuelo v
	JOIN avion a2 USING (id_avion)
    JOIN aeropuerto a ON v.desde = a.id_aeropuerto
	
    GROUP BY
        a.nombre
)
SELECT aeropuerto_salida,
    AVG((total_vuelos * 100.0 / max_pasajeros)) AS a
FROM PorcentajeOcupacion
GROUP BY aeropuerto_salida;

--CORRECCIÓN DE LUISMI 
SELECT ciudad, 
ROUND(AVG(prc,2))
SELECT a.ciudad as "cidudad" id_vuelo, max_pasajeros, COUNT(*),
	(count(*) / max_pasajeros::numeric) * 100
FROM vuelo join avion a USING (id_avion)
	JOIN aeropuerto  ON (desde= id_aeropuerto)
	JOIN reserva ON (id_vuelo)
GROUP BY id_vuelo, max_pasajeros, a.ciudad
)GROUP BY  ciudad;

	/*
Selecciona el tráfico de pasajeros (es decir, personas que han llegado en un vuelo o personas que han salido en un vuelo) agrupado por mes (independiente del año) y aeropuerto. 
INVESTIGA: Tienes que hacer uso de la cláusula UNION, y piensa en hacer primero el tráfico de salida, después el de llegada (en consultas diferentes pero casi idénticas) y posteriormente en sumarlo.
*/-- T.salida
WITH TrajSalida AS (
    SELECT EXTRACT(MONTH FROM salida) AS mes,  a1.id_aeropuerto,  COUNT(*) AS pasajeros_salida,  MAX(av.max_pasajeros) AS max_pasajeros
    FROM vuelo v JOIN aeropuerto a1 ON (v.desde = a1.id_aeropuerto)  JOIN avion av USING(id_avion)
    GROUP BY  mes, id_aeropuerto
)
-- T.llegada
, TrajLlegada AS (
    SELECT EXTRACT(MONTH FROM llegada) AS mes, a2.id_aeropuerto, COUNT(*) AS pasajeros_llegada, MAX(av.max_pasajeros) AS max_pasajeros
    FROM vuelo v JOIN aeropuerto a2 ON (v.hasta = a2.id_aeropuerto)
        JOIN avion av USING(id_avion)
    GROUP BY mes, id_aeropuerto
)
-- UNION
, TrajTotal AS (
    SELECT mes, id_aeropuerto AS aeropuerto, max_pasajeros AS total_pasajeros
    FROM TrajSalida
    UNION ALL
    SELECT mes, id_aeropuerto AS aeropuerto, max_pasajeros AS total_pasajeros
    FROM TrajLlegada
)
-- Sumar el tráfico total por mes y aeropuerto
SELECT mes, aeropuerto,
    SUM(total_pasajeros) AS total_pasajeros
FROM TrajTotal
GROUP BY mes, aeropuerto
ORDER BY  mes, aeropuerto;

/**
Suponiendo que el 30% del precio de cada billete son beneficios (y el 70% son gastos), 
¿cuál es el trayecto que más rendimiento económico da? Es decir, ¿en qué trayecto estamos ganando más dinero?
¿Y con el que menos? Lo puedes hacer en consultas diferentes usando WITH*

*/
WITH beneficios_maximos AS (
		SELECT origen.nombre AS "desde", destino.nombre AS "hasta",
			MAX(ROUND((30 * (precio - (precio * descuento / 100)) / 100),2)) AS "beneficio_maximo"
		FROM vuelo JOIN aeropuerto origen ON(desde = origen.id_aeropuerto)
				   JOIN aeropuerto destino ON(hasta = destino.id_aeropuerto)
		WHERE descuento IS NOT NULL
		GROUP BY origen.nombre, destino.nombre
		ORDER BY MAX(ROUND((30 * (precio - (precio * descuento / 100)) / 100),2)) DESC
		LIMIT 1
), beneficios_minimos AS (
		SELECT origen.nombre AS "desde", destino.nombre AS "hasta",
			MIN(ROUND((30 * (precio - (precio * descuento / 100)) / 100),2)) AS "beneficio_minimo"
		FROM vuelo JOIN aeropuerto origen ON(desde = origen.id_aeropuerto)
				   JOIN aeropuerto destino ON(hasta = destino.id_aeropuerto)
		WHERE descuento IS NOT NULL
		GROUP BY origen.nombre, destino.nombre
		ORDER BY MIN(ROUND((30 * (precio - (precio * descuento / 100)) / 100),2))
		LIMIT 1
)
SELECT COALESCE(MAX(bmax.beneficio_maximo),0) AS "beneficio_maximo", bmax.desde, bmax.hasta
FROM beneficios_maximos bmax
GROUP BY bmax.desde, bmax.hasta
UNION
	SELECT COALESCE(MIN(bmin.beneficio_minimo),0) AS "beneficio_minimo", bmin.desde, bmin.hasta
	FROM beneficios_minimos bmin
	GROUP BY bmin.desde, bmin.hasta
ORDER BY beneficio_maximo DESC;


--CORRECCION DE LUISMI 
WITH rendimiento_por_trayecto AS (
    SELECT s.ciudad, ll.ciudad,
        ROUND(0.3 * SUM(precio * (1 -
                (COALESCE(descuento,0)/100.0))),2) AS "rendimiento"
    FROM vuelo JOIN reserva USING (id_vuelo)
            JOIN aeropuerto s ON (desde = s.id_aeropuerto)
            JOIN aeropuerto ll ON (hasta = ll.id_aeropuerto)
    GROUP BY s.ciudad, ll.ciudad
), rendimiento_maximo AS (
    SELECT MAX(rendimiento) as "maximo"
    FROM rendimiento_por_trayecto
), rendimiento_minimo AS (
    SELECT MIN(rendimiento) as "minimo"
    FROM rendimiento_por_trayecto
)
SELECT *, 'max' as "valor"
FROM rendimiento_por_trayecto
WHERE rendimiento = (
                        SELECT maximo
                        FROM rendimiento_maximo
                    )
UNION
SELECT *, 'min'
FROM rendimiento_por_trayecto
WHERE rendimiento = (
                        SELECT minimo
                        FROM rendimiento_minimo
                    );
/*
Seleccionar el nombre y apellidos de los clientes que no han hecho ninguna reserva para un vuelo que salga en el tercer trimestre desde Sevilla.
*/
WITH ClientesSinReserva AS (
    SELECT c.nombre, c.apellido1, c.apellido2
    FROM cliente c
    WHERE
        NOT EXISTS (
            SELECT 1
            FROM reserva r
                JOIN vuelo v ON r.id_vuelo = v.id_vuelo
                JOIN aeropuerto a ON v.desde = a.id_aeropuerto
            WHERE
                r.id_cliente = c.id_cliente
                AND EXTRACT(QUARTER FROM v.salida) = 3
                AND a.nombre = 'Sevilla'
        )
)
SELECT  nombre,  apellido1, apellido2
FROM ClientesSinReserva;

--Correccion de luismi 
SELECT DISTINCT nombre, apellido1, apellido2
FROM cliente JOIN reserva USING (id_cliente)
        --JOIN vuelo USING (id_vuelo)
        --JOIN aeropuerto ON (desde = id_aeropuerto)
WHERE id_cliente NOT IN (
        SELECT id_cliente
        FROM reserva JOIN vuelo USING (id_vuelo)
            JOIN aeropuerto ON (desde = id_aeropuerto)
        WHERE ciudad = 'Sevilla'
          AND TO_CHAR(salida, 'Q') = '3'
);
/*Selecciona el nombre y apellidos de aquellos clientes cuyo gasto en reservas de vuelos con origen en España (Sevilla, Málaga, Madrid, Bilbao y Barcelona)
ha sido superior a la media total de gasto de vuelos con origen fuera de España.
*/
WITH GastoClientes AS (
    SELECT
        c.id_cliente,
        c.nombre,
        c.apellido1, c.apellido2,
        SUM(v.precio) AS gasto
    FROM
        cliente c
        JOIN reserva r ON c.id_cliente = r.id_cliente
        JOIN vuelo v ON r.id_vuelo = v.id_vuelo
        JOIN aeropuerto a ON v.desde = a.id_aeropuerto
    WHERE
        a.ciudad IN ('Sevilla', 'Málaga', 'Madrid', 'Bilbao', 'Barcelona') 
    GROUP BY
        c.id_cliente, c.nombre, c.apellido1, c.apellido2
)
, MediaGastoExtranjero AS (
    SELECT
        AVG(v.precio) AS media_gasto_extranjero
    FROM
        reserva r
        JOIN vuelo v ON r.id_vuelo = v.id_vuelo
        JOIN aeropuerto a ON v.desde = a.id_aeropuerto
    WHERE
        a.ciudad IN  ('Sevilla', 'Málaga', 'Madrid', 'Bilbao', 'Barcelona') 
    
)
SELECT
    gc.nombre,
    gc.apellido1,
	gc.apellido2,
    gc.gasto
FROM
    GastoClientes gc
    CROSS JOIN MediaGastoExtranjero mg
WHERE
    gc.gasto > mg.media_gasto_extranjero;
	
	
	--Ejercicio de clase 
	/**Seleccionar el nombre, apellidos y número de vuelos por aeropuerto de
salida, 
para el cliente que más vuelos de salida ha usado en cada aeropuerto.*/

SELECT c.nombre, apellido1, apellido2, a.ciudad,
        count(*) as "cantidad"
FROM cliente c JOIN reserva USING (id_cliente)
        JOIN vuelo v1 USING (id_vuelo)
        JOIN aeropuerto a ON (desde = id_aeropuerto)
GROUP BY c.nombre, apellido1, apellido2, a.ciudad,
            desde
HAVING COUNT(*) >= ALL (
                        SELECT COUNT(*)
                        FROM vuelo v2 JOIN
                         reserva USING (id_vuelo)
                        WHERE v1.desde = v2.desde
                        GROUP BY id_cliente
                    );

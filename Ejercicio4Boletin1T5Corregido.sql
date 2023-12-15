/*Seleccionar el vuelo más largo (con mayor duración) de cada día de la semana. Debe aparecer el nombre del aeropuerto de salida,
el de llegada, la fecha y hora de salida y llegada y la duración.
*/

SELECT o.ciudad, salida, TO_CHAR(salida,'dy') ,
		d.ciudad, llegada ,
		AGE(llegada, salida) as "duracion"
FROM vuelo v1 JOIN aeropuerto o ON (desde = o.id_aeropuerto)
			JOIN aeropuerto d ON (hasta = d.id_aeropuerto)
WHERE AGE(llegada, salida) >= ALL (
	SELECT AGE(llegada, salida)
		FROM vuelo  v2
WHERE EXTRACT(isodow FROM v1.salida) =	EXTRACT(isodow FROM v2.salida)
			)
			ORDER BY extract(isodow FROM v1.salida);
			
			--En la línea 13 decimos que qeuremos todos los vuelos de cada día con mayor duracion qeu todos los vuelos de ese día 
			
			
/*Seleccionar el cliente que más ha gastado en vuelos que salen del mismo aeropuerto. 
Debe aparecer el nombre del cliente, el nombre y la ciudad del aeropuerto y la cuantía de dinero que ha gastado.
*/

	SELECT c.nombre, c.apellido1, c.apellido2,
        a.nombre, a.ciudad,  
        SUM(precio * (1 - (COALESCE(descuento,0)/100)))
FROM vuelo v1 JOIN reserva USING (id_vuelo)
        JOIN cliente c USING (id_cliente)
        JOIN aeropuerto a ON (desde = id_aeropuerto)
GROUP BY c.nombre, c.apellido1, c.apellido2,
        a.nombre, a.ciudad, v1.desde
HAVING SUM(precio *
           (1 - (COALESCE(descuento,0)/100))) >= ALL (
           SELECT SUM(precio * (1 -
                    (COALESCE(descuento,0)/100)))
           FROM vuelo v2 JOIN reserva USING (id_vuelo)
           WHERE v1.desde = v2.desde
           GROUP BY id_cliente
        );
/*Seleccionar el piso que se ha vendido más caro de cada provincia.
Debe aparecer la provincia, el nombre del comprador, la fecha de la operación y la cuantía.
*/

SELECT provincia, c.nombre,
        fecha_operacion, precio_final
FROM operacion JOIN inmueble i1 USING (id_inmueble)
        JOIN tipo ON (tipo_inmueble = id_tipo)
        JOIN comprador c USING (id_cliente)
WHERE tipo.nombre = 'Piso'
  AND tipo_operacion = 'Venta'
  AND precio_final >= ALL (
        SELECT precio_final
        FROM operacion JOIN
              inmueble i2 USING (id_inmueble)
            JOIN tipo ON (tipo_inmueble = id_tipo)
        WHERE tipo.nombre = 'Piso'
          AND i1.provincia = i2.provincia
              AND tipo_operacion = 'Venta'      
);


/*Seleccionar los alquileres más baratos de cada provincia y mes (da igual el día y el año). 
Debe aparecer el nombre de la provincia, el nombre del mes, el resto de atributos de la tabla inmueble y el precio final del alquiler.
*/
SELECT provincia, TO_CHAR(fecha_operacion, 'Month'),
 precio_final,
 id_inmueble, fecha_alta, tipo_inmueble, tipo_operacion,
 superficie, precio
FROM inmueble i1 JOIN operacion o1 USING (id_inmueble)
WHERE tipo_operacion = 'Alquiler'
  AND precio_final <= ALL (
      SELECT precio_final
    FROM inmueble i2 JOIN operacion o2 USING (id_inmueble)
    WHERE tipo_operacion = 'Alquiler'
      AND i1.provincia = i2.provincia
      AND EXTRACT(month from o1.fecha_operacion) =
          EXTRACT(month from o2.fecha_operacion)
  )
ORDER BY provincia, EXTRACT(month from o1.fecha_operacion);
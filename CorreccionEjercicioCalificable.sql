/*Seleccionar el nombre y los dos apellidos de aquellos clientes
que reservaron un vuelo que salió en un miércoles con una antelación
de 35 días (despreciando la hora), y que su segundo apellido tenga 
exactamente 4 letras. La salida del nombre no debe ser totalmente en
mayúsculas, sino con la primera letra de cada palabra en mayúsculas, 
y el resto en minúsculas. Por ejemplo: Ángel Naranjo González (puede que
las Ñ aparezcan en mayúsculas).
Las calificaciones se publicarán a través de un comentario privado en la entrega.*/
SELECT nombre , apellido1, apellido2
FROM cliente  JOIN reserva r USING (id_cliente)
			  JOIN vuelo v USING (id_vuelo)
WHERE EXTRACT(DAY FROM v.salida) IN (4) 
AND AGE(r.fecha_reserva::date,v.salida::date) = '35 days'::interval
AND apellido2 ILIKE '____';
*/
SELECT INITCAP(c.nombre) AS nombre, INITCAP(c.apellido1),
  INITCAP(c.apellido2) AS apellido2
FROM  cliente c
  JOIN reserva r USING (id_cliente)
  JOIN vuelo v USING (id_vuelo)
WHERE 
  EXTRACT(ISODOW FROM v.salida) = 3 
  AND AGE(DATE_TRUNC ('day', salida),DATE_TRUNC('day',fecha_reserva)) = '35 days'::interval
  AND LENGTH(c.apellido2) = 4;
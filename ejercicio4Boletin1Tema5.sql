/*Seleccionar el vuelo más largo (con mayor duración)
de cada día de la semana. Debe aparecer el nombre del 
aeropuerto de salida, el de llegada, 
la fecha y hora de salida y llegada y la duración.*/

WITH vuelo AS (
    SELECT a1.nombre AS aeropuerto_salida, a2.nombre AS aeropuerto_llegada,
        salida, llegada, AGE(llegada, salida) AS duracion,
        EXTRACT(isodow FROM salida) 
    FROM vuelo JOIN aeropuerto a1 ON (vuelo.desde = a1.id_aeropuerto)
    		JOIN aeropuerto a2 ON (vuelo.hasta = a2.id_aeropuerto)
	ORDER BY AGE(llegada, salida) DESC
						   
)
SELECT aeropuerto_salida, aeropuerto_llegada, salida, llegada, duracion,
	EXTRACT(isodow FROM salida)
FROM vuelo LIMIT  1;















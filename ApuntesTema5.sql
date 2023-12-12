--LIMIT 
SELECT *
FROM reserva
WHERE EXTRACT(year from fecha_reserva)=2024
ORDER BY fecha_reserva DESC
LIMIT 50  OFFSET(2+50); --EL 2 dice que descartamo los 100 primeros resultados
--por ahora en el group by pondremos lo mismo que en el select quitando las funciones de agregacion

--contar por  el nombre de la ciudad del aeropuerto que salen desde Sevilla
SELECT origen.ciudad,destino.ciudad, COUNT(*)
FROM vuelo 
		JOIN aeropuerto origen 
				ON (desde= origen.id_aeropuerto)
		JOIN aeropuerto destino
				ON (hasta = destino.id_aeropuerto)
WHERE origen.ciudad= 'Sevilla'
GROUP  BY origen.ciudad, destino.ciudad;
--Cuantas personas han viajado en cada trayecto. Si hay mas de un vuelo por trayecto el total de todos los vuelos 
SELECT  SUM(COUNT(*))
FROM vuelo 
		JOIN aeropuerto origen 
				ON (desde= origen.id_aeropuerto)
		JOIN aeropuerto destino
				ON (hasta = destino.id_aeropuerto)
		JOIN reserva r USING(id_vuelo)
--GROUP  BY origen.ciudad, destino.ciudad;


/*4/12*/
/*Contar el numero de vueloss por la fecha de salida agrupar por mes
*/
SELECT EXTRACT(MONTH FROM salida) as "mes", COUNT(salida)
FROM vuelo 
GROUP by EXTRACT(MONTH FROM salida)
ORDER BY mes;
/*Para agrupar por ems y dia del mes */

SELECT EXTRACT(MONTH FROM salida) as "mes",EXTRACT(DAY FROM salida) as "dia", COUNT(salida)
FROM vuelo 
GROUP by EXTRACT(MONTH FROM salida),EXTRACT(DAY FROM salida)-- En el group by tambien se pueden usar las alias 
ORDER BY mes, dia;
--other form from the firts line SELECT TO_CHAR(salida,'MM-DD') para decir dia y mes 

/*Contar el numero de vuelo por el dia de la semana,  los primeros 6 meses del año */
SELECT TO_CHAR(salida, 'dy'), COUNT(*)
FROM vuelo
WHERE TO_CHAR(salida, 'Q') IN ('1','2')--La Q significa trimestre
GROUP BY TO_CHAR(salida, 'dy');
/*Sumale a la anterior que la suma de vuelos  no pueda ser mas de 10*/
SELECT TO_CHAR(salida, 'dy'), COUNT(*)
FROM vuelo
WHERE TO_CHAR(salida, 'Q') IN ('1','2')--La Q significa trimestre
GROUP BY TO_CHAR(salida, 'dy')
HAVING COUNT(*)>=10;--Se usara el having como condicion cuando ya estan eschos los grupos 	
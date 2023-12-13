--Selecciona la media de vuelos que salen cada día, 
--independientemente del aeropuerto del que salga el vuelo 
SELECT dia , AVG(vuelardo)
FROM (
	SELECT TO_CHAR(salida, 'Day') AS "dia", salida::date,
	EXTRACT(isodow FROM salida),
	COUNT (*) as "count"
	FROM vuelo
	GROUP  BY dia
	,EXTRACT(isodow FROM salida)
	
)d
GROUP BY dia ,
;
--Seleccionar, para cada estación meterológica, la fecha en la que ha tenido una 
--temperatura_maxima menor
--Debe aparecer la provincia, el nombre de la estacion 
--la fecha, y la temperatura_maxima mas pequeña 

SELECT provincia, estacion , fecha, temperatura_maxima 
FROM climatologia c
WHERE temperatura_maxima <= ALL (
	SELECT temperatura_maxima 
	FROM climatologia c2
	WHERE c.estacion = c2.estacion
);

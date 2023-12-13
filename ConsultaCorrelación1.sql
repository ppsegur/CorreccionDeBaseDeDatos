--sELECCIONAR PARA CADA PROVINCIA EL AÑO EN EL QUE HAN 
--TENIDO MAS HABITANTE 
	SELECT *, hombres + mujeres as "total"
	FROM demografia_basica dbl
	WHERE hombres + mujeres >= 
		ALL(
		SELECT hombres + mujeres 
		FROM demografia_basica dbl2
			WHERE dbl.provincia = dbl2.provincia
		)ORDER BY provincia;
		
--Seleccionar los departamentos que su salario maximo sea mayor que la media de esos salarios 
SELECT  AVG(maximo)
FROM ( 
SELECT department_name, MAX(salary) as "maximo"
FROM departments JOIN employees USING (department_id)
		GROUP  BY department_name	)
		datos; 
		
		--Una subconsulta en el from lleva alias.
		
--Seleccionar el nº medio de empleados que tiene cada departamento 
SELECT ROUND(AVG(numero_empleados),0) AS promedio_empleados_por_departamento
FROM (
    SELECT department_id, COUNT(*) AS numero_empleados
    FROM employees
    GROUP BY department_id
)d ;


--Seleccionar aquellos empleados que cobran más que todos 
-- los empleados del departamento de Purchasing  
SELECT *
FROM employees 
WHERE salary > ALL (
	SELECT salary 
	FROM employees JOIN departments USING(department_id)
	WHERE department_name = 'Purchasing'
);
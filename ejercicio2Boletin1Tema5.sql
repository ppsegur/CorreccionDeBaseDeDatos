*Seleccionar el número de pedidos atendidos por cada empleado,
sí y sólo si dicho número está entre 100 y 150*/
SELECT employee_id ,COUNT(*) as "pedidos"
FROM orders
GROUP BY employee_id 
HAVING COUNT(*) BETWEEN 100 AND 150;
/*Seleccionar el nombre de las empresas que no han realizado ningún pedido.
*/
SELECT COALESCE(c.company_name, 'sinPedidos') , COUNT(order_id) as "num_pedidos"
FROM customers c FULL JOIN orders USING(customer_id)

WHERE order_id IS NULL
GROUP BY c.customer_id, order_id
ORDER BY num_pedidos desc; /*Si hacemos el order  by de order_id nos saldran primero las de 0 y despues la de uno 
*/
/*Seleccionar la categoría que tiene más productos diferentes solicitados en pedidos.
Mostrar el nombre de la categoría y dicho número.
*/
SELECT c.category_name, COUNT(DISTINCT p.product_id) as "productos_diferentes"
FROM products p
		JOIN categories c USING (category_id)
GROUP BY c.category_name 
ORDER BY productos_diferentes DESC
LIMIT 1
		;
		/*Si suponemos que nuestro margen de beneficio con los productos es de un 25% 
		(es decir, el 25% de su precio, son beneficios, y el 75% son costes),
		calcular la cantidad de beneficio que hemos obtenido, agrupado por categoría 
		y producto. Las cantidades deben redondearse a dos decimales.
*/	
	SELECT c.category_name, ROUND((p.unit_price::numeric * 0.25), 2), p.product_name
FROM orders o JOIN order_details od USING (order_id)
            JOIN products p USING (product_id)
        JOIN categories c USING (category_id)
GROUP BY c.category_name, p.product_name, p.unit_price;




		/**Selecciona aquellos clientes (CUSTOMERS) para los que todos los envíos que 
		ha recibido (sí, todos) los haya transportado (SHIPPERS) la empresa United Package.
*/

SELECT c.customer_id, c.contact_name
	FROM customers c
			JOIN orders o ON c.customer_id = o.customer_id
		LEFT JOIN shippers s ON o.ship_via = s.shipper_id
WHERE s.company_name= 'United Package'
GROUP BY c.customer_id, c.contact_name;

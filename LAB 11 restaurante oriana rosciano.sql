USE restaurante;

-- 1. ¿Cuál es la cantidad total que gastó cada cliente en el restaurante?
SELECT s.customer_id, SUM(m.price) AS total_gastado
FROM sales AS s
INNER JOIN menu AS m 
ON s.product_id = m.product_id
GROUP BY s.customer_id;

-- 2. ¿Cuántos días ha visitado cada cliente el restaurante?
SELECT customer_id, COUNT(DISTINCT order_date) AS dias_visitados
FROM sales
GROUP BY customer_id;

-- 3. ¿Cuál fue el primer artículo del menú comprado por cada cliente?
WITH primeros AS (
SELECT s.customer_id, m.product_name,
DENSE_RANK() OVER (PARTITION BY s.customer_id ORDER BY s.order_date) AS rn
FROM sales AS s
INNER JOIN menu AS m 
ON s.product_id = m.product_id)
SELECT DISTINCT customer_id, product_name
FROM primeros
WHERE rn = 1;

-- 4. ¿Cuál es el artículo más comprado en el menú y cuántas veces lo compraron todos los clientes?
SELECT m.product_name, COUNT(*) AS veces_comprado
FROM sales AS s
INNER JOIN menu AS m 
ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY veces_comprado DESC
LIMIT 1;

-- 5. ¿Qué artículo fue el más popular para cada cliente?
WITH conteo AS (
SELECT s.customer_id, m.product_name, COUNT(*) AS veces,
DENSE_RANK() OVER (PARTITION BY s.customer_id ORDER BY COUNT(*) DESC) AS rn
FROM sales AS s
INNER JOIN menu AS m 
ON s.product_id = m.product_id
GROUP BY s.customer_id, m.product_name)
SELECT customer_id, product_name, veces
FROM conteo
WHERE rn = 1;

-- 6. ¿Qué artículo compró primero el cliente después de convertirse en miembro?
WITH despues AS (
SELECT s.customer_id, m.product_name,
DENSE_RANK() OVER (PARTITION BY s.customer_id ORDER BY s.order_date ASC) AS rn
FROM sales AS s
INNER JOIN members AS mb 
ON s.customer_id = mb.customer_id
INNER JOIN menu AS m 
ON s.product_id = m.product_id
WHERE s.order_date >= mb.join_date)
SELECT DISTINCT customer_id, product_name
FROM despues
WHERE rn = 1;

-- 7. ¿Qué artículo se compró justo antes de que el cliente se convirtiera en miembro?
WITH despues AS (
SELECT s.customer_id, m.product_name,
DENSE_RANK() OVER (PARTITION BY s.customer_id ORDER BY s.order_date DESC) AS rn
FROM sales AS s
INNER JOIN members AS mb 
ON s.customer_id = mb.customer_id
INNER JOIN menu AS m 
ON s.product_id = m.product_id
WHERE s.order_date <= mb.join_date)
SELECT DISTINCT customer_id, product_name
FROM despues
WHERE rn = 1;

-- 8. ¿Cuál es el total de artículos y la cantidad gastada por cada miembro antes de convertirse en miembro?
SELECT s.customer_id, COUNT(*) AS total_articulos, SUM(m.price) AS total_gastado
FROM sales AS s
INNER JOIN members AS mb 
ON s.customer_id = mb.customer_id
INNER JOIN menu AS m 
ON s.product_id = m.product_id
WHERE s.order_date < mb.join_date
GROUP BY s.customer_id;

-- 9. Si cada $1 gastado equivale a 10 puntos y el sushi tiene multiplicador 2x, ¿cuántos puntos tendría cada cliente?
-- Solo los clientes que son miembros reciben puntos al comprar artículos, los puntos los reciben en las órdenes iguales o posteriores a la fecha en la que se convierten en miembros.
SELECT s.customer_id, SUM(CASE WHEN m.product_name = 'sushi' THEN m.price * 20
ELSE m.price * 10 END) AS puntos
FROM sales AS s
INNER JOIN members AS mb 
ON s.customer_id = mb.customer_id
INNER JOIN menu AS m 
ON s.product_id = m.product_id
WHERE s.order_date >= mb.join_date
GROUP BY s.customer_id;

-- 10. En la primera semana después de que un cliente se une al programa (incluida la fecha de ingreso), gana el doble de puntos en todos los artículos, no solo en sushi. ¿Cuántos puntos tienen los clientes A y B a fines de enero?
-- Suposición: Solo los clientes que son miembros reciben puntos al comprar artículos, los puntos los reciben en las órdenes iguales o posteriores a la fecha en la que se convierten en miembros. Solo las órdenes de la primera semana en la que se convierten en miembros suman 20 puntos para todos los artículos.
SELECT s.customer_id,
SUM(CASE WHEN s.order_date <= DATE_ADD(mb.join_date, INTERVAL 6 DAY) THEN m.price * 20
WHEN m.product_name = 'sushi' THEN m.price * 20
ELSE m.price * 10 END) AS puntos
FROM sales AS s
INNER JOIN members AS mb 
ON s.customer_id = mb.customer_id
INNER JOIN menu AS m 
ON s.product_id = m.product_id
WHERE s.order_date >= mb.join_date
AND s.order_date <= '2021-01-31'
GROUP BY s.customer_id;
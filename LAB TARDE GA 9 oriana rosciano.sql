USE ZaraBusiness;
SET SQL_SAFE_UPDATES = 0;


-- 1. Selecciona todos los clientes junto con las compras que han realizado, mostrando el nombre del cliente y el monto de cada compra.
SELECT c.nombre_cliente, co.monto_total
FROM Clientes c
JOIN Compras co ON c.id_cliente = co.id_cliente;


-- 2. Muestra todos los empleados y la tienda en la que trabajan, incluyendo el nombre del empleado y el nombre de la tienda.
SELECT e.nombre_empleado, t.nombre_tienda
FROM Empleados e
JOIN Tiendas t ON e.tienda_id = t.id_tienda;


-- 3. Selecciona todas las prendas que han sido compradas, junto con el nombre del cliente que las compro.
SELECT p.tipo_prenda, c.nombre_cliente
FROM Detalle_Compras d
JOIN Prendas p  ON d.id_prenda = p.id_prenda
JOIN Compras co ON d.id_compra = co.id_compra
JOIN Clientes c ON co.id_cliente = c.id_cliente;


-- 4. Muestra el total de compras realizadas por cada cliente, mostrando su nombre y el total de compras.
SELECT c.nombre_cliente, SUM(co.monto_total) AS total_compras
FROM Clientes c
JOIN Compras co ON c.id_cliente = co.id_cliente
GROUP BY c.nombre_cliente;


-- 5. Selecciona los empleados que han vendido prendas de color "Rojo", incluyendo el nombre del empleado y el tipo de prenda.
SELECT DISTINCT e.nombre_empleado, p.tipo_prenda
FROM Compras co
JOIN Empleados e        ON co.id_empleado = e.id_empleado
JOIN Detalle_Compras d  ON d.id_compra = co.id_compra
JOIN Prendas p          ON d.id_prenda = p.id_prenda
WHERE p.color = 'Rojo';


-- 6. Muestra la cantidad de prendas vendidas por cada tienda, mostrando el nombre de la tienda y el total de prendas vendidas.
SELECT t.nombre_tienda, SUM(d.cantidad) AS prendas_vendidas
FROM Compras co
JOIN Tiendas t         ON co.id_tienda = t.id_tienda
JOIN Detalle_Compras d ON d.id_compra = co.id_compra
GROUP BY t.nombre_tienda;


-- 7. Selecciona los clientes que han realizado compras por un monto total superior a 100, mostrando su nombre y el monto total de la compra.
SELECT c.nombre_cliente, co.monto_total
FROM Clientes c
JOIN Compras co ON c.id_cliente = co.id_cliente
WHERE co.monto_total > 100;


-- 8. Muestra todos los tipos de prendas y cuantas han sido compradas, mostrando el tipo de prenda y la cantidad vendida.
SELECT p.tipo_prenda, SUM(d.cantidad) AS cantidad_vendida
FROM Prendas p
JOIN Detalle_Compras d ON d.id_prenda = p.id_prenda
GROUP BY p.tipo_prenda;


-- 9. Selecciona las prendas que han sido compradas por mas de un cliente, mostrando el tipo de prenda y el numero de clientes que la han comprado.
SELECT p.tipo_prenda, COUNT(DISTINCT co.id_cliente) AS num_clientes
FROM Prendas p
JOIN Detalle_Compras d ON d.id_prenda = p.id_prenda
JOIN Compras co        ON d.id_compra = co.id_compra
GROUP BY p.tipo_prenda
HAVING num_clientes > 1;


-- 10. Muestra la lista de compras realizadas en una tienda especifica, incluyendo el nombre del cliente y el monto de la compra.
SELECT c.nombre_cliente, co.monto_total
FROM Compras co
JOIN Clientes c ON co.id_cliente = c.id_cliente
JOIN Tiendas t  ON co.id_tienda = t.id_tienda
WHERE t.nombre_tienda = 'Zara Gran Vía';


-- 11. Selecciona los empleados que trabajan en tiendas en "Madrid", mostrando su nombre y el nombre de la tienda.
SELECT e.nombre_empleado, t.nombre_tienda
FROM Empleados e
JOIN Tiendas t ON e.tienda_id = t.id_tienda
WHERE t.ciudad = 'Madrid';


-- 12. Muestra los clientes que no han realizado ninguna compra, mostrando su nombre y correo electronico.
SELECT c.nombre_cliente, c.email_cliente
FROM Clientes c
LEFT JOIN Compras co ON c.id_cliente = co.id_cliente
WHERE co.id_compra IS NULL;


-- 13. Selecciona el nombre de la tienda con el mayor numero de empleados, mostrando el nombre de la tienda y la cantidad de empleados.
SELECT t.nombre_tienda, COUNT(e.id_empleado) AS num_empleados
FROM Tiendas t
JOIN Empleados e ON e.tienda_id = t.id_tienda
GROUP BY t.nombre_tienda
ORDER BY num_empleados DESC
LIMIT 1;


-- 14. Muestra el monto total de compras por cada empleado, incluyendo el nombre del empleado y el monto total vendido.
SELECT e.nombre_empleado, SUM(co.monto_total) AS total_vendido
FROM Empleados e
JOIN Compras co ON co.id_empleado = e.id_empleado
GROUP BY e.nombre_empleado;


-- 15. Selecciona las compras realizadas en el mes de septiembre de 2023, mostrando el nombre del cliente y la fecha de la compra.
SELECT c.nombre_cliente, co.fecha_compra
FROM Clientes c
JOIN Compras co ON c.id_cliente = co.id_cliente
WHERE co.fecha_compra BETWEEN '2023-09-01' AND '2023-09-30';


-- 16. Muestra todos los clientes y las tiendas donde han realizado compras, incluyendo el nombre del cliente y el nombre de la tienda.
SELECT DISTINCT c.nombre_cliente, t.nombre_tienda
FROM Clientes c
JOIN Compras co ON c.id_cliente = co.id_cliente
JOIN Tiendas t  ON co.id_tienda = t.id_tienda;


-- 17. Selecciona las prendas cuyo precio promedio es superior a 40, mostrando el tipo de prenda y el precio promedio.
SELECT tipo_prenda, AVG(precio) AS precio_promedio
FROM Prendas
GROUP BY tipo_prenda
HAVING precio_promedio > 40;


-- 18. Muestra la lista de empleados y la cantidad de compras que han gestionado, mostrando su nombre y la cantidad de compras.
SELECT e.nombre_empleado, COUNT(co.id_compra) AS num_compras
FROM Empleados e
JOIN Compras co ON co.id_empleado = e.id_empleado
GROUP BY e.nombre_empleado;


-- 19. Selecciona los clientes que han realizado mas de 3 compras, mostrando su nombre y el numero de compras.
SELECT c.nombre_cliente, COUNT(co.id_compra) AS num_compras
FROM Clientes c
JOIN Compras co ON c.id_cliente = co.id_cliente
GROUP BY c.nombre_cliente
HAVING num_compras > 3;


-- 20. Muestra el total de ventas por cada tipo de prenda, mostrando el tipo de prenda y el monto total vendido.
SELECT p.tipo_prenda, SUM(p.precio * d.cantidad) AS total_vendido
FROM Prendas p
JOIN Detalle_Compras d ON d.id_prenda = p.id_prenda
GROUP BY p.tipo_prenda;


-- 21. Usa CASE WHEN para mostrar un mensaje diferente segun el monto total de las compras: "Bajo", "Medio" o "Alto" para cada cliente.
SELECT c.nombre_cliente,
       SUM(co.monto_total) AS total,
       CASE
           WHEN SUM(co.monto_total) < 100 THEN 'Bajo'
           WHEN SUM(co.monto_total) < 250 THEN 'Medio'
           ELSE 'Alto'
       END AS nivel
FROM Clientes c
JOIN Compras co ON c.id_cliente = co.id_cliente
GROUP BY c.nombre_cliente;


-- 22. Actualiza el precio de todas las prendas de ropa que sean de tipo "Zapatos" incrementandolos en un 10%.
UPDATE Prendas
SET precio = precio * 1.10
WHERE tipo_prenda = 'Zapatos';


-- 23. Alterar la tabla de Clientes para agregar una nueva columna llamada "telefono_cliente".
ALTER TABLE Clientes
ADD COLUMN telefono_cliente VARCHAR(20);


-- 24. Muestra el numero total de compras y el promedio de gasto por cliente, usando GROUP BY.
SELECT c.nombre_cliente,
       COUNT(co.id_compra) AS num_compras,
       AVG(co.monto_total) AS gasto_promedio
FROM Clientes c
JOIN Compras co ON c.id_cliente = co.id_cliente
GROUP BY c.nombre_cliente;


-- 25. Elimina todas las prendas cuyo precio es menor que 10.
DELETE FROM Detalle_Compras
WHERE id_prenda IN (SELECT id_prenda FROM Prendas WHERE precio < 10);

DELETE FROM Prendas
WHERE precio < 10;


-- 26. Usa JOIN para mostrar el nombre de los clientes y la cantidad total que han gastado en compras.
SELECT c.nombre_cliente, SUM(co.monto_total) AS total_gastado
FROM Clientes c
JOIN Compras co ON c.id_cliente = co.id_cliente
GROUP BY c.nombre_cliente;


-- 27. Muestra un informe que incluya el nombre del empleado y la cantidad de compras gestionadas por tienda, usando GROUP BY.
SELECT e.nombre_empleado, t.nombre_tienda, COUNT(co.id_compra) AS num_compras
FROM Compras co
JOIN Empleados e ON co.id_empleado = e.id_empleado
JOIN Tiendas t   ON co.id_tienda = t.id_tienda
GROUP BY e.nombre_empleado, t.nombre_tienda;


-- 28. Usa un subquery para mostrar el cliente que ha realizado la compra mas alta.
SELECT nombre_cliente
FROM Clientes
WHERE id_cliente = (SELECT id_cliente
                    FROM Compras
                    ORDER BY monto_total DESC
                    LIMIT 1);


-- 29. Actualiza la ciudad de los empleados que trabajan en la tienda "Zara Gran Vía" a "Madrid".
UPDATE Tiendas
SET ciudad = 'Madrid'
WHERE nombre_tienda = 'Zara Gran Vía';


-- 30. Usa una subconsulta con EXISTS para seleccionar todos los clientes que han realizado compras, mostrando solo sus nombres.
SELECT nombre_cliente
FROM Clientes c
WHERE EXISTS (SELECT 1 FROM Compras co WHERE co.id_cliente = c.id_cliente);

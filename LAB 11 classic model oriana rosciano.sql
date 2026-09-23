USE classicmodels;
-- Ejercicio 1
-- Contactos de oficina: Tiene una tabla que contiene los códigos de oficina y sus números de teléfono asociados.
SELECT officeCode, phone FROM offices;
-- Detectives de correo electrónico: ¿Puede identificar a los empleados cuyas direcciones de correo electrónico terminan en “.es”?
SELECT employeeNumber, lastName, firstName, email FROM employees WHERE RIGHT(email,3)=".es";
-- Estado de confusión: descubra qué clientes carecen de información estatal en sus registros.
SELECT customerNumber, customerName, state FROM customers WHERE state IS NULL;
-- Grandes gastadores: busquemos pagos que superen los $20.000.
SELECT customerNumber, amount FROM payments WHERE amount>20000;
-- Grandes gastadores de 2005: Ahora, acote la lista aún más y busque los pagos mayores a $20,000 que se realizaron en el año 2005.
SELECT customerNumber, amount, paymentDate FROM payments WHERE amount>20000 AND YEAR(paymentDate)=2005;
-- Detalles distintos: busque y muestre solo las filas únicas de la tabla “orderdetails” en función de la columna “productcode”.
SELECT DISTINCT productCode FROM orderdetails;
-- Estadísticas globales de compradores: por último, cree una tabla que muestre el recuento de compras realizadas por país.
SELECT c.country, COUNT(o.orderNumber) AS compras
FROM customers c
LEFT JOIN orders o
ON c.customerNumber=o.customerNumber
GROUP BY c.country;

-- Ejercicio 2
-- Descripción de línea de producto más larga: descubramos qué línea de producto tiene la descripción de texto más larga.
SELECT productLine, textDescription FROM productlines
ORDER BY char_length(textDescription) DESC LIMIT 1;
-- Recuento de clientes de oficina: ¿Puede determinar el número de clientes asociados a cada oficina?
WITH relacion AS (
SELECT c.customerNumber,
e.employeeNumber,
e.officeCode
FROM customers AS c
INNER JOIN employees AS e
ON c.SalesRepEmployeeNumber = e.employeeNumber)
SELECT o.officeCode, COUNT(r.customerNumber) as clientes
FROM offices AS o
LEFT JOIN relacion AS r
ON o.officeCode = r.officeCode
GROUP BY o.officeCode;
-- Día de mayores ventas de automóviles: descubra qué día de la semana se registra el mayor número de ventas de automóviles.
SELECT weekday(o.orderDate)
FROM orders as o
INNER JOIN orderdetails as od
ON o.orderNumber=od.orderNumber
WHERE od.productCode in (SELECT productCode FROM products WHERE RIGHT(productLine,4)="CARS")
GROUP BY WEEKDAY(o.orderDate)
ORDER BY ventas DESC
LIMIT 1;
-- Corrección de datos territoriales faltantes: Hay algunos valores faltantes (NA) en la variable " territory " de la tabla " offices ". Podemos usar una instrucción "case when" para corregir estos valores y establecerlos en " USA".
SELECT CASE
WHEN territory="NA" THEN 'USA'
ELSE territory
END AS territory
FROM offices;
-- Estadísticas de empleados de la familia Patterson: calcule el monto promedio del carrito y el total de artículos, año por mes, para las compras realizadas en los años 2004 y 2005 por clientes asistidos por empleados de la familia Patterson.
WITH carritos AS (
SELECT
o.orderNumber,
o.orderDate,
SUM(od.quantityOrdered * od.priceEach) AS monto_carrito,
SUM(od.quantityOrdered) AS total_articulos
FROM orders AS o
INNER JOIN orderdetails AS od
ON o.orderNumber = od.orderNumber
INNER JOIN customers AS c
ON o.customerNumber = c.customerNumber
INNER JOIN employees AS e
ON c.salesRepEmployeeNumber = e.employeeNumber
WHERE e.lastName = 'Patterson'
AND YEAR(o.orderDate) IN (2004, 2005)
GROUP BY o.orderNumber, o.orderDate)
SELECT
YEAR(orderDate) AS año,
MONTH(orderDate) AS mes,
ROUND(AVG(monto_carrito), 2) AS monto_promedio_carrito,
SUM(total_articulos) AS total_articulos
FROM carritos
GROUP BY YEAR(orderDate), MONTH(orderDate)
ORDER BY año, mes;

-- Ejercicio 3 (Usar subconsultas)
-- Análisis de compras anuales: Analicemos algunos cálculos avanzados mediante subconsultas. Queremos encontrar el importe promedio del carrito y el total de artículos, desglosados por año y mes. Esto se aplica específicamente a las compras realizadas en los años 2004 y 2005, pero nos interesan los clientes atendidos por empleados de la familia Patterson.
SELECT
YEAR(orderDate) AS año,
MONTH(orderDate) AS mes,
ROUND(AVG(monto_carrito), 2) AS monto_promedio_carrito,
SUM(total_articulos) AS total_articulos
FROM (SELECT
o.orderNumber,
o.orderDate,
SUM(od.quantityOrdered * od.priceEach) AS monto_carrito,
SUM(od.quantityOrdered) AS total_articulos
FROM orders AS o
INNER JOIN orderdetails AS od
ON o.orderNumber = od.orderNumber
INNER JOIN customers AS c
ON o.customerNumber = c.customerNumber
INNER JOIN employees AS e
ON c.salesRepEmployeeNumber = e.employeeNumber
WHERE e.lastName = 'Patterson'
AND YEAR(o.orderDate) IN (2004, 2005)
GROUP BY o.orderNumber, o.orderDate) as carrito
GROUP BY YEAR(orderDate), MONTH(orderDate)
ORDER BY año, mes;
-- Viaje a la oficina: ¡Llegó una misión especial! Visitaremos algunas de nuestras oficinas personalmente. Queremos identificar cuáles tienen empleados que atienden a clientes con información estatal vacía. Visitaremos estas oficinas para charlar y asegurarnos de que todo esté en orden.
SELECT DISTINCT o.officeCode, o.city
FROM offices AS o
INNER JOIN employees AS e
ON o.officeCode = e.officeCode
INNER JOIN customers AS c
ON e.employeeNumber = c.salesRepEmployeeNumber
WHERE c.state IS NULL;
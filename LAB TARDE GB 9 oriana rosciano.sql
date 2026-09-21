USE zarabusiness;
SET SQL_SAFE_UPDATES=0

-- 1. Selecciona todos los clientes.

SELECT * FROM clientes;

-- 2. Selecciona todos los empleados.

SELECT * FROM empleados;

-- 3. Selecciona todas las tiendas.

SELECT * FROM tiendas;

-- 4. Selecciona todas las prendas de ropa.

SELECT * FROM prendas;

-- 5. Busca clientes cuyo nombre comience con la letra "L".

SELECT * FROM clientes
WHERE LEFT(nombre_cliente,1)="L";

-- 6. Cuenta cuántos clientes hay en la base de datos.

SELECT COUNT(*) FROM clientes;

-- 7. Selecciona las compras realizadas después del 1 de mayo de 2023.

SELECT * FROM compras
WHERE fecha_compra > "2023-05-01";

-- 8. Actualiza el correo electrónico de un cliente específico.

UPDATE clientes SET email_cliente="gonzalezlaura@email.com" WHERE id_cliente=2;

-- 9. Elimina un cliente por su ID.

DELETE FROM Detalle_Compras
WHERE id_compra IN (
SELECT id_compra
FROM Compras
WHERE id_cliente = 4
);
DELETE FROM Compras
WHERE id_cliente = 4;
DELETE FROM Clientes
WHERE id_cliente = 4;

-- 10. Selecciona las prendas de color Negro.

SELECT * FROM prendas
WHERE color="negro";

-- 11. Selecciona todas las tiendas que hay en Madrid.

SELECT * FROM tiendas
WHERE ciudad="Madrid";

-- 12. Cuenta cuántas prendas tienen un precio mayor a 50.

SELECT COUNT(*) FROM prendas
WHERE precio>50;

-- 13. Selecciona los empleados que trabajan en la tienda con ID 1.

SELECT * FROM empleados 
WHERE tienda_id=1;

-- 14. Busca clientes cuyo nombre contenga "Andrés".

SELECT * FROM clientes
WHERE nombre_cliente LIKE "%Andrés%";

-- 15. Selecciona las compras realizadas por el cliente con ID 2.

SELECT * FROM compras
WHERE id_cliente=2;

-- 16. Elimina todas las compras cuyo monto sea menor a 30.

DELETE FROM Detalle_Compras
WHERE id_compra IN (
SELECT id_compra
FROM Compras
WHERE monto_total < 30
);
DELETE FROM Compras
WHERE monto_total < 30;

-- 17. Selecciona las prendas cuyo precio esté entre 20 y 40.

SELECT * FROM prendas
WHERE precio BETWEEN 20 AND 40;

-- 18. Busca empleados cuyo nombre contenga la letra "a".

SELECT * FROM empleados
WHERE nombre_empleado LIKE "%a%";

-- 19. Selecciona las 5 prendas más caras.

SELECT * FROM prendas
ORDER BY precio DESC
LIMIT 5;

-- 20. Selecciona las compras de un cliente con un monto superior a 75.

SELECT * FROM compras 
WHERE id_cliente=1
AND monto_total>75;

-- 21. Selecciona las prendas de talla M.

SELECT * FROM prendas
WHERE talla="M";

-- 22. Actualiza la talla de una prenda específica por su ID.

UPDATE prendas SET talla="S" 
WHERE id_prenda=1;

-- 23. Selecciona todos los empleados contratados después del 1 de enero de 2022.

SELECT * FROM empleados
WHERE fecha_contratacion>"2022-01-01";

-- 24. Busca tiendas en "Barcelona".

SELECT * FROM tiendas
WHERE ciudad="Barcelona";

-- 25. Elimina un empleado por su ID.

DELETE FROM Detalle_Compras
WHERE id_compra IN (
SELECT id_compra
FROM Compras
WHERE id_empleado = 1
);
DELETE FROM Compras
WHERE id_empleado = 1;
DELETE FROM Empleados
WHERE id_empleado = 1;

-- 26. Selecciona las compras que se realizaron antes del 1 de julio de 2023.

SELECT * FROM compras
WHERE fecha_compra<"2023-07-01";

-- 27. Busca prendas cuyo nombre termine en "eta".

SELECT * FROM prendas
WHERE RIGHT(tipo_prenda,3)="eta";

-- 28. Selecciona los clientes que no tengan un email registrado con "hotmail".

SELECT * FROM clientes 
WHERE email_cliente NOT LIKE "%hotmail%";

-- 29. Cuenta cuántas compras se realizaron en septiembre de 2023.

SELECT COUNT(*) FROM compras
WHERE YEAR(fecha_compra) = 2023
AND MONTH(fecha_compra) = 9;

-- 30. Actualiza la dirección de una tienda por su ID.

UPDATE tiendas SET direccion="Portal de l'Àngel, 15" 
WHERE id_tienda=2;

-- 31. Selecciona las prendas que sean camisetas.

SELECT * FROM prendas 
WHERE tipo_prenda="Camiseta";

-- 32. Elimina todas las prendas cuyo precio sea menor a 20.

DELETE FROM Detalle_Compras
WHERE id_prenda IN (
SELECT id_prenda
FROM Prendas
WHERE precio < 20
);
DELETE FROM Prendas
WHERE precio < 20;

-- 33. Selecciona todas las tiendas y ordénalas por ciudad.

SELECT * FROM TIENDAS
ORDER BY ciudad;

-- 34. Selecciona los empleados que sean vendedores.

SELECT * FROM empleados
WHERE puesto="Vendedor";

-- 35. Cuenta cuántas prendas son de color blanco.

SELECT COUNT(*) FROM prendas
WHERE color="Blanco";

-- 36. Selecciona los clientes que tengan nombres de más de 10 caracteres.

SELECT * FROM clientes
WHERE char_length(nombre_cliente)>10;

-- 37. Busca compras cuyo monto total esté entre 50 y 100.

SELECT * FROM compras 
WHERE monto_total BETWEEN 50 AND 100;

-- 38. Selecciona las 3 compras más recientes.

SELECT * FROM compras
ORDER BY fecha_compra DESC
LIMIT 3;

-- 39. Busca cursos cuyo nombre contenga la palabra "Digital".

-- 40. Agrupa las prendas por color y cuenta cuántas hay de cada color.

SELECT color, COUNT(*) FROM prendas
GROUP BY color;

-- 41. Añade dos tiendas más que existan en Madrid y no estén en la base de datos.

INSERT INTO tiendas (nombre_tienda, direccion, ciudad, pais)
VALUES
('Zara Goya', 'Calle Goya, 85', 'Madrid', 'España'),
('Zara Príncipe Pío', 'Paseo de la Florida, 2', 'Madrid', 'España');

-- 42. El cliente Miguel Torres se ha hecho trans y ha pedido que le cambien el nombre a Micaela. Actualiza también su e-mail.

UPDATE clientes 
SET nombre_cliente="Micaela Torres",
email_cliente="micaela.torres@email.com"
WHERE id_cliente=5; 
-- Utilice la base de datos Sakila.

USE sakila;

-- Obtenga todos los datos de las tablas actor, film y customer.

SELECT * FROM actor;
SELECT * FROM film;
SELECT * FROM customer;

-- Obtener títulos de películas.

SELECT title FROM film;

-- Obtén una lista única de idiomas de las películas bajo el alias language. Ten en cuenta que no te pedimos que obtengas el idioma de cada película, pero es un buen momento para pensar cómo podrías obtener esa información en el futuro.

SELECT DISTINCT(name) AS language 
FROM language;

-- 5.1 ¿Averigua cuántas tiendas tiene la empresa?

SELECT COUNT(*) FROM store;

-- 5.2 ¿Averigua cuántos empleados tiene la empresa?

SELECT COUNT(*) FROM staff;

-- 5.3 ¿Devolver una lista solo con los nombres de los empleados?

SELECT CONCAT(First_name, " ", Last_name) FROM staff;

-- Seleccione todos los actores con el nombre Scarlett.

SELECT * FROM actor
WHERE First_name = "Scarlett";

-- Seleccione todos los actores con el apellido Johansson.

SELECT * FROM actor
WHERE Last_name = "Johansson";

-- ¿Cuántas películas están disponibles para alquilar?

SELECT COUNT(*) FROM inventory;

-- ¿Cuántas películas se han alquilado?

SELECT COUNT(*) FROM rental;

-- ¿Cuál es el período de alquiler más corto y más largo?

SELECT 
MIN(rental_duration),
MAX(rental_duration)
FROM film;

-- ¿Cuál es la duración más corta y más larga de una película? Nombra los valores max_durationy min_duration.

SELECT
MIN(length) AS min_duration,
MAX(length) AS max_duration
FROM film;

-- ¿Cuál es la duración media de una película?

SELECT AVG(length) FROM film;

-- ¿Cuál es la duración promedio de una película expresada en formato (horas, minutos)?

SELECT CONCAT(
FLOOR(AVG(length)/60),
" horas, ",
ROUND(AVG(length)%60),
" minutos")
FROM film;

-- ¿Cuántas películas duran más de 3 horas?

SELECT COUNT(*)
FROM film
WHERE length > 180;

-- Formatee el nombre y el correo electrónico. Ejemplo: Mary SMITH - mary.smith@sakilacustomer.org .

SELECT CONCAT(first_name, ' ', UPPER(last_name), ' - ', email)
FROM customer;

-- ¿Cuál es el título de la película de la mayor duración?

SELECT title 
FROM film
WHERE length = (SELECT MAX(length) FROM film);
USE erasmus;
-- 1 ¿Cuál es la edad promedio de los estudiantes que tienen calificaciones sobresalientes? Complete la tabla con EXCELENTE si tienen un 9 o un 10, BUENO si tienen un 7 u 8, APROBADO si tienen un 5 o un 6, y REPROBADO si tienen menos de 5.
WITH calificacion AS (SELECT student_id, AVG(grades) AS media,
CASE WHEN AVG(grades) >= 9 THEN 'EXCELENTE'
WHEN AVG(grades) >= 7 THEN 'BUENO'
WHEN AVG(grades) >= 5 THEN 'APROBADO'
ELSE 'REPROBADO' END AS nota
FROM grades
GROUP BY student_id)
SELECT AVG(TIMESTAMPDIFF(YEAR, s.dob, CURDATE())) AS edad_promedio
FROM calificacion AS c
INNER JOIN students AS s ON c.student_id = s.student_id
WHERE c.nota = 'EXCELENTE';

-- 2 ¿Cuál es la edad media de los estudiantes por universidad?
SELECT u.uni_name, FLOOR(AVG(TIMESTAMPDIFF(YEAR, s.dob, CURDATE()))) AS edad_promedio
FROM university AS u
INNER JOIN campus AS c 
ON u.university_id = c.university_id
INNER JOIN students AS s 
ON c.city = s.city
GROUP BY u.uni_name;

-- 3 ¿Cuál es la proporción de alumnos que suspendieron cada asignatura? Indique el nombre de la asignatura, el número de alumnos que suspendieron, el número total de alumnos y la proporción de alumnos que suspendieron (en porcentaje) para cada asignatura. Muestre los resultados en orden descendente según la proporción de alumnos que suspendieron.
SELECT s.subj_name as subject, SUM(g.grades<5) as reprobados, COUNT(*) as alumnos, ROUND(SUM(g.grades<5)*100/COUNT(*),2) as ratio
FROM subjects as s
INNER JOIN grades as g
ON s.subject_id=g.subject_id
GROUP BY s.subj_name
ORDER BY ratio DESC;

-- 4 Cuál es la nota media de los estudiantes que han realizado un Erasmus en comparación con los que no lo han hecho?
SELECT CASE WHEN s.student_id IN (SELECT student_id FROM international_agreement)
THEN 'CON ERASMUS'
ELSE 'SIN ERASMUS' END AS grupo,
COUNT(DISTINCT s.student_id) AS num_estudiantes,
AVG(g.grades) AS nota_media
FROM students AS s
INNER JOIN grades AS g ON s.student_id = g.student_id
GROUP BY grupo;

-- 5. Para cada universidad, identifique el número de títulos de licenciatura, maestría y doctorado otorgados. Proporcione la identificación y el nombre de la universidad junto con el recuento de cada tipo de título.
SELECT u.university_id,
u.uni_name,
SUM(CASE WHEN LEFT(b.bachelor_id, 1) = 'B' THEN 1 ELSE 0 END) AS licenciaturas,
SUM(CASE WHEN LEFT(b.bachelor_id, 1) = 'M' THEN 1 ELSE 0 END) AS masters,
SUM(CASE WHEN LEFT(b.bachelor_id, 1) = 'D' THEN 1 ELSE 0 END) AS doctorados
FROM university AS u
INNER JOIN bachelor AS b ON u.university_id = b.university_id
GROUP BY u.university_id, u.uni_name
ORDER BY u.university_id;

-- 6. ¿Cuáles son las 5 universidades con la clasificación media más alta a lo largo de los años? Indique el ID de la universidad, el nombre de la universidad y la clasificación media.
SELECT u.university_id,
u.uni_name,
AVG(r.intl_ranking) AS ranking_medio
FROM university AS u
INNER JOIN ranking AS r ON u.university_id = r.university_id
GROUP BY u.university_id, u.uni_name
ORDER BY ranking_medio ASC
LIMIT 5;

-- 7. Proporcione el número de identificación, el nombre, los apellidos, el nombre de la universidad de origen y el correo electrónico de los 10 estudiantes que hayan participado más veces en un acuerdo internacional.
WITH conteo AS (
SELECT student_id,
COUNT(*) AS veces,
DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS rn
FROM international_agreement
GROUP BY student_id
)
SELECT DISTINCT s.student_id, s.f_name, s.l_name, u.uni_name AS universidad_origen,
s.email, c.veces
FROM conteo AS c
INNER JOIN students AS s ON c.student_id = s.student_id
INNER JOIN international_agreement AS ia ON ia.student_id = s.student_id
INNER JOIN university AS u ON ia.home_university = u.university_id
WHERE c.rn <= 10
ORDER BY c.veces DESC;

-- 8. Realice una consulta en la que, modificando el número de acuerdo internacional, pueda identificar el identificador y el nombre del estudiante que realizó el intercambio, el nombre de la universidad de origen y el nombre de la ciudad donde tuvo lugar el intercambio.
SELECT ia.agreement_code,
s.student_id,
s.f_name,
s.l_name,
origen.uni_name AS universidad_origen,
c.city AS ciudad_intercambio
FROM international_agreement AS ia
INNER JOIN students AS s ON ia.student_id = s.student_id
INNER JOIN university AS origen ON ia.home_university = origen.university_id
INNER JOIN campus AS c ON ia.away_university = c.university_id
WHERE ia.agreement_code = '123BH';

-- 8 BONUS..
DROP PROCEDURE IF EXISTS buscar_acuerdo;
DELIMITER //
CREATE PROCEDURE buscar_acuerdo (IN p_codigo VARCHAR(5))
BEGIN
SELECT ia.agreement_code,
s.student_id,
s.f_name,
s.l_name,
origen.uni_name AS universidad_origen,
c.city AS ciudad_intercambio
FROM international_agreement AS ia
INNER JOIN students AS s ON ia.student_id = s.student_id
INNER JOIN university AS origen ON ia.home_university = origen.university_id
INNER JOIN campus AS c ON ia.away_university = c.university_id
WHERE ia.agreement_code = p_codigo;
END //
DELIMITER ;
CALL buscar_acuerdo('123BH');

-- 9. Busque y muestre el número de universidades que ofrecen cada asignatura, junto con la nota media de cada asignatura.
SELECT sub.subject_id,
sub.subj_name,
(SELECT COUNT(DISTINCT us.university_id)
FROM uni_subj AS us
WHERE us.subject_id = sub.subject_id) AS num_universidades,
(SELECT AVG(g.grades)
FROM grades AS g
WHERE g.subject_id = sub.subject_id) AS nota_media
FROM subjects AS sub
ORDER BY sub.subject_id;

-- 10. Encuentre las 5 ciudades con el mayor porcentaje de estudiantes con calificaciones sobresalientes (9 o 10). Indique la ciudad, el estado y el porcentaje de estudiantes sobresalientes de cada ciudad.
WITH sobresalientes AS (
SELECT DISTINCT student_id
FROM grades
WHERE grades >= 9
)
SELECT s.city,
s.state,
COUNT(DISTINCT s.student_id) AS total_estudiantes,
COUNT(DISTINCT sob.student_id) AS num_sobresalientes,
COUNT(DISTINCT sob.student_id) * 100.0 / COUNT(DISTINCT s.student_id) AS porcentaje
FROM students AS s
LEFT JOIN sobresalientes AS sob ON s.student_id = sob.student_id
GROUP BY s.city, s.state
ORDER BY porcentaje DESC
LIMIT 5;

-- 11. Compara las universidades que envían más estudiantes con las universidades que reciben más estudiantes. Hazlo en dos consultas.
-- 11a. Universidades que ENVÍAN más estudiantes.
SELECT u.university_id,
u.uni_name,
COUNT(*) AS estudiantes_enviados
FROM international_agreement AS ia
INNER JOIN university AS u ON ia.home_university = u.university_id
GROUP BY u.university_id, u.uni_name
ORDER BY estudiantes_enviados DESC;

-- 11b. Universidades que RECIBEN más estudiantes.
SELECT u.university_id,
u.uni_name,
COUNT(*) AS estudiantes_recibidos
FROM international_agreement AS ia
INNER JOIN university AS u ON ia.away_university = u.university_id
GROUP BY u.university_id, u.uni_name
ORDER BY estudiantes_recibidos DESC;

-- 11 BONUS UNION ALL.
SELECT 'ENVIADOS' AS tipo, u.university_id, u.uni_name, COUNT(*) AS num_estudiantes
FROM international_agreement AS ia
INNER JOIN university AS u ON ia.home_university = u.university_id
GROUP BY u.university_id, u.uni_name
UNION ALL
SELECT 'RECIBIDOS' AS tipo, u.university_id, u.uni_name, COUNT(*) AS num_estudiantes
FROM international_agreement AS ia
INNER JOIN university AS u ON ia.away_university = u.university_id
GROUP BY u.university_id, u.uni_name
ORDER BY tipo, num_estudiantes DESC;
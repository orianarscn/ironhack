USE bands;
-- 1 QUÉ MÚSICO HA PERTENECIDO A MÁS BANDAS
SELECT mn.musician_name, COUNT(DISTINCT bm.band_id) AS num_bandas
FROM musician_name AS mn
INNER JOIN band_musician AS bm
ON mn.musician_id = bm.musician_id
GROUP BY bm.musician_id, mn.musician_name
ORDER BY num_bandas DESC LIMIT 1;
-- 2 QUÉ MÚSICO HA PARTICIPADO EN MÁS ALBUMS
SELECT mn.musician_name, COUNT(DISTINCT a.album_id) AS num_albums
FROM musician_name AS mn
INNER JOIN band_musician AS bm
ON mn.musician_id = bm.musician_id
INNER JOIN album as a
ON bm.band_id=a.band_id
GROUP BY bm.musician_id, mn.musician_name
ORDER BY num_albums DESC LIMIT 1;
-- 3 QUÉ BANDA HA HECHO MÁS DISCOS
SELECT b.band_name, COUNT(DISTINCT a.album_id) AS num_albums
FROM band AS b
INNER JOIN album AS a
ON b.band_id=a.band_id
GROUP BY b.band_id, b.band_name
ORDER BY num_albums DESC LIMIT 1;
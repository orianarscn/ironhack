CREATE DATABASE TikTokDB;
USE TikTokDB;

CREATE TABLE Usuarios (
usuario_id INT PRIMARY KEY,
nombre_usuario VARCHAR(50),
email VARCHAR(100),
fecha_registro DATE,
pais VARCHAR(50) NOT NULL
);

CREATE TABLE Videos (
video_id INT PRIMARY KEY,
usuario_id INT,
titulo VARCHAR(100),
descripcion VARCHAR(255),
fecha_publicacion DATE,
duracion_segundos INT,
FOREIGN KEY (usuario_id) REFERENCES Usuarios(usuario_id)
);

CREATE TABLE Comentarios (
comentario_id INT PRIMARY KEY,
video_id INT,
usuario_id INT,
texto VARCHAR(255) NOT NULL,
fecha_comentario DATE,
FOREIGN KEY (video_id) REFERENCES Videos(video_id),
FOREIGN KEY (usuario_id) REFERENCES Usuarios(usuario_id)
);

CREATE TABLE Likes (
like_id INT PRIMARY KEY,
video_id INT,
usuario_id INT,
fecha_like DATE,
FOREIGN KEY (video_id) REFERENCES Videos(video_id),
FOREIGN KEY (usuario_id) REFERENCES Usuarios(usuario_id)
);

CREATE TABLE Seguidores (
seguidor_id INT PRIMARY KEY,
id_sigue INT,
id_seguido INT,
fecha_seguimiento DATE,
FOREIGN KEY (id_sigue) REFERENCES Usuarios(usuario_id),
FOREIGN KEY (id_seguido) REFERENCES Usuarios(usuario_id)
);

INSERT INTO Usuarios VALUES
(1, 'ana_lopez', 'ana@mail.com', '2024-01-10', 'España'),
(2, 'carlos99', 'carlos@mail.com', '2024-02-15', 'México'),
(3, 'lauraT', 'laura@mail.com', '2024-03-05', 'Argentina');

INSERT INTO Videos VALUES
(1, 1, 'Baile viral', 'Coreografía de moda', '2024-04-01', 30),
(2, 2, 'Receta rápida', 'Tortilla en 5 minutos', '2024-04-03', 60),
(3, 1, 'Mi gato', 'El gato juega', '2024-04-10', 15);

INSERT INTO Comentarios VALUES
(1, 1, 2, 'Me encanta!', '2024-04-02'),
(2, 2, 3, 'Voy a probarlo', '2024-04-04'),
(3, 3, 2, 'Qué bonito', '2024-04-11');

INSERT INTO Likes VALUES
(1, 1, 2, '2024-04-02'),
(2, 1, 3, '2024-04-02'),
(3, 2, 1, '2024-04-05');

INSERT INTO Seguidores VALUES
(1, 2, 1, '2024-04-01'),
(2, 3, 1, '2024-04-02'),
(3, 1, 2, '2024-04-06');

SELECT * FROM Usuarios;

SELECT * FROM Videos;

SELECT * FROM Comentarios;

SELECT * FROM Likes;

SELECT * FROM Seguidores;

SELECT v.titulo, u.nombre_usuario
FROM Videos v
JOIN Usuarios u ON v.usuario_id = u.usuario_id;

SELECT v.titulo, COUNT(l.like_id) AS total_likes
FROM Videos v
LEFT JOIN Likes l ON v.video_id = l.video_id
GROUP BY v.titulo;

SELECT u.nombre_usuario, COUNT(s.seguidor_id) AS seguidores
FROM Usuarios u
LEFT JOIN Seguidores s ON u.usuario_id = s.id_seguido
GROUP BY u.nombre_usuario;
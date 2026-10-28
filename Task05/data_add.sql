INSERT INTO users (name, email, gender, register_date, occupation)
VALUES ('Абушаева Валерия', 'abushaeva@pochta.ru', 'female', date('now'), 'student');

INSERT INTO users (name, email, gender, register_date, occupation)
VALUES ('Базаев Данила', 'bazaev@pochta.ru', 'male', date('now'), 'student');

INSERT INTO users (name, email, gender, register_date, occupation)
VALUES ('Жирнов Сергей', 'zhirnov@pochta.ru', 'male', date('now'), 'student');

INSERT INTO users (name, email, gender, register_date, occupation)
VALUES ('Кашаев Айрат', 'kashaev@pochta.ru', 'male', date('now'), 'student');

INSERT INTO users (name, email, gender, register_date, occupation)
VALUES ('Колыганов Александр', 'koliganov@pochta.ru', 'male', date('now'), 'student');

INSERT INTO movies (title, year)
VALUES ('Колобок', 2026);

INSERT INTO movie_genres (movie_id, genre_id)
SELECT m.id, g.id 
FROM movies m, genres g 
WHERE m.title = 'Колобок' AND g.name = 'Action';

INSERT INTO movies (title, year)
VALUES ('Сказка о потерянном времени', 2026);

INSERT INTO movie_genres (movie_id, genre_id)
SELECT m.id, g.id 
FROM movies m, genres g 
WHERE m.title = 'Сказка о потерянном времени' AND g.name = 'Comedy';

INSERT INTO movies (title, year)
VALUES ('Девятая планета', 2026);

INSERT INTO movie_genres (movie_id, genre_id)
SELECT m.id, g.id 
FROM movies m, genres g 
WHERE m.title = 'Девятая планета' AND g.name = 'Sci-Fi';

INSERT INTO ratings (user_id, movie_id, rating, timestamp)
SELECT 
    (SELECT id FROM users WHERE email = 'abushaeva@pochta.ru'),
    (SELECT id FROM movies WHERE title = 'Колобок'),
    4.0,
    strftime('%s', 'now');

INSERT INTO ratings (user_id, movie_id, rating, timestamp)
SELECT 
    (SELECT id FROM users WHERE email = 'abushaeva@pochta.ru'),
    (SELECT id FROM movies WHERE title = 'Сказка о потерянном времени'),
    5.0,
    strftime('%s', 'now');

INSERT INTO ratings (user_id, movie_id, rating, timestamp)
SELECT 
    (SELECT id FROM users WHERE email = 'abushaeva@pochta.ru'),
    (SELECT id FROM movies WHERE title = 'Девятая планета'),
    4.5,
    strftime('%s', 'now');

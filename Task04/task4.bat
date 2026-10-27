#!/bin/bash
chcp 65001

sqlite3 movies_rating.db < db_init.sql

echo "1. Найти все пары пользователей, оценивших один и тот же фильм. Устранить дубликаты, проверить отсутствие пар с самим собой. Для каждой пары должны быть указаны имена пользователей и название фильма, который они ценили. В списке оставить первые 100 записей."
echo "--------------------------------------------------"
sqlite3 movies_rating.db -box -echo "SELECT u1.name AS Пользователь_1, u2.name AS Пользователь_2, m.title AS Фильм FROM ratings r1 JOIN ratings r2 ON r1.movie_id = r2.movie_id AND r1.user_id < r2.user_id JOIN users u1 ON u1.id = r1.user_id JOIN users u2 ON u2.id = r2.user_id JOIN movies m ON m.id = r1.movie_id GROUP BY r1.user_id, r2.user_id, r1.movie_id ORDER BY m.title, Пользователь_1, Пользователь_2 LIMIT 100;"
echo " "

echo "2. Найти 10 самых свежих оценок от разных пользователей, вывести названия фильмов, имена пользователей, оценку, дату отзыва в формате ГГГГ-ММ-ДД."
echo "--------------------------------------------------"
sqlite3 movies_rating.db -box -echo "WITH ranked AS (SELECT r.*, ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY timestamp DESC, id DESC) AS user_row FROM ratings r) SELECT m.title AS Фильм, u.name AS Пользователь, r.rating AS Оценка, date(r.timestamp, 'unixepoch') AS Дата_отзыва FROM ranked r JOIN users u ON u.id = r.user_id JOIN movies m ON m.id = r.movie_id WHERE r.user_row = 1 ORDER BY r.timestamp DESC, r.id DESC LIMIT 10;"
echo " "

echo "3. Вывести в одном списке все фильмы с максимальным средним рейтингом и все фильмы с минимальным средним рейтингом. Общий список отсортировать по году выпуска и названию фильма. В зависимости от рейтинга в колонке "Рекомендуем" для фильмов должно быть написано "Да" или "Нет"."
echo "--------------------------------------------------"
sqlite3 movies_rating.db -box -echo "WITH avg_ratings AS (SELECT m.id, m.title, m.year, AVG(r.rating) AS avg_rating FROM movies m JOIN ratings r ON r.movie_id = m.id GROUP BY m.id), extremes AS (SELECT MAX(avg_rating) AS max_rating, MIN(avg_rating) AS min_rating FROM avg_ratings) SELECT a.title AS Фильм, a.year AS Год, ROUND(a.avg_rating, 3) AS Средний_рейтинг, 'Да' AS Рекомендуем FROM avg_ratings a CROSS JOIN extremes e WHERE a.avg_rating = e.max_rating UNION SELECT a.title, a.year, ROUND(a.avg_rating, 3), 'Нет' FROM avg_ratings a CROSS JOIN extremes e WHERE a.avg_rating = e.min_rating ORDER BY 2, 1;"
echo " "

echo "4. Вычислить количество оценок и среднюю оценку, которую дали фильмам пользователи-женщины в период с 2010 по 2012 год."
echo "--------------------------------------------------"
sqlite3 movies_rating.db -box -echo "SELECT COUNT(*) AS Количество_оценок, ROUND(AVG(r.rating), 3) AS Средняя_оценка FROM ratings r JOIN users u ON u.id = r.user_id WHERE u.gender = 'female' AND date(r.timestamp, 'unixepoch') >= '2010-01-01' AND date(r.timestamp, 'unixepoch') < '2013-01-01';"
echo " "

echo "5. Составить список фильмов с указанием их средней оценки и места в рейтинге по средней оценке. Полученный список отсортировать по году выпуска и названиям фильмов. В списке оставить первые 20 записей."
echo "--------------------------------------------------"
sqlite3 movies_rating.db -box -echo "WITH movie_ratings AS (SELECT m.id, m.title, m.year, AVG(r.rating) AS avg_rating FROM movies m JOIN ratings r ON r.movie_id = m.id GROUP BY m.id), ranked AS (SELECT title, year, avg_rating, RANK() OVER (ORDER BY avg_rating DESC) AS place FROM movie_ratings) SELECT title AS Фильм, year AS Год, ROUND(avg_rating, 3) AS Средняя_оценка, place AS Место FROM ranked ORDER BY year, title LIMIT 20;"
echo " "

echo '6. Вывести список из 10 последних зарегистрированных пользователей в формате "Фамилия Имя | Дата регистрации" (сначала фамилия, потом имя).'
echo "--------------------------------------------------"
sqlite3 movies_rating.db -box -echo "SELECT substr(name, instr(name, ' ') + 1) || ' ' || substr(name, 1, instr(name, ' ') - 1) || '|' || register_date AS Пользователь FROM users ORDER BY register_date DESC, id DESC LIMIT 10;"
echo " "

echo "7. С помощью рекурсивного CTE составить таблицу умножения для чисел от 1 до 10."
echo "--------------------------------------------------"
sqlite3 movies_rating.db -box -echo "WITH RECURSIVE seq(i) AS (SELECT 1 UNION ALL SELECT i + 1 FROM seq WHERE i < 100) SELECT ((i - 1) / 10 + 1) || 'x' || ((i - 1) % 10 + 1) || '=' || (((i - 1) / 10 + 1) * ((i - 1) % 10 + 1)) AS Таблица_умножения FROM seq ORDER BY i;"
echo " "

echo "8. С помощью рекурсивного CTE выделить все жанры фильмов, имеющиеся в таблице movies (каждый жанр в отдельной строке)."
echo "--------------------------------------------------"
sqlite3 movies_rating.db -box -echo "WITH RECURSIVE split(movie_id, genre, rest) AS (SELECT id, '', genres || '|' FROM movies WHERE genres IS NOT NULL AND genres <> '' UNION ALL SELECT movie_id, substr(rest, 1, instr(rest, '|') - 1), substr(rest, instr(rest, '|') + 1) FROM split WHERE rest <> '') SELECT DISTINCT genre AS Жанр FROM split WHERE genre <> '' ORDER BY genre;"
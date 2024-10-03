-- Drop and create the database
DROP DATABASE IF EXISTS netflix;
CREATE DATABASE netflix;

-- Connect to the database
\c netflix;

-- Set character encoding
SET NAMES 'utf8';
SET client_encoding = 'utf8mb4';

-- Drop and create the movies table
DROP TABLE IF EXISTS movies;
CREATE TABLE movies (
    movie_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    director VARCHAR(255) NOT NULL,
    genre VARCHAR(255) NOT NULL,
    release_year DATE
);

-- Insert data into movies
INSERT INTO movies (movie_id, title, director, genre, release_year) VALUES
    (1, 'love_brewed_in_the_african_pot', 'kwaw_ansah', 'romantic_drama', '1980-01-01'),
    (2, 'kill_bill', 'jane_eyre', 'action', '2017-02-04'),
    (3, 'torga_and_fuseini', 'foli', 'comedy_drama', '2005-11-23'),
    (4, 'dead-shot', 'kendar_jukebox', 'erotica', '2012-05-04'),
    (5, 'taxi_driver', 'plsam_adjeteyfio', 'comedy', '1990-02-06'),
    (6, 'the_lost_city', 'ngugi_kenyata', 'action', '2010-08-09'),
    (7, 'double_generation', 'bella_bello', 'romantic_drama', '1996-03-07'),
    (8, 'paulie', 'michael_kedey', 'erotica', '2020-04-07'),
    (9, 'road_of_gold', 'zingaro', 'romantic_drama', '2015-10-04'),
	
    (10, 'men_who_built_britain', 'jon parker', 'drama', '1999-03-10');
	(11, 'girls_who_are_bad',  'carter mars', 'comdedy','2021-02-10');
	

-- Drop and create the subscribers table
DROP TABLE IF EXISTS subscribers;
CREATE TABLE subscribers (
    subscriber_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    subscription_plan VARCHAR(255) NOT NULL,
    subscription_date DATE NOT NULL,
    CONSTRAINT check_email CHECK (email LIKE '%@%.%')
);

-- Insert data into subscribers
INSERT INTO subscribers (subscriber_id, name, email, subscription_plan, subscription_date) VALUES
    (1, 'michael_sedem', 'privatemyk@gmail.com', 'platinum', '2023-07-03'),
    (2, 'gemma_nkiru', 'jdo@gmail.com', 'standard', '2012-04-07'),
    (3, 'jaguar_ray', 'bobo@hotmail.com', 'standard', '2020-12-12'),
    (4, 'seth_jakpa', 'sethjag@gmail.com', 'gold', '2015-03-03'),
    (5, 'stewie_brown', 'stew@gmail.com', 'standard', '2023-04-23'),
    (6, 'amy_jefferson', 'amyjef@gmail.com', 'gold', '2019-07-11'),
    (7, 'enoch_jamie', 'odartey@gmail.com', 'platinum', '2000-03-04'),
    (8, 'bridget_zen', 'bribaby@gmail.com', 'platinum', '2004-03-04'),
    (9, 'jane_afi', 'jas@gmail.com', 'platinum', '2020-03-04'),
    (10, 'nkiru_wathiongo', 'nkiwa@gmail.com', 'platinum', '2023-03-04');
	(11, 'lord_barn', 'genny@gmail.com', 'platinum', '2023-02-03');

-- Drop and create the movie_rentals table
DROP TABLE IF EXISTS movie_rentals;
CREATE TABLE movie_rentals (
    rental_id SERIAL PRIMARY KEY,
    movie_id INT,
    subscriber_id INT,
    rental_date DATE NOT NULL,
    return_date DATE,
    CONSTRAINT FK_movie_id FOREIGN KEY (movie_id) REFERENCES movies(movie_id) ON DELETE RESTRICT,
    CONSTRAINT FK_subscriber_id FOREIGN KEY (subscriber_id) REFERENCES subscribers(subscriber_id) ON DELETE RESTRICT,
    CONSTRAINT check_return_date CHECK (return_date >= rental_date)
);

-- Insert data into movie_rentals
INSERT INTO movie_rentals (rental_id, movie_id, subscriber_id, rental_date, return_date) VALUES
    (16, 3, 7, '2021-03-04', '2021-03-06'),
    (2, 3, 1, '2023-08-03', '2023-08-16'),
    (3, 2, 6, '2022-07-11', '2022-07-13'),
    (4, 7, 6, '2021-07-11', '2021-07-20'),
    (5, 4, 4, '2019-03-03', '2019-03-05'),
    (6, 1, 7, '2023-03-04', '2023-03-07'),
    (7, 3, 2, '2017-04-07', '2017-04-09'),
    (8, 5, 3, '2021-12-12', '2021-12-23'),
    (9, 7, 6, '2023-07-11', '2023-07-15'),
    (10, 6, 3, '2023-12-12', NULL),
    (11, 2, 2, '2023-11-03', '2023-11-07'),
    (12, 4, 1, '2023-12-03', NULL),
    (13, 5, 7, '2022-03-04', '2022-03-11'),
    (14, 9, 4, '2016-03-03', '2016-03-13'),
    (15, 10, 6, '2019-07-11', '2019-07-17');
	(17, 7, 2, '2021-07-11', '2021-07-18');

-- Drop and create procedures
DROP FUNCTION IF EXISTS add_movie(INT, VARCHAR, VARCHAR, VARCHAR, DATE);
CREATE OR REPLACE FUNCTION add_movie(movie_id INT, title VARCHAR, director VARCHAR, genre VARCHAR, release_year DATE)
RETURNS VOID AS $$
BEGIN
    INSERT INTO movies (movie_id, title, director, genre, release_year)
    VALUES (movie_id, title, director, genre, release_year);
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS subscribe_user(INT, VARCHAR, VARCHAR, VARCHAR, DATE);
CREATE OR REPLACE FUNCTION subscribe_user(subscriber_id INT, name VARCHAR, email VARCHAR, subscription_plan VARCHAR, subscription_date DATE)
RETURNS VOID AS $$
BEGIN
    INSERT INTO subscribers (subscriber_id, name, email, subscription_plan, subscription_date)
    VALUES (subscriber_id, name, email, subscription_plan, subscription_date);
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS rent_movie(INT, INT, INT, DATE, DATE);
CREATE OR REPLACE FUNCTION rent_movie(rental_id INT, movie_id INT, subscriber_id INT, rental_date DATE, return_date DATE)
RETURNS VOID AS $$
BEGIN
    INSERT INTO movie_rentals (rental_id, movie_id, subscriber_id, rental_date, return_date)
    VALUES (rental_id, movie_id, subscriber_id, rental_date, return_date);
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS return_movie(INT, DATE);
CREATE OR REPLACE FUNCTION return_movie(id INT, returning_date DATE)
RETURNS VOID AS $$
BEGIN
    UPDATE movie_rentals
    SET return_date = returning_date
    WHERE rental_id = id;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS popular_movies();
CREATE OR REPLACE FUNCTION popular_movies()
RETURNS TABLE(top_3_popular_movies VARCHAR, popularity_rate INT, movie_id INT, genre VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT
        m.title AS top_3_popular_movies,
        COUNT(mr.movie_id) AS popularity_rate,
        m.movie_id,
        m.genre
    FROM movies m
    JOIN movie_rentals mr ON m.movie_id = mr.movie_id
    GROUP BY mr.movie_id
[O    ORDER BY popularity_rate DESC
    LIMIT 3;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS subscriber_rentals(INT);
CREATE OR REPLACE FUNCTION subscriber_rentals(sub_id INT)
RETURNS TABLE(subscriber_id INT, movies_subscribed VARCHAR, genre VARCHAR, rental_id INT, rental_date DATE) AS $$
BEGIN
    RETURN QUERY
    SELECT
        mr.subscriber_id,
        m.title AS movies_subscribed,
        m.genre,
        mr.rental_id,
        mr.rental_date
    FROM movies m
    JOIN movie_rentals mr ON m.movie_id = mr.movie_id
    WHERE mr.subscriber_id = sub_id;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS total_rentals(DATE, DATE);
CREATE OR REPLACE FUNCTION total_rentals(from_date DATE, to_date DATE)
RETURNS TABLE(rental_id INT, movie_id INT, subscriber_id INT, rental_date DATE, return_date DATE) AS $$
BEGIN
    RETURN QUERY
    SELECT *
    FROM movie_rentals
    WHERE rental_date BETWEEN from_date AND to_date
    ORDER BY rental_date DESC;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS active_subscribers();
CREATE OR REPLACE FUNCTION active_subscribers()
RETURNS TABLE(active_subscribers VARCHAR, subscriber_id INT, activeness INT) AS $$
BEGIN
    RETURN QUERY
    SELECT
        s.name AS active_subscribers,
        s.subscriber_id,
        COUNT(mr.subscriber_id) AS activeness
    FROM subscribers s
    JOIN movie_rentals mr ON s.subscriber_id = mr.subscriber_id
    GROUP BY s.name, s.subscriber_id
    ORDER BY activeness DESC
    LIMIT 3;
END;
$$ LANGUAGE plpgsql;

-- Drop and create the check_rent_date trigger function
DROP FUNCTION IF EXISTS check_rent_date();
CREATE OR REPLACE FUNCTION check_rent_date()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM movies WHERE movie_id = NEW.movie_id) OR
       NOT EXISTS (SELECT 1 FROM subscribers WHERE subscriber_id = NEW.subscriber_id) THEN
        RAISE EXCEPTION 'Error! No record found for either movie id or subscriber id';
    ELSIF NEW.rental_date > (SELECT release_year FROM movies WHERE movie_id = NEW.movie_id) THEN
        RAISE EXCEPTION 'Error! Rental date greater than movie release date for movie id';
    ELSIF NEW.rental_date < (SELECT subscription_date FROM subscribers WHERE subscriber_id = NEW.subscriber_id) THEN
        RAISE EXCEPTION 'Error! Rental date less than subscription date or subscriber id';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger
DROP TRIGGER IF EXISTS check_rent_date ON movie_rentals;
CREATE TRIGGER check_rent_date
BEFORE INSERT ON movie_rentals
FOR EACH ROW EXECUTE FUNCTION check_rent_date();

-- View to get all movie rentals with subscriber details
CREATE OR REPLACE VIEW vw_movie_rentals AS
SELECT
    mr.rental_id,
    m.title AS movie_title,
    s.name AS subscriber_name,
    mr.rental_date,
    mr.return_date
FROM
    movie_rentals mr
JOIN
    movies m ON mr.movie_id = m.movie_id
JOIN
    subscribers s ON mr.subscriber_id = s.subscriber_id;

-- View to get the total rentals per movie
CREATE OR REPLACE VIEW vw_total_rentals_per_movie AS
SELECT
    m.movie_id,
    m.title,
    COUNT(mr.rental_id) AS total_rentals
FROM
    movies m
LEFT JOIN
    movie_rentals mr ON m.movie_id = mr.movie_id
GROUP BY
    m.movie_id, m.title
ORDER BY
    total_rentals DESC;

-- View to get active subscribers with their latest rental date
CREATE OR REPLACE VIEW vw_active_subscribers AS
SELECT
    s.subscriber_id,
    s.name,
    MAX(mr.rental_date) AS last_rental_date
FROM
    subscribers s
JOIN
    movie_rentals mr ON s.subscriber_id = mr.subscriber_id
GROUP BY
    s.subscriber_id, s.name
ORDER BY
    last_rental_date DESC;

-- View to get the most popular movies based on rental count
CREATE OR REPLACE VIEW vw_popular_movies AS
SELECT
    m.movie_id,
    m.title,
    COUNT(mr.rental_id) AS rental_count
FROM
    movies m
JOIN
    movie_rentals mr ON m.movie_id = mr.movie_id
GROUP BY
    m.movie_id, m.title
ORDER BY
    rental_count DESC
LIMIT 10;


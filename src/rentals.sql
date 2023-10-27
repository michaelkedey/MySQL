DROP DATABASE IF EXISTS `project_rentals`;
CREATE DATABASE `project_rentals`;
USE `project_rentals`;

SET NAMES utf8 ;
SET character_set_client = utf8mb4 ;


DROP TABLE IF EXISTS `movies`;
CREATE TABLE `movies`(
	`movie_id` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `title` varchar(255) NOT NULL,
    `director` varchar(255) NOT NULL,
    `genre` varchar(255) NOT NULL,
    `release_year` date
);  

INSERT INTO `movies` VALUES
	(1, 'love_brewed_in_the_african_pot', 'kwaw_ansah', 'romantic_drama', '1980-01-01'),
    (2, 'kill_bill', 'jane_eyre', 'action', '2017-02-04'),
    (3, 'torga_and_fuseini', 'foli', 'comedy_drama', '2005-11-23'),
    (4, 'dead-shot', 'kendar_jukebox', 'erotica', '2012-5-4'),
    (5, 'taxi_driver', 'plsam_adjeteyfio', 'comedy', '1990-2-6'),
    (6, 'the_lost_city', 'ngugi_kenyata', 'action', '2010-8-9'),
    (7, 'double_generation', 'bella_bello', 'romantic_drama', '1996-3-7'),
    (8, 'paulie', 'michael_kedey', 'erotica', '2020-4-7'),
    (9, 'road_of_gold', 'zingaro', 'romantic_drama', '2015-10-4'),
    (10, 'men_who_built_britain', 'jon parker', 'drama', '1999-3-10');    


DROP TABLE IF EXISTS `subscribers`;
CREATE TABLE `subscribers`(
	`subscriber_id` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `name` varchar(255) NOT NULL,
    `email`varchar(255) NOT NULL UNIQUE,
    `subscription_plan` varchar(255) NOT NULL,
    `subscription_date` date NOT NULL,
    CONSTRAINT `check_email` CHECK (`email` LIKE '%@%.%_%')
);


 INSERT INTO `subscribers` VALUES
	(1, 'michael_sedem', 'privatemyk@gmail.com', 'platinum', '2023-7-3'),
    (2, 'gemma_nkiru', 'jdo@gmail.com', 'standard', '2012-4-7'),
	(3, 'jaguar_ray', 'bobo@hotmail.com', 'standard', '2020-12-12'),
    (4, 'seth_jakpa', 'sethjag@gmail.com', 'gold', '2015-3-3'),
    (5, 'stewie_brown', 'stew@gmail.com', 'standard', '2023-4-23'),
    (6, 'amy_jefferson', 'amyjef@gmail.com', 'gold', '2019-7-11'),
    (7, 'enoch_jamie', 'odartey@gmail.com', 'platinum', '2000-3-4'),
	(8, 'bridget_zen', 'bribaby@gmail.com', 'platinum', '2004-3-4'),
	(9, 'jane_afi', 'jas@gmail.com', 'platinum', '2020-3-4'),
	(10, 'nkiru_wathiongo', 'nkiwa@gmail.com', 'platinum', '2023-3-4');
 

DROP TABLE IF EXISTS `movie_rentals`;
CREATE TABLE `movie_rentals`(
	`rental_id` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `movie_id` int,
    `subscriber_id` int,
    `rental_date` date NOT NULL,
    `return_date` date,
    KEY `FK_movie_id` (`movie_id`),
    CONSTRAINT `FK_movie_id` FOREIGN KEY(`movie_id`)REFERENCES `movies`(`movie_id`) ON DELETE RESTRICT,
    KEY `FK_subscriber_id` (`subscriber_id`),
    CONSTRAINT `FK_subscriber_id` FOREIGN KEY (`subscriber_id`) REFERENCES `subscribers`(`subscriber_id`) ON DELETE RESTRICT,
    CONSTRAINT `check_return_date` CHECK(`return_date` >= `rental_date`)
);

INSERT INTO `movie_rentals` VALUES
	(16, 3, 7, '2021-3-4', '2021-3-6'),
    (2, 3, 1, '2023-8-3', '2023-8-16'),
    (3, 2, 6, '2022-7-11', '2022-7-13'),
    (4, 7, 6, '2021-7-11', '2021-7-20'),
    (5, 4, 4, '2019-3-3', '2019-3-5'),
    (6, 1, 7, '2023-3-4', '2023-3-7'),
    (7, 3, 2, '2017-4-7', '2017-4-9'),
    (8, 5, 3, '2021-12-12', '2021-12-23'),
    (9, 7, 6, '2023-7-11', '2023-7-15'),
    (10, 6, 3, '2023-12-12', null),
    (11, 2, 2, '2023-11-3', '2023-11-7'),
    (12, 4, 1, '2023-12-3', null),
    (13, 5, 7, '2022-3-4', '2022-3-11'),
    (14, 9, 4, '2016-3-3', '2016-3-13'),
    (15, 10, 6, '2019-7-11', '2019-7-17');    


DROP PROCEDURE IF EXISTS `add_movie`;
DELIMITER //
CREATE PROCEDURE `add_movie`(`movie_id` int, `title` varchar(255), `director` varchar(255), `genre` varchar(255),`release_year` date)
BEGIN
	INSERT INTO `movies` VALUES
		(`movie_id`, `title`, `director`, `genre`,`release_year`);
END //
DELIMITER //


DROP PROCEDURE IF EXISTS `subscribe_user`;
DELIMITER //
CREATE PROCEDURE `subscribe_user` (`subscriber_id` int, `name` varchar(255), `email`varchar(255), `subscription_plan` varchar(255), `subscription_date` date)
BEGIN
	INSERT INTO `subscribers` VALUES
		(`subscriber_id`, `name`, `email`, `subscription_plan`, `subscription_date`);
END //
DELIMITER //


DROP PROCEDURE IF EXISTS `rent_movie`;
DELIMITER //
CREATE PROCEDURE `rent_movie` ( `rental_id` int, `movie_id` int, `subscriber_id` int, `rental_date` date, `return_date` date)
BEGIN
	INSERT INTO `movie_rentals` VALUES
		(`rental_id`, `movie_id`, `subscriber_id`, `rental_date`, `return_date`);
END //
DELIMITER //


DROP PROCEDURE IF EXISTS `return_movie`;
DELIMITER //
CREATE PROCEDURE `return_movie` (`id` int, `returning_date` date)
BEGIN
	UPDATE `movie_rentals`
    SET `return_date` = `returning_date`
    WHERE `movie_id` = `id`;
END //
DELIMITER //


DROP PROCEDURE IF EXISTS `popular_movies`;
DELIMITER //
CREATE PROCEDURE `popular_movies`()
BEGIN
	SELECT
		m.title AS `top_3_popular_movies`,
        COUNT(mr.movie_id) AS `popularity_rate`,
		m.movie_id,
        m.genre
	FROM `movies` m
    JOIN `movie_rentals` mr
    ON m.movie_id = mr.movie_id
    WHERE (SELECT COUNT(mr.movie_id) FROM `movie_rentals`) >= 1
    GROUP BY mr.movie_id
    ORDER BY `popularity_rate` DESC
    LIMIT 3;
END //
DELIMITER //


DROP PROCEDURE IF EXISTS `subscriber_rentals`;
DELIMITER //
CREATE PROCEDURE `subscriber_rentals` (`sub_id` int)
BEGIN
	SELECT 
		mr.subscriber_id,
		m.title AS `movies_subscribed`,
        m.genre,
        mr.rental_id,
        mr.rental_date
	FROM `movies` m
    JOIN `movie_rentals` mr 
    ON m.movie_id = mr.movie_id
    WHERE mr.subscriber_id = `sub_id`;
END //
DELIMITER //


DROP PROCEDURE IF EXISTS `total_rentals`;
DELIMITER //
CREATE PROCEDURE `total_rentals` (`from` date, `to` date)
BEGIN
	SELECT * FROM `movie_rentals`
    WHERE `rental_date` BETWEEN `from` AND `to`
    ORDER BY `rental_date` DESC;
END //
DELIMITER //


DROP PROCEDURE IF EXISTS `active_subscribers`;
DELIMITER //
CREATE PROCEDURE `active_subscribers`()
BEGIN
	SELECT 
		s.name AS `active_subscribers`,
        s.subscriber_id,
        COUNT(mr.subscriber_id) AS `activeness`
	FROM `subscribers` s
    JOIN `movie_rentals` mr
    ON s.subscriber_id = mr.subscriber_id
    GROUP BY `active_subscribers`, s.subscriber_id
    ORDER BY `activeness` DESC
    LIMIT 3;
END //
DELIMITER //


DROP TRIGGER IF EXISTS `check_date`;
DELIMITER //
CREATE TRIGGER `check_rent_date`
BEFORE INSERT ON `movie_rentals`
FOR EACH ROW
BEGIN
	IF NEW.movie_id NOT IN (SELECT `movie_id` FROM `movies`) OR NEW.subscriber_id NOT IN (SELECT `subscriber_id` FROM `subscibers`) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'error! no record found for either movie id or subscriber id';
	ELSEIF NEW.rental_date > (SELECT `release_year` FROM `movies` WHERE NEW.movie_id = `movie_id`) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'error! rental date greater than movie release date for movie id';
	ELSEIF NEW.rental_date < (SELECT `subscription_date` FROM `subsribers` WHERE NEW.subscriber_id = `subscriber_id`) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'error! rental date less then subscription date or subscriber id';
	END IF;
END //
DELIMITER //


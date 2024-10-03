DROP DATABASE IF EXISTS `project_ticketing2`;
CREATE DATABASE `project_ticketing2`;
USE `project_ticketing2`;

SET NAMES utf8 ;
SET character_set_client = utf8mb4 ;


DROP TABLE IF EXISTS `flights`;
CREATE TABLE `flights`(
	`flight_id` int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `airline` varchar(255),
    `departure_airport` varchar(255) NOT NULL,
    `destination_airport` varchar(255) NOT NULL,
    `departure_time` datetime NOT NULL,
    `arrival_time` datetime NOT NULL,
    `seat_availability` varchar(3) NOT NULL,
    CONSTRAINT `check_seat_availability` CHECK (`seat_availability` IN ('yes', 'no'))
);
INSERT INTO `flights` VALUES 
(1, 'ghana_airways', 'kotoka_international_airport', 'calgary_international_airport', '2023-12-11 1:11', '2023-12-12 22', 'yes'),
(2, 'project_air', 'vancouver_international_airport', 'addis_baba_bole_international_airport', '2023-10-11 8:8:11', '2023-10-11 21', 'yes'),
(3, 'africa_world_airlines', 'kotoka_international_airport', 'ho_airport', '2023-06-10 19:19:11', '2023-06-10 20', 'no'),
(4, 'passion_air', 'kotoka_international_airport', 'kumasi_airport', '2023-12-12 1:11:11', '2023-12-12 15', 'yes'),
(5, 'air_ethiopia', 'addis_baba_bole_international_airport', 'kotoka_int_airport', '2023-12-12 1:11:11', '2023-12-12 12', 'no'),
(6, 'kenya_airways', 'jomo_kenyatta_international_airport', 'vancouver_international_airport', '2023-6-12 14:1', '2023-6-12 15', 'no'),
(7, 'rwandair', 'kotoka_international_airport', 'calgary_international_airport', '2023-09-08 1:19:11', '2023-09-08 6', 'yes'),
(8, 'british_airways', 'heathrow_airport', 'calgary_international_airport', '2023-12-12 10:8:11', '2023-12-12 15', 'yes'),
(9, 'air_peace', 'murtala_muhammed_international_airport', 'nnamdi_azikiwe_international_airport', '2023-06-10 19:19:11', '2023-06-10 20', 'yes'),
(10, 'emirates', 'dubai_international_airport', 'kotoka_international_airport', '2023-11-15 10:30', '2023-11-15 20', 'yes'),
(11, 'qatar_airways', 'hamad_international_airport', 'vancouver_international_airport', '2023-10-20 14:45', '2023-10-20 23', 'yes'),
(12, 'turkish_airlines', 'ataturk_airport', 'kotoka_international_airport', '2023-09-05 08:00', '2023-09-05 16', 'yes'),
(13, 'lufthansa', 'frankfurt_airport', 'kotoka_international_airport', '2023-12-01 12:30', '2023-12-01 21', 'yes'),
(14, 'ethiopian_airlines', 'addis_baba_bole_international_airport', 'kumasi_airport', '2023-07-10 16:15', '2023-07-10 18', 'no'),
(15, 'south_african_airways', 'or_tambo_international_airport', 'kotoka_international_airport', '2023-08-20 09:45', '2023-08-20 17', 'yes'),
(16, 'air_france', 'charles_de_gaulle_airport', 'kotoka_international_airport', '2023-11-10 11:00', '2023-11-10 19', 'yes'),
(17, 'delta_air_lines', 'hartsfield-jackson_atlanta_international_airport', 'kotoka_international_airport', '2023-10-05 13:20', '2023-10-05 22', 'yes'),
(18, 'virgin_atlantic', 'heathrow_airport', 'kotoka_international_airport', '2023-09-15 17:10', '2023-09-15 23', 'yes'),
(19, 'emirates', 'dubai_international_airport', 'kotoka_international_airport', '2023-12-10 08:45', '2023-12-10 18', 'yes');
(DEFAULT, 'air_canada', 'calgary_international_airport', 'jfk_airport', '2023-05-06 12:11:11', '2023-05-06 19', 'no');    


DROP TABLE IF EXISTS `passengers`;
CREATE TABLE `passengers`(
	`passenger_id` int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` varchar(255),
    `contact_number` int (10) UNIQUE,
    `email` varchar(50) NOT NULL UNIQUE,
    CONSTRAINT `check_email` CHECK (`email` LIKE '%@%.%_%')
    -- CONSTRAINT `check_number` CHECK (LENGTH(`contact_number`) =10)
    -- onstraint above forces phone number to be 10 digits 
);
INSERT INTO `passengers` VALUES
	(1, 'michael_kedey', 0244376616, 'privatemyk@gmail.com'),
    (2, 'john_doe', 0808838123, 'jdo@gmail.com'),
	(3, 'bola_ahmed', 0248601234, 'bobo@hotmail.com'),
    (4, 'godwin_dogbatsey', 0268834123, 'godwindog@gmail.com'),
    (5, 'holy_boy', 0258863123, 'holiest@gmail.com'),
    (6, 'evans_osei', 0236708123, 'eosei@gmail.com'),
    (DEFAULT, 'enoch_odartey_ameyaw', 0708658163, 'odartey@gmail.com');


DROP TABLE IF EXISTS `bookings`;   
CREATE TABLE `bookings`(
	`booking_id` int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `passenger_id` int NOT NULL,
    `flight_id` int NOT NULL,
    `date_of_booking` date NOT NULL,
    `seat_number` int(3) NOT NULL,
    `flight_date` date NOT NULL,
    KEY `FK_passenger_id` (`passenger_id`),
    CONSTRAINT `FK_passenger_id` FOREIGN KEY (`passenger_id`) REFERENCES `passengers` (`passenger_id`) ON DELETE RESTRICT,
    KEY `FK_flight_id` (`flight_id`),
    CONSTRAINT `FK_flight_id` FOREIGN KEY (`flight_id`) REFERENCES `flights` (`flight_id`) ON DELETE RESTRICT
    -- the foreign key constraints prevent accidental deletion of data from the flights and passenger tables as this table is synced with it
    -- you can alter the bookings table and drop the key constraints if you want to delete records from the flughts and passengers tables.
);
INSERT INTO `bookings` VALUES 
	(1, 2, 2, '2023-07-08', 232, '2023-10-11'),
    (2, 6, 2, '2023-06-20', 202, '2023-10-11'),
    (3, 1, 5, '2023-04-05', 232, '2023-09-08'),
	(4, 2, 10, '2023-04-05', 232, '2023-09-08'),
    (5, 4, 1, '2023-12-11', 34, '2023-12-17'),
    (6, 1, 5, '2023-04-05', 232, '2023-09-08');
    (7, 3, 8, '2023-08-15', 101, '2023-09-20'),
    (8, 5, 3, '2023-11-02', 56, '2023-11-10'),
    (9, 2, 7, '2023-10-18', 89, '2023-11-01'),
    (10, 1, 4, '2023-09-05', 123, '2023-09-15'),
    (11, 6, 9, '2023-12-25', 45, '2023-12-30'),
    (12, 4, 2, '2023-07-10', 78, '2023-07-15'),
    (13, 3, 1, '2023-06-12', 67, '2023-06-20'),
    (14, 5, 6, '2023-08-20', 90, '2023-08-25'),
    (15, 2, 5, '2023-11-10', 12, '2023-11-15'),
    (16, 1, 3, '2023-10-05', 34, '2023-10-10');


DROP PROCEDURE IF EXISTS `cancel_booking`;
DELIMITER //
CREATE PROCEDURE `cancel_booking`(`id` int)
BEGIN
	DELETE FROM `bookings`
	WHERE booking_id = `id`;
END //
DELIMITER ;
-- SET SQL_SAFE_UPDATES = 0;
-- commented statement above allows MySQL to delete records using the trigger, whereas MySQL would have demanded
-- a drop query with an explicit where clause using a key value. uncomment and run it if you have to and update it when done


DROP PROCEDURE IF EXISTS available_flights;
DELIMITER //
CREATE PROCEDURE `available_flights`(`depature` varchar(255), `destination` varchar(255))
BEGIN
	SELECT 
		`airline` AS `available_flights`,
        `depature_airport`,
        `destination_airport`
	FROM `flights` 
    WHERE
		`depature_airport` = `depature` AND `destination_airport` = `destination`;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS `passenger_booking`;
DELIMITER //
CREATE PROCEDURE `passenger_booking`(`id` int)
BEGIN
	SELECT 
		b.*,
        f.airline,
        f.departure_airport,
        f.destination_airport,
        f.departure_time,
        f.arrival_time
	FROM bookings b
    JOIN flights f ON b.flight_id = f.flight_id
    WHERE 
		b.passenger_id = id;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS `full_flights`;
DELIMITER //
CREATE PROCEDURE `full_flights`()
BEGIN
	SELECT 
		`flight_id`,
		`airline` as `full_capacity_flights`,
        `seat_availability`
	FROM `flights`
    WHERE
    seat_availability='no';
END //
DELIMITER ;


DROP TRIGGER IF EXISTS `bookings_update`;
DELIMITER //
CREATE TRIGGER `bookings_update` 
BEFORE INSERT ON `bookings`
FOR EACH ROW
BEGIN
	IF NEW.passenger_id NOT IN (SELECT `passenger_id` FROM `passengers`) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'no passenger matches the passenger_id';
	ELSEIF NEW.flight_id NOT IN (SELECT `flight_id` FROM `flights`) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'no flight matches the flight_id';
	ELSEIF NEW.flight_date != (SELECT DATE(`departure_time`) FROM `flights` WHERE NEW.flight_id = flight_id)
    OR NEW.date_of_booking > (SELECT (`departure_time`) FROM `flights` WHERE NEW.flight_id = flight_id) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'flight_date or date_of_booking differs from depature date for flight id';
	END IF;
END//
DELIMITER //

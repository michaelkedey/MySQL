/* USE `project_rentals`;
SELECT * FROM movies;
SELECT * FROM subscribers;
SELECT * FROM movie_rentals; */

--uncomment statement below to see subscriber rentals
--CALL subscriber_rentals(1)

--uncomment statement below to see total rentals
--CALL total_rentals

--uncomment statement below to see active subscribers
--CALL active_subscribers()

--uncomment statement below to add a movie
--CALL add_movie(1, "ghana must go", "amina zazau", "satire")

--uncomment statement below to add a subscriber
--CALL subscribe_user(30, "sedem_juma", "sed@mickey.com", "gold", "2023-10-29")

--uncomment statement below to rent a movie
--call `rent_movie` (19, 2, 3, '2023-01-01', null);

--uncomment statement below to see popular movies
--call popular_movies()



/* USE `project_ticketing`; */

--SELECT * FROM flights; 
--SELECT * FROM bookings;

-- SELECT * FROM bookings;
-- CALL cancel_booking(2);
-- SELECT * FROM bookings;
-- uncomment statements above to use the procedure and notice the changes before and after */

/* --CALL available_flights('kotoka_international_airport', 'calgary_international_airport');
--uncomment statement above to use the procedure */

/* --CALL passenger_booking(1);
--uncomment statement above to use the procedure */

--CALL full_flights();

/* -- SELECT * FROM `bookings`;
-- INSERT INTO `bookings` VALUES (DEFAULT, 200, 2, '2024-12-11', 34, '2023-12-11');
-- INSERT INTO `bookings` VALUES (DEFAULT, 3, 200, '2024-12-11', 34, '2023-12-11');
-- INSERT INTO `bookings` VALUES (DEFAULT, 5, 2, '2024-12-11', 34, '2023-12-11');
-- uncomment queries above to to use the trigger, notice the different error messages
-- SELECT * FROM `bookings`; */

/* --uncomment query below to see all passengers
--SELECT * FROM passengers; */

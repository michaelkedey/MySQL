-- Drop and create the database
DROP DATABASE IF EXISTS tracy_table;
CREATE DATABASE tracy_table;
\c tracy_table;  -- Connect to the newly created database

-- Create flights table
DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
    flight_id SERIAL PRIMARY KEY,
    airline VARCHAR(255),
    departure_airport VARCHAR(255) NOT NULL,
    destination_airport VARCHAR(255) NOT NULL,
    departure_time TIMESTAMPTZ NOT NULL,
    arrival_time TIMESTAMPTZ NOT NULL,
    seat_availability VARCHAR(3) NOT NULL,
    CONSTRAINT check_seat_availability CHECK (seat_availability IN ('yes', 'no'))
);

INSERT INTO flights (airline, departure_airport, destination_airport, departure_time, arrival_time, seat_availability) VALUES
('ghana_airways', 'kotoka_international_airport', 'calgary_international_airport', '2023-12-11 01:11', '2023-12-12 22:00', 'yes'),
('project_air', 'vancouver_international_airport', 'addis_baba_bole_international_airport', '2023-10-11 08:08:11', '2023-10-11 21:00', 'yes'),
('africa_world_airlines', 'kotoka_international_airport', 'ho_airport', '2023-06-10 19:19:11', '2023-06-10 20:00', 'no'),
('passion_air', 'kotoka_international_airport', 'kumasi_airport', '2023-12-12 01:11:11', '2023-12-12 15:00', 'yes'),
('air_ethiopia', 'addis_baba_bole_international_airport', 'kotoka_int_airport', '2023-12-12 01:11:11', '2023-12-12 12:00', 'no'),
('kenya_airways', 'jomo_kenyatta_international_airport', 'vancouver_international_airport', '2023-06-12 14:01', '2023-06-12 15:00', 'no'),
('rwandair', 'kotoka_international_airport', 'calgary_international_airport', '2023-09-08 01:19:11', '2023-09-08 06:00', 'yes'),
('british_airways', 'heathrow_airport', 'calgary_international_airport', '2023-12-12 10:08:11', '2023-12-12 15:00', 'yes'),
('air_peace', 'murtala_muhammed_international_airport', 'nnamdi_azikiwe_international_airport', '2023-06-10 19:19:11', '2023-06-10 20:00', 'yes'),
('air_canada', 'calgary_international_airport', 'jfk_airport', '2023-05-06 12:11:11', '2023-05-06 19:00', 'no'),
('dubai_airways', 'kinaata airport', 'JDK airport', '2024-09-11 01:55', '2024-10-02 11:00', 'no');

-- Create passengers table
DROP TABLE IF EXISTS passengers;
CREATE TABLE passengers (
    passenger_id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    contact_number VARCHAR(10) UNIQUE,
    email VARCHAR(50) NOT NULL UNIQUE,
    CONSTRAINT check_email CHECK (email LIKE '%@%.%')
);

INSERT INTO passengers (name, contact_number, email) VALUES
('michael_kedey', '0244376616', 'privatemyk@gmail.com'),
('john_doe', '0808838123', 'jdo@gmail.com'),
('bola_ahmed', '0248601234', 'bobo@hotmail.com'),
('godwin_dogbatsey', '0268834123', 'godwindog@gmail.com'),
('holy_boy', '0258863123', 'holiest@gmail.com'),
('evans_osei', '0236708123', 'eosei@gmail.com'),
('enoch_odartey_ameyaw', '0708658163', 'odartey@gmail.com'),
('ama akosua', '09240883939', 'mama@gmail.com');

-- Create bookings table
DROP TABLE IF EXISTS bookings;
CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    passenger_id INT NOT NULL,
    flight_id INT NOT NULL,
    date_of_booking DATE NOT NULL,
    seat_number INT NOT NULL,
    flight_date DATE NOT NULL,
    FOREIGN KEY (passenger_id) REFERENCES passengers (passenger_id) ON DELETE RESTRICT,
    FOREIGN KEY (flight_id) REFERENCES flights (flight_id) ON DELETE RESTRICT
);

INSERT INTO bookings (passenger_id, flight_id, date_of_booking, seat_number, flight_date) VALUES
(2, 2, '2023-07-08', 232, '2023-10-11'),
(6, 2, '2023-06-20', 202, '2023-10-11'),
(1, 5, '2023-04-05', 232, '2023-09-08'),
(2, 10, '2023-04-05', 232, '2023-09-08'),
(4, 1, '2023-12-11', 34, '2023-12-17'),
(1, 5, '2023-04-05', 232, '2023-09-08'),
(7, 8, '2023-09-09', 33, '2023-09-15');

-- Functions to handle procedures
DROP FUNCTION IF EXISTS cancel_booking(IN id INT);
CREATE OR REPLACE FUNCTION cancel_booking(IN id INT) RETURNS VOID AS $$
BEGIN
    DELETE FROM bookings WHERE booking_id = id;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS available_flights(IN depature VARCHAR, IN destination VARCHAR);
CREATE OR REPLACE FUNCTION available_flights(IN depature VARCHAR, IN destination VARCHAR) RETURNS TABLE(airline VARCHAR, departure_airport VARCHAR, destination_airport VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        airline, 
        departure_airport, 
        destination_airport
    FROM flights 
    WHERE departure_airport = depature AND destination_airport = destination;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS passenger_booking(IN id INT);
CREATE OR REPLACE FUNCTION passenger_booking(IN id INT) RETURNS TABLE(booking_id INT, passenger_id INT, flight_id INT, date_of_booking DATE, seat_number INT, flight_date DATE, airline VARCHAR, departure_airport VARCHAR, destination_airport VARCHAR, departure_time TIMESTAMPTZ, arrival_time TIMESTAMPTZ) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        b.booking_id,
        b.passenger_id,
        b.flight_id,
        b.date_of_booking,
        b.seat_number,
        b.flight_date,
        f.airline,
        f.departure_airport,
        f.destination_airport,
        f.departure_time,
        f.arrival_time
    FROM bookings b
    JOIN flights f ON b.flight_id = f.flight_id
    WHERE b.passenger_id = id;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS full_flights();
CREATE OR REPLACE FUNCTION full_flights() RETURNS TABLE(flight_id INT, full_capacity_flights VARCHAR, seat_availability VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        flight_id,
        airline AS full_capacity_flights,
        seat_availability
    FROM flights
    WHERE seat_availability = 'no';
END;
$$ LANGUAGE plpgsql;

-- Create views
CREATE OR REPLACE VIEW vw_flight_details AS
SELECT
    f.flight_id,
    f.airline,
    f.departure_airport,
    f.destination_airport,
    f.departure_time,
    f.arrival_time,
    f.seat_availability,
    COUNT(b.booking_id) AS booked_seats
FROM
    flights f
LEFT JOIN
    bookings b ON f.flight_id = b.flight_id
GROUP BY
    f.flight_id;

CREATE OR REPLACE VIEW vw_passenger_bookings AS
SELECT
    p.passenger_id,
    p.name,
    COUNT(b.booking_id) AS total_bookings
FROM
    passengers p
LEFT JOIN
    bookings b ON p.passenger_id = b.passenger_id
GROUP BY
    p.passenger_id;

CREATE OR REPLACE VIEW vw_available_flights AS
SELECT
    f.flight_id,
    f.airline,
    f.departure_airport,
    f.destination_airport,
    f.departure_time,
    f.arrival_time
FROM
    flights f
WHERE
    f.seat_availability = 'yes';

CREATE OR REPLACE VIEW vw_full_flights AS
SELECT
    flight_id,
    airline,
    seat_availability
FROM
    flights
WHERE
    seat_availability = 'no';


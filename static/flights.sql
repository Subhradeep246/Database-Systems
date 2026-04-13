CREATE TABLE Airport (
    airport_code VARCHAR(3) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL
);

CREATE TABLE Aircraft (
    plane_type VARCHAR(30) PRIMARY KEY,
    capacity INT NOT NULL
);

CREATE TABLE FlightService (
    flight_number VARCHAR(10) PRIMARY KEY,
    airline_name VARCHAR(50) NOT NULL,
    origin_code VARCHAR(3) NOT NULL,
    dest_code VARCHAR(3) NOT NULL,
    departure_time TIME NOT NULL,
    duration INTERVAL NOT NULL,
    FOREIGN KEY (origin_code) REFERENCES Airport(airport_code),
    FOREIGN KEY (dest_code) REFERENCES Airport(airport_code)
);

CREATE TABLE Flight (
    flight_number VARCHAR(10) NOT NULL,
    departure_date DATE NOT NULL,
    plane_type VARCHAR(30) NOT NULL,
    PRIMARY KEY (flight_number, departure_date),
    FOREIGN KEY (flight_number) REFERENCES FlightService(flight_number),
    FOREIGN KEY (plane_type) REFERENCES Aircraft(plane_type)
);

CREATE TABLE Passenger (
    pid INT PRIMARY KEY,
    passenger_name VARCHAR(100) NOT NULL
);

CREATE TABLE Booking (
    pid INT NOT NULL,
    flight_number VARCHAR(10) NOT NULL,
    departure_date DATE NOT NULL,
    seat_number INT NOT NULL,
    PRIMARY KEY (pid, flight_number, departure_date),
    FOREIGN KEY (pid) REFERENCES Passenger(pid),
    FOREIGN KEY (flight_number, departure_date) REFERENCES Flight(flight_number, departure_date)
);


-- ==================
-- DATA
-- ==================

-- Airports: includes 2 in Chicago, 2 in Paris/France
INSERT INTO Airport VALUES
('JFK', 'John F Kennedy International', 'New York', 'United States'),
('LAX', 'Los Angeles International', 'Los Angeles', 'United States'),
('ORD', 'O''Hare International', 'Chicago', 'United States'),
('MDW', 'Midway International', 'Chicago', 'United States'),
('LHR', 'Heathrow Airport', 'London', 'United Kingdom'),
('CDG', 'Charles de Gaulle Airport', 'Paris', 'France'),
('ORY', 'Paris Orly Airport', 'Paris', 'France'),
('SFO', 'San Francisco International', 'San Francisco', 'United States'),
('MIA', 'Miami International', 'Miami', 'United States'),
('ATL', 'Hartsfield-Jackson International', 'Atlanta', 'United States'),
('NRT', 'Narita International', 'Tokyo', 'Japan'),
('SIN', 'Changi Airport', 'Singapore', 'Singapore');

-- Aircraft: small capacities for manageable data
INSERT INTO Aircraft VALUES
('CRJ-200', 10),
('Boeing 737', 20),
('Airbus A320', 15),
('Boeing 787', 25);

-- Flight Services (duration = scheduled flight time)
INSERT INTO FlightService VALUES
('AA101', 'American Airlines', 'JFK', 'LAX', '08:00:00', INTERVAL '3 hours 30 minutes'),
('AA205', 'American Airlines', 'JFK', 'LAX', '14:00:00', INTERVAL '3 hours 30 minutes'),
('UA302', 'United Airlines', 'SFO', 'ORD', '09:00:00', INTERVAL '6 hours'),
('DL410', 'Delta Air Lines', 'ATL', 'MIA', '10:00:00', INTERVAL '2 hours 30 minutes'),
('BA178', 'British Airways', 'LHR', 'JFK', '10:00:00', INTERVAL '3 hours'),
('AF023', 'Air France', 'CDG', 'NRT', '22:00:00', INTERVAL '19 hours'),
('SQ321', 'Singapore Airlines', 'SIN', 'LHR', '23:00:00', INTERVAL '7 hours'),
('AA550', 'American Airlines', 'ORD', 'MIA', '07:00:00', INTERVAL '4 hours'),
('DL620', 'Delta Air Lines', 'JFK', 'ATL', '16:00:00', INTERVAL '2 hours 30 minutes'),
('UA789', 'United Airlines', 'LAX', 'SFO', '12:00:00', INTERVAL '1 hour 30 minutes');

-- Flights
INSERT INTO Flight VALUES
('AA101', '2025-12-29', 'Boeing 737'),
('AA101', '2025-12-31', 'Boeing 737'),
('AA205', '2025-12-31', 'Boeing 737'),
('UA302', '2025-12-31', 'CRJ-200'),
('DL410', '2025-12-31', 'Airbus A320'),
('BA178', '2025-12-31', 'Boeing 787'),
('AF023', '2025-12-30', 'Boeing 787'),
('SQ321', '2025-12-30', 'Boeing 787'),
('DL620', '2025-12-30', 'Airbus A320'),
('DL620', '2025-12-31', 'Airbus A320'),
('AA550', '2025-12-31', 'CRJ-200'),
('UA789', '2025-12-31', 'Airbus A320');

-- Passengers
INSERT INTO Passenger VALUES
(1, 'John Adams'),
(2, 'Sarah Miller'),
(3, 'Michael Chen'),
(4, 'Emily Wong'),
(5, 'David Park'),
(6, 'Lisa Johnson'),
(7, 'James Brown'),
(8, 'Maria Garcia'),
(9, 'Robert Kim'),
(10, 'Jennifer Lee'),
(11, 'Thomas Wilson'),
(12, 'Amanda Clark'),
(13, 'Christopher Davis'),
(14, 'Jessica Martinez'),
(15, 'Daniel Taylor'),
(16, 'Rachel Anderson'),
(17, 'William Thomas'),
(18, 'Nicole White'),
(19, 'Kevin Harris'),
(20, 'Stephanie Moore'),
(21, 'Andrew Jackson'),
(22, 'Michelle Robinson'),
(23, 'Brian Lewis'),
(24, 'Laura Walker'),
(25, 'Steven Hall');

-- Bookings
-- AA101, 2025-12-29 (Boeing 737, cap 20): 5 passengers
INSERT INTO Booking VALUES
(1, 'AA101', '2025-12-29', 1),
(2, 'AA101', '2025-12-29', 2),
(3, 'AA101', '2025-12-29', 3),
(4, 'AA101', '2025-12-29', 4),
(5, 'AA101', '2025-12-29', 5);

-- AA101, 2025-12-31 (Boeing 737, cap 20): 15 passengers
INSERT INTO Booking VALUES
(1, 'AA101', '2025-12-31', 1),
(2, 'AA101', '2025-12-31', 2),
(3, 'AA101', '2025-12-31', 3),
(4, 'AA101', '2025-12-31', 4),
(5, 'AA101', '2025-12-31', 5),
(6, 'AA101', '2025-12-31', 6),
(7, 'AA101', '2025-12-31', 7),
(8, 'AA101', '2025-12-31', 8),
(9, 'AA101', '2025-12-31', 9),
(10, 'AA101', '2025-12-31', 10),
(11, 'AA101', '2025-12-31', 11),
(12, 'AA101', '2025-12-31', 12),
(13, 'AA101', '2025-12-31', 13),
(14, 'AA101', '2025-12-31', 14),
(15, 'AA101', '2025-12-31', 15);

-- AA205, 2025-12-31 (Boeing 737, cap 20): 4 passengers
INSERT INTO Booking VALUES
(16, 'AA205', '2025-12-31', 1),
(17, 'AA205', '2025-12-31', 2),
(18, 'AA205', '2025-12-31', 3),
(19, 'AA205', '2025-12-31', 4);

-- UA302, 2025-12-31 (CRJ-200, cap 10): 10 passengers
INSERT INTO Booking VALUES
(1, 'UA302', '2025-12-31', 1),
(2, 'UA302', '2025-12-31', 2),
(3, 'UA302', '2025-12-31', 3),
(4, 'UA302', '2025-12-31', 4),
(5, 'UA302', '2025-12-31', 5),
(6, 'UA302', '2025-12-31', 6),
(7, 'UA302', '2025-12-31', 7),
(8, 'UA302', '2025-12-31', 8),
(9, 'UA302', '2025-12-31', 9),
(10, 'UA302', '2025-12-31', 10);

-- DL410, 2025-12-31 (Airbus A320, cap 15): 14 passengers
INSERT INTO Booking VALUES
(5, 'DL410', '2025-12-31', 1),
(6, 'DL410', '2025-12-31', 2),
(7, 'DL410', '2025-12-31', 3),
(8, 'DL410', '2025-12-31', 4),
(9, 'DL410', '2025-12-31', 5),
(10, 'DL410', '2025-12-31', 6),
(11, 'DL410', '2025-12-31', 7),
(12, 'DL410', '2025-12-31', 8),
(13, 'DL410', '2025-12-31', 9),
(14, 'DL410', '2025-12-31', 10),
(15, 'DL410', '2025-12-31', 11),
(16, 'DL410', '2025-12-31', 12),
(17, 'DL410', '2025-12-31', 13),
(18, 'DL410', '2025-12-31', 14);

-- BA178, 2025-12-31 (Boeing 787, cap 25): 6 passengers
INSERT INTO Booking VALUES
(20, 'BA178', '2025-12-31', 1),
(21, 'BA178', '2025-12-31', 2),
(22, 'BA178', '2025-12-31', 3),
(23, 'BA178', '2025-12-31', 4),
(24, 'BA178', '2025-12-31', 5),
(25, 'BA178', '2025-12-31', 6);

-- AF023, 2025-12-30 (Boeing 787, cap 25): 4 passengers
INSERT INTO Booking VALUES
(1, 'AF023', '2025-12-30', 1),
(2, 'AF023', '2025-12-30', 2),
(3, 'AF023', '2025-12-30', 3),
(4, 'AF023', '2025-12-30', 4);

-- SQ321, 2025-12-30 (Boeing 787, cap 25): 3 passengers
INSERT INTO Booking VALUES
(5, 'SQ321', '2025-12-30', 1),
(6, 'SQ321', '2025-12-30', 2),
(7, 'SQ321', '2025-12-30', 3);

-- DL620, 2025-12-30 (Airbus A320, cap 15): 4 passengers
INSERT INTO Booking VALUES
(10, 'DL620', '2025-12-30', 1),
(11, 'DL620', '2025-12-30', 2),
(12, 'DL620', '2025-12-30', 3),
(13, 'DL620', '2025-12-30', 4);

-- DL620, 2025-12-31 (Airbus A320, cap 15): 5 passengers
INSERT INTO Booking VALUES
(20, 'DL620', '2025-12-31', 1),
(21, 'DL620', '2025-12-31', 2),
(22, 'DL620', '2025-12-31', 3),
(23, 'DL620', '2025-12-31', 4),
(24, 'DL620', '2025-12-31', 5);

-- AA550, 2025-12-31 (CRJ-200, cap 10): 7 passengers
INSERT INTO Booking VALUES
(8, 'AA550', '2025-12-31', 1),
(9, 'AA550', '2025-12-31', 2),
(10, 'AA550', '2025-12-31', 3),
(11, 'AA550', '2025-12-31', 4),
(12, 'AA550', '2025-12-31', 5),
(13, 'AA550', '2025-12-31', 6),
(14, 'AA550', '2025-12-31', 7);

-- UA789, 2025-12-31 (Airbus A320, cap 15): 3 passengers
INSERT INTO Booking VALUES
(22, 'UA789', '2025-12-31', 1),
(23, 'UA789', '2025-12-31', 2),
(24, 'UA789', '2025-12-31', 3);

-- ==================
-- PART (A): FOREIGN KEYS (ADDED ABOVE)
-- ==================
-- Foreign Keys identified:
-- FlightService.origin_code -> Airport.airport_code
-- FlightService.dest_code -> Airport.airport_code
-- Flight.flight_number -> FlightService.flight_number
-- Flight.plane_type -> Aircraft.plane_type
-- Booking.pid -> Passenger.pid
-- Booking.(flight_number, departure_date) -> Flight.(flight_number, departure_date)

-- ==================
-- PART (B): ER DIAGRAM DESCRIPTION
-- ==================
-- Entities:
--   - Airport (airport_code: PK, name, city, country)
--   - Aircraft (plane_type: PK, capacity)
--   - FlightService (flight_number: PK, airline_name, origin_code, dest_code, departure_time, duration)
--   - Flight (flight_number: PK, departure_date: PK, plane_type) [WEAK ENTITY]
--   - Passenger (pid: PK, passenger_name)
--   - Booking (pid: PK, flight_number: PK, departure_date: PK, seat_number) [WEAK ENTITY]
--
-- Relationships:
--   - FlightService ---> Airport (Many FlightService to 1 Airport on origin/destination)
--   - Flight ---> FlightService (Many Flight to 1 FlightService, Total participation by Flight)
--   - Flight ---> Aircraft (Many Flight to 1 Aircraft)
--   - Booking ---> Flight (Many Booking to 1 Flight, Total participation by Booking)
--   - Booking ---> Passenger (Many Booking to 1 Passenger, Total participation by Booking)
--
-- Cardinalities: FlightService:Airport (N:1), Flight:FlightService (N:1), Flight:Aircraft (N:1), 
--                Booking:Flight (N:1), Booking:Passenger (N:1)
-- Weak Entities: Flight (depends on FlightService), Booking (depends on Flight and Passenger)

-- ==================
-- PART (C): VIEW FOR FLIGHT OCCUPANCY
-- ==================

CREATE VIEW FlightOccupancy AS
SELECT
    f.flight_number,
    f.departure_date,
    (f.departure_date + fs.departure_time) AS arrival_date,
    fs.origin_code,
    fs.dest_code,
    a.capacity,
    COUNT(b.pid) AS total_passengers
FROM Flight f
JOIN FlightService fs ON f.flight_number = fs.flight_number
JOIN Aircraft a ON f.plane_type = a.plane_type
LEFT JOIN Booking b ON f.flight_number = b.flight_number AND f.departure_date = b.departure_date
GROUP BY f.flight_number, f.departure_date, fs.departure_time, fs.duration, fs.origin_code, fs.dest_code, a.capacity;

-- PART (C.1): Flight with highest number of passenger bookings
\echo '--- PART (C.1): Flight with highest number of passenger bookings ---'
SELECT flight_number, departure_date, total_passengers
FROM FlightOccupancy
ORDER BY total_passengers DESC
LIMIT 1;

-- PART (C.2): For each airport, total passengers scheduled to arrive on 2025-12-31
\echo '--- PART (C.2): Total passengers arriving at each airport on 2025-12-31 ---'
SELECT dest_code as airport_code, SUM(total_passengers) AS total_arriving_passengers
FROM FlightOccupancy
WHERE departure_date = '2025-12-31'
GROUP BY dest_code
ORDER BY dest_code;

-- PART (C.3): All flights that are more than 90% full
\echo '--- PART (C.3): Flights more than 90% full ---'
SELECT flight_number, departure_date, capacity, total_passengers, capacity
FROM FlightOccupancy
WHERE total_passengers > 0.9 * capacity
ORDER BY flight_number DESC;

-- ==================
-- PART (D): LIMITED VIEW ON AIRPORT (WITHOUT COUNTRY)
-- ==================

CREATE VIEW AirportLimited AS
SELECT airport_code, name, city
FROM Airport;

-- PART (D.1): TRY TO INSERT record without country attribute
\echo '--- PART (D.1): Attempting to INSERT via limited view ---'
-- This will FAIL because the view does not include the country column,
-- and Airport.country has NOT NULL constraint.
-- Explanation: We cannot insert NULL into a NOT NULL column via the view.
-- The following command would fail:
-- INSERT INTO AirportLimited (airport_code, name, city) VALUES ('DXB', 'Dubai International', 'Dubai');
-- Instead, we insert into the base table with all required columns:
\echo '--- PART (D.1): Inserting into base table with all required attributes ---'
INSERT INTO Airport (airport_code, name, city, country) 
VALUES ('DXB', 'Dubai International', 'Dubai', 'United Arab Emirates')
ON CONFLICT DO NOTHING;

-- PART (D.2): DELETE airports in Chicago via limited view
\echo '--- PART (D.2): Deleting airports in Chicago via limited view ---'
-- This will FAIL due to foreign key constraints (flights reference these airports).
-- The view allows the deletion syntax, but the database prevents it because
-- FlightService records reference the Chicago airports (ORD has flights).
-- Explanation: Cannot delete airports with active flight services without
-- first removing the dependent records.
\echo '--- PART (D.2): Attempting delete (would fail due to FK constraints) ---'
-- DELETE FROM AirportLimited WHERE city = 'Chicago';
\echo '--- Airports in Chicago (not deleted due to FK constraints) ---'
SELECT * FROM AirportLimited WHERE city = 'Chicago';

-- PART (D.3): DELETE airports in France via limited view
\echo '--- PART (D.3): Attempting to DELETE airports in France via limited view ---'
-- This will FAIL for two reasons:
-- 1. The limited view does not include the country column, so WHERE country = 'France' cannot be used
-- 2. Even if we delete from the base table, FK constraints prevent deletion
-- (Air France CDG-NRT flight references CDG airport)
\echo '--- PART (D.3): Attempting delete via base table (would fail due to FK constraints) ---'
-- DELETE FROM Airport WHERE country = 'France';
\echo '--- Airports in France (not deleted due to FK constraints) ---'
SELECT * FROM AirportLimited WHERE city = 'Paris';

-- PART (D.4): For each city, count distinct airports
\echo '--- PART (D.4): Number of distinct airports per city ---'
SELECT city, COUNT(DISTINCT airport_code) AS num_airports
FROM AirportPublic
GROUP BY city
ORDER BY city;



-- Homework 3
-- 4.a: Write a query listing all the tables that have at least two outgoing foreign keys referencing distinct tables.
\echo '--- Homework 3, 4.a: Tables with at least two outgoing foreign keys referencing distinct tables ---'
SELECT tc.table_name
FROM information_schema.table_constraints tc
JOIN information_schema.referential_constraints rc
    ON tc.constraint_name = rc.constraint_name
    AND tc.constraint_schema = rc.constraint_schema
JOIN information_schema.constraint_column_usage ccu
    ON rc.unique_constraint_name = ccu.constraint_name
    AND rc.unique_constraint_schema = ccu.constraint_schema
WHERE tc.constraint_type = 'FOREIGN KEY'
    AND tc.table_schema = 'public'
GROUP BY tc.table_name
HAVING COUNT (DISTINCT ccu. table_name) ›= 2
ORDER BY tc. table_name;



-- 4.b: Write a query to list all columns in the database that are configured to store timestamp/date type columns.
\echo '--- Homework 3, 4.b: Columns configured to store timestamp/date types ---'
SELECT table_name, column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public'
    AND data_type IN ('time with time zone', 'time without time zone', 'timestamp without time zone', 'timestamp with time zone', 'date')
ORDER BY table_name, column_name;

-- 4.c: For each attribute in the Flight table, output how many distinct values each attribute has in the current database.
\echo '--- Homework 3, 4.c: Distinct values for each attribute in the Flight table ---'
SELECT
    'flight_number' AS attribute,
    COUNT(DISTINCT flight_number) AS distinct_count
FROM Flight
UNION ALL
SELECT
    'departure_date' AS attribute,
    COUNT(DISTINCT departure_date) AS distinct_count
FROM Flight
UNION ALL
SELECT
    'plane_type' AS attribute,
    COUNT(DISTINCT plane_type) AS distinct_count
FROM Flight
ORDER BY attribute;

-- 4.d: Find all the tables where the primary key is composite
\echo '--- Homework 3, 4.d: Tables with composite primary keys ---'
SELECT tc.table_name, COUNT(kcu.column_name) AS pk_column_count
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
WHERE tc.constraint_type = 'PRIMARY KEY'
    AND tc.table_schema = 'public'
GROUP BY tc.table_name
HAVING COUNT(kcu.column_name) > 1
ORDER BY tc.table_name;

-- 4.e: Find all attributes containing the substring "name".
\echo '--- Homework 3, 4.e: Attributes containing the substring "name" ---'
SELECT table_name, column_name
FROM information_schema.columns
WHERE table_schema = 'public'
    AND column_name ILIKE '%name%'
ORDER BY table_name, column_name;
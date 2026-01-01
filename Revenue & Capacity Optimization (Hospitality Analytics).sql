CREATE DATABASE hospitality;
USE hospitality;

CREATE TABLE dim_hotels (
  property_id INT PRIMARY KEY,
  hotel_name VARCHAR(50),
  city VARCHAR(30)
);

CREATE TABLE dim_rooms (
  room_id VARCHAR(5),
  room_class VARCHAR(30)
);

CREATE TABLE fact_aggregated_bookings (
  property_id INT,
  check_in_date DATE,
  room_category VARCHAR(5),
  successful_bookings INT,
  capacity INT
);

CREATE TABLE fact_bookings (
  booking_id VARCHAR(10),
  property_id INT,
  check_in_date DATE,
  room_category VARCHAR(5),
  booking_status VARCHAR(20),
  revenue INT
);

-- Occupancy %
SELECT
  property_id,
  ROUND(SUM(successful_bookings)*100.0 / SUM(capacity),2) AS occupancy_percent
FROM fact_aggregated_bookings
GROUP BY property_id;

-- ADR
SELECT
  property_id,
  ROUND(AVG(revenue),2) AS ADR
FROM fact_bookings
WHERE booking_status='Checked Out'
GROUP BY property_id;

-- RevPAR
SELECT
  f.property_id,
  ROUND(SUM(f.revenue)/SUM(a.capacity),2) AS RevPAR
FROM fact_bookings f
JOIN fact_aggregated_bookings a
ON f.property_id=a.property_id
GROUP BY f.property_id;

-- Cancellation Rate
SELECT
  property_id,
  COUNT(CASE WHEN booking_status='Cancelled' THEN 1 END)*100.0/COUNT(*) AS cancellation_rate
FROM fact_bookings
GROUP BY property_id;

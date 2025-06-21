
-- 1. Create the Uber Requests Table
CREATE TABLE uber_requests (
    request_id INT PRIMARY KEY,
    pickup_point VARCHAR(20),
    driver_id INT,
    status VARCHAR(30),
    request_timestamp DATETIME,
    drop_timestamp DATETIME
);

-- 2. Total Number of Requests
SELECT COUNT(*) AS total_requests FROM uber_requests;

-- 3. Count by Status
SELECT status, COUNT(*) AS request_count
FROM uber_requests
GROUP BY status
ORDER BY request_count DESC;

-- 4. Count by Pickup Point
SELECT pickup_point, COUNT(*) AS count
FROM uber_requests
GROUP BY pickup_point;

-- 5. Requests by Hour of Day
SELECT HOUR(request_timestamp) AS hour, COUNT(*) AS total_requests
FROM uber_requests
GROUP BY hour
ORDER BY hour;

-- 6. Hourly Status Breakdown
SELECT HOUR(request_timestamp) AS hour,
       SUM(CASE WHEN status = 'Trip Completed' THEN 1 ELSE 0 END) AS completed,
       SUM(CASE WHEN status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled,
       SUM(CASE WHEN status = 'No Cars Available' THEN 1 ELSE 0 END) AS no_cars,
       COUNT(*) AS total_requests
FROM uber_requests
GROUP BY hour
ORDER BY hour;

-- 7. Demand-Supply Gap by Hour
SELECT HOUR(request_timestamp) AS hour,
       COUNT(*) AS total_requests,
       SUM(CASE WHEN status = 'Trip Completed' THEN 1 ELSE 0 END) AS fulfilled,
       COUNT(*) - SUM(CASE WHEN status = 'Trip Completed' THEN 1 ELSE 0 END) AS demand_gap
FROM uber_requests
GROUP BY hour
ORDER BY demand_gap DESC;

-- 8. Pickup Point vs Status
SELECT pickup_point, status, COUNT(*) AS count
FROM uber_requests
GROUP BY pickup_point, status
ORDER BY pickup_point, status;

-- 9. Top 5 Hours with Most Requests
SELECT HOUR(request_timestamp) AS hour, COUNT(*) AS total_requests
FROM uber_requests
GROUP BY hour
ORDER BY total_requests DESC
LIMIT 5;

-- 10. Cancelled and No Cars by Hour
SELECT HOUR(request_timestamp) AS hour, status, COUNT(*) AS count
FROM uber_requests
WHERE status IN ('Cancelled', 'No Cars Available')
GROUP BY hour, status
ORDER BY hour;

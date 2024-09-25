DROP TABLE IF EXISTS booking;

CREATE TABLE booking (
    booking_date date,
    hotel text,
    is_canceled int,
    adults int,
    children int,
    meal text,
    country text,
    market_segment text,
    deposit_type text,
    agent int,
    price numeric,
    car_parking int,
    reservation_status text,
    register_name text,
    email text,
    weekend_nights int
);

SELECT count(*) AS TOTAL_BOOKINGS FROM booking;


-- 1.What is the overall cancellation rate for hotel bookings?
WITH TOTAL_BOOKINGS AS (
    SELECT
        COUNT(*) AS TOTAL_BOOKING
    FROM 
        BOOKING
),
CANCELLED_BOOKINGS AS (
    SELECT
        COUNT(*) AS TOTAL_CANCELLATION
    FROM
        BOOKING
    WHERE
        IS_CANCELED =1
)
SELECT 
    ROUND(CAST(CANCELLED_BOOKINGS.TOTAL_CANCELLATION AS NUMERIC) * 100 / CAST(TOTAL_BOOKINGS.TOTAL_BOOKING AS NUMERIC), 2) AS CANCELLATION_RATE
FROM 
    TOTAL_BOOKINGS, CANCELLED_BOOKINGS;


-- 2.What is the average number of adults and children by hotel?

SELECT HOTEL,
    ROUND(AVG(ADULTS),2) AS AVERAGE_ADULTS,
    ROUND(AVG(CHILDREN),2) AS AVG_CHILDEREN
FROM 
    BOOKING
GROUP BY
	HOTEL;
	
-- 3.Which hotel contributes the most revenue to the hotel?

SELECT 
	HOTEL,SUM(PRICE) AS TOTAL_REVENUE 
FROM 
	BOOKING
GROUP BY 1 
ORDER BY 
	2 DESC 
LIMIT 1

-- 4.Which countries are the top contributors to hotel bookings?

SELECT 
	COUNTRY ,SUM(PRICE) AS TOTAL_CONTRIBUTIONS 
FROM 
	BOOKING
GROUP BY 
	COUNTRY
ORDER BY 
	2 DESC 
LIMIT 5

-- 5.Which meal plan is the most preferred among guests?

SELECT
	MEAL,COUNT(*) 
FROM 
	BOOKING
WHERE 
	MEAL<> 'Undefined'
GROUP BY 1
ORDER BY 2 DESC;


-- 6.Is there a relationship between deposit type and the likelihood of cancellation?

WITH CANCEL_BY_DEPOSIT AS (
	SELECT 
		DEPOSIT_TYPE,SUM(IS_CANCELED) AS CANCEL_BOOKINGS
	FROM 
		BOOKING
	WHERE
		IS_CANCELED = 1
	GROUP BY
		1
	),
TOTAL_CAL_BOOKINGS AS (
	SELECT
		COUNT(*) AS BY_DEPOSIT_CANCEL
	FROM
		BOOKING
	WHERE
		IS_CANCELED = 1
	)
SELECT 
	DEPOSIT_TYPE,((BY_DEPOSIT_CANCEL)*100/CANCEL_BOOKINGS) AS CANCELLED 
FROM 
	CANCEL_BY_DEPOSIT,TOTAL_CAL_BOOKINGS
ORDER BY 
	2 DESC;

-- 7.What is the most common market segment (e.g., Direct, Online TA)?
SELECT 
	MARKET_SEGMENT,COUNT(MARKET_SEGMENT) AS SEGMENT 
FROM 
	BOOKING
GROUP BY 1 
ORDER BY 2 DESC;

-- 8.How do prices vary across different hotels ? Are there any seasonal pricing trends?

SELECT 
	TO_CHAR(BOOKING_DATE, 'MON') AS MONTH, HOTEL, AVG(PRICE) AS AVERAGE_PRICE
FROM 
	BOOKING
GROUP BY 
	TO_CHAR(BOOKING_DATE, 'MON'), HOTEL,BOOKING_DATE
ORDER BY 
	CAST(TO_CHAR(BOOKING_DATE, 'MM') AS INTEGER);


-- 9.What are the main reservation statuses (e.g., confirmed, cancelled, checked-in), and how do they change over time?

SELECT 
	RESERVATION_STATUS,TO_CHAR(BOOKING_DATE,'YYYY') AS YEAR, CONCAT(ROUND((COUNT(RESERVATION_STATUS) * 100.0) / (SELECT COUNT(*) FROM BOOKING), 2), '%') AS RESERVATION_STATUS_COUNT
FROM 
	BOOKING
GROUP BY 
 	1,2
ORDER BY
	1,2;

-- 10.Which email domains are most commonly used for making hotel bookings?

SELECT	
	RIGHT(EMAIL,LENGTH(EMAIL)-REGEXP_INSTR(EMAIL,'@')) AS EMAIL_DOMAIN,COUNT(*)
FROM
	BOOKING
GROUP BY
	1;



# Hotel Booking Data Analysis using SQL

## Overview
This project analyzes hotel booking data to answer various business-related questions. SQL queries are used to extract insights regarding booking behavior, revenue generation, customer preferences, and pricing trends.

---

## Dataset
- **Table**: `booking`
- **Columns**:
  - `booking_date`: Date of booking
  - `hotel`: Hotel name
  - `is_canceled`: Indicator if the booking was canceled
  - `adults`: Number of adults in the booking
  - `children`: Number of children in the booking
  - `meal`: Meal plan opted for
  - `country`: Country of the customer
  - `market_segment`: Segment from which the booking originated
  - `deposit_type`: Type of deposit (e.g., No Deposit, Refundable)
  - `agent`: Agent responsible for the booking
  - `price`: Price paid for the booking
  - `car_parking`: Car parking required
  - `reservation_status`: Status of the reservation (e.g., Checked-Out, Canceled)
  - `register_name`: Customer name
  - `email`: Customer email address
  - `weekend_nights`: Number of weekend nights booked

---

## Business Problems and Solutions

### 1. Count the total number of bookings
```sql
SELECT count(*) AS TOTAL_BOOKINGS FROM booking;
```

---

### 2. What is the overall cancellation rate for hotel bookings?
```sql
WITH TOTAL_BOOKINGS AS (
    SELECT COUNT(*) AS TOTAL_BOOKING FROM BOOKING
),
CANCELLED_BOOKINGS AS (
    SELECT COUNT(*) AS TOTAL_CANCELLATION FROM BOOKING WHERE IS_CANCELED = 1
)
SELECT 
    ROUND(CAST(CANCELLED_BOOKINGS.TOTAL_CANCELLATION AS NUMERIC) * 100 / CAST(TOTAL_BOOKINGS.TOTAL_BOOKING AS NUMERIC), 2) AS CANCELLATION_RATE
FROM TOTAL_BOOKINGS, CANCELLED_BOOKINGS;
```

---

### 3. What is the average number of adults and children by hotel?
```sql
SELECT HOTEL,
    ROUND(AVG(ADULTS), 2) AS AVERAGE_ADULTS,
    ROUND(AVG(CHILDREN), 2) AS AVERAGE_CHILDREN
FROM BOOKING
GROUP BY HOTEL;
```

---

### 4. Which hotel contributes the most revenue?
```sql
SELECT HOTEL, SUM(PRICE) AS TOTAL_REVENUE 
FROM BOOKING
GROUP BY HOTEL
ORDER BY TOTAL_REVENUE DESC 
LIMIT 1;
```

---

### 5. Which countries are the top contributors to hotel bookings?
```sql
SELECT COUNTRY, SUM(PRICE) AS TOTAL_CONTRIBUTIONS 
FROM BOOKING
GROUP BY COUNTRY
ORDER BY TOTAL_CONTRIBUTIONS DESC 
LIMIT 5;
```

---

### 6. Which meal plan is the most preferred among guests?
```sql
SELECT MEAL, COUNT(*) AS MEAL_COUNT
FROM BOOKING
WHERE MEAL <> 'Undefined'
GROUP BY MEAL
ORDER BY MEAL_COUNT DESC;
```

---

### 7. Is there a relationship between deposit type and the likelihood of cancellation?
```sql
WITH CANCEL_BY_DEPOSIT AS (
    SELECT DEPOSIT_TYPE, SUM(IS_CANCELED) AS CANCEL_BOOKINGS
    FROM BOOKING
    WHERE IS_CANCELED = 1
    GROUP BY DEPOSIT_TYPE
),
TOTAL_CANCEL_BOOKINGS AS (
    SELECT COUNT(*) AS BY_DEPOSIT_CANCEL
    FROM BOOKING
    WHERE IS_CANCELED = 1
)
SELECT DEPOSIT_TYPE, ((BY_DEPOSIT_CANCEL)*100/CANCEL_BOOKINGS) AS CANCELLED
FROM CANCEL_BY_DEPOSIT, TOTAL_CANCEL_BOOKINGS
ORDER BY CANCELLED DESC;
```

---

### 8. What is the most common market segment?
```sql
SELECT MARKET_SEGMENT, COUNT(*) AS SEGMENT_COUNT
FROM BOOKING
GROUP BY MARKET_SEGMENT
ORDER BY SEGMENT_COUNT DESC;
```

---

### 9. How do prices vary across different hotels? Are there any seasonal pricing trends?
```sql
SELECT TO_CHAR(BOOKING_DATE, 'MON') AS MONTH, HOTEL, AVG(PRICE) AS AVERAGE_PRICE
FROM BOOKING
GROUP BY TO_CHAR(BOOKING_DATE, 'MON'), HOTEL, BOOKING_DATE
ORDER BY CAST(TO_CHAR(BOOKING_DATE, 'MM') AS INTEGER);
```

---

### 10. What are the main reservation statuses and how do they change over time?
```sql
SELECT RESERVATION_STATUS, TO_CHAR(BOOKING_DATE, 'YYYY') AS YEAR, 
       CONCAT(ROUND((COUNT(RESERVATION_STATUS) * 100.0) / (SELECT COUNT(*) FROM BOOKING), 2), '%') AS RESERVATION_STATUS_COUNT
FROM BOOKING
GROUP BY RESERVATION_STATUS, YEAR
ORDER BY YEAR DESC;
```

---

### 11. Which email domains are most commonly used for hotel bookings?
```sql
SELECT RIGHT(EMAIL, LENGTH(EMAIL) - REGEXP_INSTR(EMAIL, '@')) AS EMAIL_DOMAIN, COUNT(*) AS DOMAIN_COUNT
FROM BOOKING
GROUP BY EMAIL_DOMAIN
ORDER BY DOMAIN_COUNT DESC;
```

---

## Conclusion
This SQL-based analysis offers valuable insights into hotel booking trends, customer behavior, and revenue generation, helping hotel management optimize marketing efforts, pricing strategies, and customer service.
 

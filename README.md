
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
![image](https://github.com/user-attachments/assets/8edb0330-c3b5-4c83-af48-751f0c9d2f5a)

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
![image](https://github.com/user-attachments/assets/edf8aef5-7c8c-4f4f-8760-0f26f6b9e5e7)

---

### 3. What is the average number of adults and children by hotel?
```sql
SELECT HOTEL,
    ROUND(AVG(ADULTS), 2) AS AVERAGE_ADULTS,
    ROUND(AVG(CHILDREN), 2) AS AVERAGE_CHILDREN
FROM BOOKING
GROUP BY HOTEL;
```
![image](https://github.com/user-attachments/assets/fa4de1de-fa62-49c7-af2b-6ae2a214cb90)

---

### 4. Which hotel contributes the most revenue?
```sql
SELECT HOTEL, SUM(PRICE) AS TOTAL_REVENUE 
FROM BOOKING
GROUP BY HOTEL
ORDER BY TOTAL_REVENUE DESC 
LIMIT 1;
```
![image](https://github.com/user-attachments/assets/d34c6479-05e5-456d-8778-976aa6756f02)

---

### 5. Which countries are the top contributors to hotel bookings?
```sql
SELECT COUNTRY, SUM(PRICE) AS TOTAL_CONTRIBUTIONS 
FROM BOOKING
GROUP BY COUNTRY
ORDER BY TOTAL_CONTRIBUTIONS DESC 
LIMIT 5;
```
![image](https://github.com/user-attachments/assets/e6b23a40-9186-4fb4-b84b-124987d00120)

---

### 6. Which meal plan is the most preferred among guests?
```sql
SELECT MEAL, COUNT(*) AS MEAL_COUNT
FROM BOOKING
WHERE MEAL <> 'Undefined'
GROUP BY MEAL
ORDER BY MEAL_COUNT DESC;
```
![image](https://github.com/user-attachments/assets/a86013e3-3dca-4fbb-a021-0965c6763a6e)

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
![image](https://github.com/user-attachments/assets/e0cf9872-227e-43c7-b091-e73db9c9ba90)

---

### 8. What is the most common market segment?
```sql
SELECT MARKET_SEGMENT, COUNT(*) AS SEGMENT_COUNT
FROM BOOKING
GROUP BY MARKET_SEGMENT
ORDER BY SEGMENT_COUNT DESC;
```
![image](https://github.com/user-attachments/assets/12887e0c-5b29-43dd-87e3-83557dc3c5ac)

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
![image](https://github.com/user-attachments/assets/6f7e5639-f9e2-4d1d-be19-6a70dd183ec3)

---

### 11. Which email domains are most commonly used for hotel bookings?
```sql
SELECT RIGHT(EMAIL, LENGTH(EMAIL) - REGEXP_INSTR(EMAIL, '@')) AS EMAIL_DOMAIN, COUNT(*) AS DOMAIN_COUNT
FROM BOOKING
GROUP BY EMAIL_DOMAIN
ORDER BY DOMAIN_COUNT DESC;
```
![image](https://github.com/user-attachments/assets/bb800512-c0d6-4080-a921-8403301b68f4)

---

## Conclusion
This SQL-based analysis offers valuable insights into hotel booking trends, customer behavior, and revenue generation, helping hotel management optimize marketing efforts, pricing strategies, and customer service.
 

# SQL_Amazon_Sales_Analysis_Project
## Project Overview
**Project Title:** Amazon sales analysis  

**Database:** `Amazon`

**Description:** This project demonstrates essential SQL skills commonly required for data analysts. It involves setting up a transactional sales database, performing data cleaning, and conducting exploratory analysis to uncover  

**Business insights:** Successfully applied SQL to clean, analyze, and extract meaningful business insights from Amazon retail sales data. Demonstrated ability to handle real-world data challenges like missing values and data type issues, and used SQL queries to identify sales trends, customer behavior, and revenue performance across multiple dimensions. This project strengthened my practical skills in SQL and data-driven decision making   

## Objectives   
**Database Setup:** Create and populate a retail sales database using structured sales data  
**Data Cleaning:**  Identify and fix incorrect or missing entries by applying SQL data quality techniques   
**Exploratory Analysis:** Use SQL to explore trends in products, customer behavior, revenue, and time-based patterns   
**Business Insights:** Answer key business questions using SQL that help improve sales performance and decision-making

## Project Structure  
1. **Database Creation:**  
    A database named Project is created to store sales transaction data.
2. **Table Creation:**  
  `Branch (char)`,`City` (varchar)    
  `Customer_type`, `Gender`, `Product_line`, `Payment` (varchar)   
  `Unit_price`, `Tax_5%`, `Total`, `cogs`, `gross_income` (decimal)  
  `Quantity` (tinyint)  
  `Sales_date` (date), `Sales_time` (time)  
  `Gross_margin_percentage`, `Rating` (decimal)  
  `Timeofday`, `dayname`, `monthname` (varchar)

4. **Data Cleaning:**  
  - Checked for NULL values using:   
  - Used ALTER TABLE to modify column data types (e.g., increasing decimal precision).   
  - Renamed column headers for readability and consistency.                                                                                 
```SQL
SELECT COUNT(*) AS null_rows
FROM Amazon
WHERE Branch IS NULL OR city IS NULL OR Customer_type IS NULL OR Gender IS NULL
OR Product_line IS NULL OR Unit_price IS NULL OR quantity IS NULL OR Tax IS NULL
OR Total IS NULL OR sales_date IS NULL OR sales_time IS NULL OR payment IS NULL
OR cogs IS NULL OR gross_margin_percentage IS NULL OR gross_income IS NULL
OR Rating IS NULL OR Timeofday IS NULL OR dayname IS NULL OR monthname IS NULL;
```
**Challenges and Solutions:**  
During table creation in my Amazon Sales Analysis project, I initially used out-of-range data types. After identifying the issue, I updated them to more appropriate data types which improved data integrity and prevented future errors.  
```SQL
alter table Amazon 
modify column `Branch` char(1) NOT NULL,
modify column `City` varchar(20) NOT NULL,
modify column `Unit price` decimal(10,2) NOT NULL,
modify column `Quantity`tinyint NOT NULL,
modify column `Tax 5%` decimal(10,2) NOT NULL,
modify column `Total` decimal(10,2) NOT NULL,
modify column `cogs` decimal(10,2) NOT NULL,
modify column `gross income` decimal(10,2) NOT NULL
modify column `product line` varchar(30)
modify column `Invoice id` varchar(20)
```
-Renamed columns to make them meaningful and consistent   
-This helped improve code readability and avoid confusion during joins and aggregations. 
```SQL
ALTER TABLE Amazon 
RENAME COLUMN `Branch` to Branch,
RENAME COLUMN `City` to city,
RENAME COLUMN `Customer type` to Customer_type,
RENAME COLUMN `Gender` to Gender,
RENAME COLUMN `Product line` to Product_line,
RENAME COLUMN `Unit price` to Unit_price,
RENAME COLUMN `Quantity` to quantity,
RENAME COLUMN `Tax 5%` to Tax,
RENAME COLUMN `Total` to Total,
RENAME COLUMN `Date` to sales_date,
RENAME COLUMN `Time` to sales_time,
RENAME COLUMN `Payment` to payment,
RENAME COLUMN `cogs` to cogs,
RENAME COLUMN `gross margin percentage` to gross_margin_percentage,
RENAME COLUMN `gross income` to gross_income,
RENAME COLUMN `Rating` to Rating
```
**Feature Engineering:**  
Added new columns `dayname` , `dayoftime`and `monthname` for time-based analysis.   
- day_name helps identify weekday trends (e.g., highest sales on weekends or weekdays).  
- day_of_time categorizes sales into time slots like Morning, Afternoon, and Evening to understand customer behavior based on time of purchase.    
- Added a` monthname` column by extracting the month name from the date to help analyze sales trends across different months.  
```SQL
 ALTER TABLE Amazon
 add column Timeofday VArCHAR(10)
UPDATE Amazon
SET Timeofday =
         CASE
         WHEN TIME(sales_time) BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
         WHEN TIME(sales_time) BETWEEN '12:00:00' AND "17:59:59" THEN 'Afternoon'
         else 'Evening'
END  
```  
```SQL
ALTER TABLE Amazon
ADD COLUMN dayname VArCHAR(10)

UPDATE Amazon
SET dayname = DATE_FORMAT(sales_date, '%a')
```
```SQL
ALTER TABLE Amazon 
ADD COLUMN monthname VARCHAR (20)

UPDATE Amazon
SET monthname = DATE_FORMAT(sales_date,'%b')
select monthname from Amazon
```
**Query Challenges:**  
 1.What is the count of distinct cities in the dataset  
 ```SQL
SELECT DISTINCT City 
FROM Amazon
```
2.For each branch, what is the corresponding city  
```SQL
SELECT DISTINCT Branch,city 
FROM Amazon
GROUP BY 1,2
```
3.What is the count of distinct product lines in the dataset  
```SQL
SELECT COUNT(DISTINCT Product_line) AS Distinct_productline
FROM Amazon
```
4.Which payment method occurs most frequently  
```SQL
select Payment,count(payment) as Most_frequent_paymentmethod
from  Amazon 
group by 1
order by 2 desc
limit 1
```
5. Which product line has the highest sales
   ```SQL
   SELECT Product_line,SUM(Total) as highest_sales 
FROM Amazon 
GROUP BY 1 
ORDER BY 2
```
6. How much revenue is generated each month
```SQL
SELECT Monthname,SUM(Total) as Total_revenue
FROM Amazon 
GROUP BY 1
```
7. In which month did the cost of goods sold reach its peak
 ```SQL
SELECT monthname,sum(cogs) as peak_month
FROM Amazon
group by 1
ORDER BY 2 DESC
```
8. Which product line generated the highest revenue
  ```SQL
SELECT Product_line,SUM(Total) AS highest_revenue
FROM Amazon
GROUP BY 1
ORDER BY 2 DESC
```
9.In which city was the highest revenue recorded
```SQL
SELECT City,SUM(Total) as highest_total
FROM Amazon
GROUP BY 1 
ORDER BY 2 DESC 
LIMIT 1
```
10.Which product line incurred the highest Value Added Tax
```SQL
SELECT Product_line,SUM(ROUND(Tax)) as highest_tax
FROM Amazon
GROUP BY 1
ORDER BY 2 DESC
```
11.For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad"
```SQL
WITH AVG_PRODUCT_LINE AS (
    SELECT Product_line,AVG(Total) AS avg_total
    FROM Amazon
    GROUP BY Product_line
)
SELECT a.Product_line,a.Total,
       CASE
           WHEN a.Total > b.avg_total THEN 'GOOD'
           WHEN a.Total < b.avg_total THEN 'BAD'
           ELSE 'AVERAGE'
       END AS Rating
FROM Amazon a
JOIN AVG_PRODUCT_LINE b
  ON a.Product_line = b.Product_line
```

- With different approache

```SQL
SELECT a.Product_line,a.Total,
				CASE 
				WHEN a.Total > b.avg_total THEN 'GOOD'
                WHEN a.Total < b.avg_total THEN 'BAD'
           ELSE 'AVERAGE'
       END AS Rating
FROM Amazon a 
join ( select Product_line,AVG(Total) as avg_total 
FROM Amazon 
GROUP BY Product_line) b
ON a.Product_line = b.Product_Line
```
12.Identify the branch that exceeded the average number of products sold
```WITH BRANCH_SOLD AS (
SELECT Branch,SUM(quantity) as TOTAL_QUANTITY
FROM Amazon  
GROUP BY 1 ),
OVERALL_avg AS (
				SELECT AVG(TOTAL_QUANTITY) AS AVG_QUANTITY
				FROM BRANCH_SOLD)
SELECT b.Branch,b.TOTAL_QUANTITY
FROM BRANCH_SOLD b
JOIN OVERALL_AVG a
ON b.TOTAL_QUANTITY > a.AVG_QUANTITY
```
13.Which product line is most frequently associated with each gender
```SQL
SELECT Product_line,gender,count(Total) as frequently_use  
FROM Amazon 
group by 1,2
order by frequently_use desc
```
14. Calculate the average rating for each product line.
```SQL
select product_line,avg(Rating) as avg_rating
from Amazon
group by 1 
order by 2 desc
```
15. Count the sales occurrences for each time of day on every weekday.
```SQL
SELECT DISTINCT dayname,Timeofday,
COUNT(*) OVER (PARTITION BY dayname,Timeofday) AS sales_count
FROM
Amazon
ORDER BY 1,2
```
16.Identify the customer type contributing the highest revenue
```SQL
SELECT Customer_type,sum(Total) as contribution_revenue
from Amazon
group by 1
order by 2 desc
```
17.Determine the city with the highest VAT percentage
```SQL
SELECT City,ROUND((Tax / (Total - Tax)) * 100, 2) AS vat_percentage
from Amazon
order by 2 desc
limit 1
```
18.Identify the customer type with the highest Tax payments
```SQL
SELECT Customer_type,SUM(Tax) AS total_vat
FROM Amazon
GROUP BY Customer_type
ORDER BY total_vat DESC
LIMIT 1;
```
19.Identify the customer type with the highest purchase frequency
```SQL
SELECT Customer_type,COUNT(*) AS purchase_count
FROM Amazon
GROUP BY Customer_type
ORDER BY purchase_count DESC
LIMIT 1
```
20.Determine the predominant gender among customers
```SQL
SELECT Gender,COUNT(*) AS customer_count
FROM Amazon
GROUP BY Gender
ORDER BY customer_count DESC
LIMIT 1;
```
21.Examine the distribution of genders within each branch
```SQL
SELECT Branch,Gender,COUNT(*) AS gender_count
FROM Amazon
GROUP BY Branch, Gender
ORDER BY Branch, Gender;
```
22.Identify the time of day when customers provide the most ratings
```SQL
SELECT Timeofday,COUNT(Rating) AS Most_ratings
FROM Amazon 
GROUP BY 1
ORDER BY 2 DESC
```
23. Determine the time of day with the highest customer ratings for each branch
```SQL
SELECT *
FROM (
  SELECT Branch,Timeofday,
    COUNT(Rating) AS MOST_RATINGS,
    RANK() OVER (PARTITION BY Branch ORDER BY COUNT(Rating) DESC) AS rk
    FROM Amazon
  GROUP BY Branch, Timeofday
) ranked
```
24.identify the day of the week with the highest average ratings
```SQL
WITH AVG_RATE AS (SELECT dayname, AVG(Rating) AS avg_rating
  FROM Amazon
  GROUP BY dayname
),
RANKED_DAYS AS (SELECT dayname,avg_rating,
    RANK() OVER (ORDER BY avg_rating DESC) AS rnk
  FROM AVG_RATE
)
SELECT dayname, avg_rating
FROM RANKED_DAYS
```
- With subquery
```SQL
SELECT dayname, avg_rating,
RANK() OVER (ORDER BY avg_rating DESC) AS rnk  
FROM (SELECT dayname, AVG(Rating) AS avg_rating
FROM Amazon
GROUP BY dayname
) t;
```
- With simple method
```SQL
SELECT dayname,avg(rating) as avg_rating 
from Amazon 
group by 1 
order by 2 desc
```



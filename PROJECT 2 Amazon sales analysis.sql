create database project 
use project
create table Amazon
  (`Invoice ID` INT PRIMARY KEY,    
    `Branch` VARCHAR(5),
	`City` VARCHAR(15),
    `Customer type` VARCHAR(15),
    `Gender` VARCHAR(10),
    `Product line` VARCHAR(20),
    `Unit price` DECIMAL(4,2),
    `Quantity` INT,
    `Tax 5%` DECIMAL(10,9),
    `Total` DECIMAL(10,9),
    `DATE` DATE,
    `Time` TIME,
    `Payment` VARCHAR(15),
    `cogs` DECIMAL(7,5),
    `gross margin percentage` DECIMAL(10,9),
    `gross income` DECIMAL(5,3),
    `Rating` DECIMAL(4,2))
select * from Amazon

alter table Amazon 
modify column `Invoice id` varchar(20)
   
alter table Amazon 
modify column `product line` varchar(30)

alter table Amazon 
modify column `Branch` char(1) NOT NULL,
modify column `City` varchar(20) NOT NULL,
modify column `Unit price` decimal(10,2) NOT NULL,
modify column `Quantity`tinyint NOT NULL,
modify column `Tax 5%` decimal(10,2) NOT NULL,
modify column `Total` decimal(10,2) NOT NULL,
modify column `cogs` decimal(10,2) NOT NULL,
modify column `gross income` decimal(10,2) NOT NULL

ALTER TABLE Amazon 
RENAME COLUMN `Invoice id` to Invoice_id,

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

-- add new column call timeofday

 ALTER TABLE Amazon
 add column Timeofday VArCHAR(10)
 
SET SQL_SAFE_UPDATES = 0

UPDATE Amazon
SET Timeofday =
         CASE
         WHEN TIME(sales_time) BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
         WHEN TIME(sales_time) BETWEEN '12:00:00' AND "17:59:59" THEN 'Afternoon'
         else 'Evening'
END

-- add new column dayname
 ALTER TABLE Amazon
 add column dayname VArCHAR(10)
 
 UPDATE Amazon
SET dayname = DATE_FORMAT(sales_date, '%a')

-- add new column month name 
ALTER TABLE Amazon 
ADD COLUMN monthname VARCHAR (20)

UPDATE Amazon
SET monthname = DATE_FORMAT(sales_date,'%b')
select monthname from Amazon

-- What is the count of distinct cities in the dataset

SELECT DISTINCT City 
FROM Amazon

-- For each branch, what is the corresponding city

SELECT DISTINCT Branch,city 
FROM Amazon

-- What is the count of distinct product lines in the dataset

SELECT COUNT(DISTINCT Product_line) 
FROM Amazon 

-- Which payment method occurs most frequently

select Payment,count(payment) as Most_frequent_paymentmethod
from  Amazon 
group by 1
order by 2 desc
limit 1

-- USSING DIFFRENT APPROACH

SELECT DISTINCT
    Payment,
    COUNT(Payment) OVER (PARTITION BY Payment) AS Most_frequent_paymentmethod
FROM Amazon
ORDER BY Most_frequent_paymentmethod desc

--  Which product line has the highest sales?

SELECT Product_line,SUM(Total) as highest_sales 
FROM Amazon 
GROUP BY 1 
ORDER BY 2

-- How much revenue is generated each month?

SELECT Monthname,SUM(Total) as Total_revenue
FROM Amazon 
GROUP BY 1

-- In which month did the cost of goods sold reach its peak?

SELECT monthname,sum(cogs) as peak_month
FROM Amazon
group by 1
ORDER BY 2 DESC

-- Which product line generated the highest revenue

SELECT Product_line,SUM(Total) AS highest_revenue
FROM Amazon
GROUP BY 1
ORDER BY 2 DESC

-- In which city was the highest revenue recorded

SELECT City,SUM(Total) as highest_total
FROM Amazon
GROUP BY 1 
ORDER BY 2 DESC 
LIMIT 1

-- Which product line incurred the highest Value Added Tax

SELECT Product_line,SUM(ROUND(Tax)) as highest_tax
FROM Amazon
GROUP BY 1
ORDER BY 2 DESC

-- For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad

WITH AVG_PRODUCT_LINE AS (
    SELECT Product_line,AVG(Total) AS avg_total
    FROM Amazon
    GROUP BY Product_line
)
SELECT a.Product_line,a.Total
       CASE
           WHEN a.Total > b.avg_total THEN 'GOOD'
           WHEN a.Total < b.avg_total THEN 'BAD'
           ELSE 'AVERAGE'
       END AS Rating
FROM Amazon a
JOIN AVG_PRODUCT_LINE b
  ON a.Product_line = b.
  
-- END PROJECT
  
-- with diffrent approach
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

-- Identify the branch that exceeded the average number of products sold.
WITH BRANCH_SOLD AS (
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



-- Which product line is most frequently associated with each gender
 
SELECT Product_line,gender,count(Total) as frequently_use  
FROM Amazon 
group by 1,2
order by frequently_use desc


-- Calculate the average rating for each product line.

select product_line,avg(Rating) as avg_rating
from Amazon
group by 1 
order by 2 desc

-- Count the sales occurrences for each time of day on every weekday.

SELECT DISTINCT dayname,Timeofday,
COUNT(*) OVER (PARTITION BY dayname,Timeofday) AS sales_count
FROM
Amazon
ORDER BY 1,2

-- Identify the customer type contributing the highest revenue.

SELECT Customer_type,sum(Total) as contribution_revenue
from Amazon
group by 1
order by 2 desc

-- Determine the city with the highest VAT percentage.

SELECT City,ROUND((Tax / (Total - Tax)) * 100, 2) AS vat_percentage
from Amazon
order by 2 desc
limit 1

-- Identify the customer type with the highest VAT payments.

SELECT Customer_type,SUM(Tax) AS total_vat
FROM 
 Amazon
GROUP BY 
  Customer_type
ORDER BY 
  total_vat DESC
LIMIT 1;

-- What is the count of distinct payment methods in the dataset?

SELECT DISTINCT payment from Amazon

-- Identify the customer type with the highest purchase frequency.

SELECT Customer_type,COUNT(*) AS purchase_count
FROM Amazon
GROUP BY 
  Customer_type
ORDER BY 
  purchase_count DESC
LIMIT 1
-- Determine the predominant gender among customers.

SELECT Gender,COUNT(*) AS customer_count
FROM Amazon
GROUP BY Gender
ORDER BY customer_count DESC
LIMIT 1;

-- Examine the distribution of genders within each branch.

SELECT Branch,Gender,COUNT(*) AS gender_count
FROM Amazon
GROUP BY 
  Branch, Gender
ORDER BY 
  Branch, Gender;
  
-- Identify the time of day when customers provide the most ratings

SELECT Timeofday,COUNT(Rating) AS Most_ratings
FROM Amazon 
GROUP BY 1
ORDER BY 2 DESC

-- Determine the time of day with the highest customer ratings for each branch.

SELECT *
FROM (
  SELECT Branch,Timeofday,
    COUNT(Rating) AS MOST_RATINGS,
    RANK() OVER (PARTITION BY Branch ORDER BY COUNT(Rating) DESC) AS rk
    FROM Amazon
  GROUP BY Branch, Timeofday
) ranked

-- identify the day of the week with the highest average ratings.

-- using CTE 
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

-- using simple method without windows functins

SELECT dayname,avg(rating) as avg_rating 
from Amazon 
group by 1 
order by 2 desc

-- using subqueries
SELECT dayname, avg_rating,
RANK() OVER (ORDER BY avg_rating DESC) AS rnk  
FROM (SELECT dayname, AVG(Rating) AS avg_rating
FROM Amazon
GROUP BY dayname
) t;



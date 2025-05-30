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
   Renamed column headers for readability and consistency.  
   Used ALTER TABLE to modify column data types (e.g., increasing decimal precision).   
   Checked for NULL values using:  
```SQL
SELECT COUNT(*) AS null_rows
FROM Amazon
WHERE Branch IS NULL OR city IS NULL OR Customer_type IS NULL OR Gender IS NULL
OR Product_line IS NULL OR Unit_price IS NULL OR quantity IS NULL OR Tax IS NULL
OR Total IS NULL OR sales_date IS NULL OR sales_time IS NULL OR payment IS NULL
OR cogs IS NULL OR gross_margin_percentage IS NULL OR gross_income IS NULL
OR Rating IS NULL OR Timeofday IS NULL OR dayname IS NULL OR monthname IS NULL;
```




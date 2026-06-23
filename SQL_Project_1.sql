--- SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_p2;

--- Create Table
DROP TABLE IF EXISTS retail_sales;
create table retail_sales(
			       transactions_id INT PRIMARY KEY,
				   sale_date DATE,
				   sale_time TIME,
				   customer_id INT,
				   gender VARCHAR(15),
				   age INT,
				   category VARCHAR(15),	
				   quantiy INT,
				   price_per_unit FLOAT,	
				   cogs	FLOAT,
				   total_sale FLOAT
);

SELECT * FROM RETAIL_SALES;

select 
     count(*) 
from retail_sales;

 ---- Data Cleaning

 SELECT * FROM RETAIL_SALES
 WHERE 
	 transactions_id IS NULL
	 OR
	 sale_date IS NULL
	 OR
	 sale_time IS NULL
	 OR
	 gender IS NULL
	 OR
	 category IS NULL
	 OR
	 quantiy IS NULL
	 OR
	 cogs IS NULL
	 OR
	 total_sale IS NULL;
 
 
----
DELETE FROM retail_sales
WHERE
     transactions_id IS NULL
	 OR
	 sale_date IS NULL
	 OR
	 sale_time IS NULL
	 OR
	 gender IS NULL
	 OR
	 category IS NULL
	 OR
	 quantiy IS NULL
	 OR
	 cogs IS NULL
	 OR
	 total_sale IS NULL;


---- Data Exploration

---- How Many Sales We Have?
SELECT COUNT(*) as total_sale
FROM retail_sales;

---- How Many Unique Customers We Have?
SELECT COUNT(DISTINCT customer_id) 
from retail_sales;

SELECT DISTINCT category FROM retail_sales;

---- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)



-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'

SELECT * 
FROM retail_sales 
WHERE sale_date = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT * 
FROM retail_sales
WHERE 
	category = 'Clothing'
	AND
	quantiy >=4 
	AND 
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
	category, 
	SUM(total_sale) as Net_Sales,
	COUNT(*) as TOTAL_ORDERS
	FROM retail_sales
	GROUP BY category
	ORDER BY Net_Sales desc;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT 
	category, 
	ROUND(AVG(age),2) as Avg_Age
	FROM retail_sales
	GROUP BY category
	ORDER BY category 
	LIMIT 1;

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT total_sale
	FROM retail_sales
	WHERE 
		total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
	category, 
	gender, 
	count(*) as Total_Transactions
FROM retail_sales
GROUP BY
	category, 
	gender
ORDER BY category;


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT 
	year,
	month,
	avg_sale
FROM
	(	SELECT
			EXTRACT(YEAR FROM sale_date) as year,
			EXTRACT(MONTH FROM sale_date) as month,
			AVG(total_sale) as Avg_sale,
			RANK()OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale)DESC) AS RANK
			FROM retail_sales
			GROUP BY 1,2) as t1
		where rank=1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales

SELECT
	customer_id, 
	sum(total_sale) as total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales desc
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
	category,
	COUNT(DISTINCT customer_id) as Unique_Customers
	FROM retail_sales
	GROUP BY 
		category;


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
CASE
	WHEN EXTRACT(HOUR FROM sale_time)< 12 THEN 'MORNING'
	WHEN EXTRACT(HOUR FROM sale_time) Between 12 AND 17 THEN 'AFTERNOON'
	ELSE 'EVENING'
	END as shift
	FROM retail_sales
) 

SELECT 
	shift,
	COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift

---- End of Project
	

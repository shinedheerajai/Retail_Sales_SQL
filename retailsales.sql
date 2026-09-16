use mydatabase1;
---- create table----

drop table if exists retail_sales;
create table retail_sales (

						transactions_id int primary key, 
						sale_date date,
						sale_time time,
						customer_id int,
						gender varchar(15),
						age int,
						category varchar(20),
						quantity int,
						price_per_unit float,
						cogs float,
						total_sale float
						);
                        
select * from retail_sales;


-- Data Cleaning
SELECT * FROM retail_sales
WHERE transactions_id IS NULL;

SELECT * FROM retail_sales
WHERE sale_date IS NULL;

SELECT * FROM retail_sales
WHERE sale_time IS NULL;


SELECT * FROM retail_sales
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
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
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
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
    
-- Data Exploration

-- How many sales we have?
SELECT sum(total_sale) as total_sales FROM retail_sales;

-- How many uniuque customers we have ?

SELECT COUNT(DISTINCT customer_id) as total_customers FROM retail_sales;



SELECT DISTINCT category FROM retail_sales;


-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

select * from retail_sales
where sale_date = "2022-11-05";

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than  in the month of Nov-2022

select * from retail_sales
where category = "Clothing" and
sale_date between "2022-11-01" and "2022-11-30" and
quantity < 4;


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category, sum(total_sale) as net_sales from retail_sales
group by 1;



-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select category, round(avg(age)) as avg_age from retail_sales
where category = "Beauty";


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales
where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select category, gender, count(transactions_id) as total_trans
from retail_sales
group by category, gender
order by 1;


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select * from retail_sales;
select month, year, avg_sale
from
	(
    select 
    extract(year from sale_date) as year,
    extract(month from sale_date) as month,
    avg(total_sale) as avg_sale,
    rank() over (
    partition by extract(year from sale_date) order by avg(total_sale) desc) as rnk
    from retail_sales
    group by 1, 2
    ) as t1
    where rnk = 1;
    


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select customer_id, sum(total_sale) as tolal_sales
from retail_sales
group by customer_id
order by 2 desc
limit 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select category, count(distinct customer_id) as cnt_customers 
from retail_sales
group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;
-- End of project

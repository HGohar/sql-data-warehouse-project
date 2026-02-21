-- Analize Sales Performance Over Time

SELECT

	YEAR(order_date) as order_year,
	MONTH(order_date) as oredr_month,
	SUM(sales_amount) as total_sales,
	COUNT(DISTINCT customer_id) AS total_customers,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date)


SELECT

	FORMAT(order_date, 'yyyy-MMM') as order_year,
	SUM(sales_amount) as total_sales,
	COUNT(DISTINCT customer_id) AS total_customers,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MMM')
ORDER BY FORMAT(order_date, 'yyyy-MMM')

--Calculate the total sales per month and the running total of sales over time
SELECT 
order_date,
total_sales,
SUM(total_sales) OVER (PARTITION BY order_date ORDER BY order_date) AS running_total_slaes,
AVG(avg_price) OVER (ORDER BY order_date) AS moving_avarage_price
FROM
(

SELECT
	DATETRUNC(month, order_date) AS order_date,
	SUM(sales_amount) as total_sales,
	AVG(sls_price) AS avg_price
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
) t



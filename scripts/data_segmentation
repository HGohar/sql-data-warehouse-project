--Segment products into cost ranges and count how many products fall into each segment


--WITH product_segment AS (
--SELECT 
--product_key,
--product_name,
--cost,
--CASE WHEN  cost > 1500 THEN 'High Price'
--WHEN cost >= 700 AND cost <= 1500 THEN 'Normal Price'
--ELSE 'Low Price'
--END cost_range
--FROM gold.dim_products
--)

--SELECT
--cost_range,
--COUNT(product_key) AS product_count
--FROM product_segment
--GROUP BY cost_range
--ORDER BY product_count DESC


/* Group customers into three segments based on their spending behavior:
 - VIP: Customers with at least 12 months of history and spending more than 5000 EUR,
 - Regular: Customers with at least 12 months of history but spending 5000 or less.
 - New: Custoemrs with a lifespan less than 12 months.
 And find the total number of customers by each group
 */

 
WITH customers_spendings AS ( 
 
 SELECT
 c.customer_id,
 SUM(f.sales_amount) AS total_spending,
 MAX(order_date) AS last_order,
 MIN(order_date) AS first_order,
 DATEDIFF (month,MIN(order_date), MAX(order_date)) AS customer_lifespan


 FROM gold.fact_sales f
 LEFT JOIN gold.dim_customers c
 ON f.customer_id = c.customer_id
 GROUP BY c.customer_id
 )


 SELECT
     segmentation,
     COUNT(customer_id) AS total_customers
 FROM (

         SELECT 
         customer_id,
         CASE WHEN customer_lifespan > 12 AND total_spending > 5000
              THEN 'VIP'
              WHEN customer_lifespan >= 12 AND total_spending <=5000
              THEN 'REgular'
              ELSE 'New'
        END segmentation
              FROM customers_spendings
      ) t
      GROUP BY segmentation
      ORDER BY total_customers DESC

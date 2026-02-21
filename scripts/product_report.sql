/*

==========================================================================
Product Report
==========================================================================

Purpose:

  -This report consolidates key products and behaviors.

  Highlights:

	1. Gathers essential fields such as product name, category, subcategory, and cost.
	2. Segments products by revenue to identify High-Performers, Mid-Performers, Mid_Range or Low_Performers.
	3. Aggregates product-level metrics:
		- total orders
		- total sales
		- total quantity sold
		- total customers (unique)
		- lifespan (in months)
	4. Calculate valuable KPIs:
		- recency (months since last sale)
		- average order revenue (AOR)
		- average monthly revenue

	==========================================================================
	*/

CREATE VIEW gold.report_products AS
-- 1) Base Query: Retrieves core columns from fact_sales and dim_products

	WITH base_query AS (
			SELECT 
					p.product_name,
					p.category,
					p.subcategory,
					p.cost,
					p.product_key,
					f.order_number,
					f.quantity,
					f.order_date,
					f.sales_amount,
					f.customer_id	
			FROM gold.fact_sales f
			LEFT JOIN gold.dim_products p
			ON f.product_key = p.product_key
			WHERE order_date IS NOT NULL
			
			),
	-- 2) Product Aggregation: Summarize key metrics at the product level

	product_aggregations AS (
	SELECT 
	    product_key,
		product_name,
		category,
		subcategory,
		cost,
		DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
		MAX(order_date) AS last_sale_date,
	    COUNT(DISTINCT order_number) AS total_orders,
		COUNT(DISTINCT customer_id) AS total_customers,
		SUM(sales_amount) AS total_sales,
		SUM(quantity) AS total_quantity,
		ROUND (AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)), 1) AS avg_selling_price	
	FROM base_query
	GROUP BY 
		   product_key,
		   product_name,
		   category,
		   subcategory,
		   cost
		   )
	        
--3) Final Query: Combines all products results into one output

SELECT
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	last_sale_date,
	DATEDIFF(MONTH, last_sale_date, GETDATE()) AS recency_in_months,
	CASE WHEN total_sales > 50000 THEN 'High-Performer'
				 WHEN total_sales >= 10000 THEN 'Mid-Range'
	ELSE 'Low-Performer'
	END AS product_segmentation_by_revenue,
		lifespan,
		total_orders,
		total_sales,
		total_quantity,
		total_customers,
		avg_selling_price,
		--Average Order Revenue (AOR)
		CASE 
			WHEN total_orders = 0 THEN 0
			ELSE total_sales / total_orders
		END AS avg_order_revenue,

		-- Average Monthly Revenue
		CASE
			WHEN lifespan = 0 THEN total_sales
			ELSE total_sales / lifespan
		END AS avg_monthly_revenue
	FROM product_aggregations




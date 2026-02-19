**	**Data Dictionary for Gold Layer**

  
The Gold Layer is the business-level data representation, structured to support analytical and reporting use cases of dimension tables and fact tables for specific business metrics. 

-------------------------------------------------------------------------------------------------------------------------------------------------
**gold.dim_customers**

**Description**

The dim_customers view is a **dimension table** in the Gold layer that consolidates customer data from CRM and ERP sources.

- CRM (silver.crm_cust_info) is the master source for customer core attributes and gender.

- ERP (silver.erp_cust_az12, silver.erp_loc_a101) enriches customer demographic and location data.

The view generates a **surrogate key** (customer_key) for dimensional modeling purposes.



**Join Logic**
crm_cust_info.cst_key = erp_cust_az12.cid
crm_cust_info.cst_key = erp_loc_a101.cid


All joins are **LEFT JOINS**, ensuring all CRM customers are retained even if ERP data is missing.


**Business Rules Summary**

**1. Surrogate Key Generation**

     - Sequential key generated using ROW_NUMBER().

**2. Gender Priority Rule**

     - CRM is the master source.
     
     - If CRM gender is not 'n/a', use it.
     
     - Otherwise, use ERP gender.
     
     - Default to 'n/a' if both are missing.

**3. Data Retention Rule**

    - All CRM customers must exist in the dimension even if ERP enrichment is unavailable.


------------------------------------------------------------------------------------------------------------------------------------------------------------
**gold.dim_products**

**Description**

The dim_products view is a Product Dimension table in the Gold layer of the data warehouse.

It consolidates product master data from CRM and enriches it with category information from ERP.

This view:

- Generates a surrogate key (product_key) for dimensional modeling.

- Filters out historical product records (prd_end_dt IS NULL) to keep only active/current products.

**Business Rules Summary**

**1. Surrogate Key Generation**

- product_key is generated using ROW_NUMBER()

- Ordered by prd_start_dt, then prd_key

-------------------------------------------------------------------------------------------------------------------------------------------------------------
**gold.fact_sales**

**Description**

The fact_sales view is the Sales Fact table in the Gold layer of the data warehouse.

It captures transactional sales data from CRM and links it to the Product and Customer dimensions to support analytical reporting.

This table is designed using a star schema approach, where:

 - Sales transactions are stored as measurable facts.
 - Dimension tables (dim_products, dim_customers) provide descriptive context.

**Business Rules Summary**

**1. Fact Table Structure**

- Contains measurable metrics (sales_amount, quantity, price).
- Links to dimensions via keys.

**2. No Aggregation**

- Data remains at detailed transactional level.
- Aggregations (daily, monthly, yearly) should be handled in reporting layer.

**3. Referential Behavior**

- If a product or customer does not exist in the dimension, the fact record still appears (due to LEFT JOIN).

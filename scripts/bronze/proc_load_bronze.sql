/*
=========================================================================
Stored Procedure: Load Bronze Layer
=========================================================================

Usage Example:
EXEC bronze.load_bronze;

========================================================================

*/


CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @start_time_of_the_bronze_layer DATETIME, @end_time_of_the_bronze_layer DATETIME 
	
	BEGIN TRY
	SET @start_time_of_the_bronze_layer = GETDATE();
			PRINT '=========================';
			PRINT 'Loading Bronze Layer';
			PRINT '=========================';


			PRINT '=========================';
			PRINT 'Loading CRM Tables';
			PRINT '=========================';
	
	        SET @start_time = GETDATE();
			PRINT 'Truncate Table:bronze.crm_cust_info';
			TRUNCATE TABLE bronze.crm_cust_info;

			PRINT 'Insert Data Into Table:bronze.crm_cust_info';
			BULK INSERT bronze.crm_cust_info
			FROM 'D:\DS\SQL\data with Barra\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
			WITH (
					FIRSTROW = 2,
					FIELDTERMINATOR = ',',
					TABLOCK
				);
			SET @end_time = GETDATE();
			PRINT '>> Load Duration ' + cast(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'; 


			SET @start_time = GETDATE();
			PRINT 'Truncate Table:bronze.crm_prd_info';
			TRUNCATE TABLE bronze.crm_prd_info

			PRINT 'Insert Data Into Table:bronze.crm_prd_info';
			BULK INSERT bronze.crm_prd_info
			FROM 'D:\DS\SQL\data with Barra\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
			WITH (
					FIRSTROW = 2,
					FIELDTERMINATOR = ',',
					TABLOCK
			);
			SET @end_time = GETDATE();
			PRINT '>> Load Duration ' + cast(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'; 


			SET @start_time = GETDATE();
			PRINT 'Truncate Table:bronze.crm_sales_details';
			TRUNCATE TABLE bronze.crm_sales_details

			PRINT 'Insert Data Into Table:bronze.crm_sales_details';
			BULK INSERT bronze.crm_sales_details
			FROM 'D:\DS\SQL\data with Barra\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
			WITH (
					FIRSTROW = 2,
					FIELDTERMINATOR = ',',
					TABLOCK
			);
			SET @end_time = GETDATE();
			PRINT '>> Load Duration ' + cast(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'; 
	
			PRINT '=========================';
			PRINT 'Insert From ERP Tables';
			PRINT '=========================';

			SET @start_time = GETDATE();
			PRINT 'Truncating Table: bronze.erp_cust_az12';
			TRUNCATE TABLE bronze.erp_cust_az12

			PRINT 'Insert Data Into Table:bronze.erp_cust_az12';
			BULK INSERT bronze.erp_cust_az12
			FROM 'D:\DS\SQL\data with Barra\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
			WITH (
					FIRSTROW = 2,
					FIELDTERMINATOR = ',',
					TABLOCK
			);
			SET @end_time = GETDATE();
			PRINT '>> Load Duration ' + cast(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'; 


			SET @start_time = GETDATE();
			PRINT 'Truncating Table: bronze.erp_loc_a101';
			TRUNCATE TABLE bronze.erp_loc_a101

			PRINT 'Insert Data Into Table:bronze.erp_loc_a101';
			BULK INSERT bronze.erp_loc_a101
			FROM 'D:\DS\SQL\data with Barra\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
			WITH (
					FIRSTROW = 2,
					FIELDTERMINATOR = ',',
					TABLOCK
					);

			SET @end_time = GETDATE();
			PRINT '>> Load Duration ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'; 

			SET @start_time = GETDATE();
			PRINT 'Truncating Table: bronze.erp_px_cat_g1v2';
			TRUNCATE TABLE bronze.erp_px_cat_g1v2

			PRINT 'Insert Data Into Table:bronze.erp_px_cat_g1v2';
			BULK INSERT bronze.erp_px_cat_g1v2
			FROM 'D:\DS\SQL\data with Barra\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
			WITH (
					FIRSTROW = 2,
					FIELDTERMINATOR = ',',
					TABLOCK
					);
			SET @end_time = GETDATE();
			PRINT '>> Load Duration ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'; 

			SET @end_time_of_the_bronze_layer = GETDATE();
			PRINT 'Bronze Layer Is Completed'
			PRINT 'Duration of the Bronze Layer ' +  CAST(DATEDIFF(second, @start_time_of_the_bronze_layer, @end_time_of_the_bronze_layer) AS NVARCHAR) + ' seconds'
	END TRY
	BEGIN CATCH
		PRINT '======================='
		PRINT 'EROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Number' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error State' + CAST(ERROR_STATE() AS NVARCHAR);

		PRINT '======================='

	END CATCH

END

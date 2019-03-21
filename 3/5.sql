-- 5.Напишите запрос, который выгрузит данные через bcp out и загрузит через bulk insert

-- To allow advanced options to be changed.  
EXEC sp_configure 'show advanced options', 1;  
GO  
-- To update the currently configured value for advanced options.  
RECONFIGURE;  
GO  
-- To enable the feature.  
EXEC sp_configure 'xp_cmdshell', 1;  
GO  
-- To update the currently configured value for this feature.  
RECONFIGURE;  
GO  

--SELECT @@SERVERNAME

USE WideWorldImporters;

EXEC master..xp_cmdshell 'bcp "WideWorldImporters.Sales.Customers" out "C:\temp\customers.txt" -T -w -t"@eu&$1&" -S NZHARKIKH';

IF OBJECT_ID('WideWorldImporters.Sales.Customers_BulkDemo') IS NOT NULL
  TRUNCATE TABLE Sales.Customers_BulkDemo
ELSE
  SELECT *
  INTO Sales.Customers_BulkDemo
  FROM Sales.Customers
  WHERE 1 = 0
;

DECLARE 
	@path VARCHAR(256),
	@FileName VARCHAR(256),
	@onlyScript BIT, 
	@query	nVARCHAR(MAX),
	@dbname VARCHAR(255),
	@batchsize INT
	
	SELECT @dbname = DB_NAME();
	SET @batchsize = 1000;

	/*******************************************************************/
	/*******************************************************************/
	/******Change for path and file name*******************************/
	SET @path = 'C:\temp\';
	SET @FileName = 'customers.txt';
	/*******************************************************************/
	/*******************************************************************/
	/*******************************************************************/

	SET @onlyScript = 1;

	BEGIN TRY

		IF @FileName IS NOT NULL
		BEGIN
			SET @query = 'BULK INSERT [' + @dbname + '].[Sales].[Customers_BulkDemo]
				   FROM "' + @path + @FileName + '"
				   WITH 
					 (
						BATCHSIZE = ' + CAST(@batchsize AS VARCHAR(255)) + ', 
						DATAFILETYPE = ''widechar'',
						FIELDTERMINATOR = ''@eu&$1&'',
						ROWTERMINATOR =''\n'',
						KEEPNULLS,
						TABLOCK        
					  );'

			PRINT @query

			IF @onlyScript = 0
				EXEC sp_executesql @query 
			PRINT 'Bulk insert ' + @FileName + ' is done, current time ' + CONVERT(VARCHAR, GETUTCDATE(), 120)
			;
		END;
	END TRY

	BEGIN CATCH
	  SELECT   
	    ERROR_NUMBER() AS ErrorNumber  
	  , ERROR_MESSAGE() AS ErrorMessage
	  ; 
	  
	  PRINT 'ERROR in Bulk insert ' + @FileName + ' , current time ' + CONVERT(VARCHAR, GETUTCDATE(), 120)
	  ;
	END CATCH

	BULK INSERT [WideWorldImporters].[Sales].[Customers_BulkDemo]
				   FROM "C:\temp\customers.txt"
				   WITH 
					 (
						BATCHSIZE = 1000, 
						DATAFILETYPE = 'widechar',
						FIELDTERMINATOR = '@eu&$1&',
						ROWTERMINATOR ='\n',
						KEEPNULLS,
						TABLOCK        
					  );

SELECT COUNT (*)
FROM Sales.Customers_BulkDemo;
-- 3.  изменить одну запись, из добавленных через UPDATE
UPDATE TOP (1) Sales.Customers
SET CustomerName = REPLACE(CustomerName, 'MyIns', 'MyUpd') 
OUTPUT inserted.*, deleted.*
WHERE CustomerName LIKE 'MyIns %'
;
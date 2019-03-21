-- 2. удалите 1 запись из Customers, которая была вами добавлена
DELETE TOP (1) 
FROM Sales.Customers
OUTPUT deleted.*
WHERE CustomerName LIKE 'MyIns %'
;
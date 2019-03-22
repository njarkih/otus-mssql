-- 3. Выберите информацию по клиентам, которые перевели компании 5 максимальных платежей из [Sales].[CustomerTransactions] 
-- представьте 3 способа (в том числе с CTE)

WITH MaxTransaction AS (
  SELECT TOP 5
    CustomerId
  FROM Sales.CustomerTransactions
  ORDER BY TransactionAmount DESC
)
SELECT 
  c.CustomerName
, c.PhoneNumber
, c.WebsiteURL
, c.CreditLimit
FROM Sales.Customers c
WHERE c.CustomerID = ANY (SELECT CustomerId FROM MaxTransaction)
;

SELECT 
  c.CustomerName
, c.PhoneNumber
, c.WebsiteURL
, c.CreditLimit
FROM Sales.Customers c
WHERE c.CustomerID IN (SELECT TOP 5
					     CustomerId
					   FROM Sales.CustomerTransactions
					   ORDER BY TransactionAmount DESC)
;

WITH MaxTransaction AS (
  SELECT TOP 5
    CustomerId
  FROM Sales.CustomerTransactions
  ORDER BY TransactionAmount DESC
)
SELECT 
  c.CustomerName
, c.PhoneNumber
, c.WebsiteURL
, c.CreditLimit
FROM Sales.Customers c
JOIN MaxTransaction m ON c.CustomerID = m.CustomerID
;

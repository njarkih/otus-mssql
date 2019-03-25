--4. По каждому сотруднику выведите последнего клиента, которому сотрудник что-то продал
--В результатах должны быть ид и фамилия сотрудника, ид и название клиента, дата продажи, сумму сделки

WITH OrdersInfo AS (
  SELECT 
    ROW_NUMBER() OVER(PARTITION BY i.SalesPersonPersonID ORDER BY i.InvoiceDate DESC, i.InvoiceId DESC) rn
  , i.SalesPersonPersonID
  , i.InvoiceDate
  , i.CustomerID
  , t.TransactionAmount
  FROM Sales.Invoices i
  JOIN Sales.CustomerTransactions t ON i.InvoiceID = t.InvoiceID
)
SELECT 
  p.PersonID
, p.FullName
, i.CustomerID
, c.CustomerName
, i.InvoiceDate
, i.TransactionAmount
FROM OrdersInfo i
JOIN Application.People p ON i.SalespersonPersonID = p.PersonID
JOIN Sales.Customers c ON i.CustomerID = c.CustomerID
WHERE i.rn = 1
;

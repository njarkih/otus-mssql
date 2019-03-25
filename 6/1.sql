/* 1.
Сделать расчет суммы продаж нарастающим итогом по месяцам с 2015 года (в рамках одного месяца он будет одинаковый, нарастать будет в течение времени выборки)
Выведите id продажи, название клиента, дату продажи, сумму продажи, сумму нарастающим итогом
Пример 
Дата продажи Нарастающий итог по месяцу
2015-01-29	4801725.31
2015-01-30	4801725.31
2015-01-31	4801725.31
2015-02-01	9626342.98
2015-02-02	9626342.98
2015-02-03	9626342.98
Продажи можно взять из таблицы Invoices.
Сделать 2 варианта запроса - через windows function и без них. Написать какой быстрее выполняется, сравнить по set statistics time on
*/

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

-- вариант с windows function шустрее

-- SQL Server Execution Times:
--   CPU time = 547 ms,  elapsed time = 1310 ms.
SELECT
  i.OrderID
, c.CustomerName
, i.InvoiceDate
, t.TransactionAmount
, SUM(t.TransactionAmount) OVER(ORDER BY YEAR(i.InvoiceDate), MONTH(i.InvoiceDate)) AS RunningTotal
FROM Sales.Invoices i
JOIN Sales.CustomerTransactions t ON i.InvoiceID = t.InvoiceID
JOIN Sales.Customers c ON i.CustomerID = c.CustomerID
WHERE i.InvoiceDate >= '20150101'
ORDER BY i.InvoiceDate, c.CustomerName
;

PRINT CHAR(13)+'NEXT QUERY';

-- SQL Server Execution Times:
--   CPU time = 26718 ms,  elapsed time = 27468 ms.
SELECT
  i.OrderID
, c.CustomerName
, i.InvoiceDate
, t.TransactionAmount
, (SELECT SUM(st.TransactionAmount) FROM Sales.Invoices si JOIN Sales.CustomerTransactions st ON si.InvoiceID = st.InvoiceID WHERE si.InvoiceDate >= '20150101' AND si.InvoiceDate <= EOMONTH(i.InvoiceDate)) RunningTotal
FROM Sales.Invoices i
JOIN Sales.CustomerTransactions t ON i.InvoiceID = t.InvoiceID
JOIN Sales.Customers c ON i.CustomerID = c.CustomerID
WHERE i.InvoiceDate >= '20150101'
ORDER BY i.InvoiceDate, c.CustomerName
;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

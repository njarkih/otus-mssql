--4. Перепишите ДЗ из оконных функций через CROSS APPLY 
--Выберите по каждому клиенту 2 самых дорогих товара, которые он покупал
--В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки

SELECT
  c.CustomerID
, c.CustomerName
, e.StockItemID
, e.UnitPrice
, e.InvoiceDate
FROM Sales.Customers c
CROSS APPLY (SELECT TOP 2
               i.CustomerID
             , l.StockItemID
             , l.UnitPrice
             , STRING_AGG(i.InvoiceDate, ', ') WITHIN GROUP (ORDER BY i.InvoiceDate DESC) InvoiceDate
             , DENSE_RANK() OVER (PARTITION BY i.CustomerID ORDER BY l.UnitPrice DESC, l.StockItemID) rn
             FROM Sales.Invoices i
             JOIN Sales.InvoiceLines l ON i.InvoiceID = l.InvoiceID
			 WHERE c.CustomerID = i.CustomerID
			 GROUP BY 
			   i.CustomerID
                         , l.StockItemID
                         , l.UnitPrice
			 ORDER BY CustomerID, rn) e
;

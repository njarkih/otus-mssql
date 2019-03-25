--5. Выберите по каждому клиенту 2 самых дорогих товара, которые он покупал
--В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки

WITH Top2Expensive AS (
  SELECT
    i.CustomerID
  , l.StockItemID
  , l.UnitPrice
  , i.InvoiceDate
  , DENSE_RANK() OVER (PARTITION BY i.CustomerID ORDER BY l.UnitPrice DESC, l.StockItemID) rn -- товары по одной цене тоже ранжируются, т.е. в TOP 2 не попадёт больше 2 товаров
  FROM Sales.Invoices i
  JOIN Sales.InvoiceLines l ON i.InvoiceID = l.InvoiceID
)
SELECT
  c.CustomerID
, c.CustomerName
, e.StockItemID
, e.UnitPrice
, STRING_AGG(e.InvoiceDate, ', ') WITHIN GROUP (ORDER BY e.InvoiceDate DESC) InvoceDates -- если товар покупалсе неоднократно, то вывожу даты всех покупок
FROM Sales.Customers c
JOIN Top2Expensive e ON c.CustomerID = e.CustomerID AND e.rn < 3
GROUP BY c.CustomerID, c.CustomerName, e.StockItemID, e.UnitPrice
;

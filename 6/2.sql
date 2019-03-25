-- 2. Вывести список 2х самых популярных продуктов (по кол-ву проданных) в каждом месяце за 2016й год (по 2 самых популярных продукта в каждом месяце)
WITH Prepare AS (
  SELECT  
    MONTH(o.OrderDate) tMonth
  , l.StockItemID
  , ROW_NUMBER() OVER (PARTITION BY MONTH(o.OrderDate) ORDER BY SUM(l.Quantity) DESC) rn
  FROM Sales.Orders o
  JOIN Sales.OrderLines l ON o.OrderID = l.OrderID
  WHERE o.OrderDate BETWEEN '20160101' AND '20161231'
  GROUP BY MONTH(o.OrderDate), l.StockItemID
)
SELECT 
  p.tMonth
, i.StockItemName
, p.rn 
FROM Prepare p
JOIN Warehouse.StockItems i ON p.StockItemID = i.StockItemID
WHERE rn < 3
ORDER BY p.tMonth, p.rn
;

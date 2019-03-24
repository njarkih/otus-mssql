-- 3. Вывести сумму продаж, дату первой продажи и количество проданного по месяцам, по товарам, продажи которых менее 50 ед в месяц
SELECT 
  l.StockItemID
, i.StockItemName
, YEAR(o.OrderDate) [Year]
, MONTH(o.OrderDate) [Month]
, SUM(l.Quantity * l.UnitPrice) FullCost
, MIN(o.OrderDate) FirstSaleOfMonth
, SUM(l.Quantity) SumQuantity
FROM Sales.Orders o
JOIN Sales.OrderLines l ON o.OrderID = l.OrderID
JOIN Warehouse.StockItems i ON l.StockItemID = i.StockItemID
WHERE o.PickingCompletedWhen IS NOT NULL
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate), l.StockItemID, i.StockItemName
HAVING SUM(l.Quantity) < 50
;

-- если трактовать условие задачи т.о., что нам нужна информация по продажам непопулярных товаров не только в провальные месяцы,
-- то запрос будет выглядеть следующим образом:

-- товары, продажи которых менее 50 ед в месяц
WITH LowSales AS (
  SELECT         
    l.StockItemID
  FROM Sales.Orders o
  JOIN Sales.OrderLines l ON o.OrderID = l.OrderID
  WHERE o.PickingCompletedWhen IS NOT NULL 
  GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate), l.StockItemID
  HAVING SUM(l.Quantity) < 50
)
SELECT 
  YEAR(o.OrderDate) [Year]
, MONTH(o.OrderDate) [Month]
, l.StockItemID
, i.StockItemName
, SUM(l.Quantity * l.UnitPrice) FullCost
, MIN(o.OrderDate) FirstSaleOfMonth
, SUM(l.Quantity) SumQuantity
FROM LowSales ls
JOIN Sales.OrderLines l ON l.StockItemID = ls.StockItemID
JOIN Sales.Orders o ON o.OrderID = l.OrderID
JOIN Warehouse.StockItems i ON l.StockItemID = i.StockItemID
WHERE o.PickingCompletedWhen IS NOT NULL
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate), l.StockItemID, i.StockItemName
ORDER BY l.StockItemID, [Year], [Month]
;

-- и вариант на случай если был период когда не было продаж товара вообще
BEGIN TRAN

-- так как таких случаев нет, то сделаем сами
DELETE l
FROM Sales.OrderLines l
JOIN Sales.Orders o ON o.OrderID = l.OrderID  
WHERE l.StockItemID = 29 AND o.OrderDate BETWEEN '20150101' AND '20150201'
;

WITH DateBorders AS (
  SELECT 
    DATEADD(MONTH, -1, DATEADD(DAY, 1, EOMONTH(MIN(o.OrderDate)))) MinDate
  , DATEADD(MONTH, -1, DATEADD(DAY, 1, EOMONTH(MAX(o.OrderDate)))) MaxDate
  FROM Sales.Orders o
)
, DateList (StartDate, EndDate, OrderMonth, OrderYear) AS (
  SELECT MinDate, EOMONTH(MinDate),  MONTH(MinDate) OrderMonth, YEAR(MinDate) OrderYear
  FROM DateBorders
  UNION ALL
  SELECT DATEADD(MONTH, 1, StartDate), EOMONTH(DATEADD(MONTH, 1, StartDate)), MONTH(DATEADD(MONTH, 1, StartDate)), YEAR(DATEADD(MONTH, 1, StartDate))
  FROM DateList
  WHERE StartDate < (SELECT MaxDate FROM DateBorders) 
)
-- товар и его самая первая продажа
, FirstOrder AS (
  SELECT 
    l.StockItemID
  , MIN(o.OrderDate) MinOrderDate
  FROM Sales.Orders o
  JOIN Sales.OrderLines l ON o.OrderId = l.OrderID 
    AND o.PickingCompletedWhen IS NOT NULL
  GROUP BY l.StockItemID
)
SELECT 
  p.OrderYear
, p.OrderMonth
, f.StockItemID
, MIN(o.OrderDate) FirstSaleOfMonth
, ISNULL(SUM(l.Quantity * l.UnitPrice), 0) FullCost
, ISNULL(SUM(l.Quantity), 0) SumQuantity
FROM DateList p
FULL JOIN FirstOrder f ON f.MinOrderDate <= p.EndDate
LEFT JOIN Sales.Orders o ON o.OrderDate BETWEEN p.StartDate AND p.EndDate
LEFT JOIN Sales.OrderLines l ON o.OrderId = l.OrderID AND l.StockItemID = f.StockItemID
WHERE o.PickingCompletedWhen IS NOT NULL
GROUP BY p.OrderYear, p.OrderMonth, f.StockItemID
HAVING ISNULL(SUM(l.Quantity), 0) < 50
ORDER BY p.OrderYear, p.OrderMonth, f.StockItemID
;

ROLLBACK  TRAN

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

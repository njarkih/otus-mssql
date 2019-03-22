-- 2. Выберите товары с минимальной ценой (подзапросом), 2 варианта подзапроса. 
SELECT 
  i.StockItemID
, i.StockItemName
, i.UnitPrice
FROM Warehouse.StockItems i
WHERE i.UnitPrice <= ALL (SELECT a.UnitPrice FROM Warehouse.StockItems a WHERE NOT a.UnitPrice IS NULL)
;

WITH MinPrice (UnitPrice) AS (
  SELECT 
    MIN(UnitPrice)
  FROM Warehouse.StockItems
)
SELECT 
  i.StockItemID
, i.StockItemName
, i.UnitPrice 
FROM Warehouse.StockItems i 
WHERE i.UnitPrice = (SELECT UnitPrice FROM MinPrice)
;

SELECT 
  i.StockItemID
, i.StockItemName
, i.UnitPrice 
FROM Warehouse.StockItems i 
WHERE i.UnitPrice = (SELECT TOP 1 UnitPrice FROM Warehouse.StockItems ORDER BY UnitPrice)
;

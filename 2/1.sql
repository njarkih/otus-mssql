-- 1
-- ��� ������, � ������� � �������� ���� ������� urgent ��� �������� ���������� � Animal
SELECT 
  StockItemID
, StockItemName
FROM Warehouse.StockItems
WHERE StockItemName LIKE 'Animal%'
  OR StockItemName LIKE '%urgent%'
;
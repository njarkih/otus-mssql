-- 3. Функции одним запросом
-- Посчитайте по таблице товаров, в вывод также должен попасть ид товара, название, брэнд и цена
-- пронумеруйте записи по названию товара, так чтобы при изменении буквы алфавита нумерация начиналась заново
-- посчитайте общее количество товаров и выведете полем в этом же запросе
-- посчитайте общее количество товаров в зависимости от первой буквы названия товара
-- отобразите следующий id товара исходя из того, что порядок отображения товаров по имени 
-- предыдущий ид товара с тем же порядком отображения (по имени)
-- названия товара 2 строки назад, в случае если предыдущей строки нет нужно вывести "No items"
-- сформируйте 30 групп товаров по полю вес товара на 1 шт

SELECT 
  i.StockItemID
, i.StockItemName
, i.Brand
, i.UnitPrice
-- пронумеруйте записи по названию товара, так чтобы при изменении буквы алфавита нумерация начиналась заново
, ROW_NUMBER() OVER (PARTITION BY LEFT(i.StockItemName, 1) ORDER BY i.StockItemName) RnkByAlp 
-- посчитайте общее количество товаров и выведете полем в этом же запросе
, COUNT(1) OVER() CntAll
-- посчитайте общее количество товаров в зависимости от первой буквы названия товара
, COUNT(1) OVER(PARTITION BY LEFT(i.StockItemName, 1)) CntByAlp
-- отобразите следующий id товара исходя из того, что порядок отображения товаров по имени
, LEAD(i.StockItemID) OVER(ORDER BY i.StockItemName) NextId
-- предыдущий ид товара с тем же порядком отображения (по имени)
, LAG(i.StockItemID) OVER(ORDER BY i.StockItemName) PrevId
-- названия товара 2 строки назад, в случае если предыдущей строки нет нужно вывести "No items"
, LAG(i.StockItemName, 2, 'No items') OVER(ORDER BY i.StockItemName) BackTwiceName
-- сформируйте 30 групп товаров по полю вес товара на 1 шт 
, NTILE(30) OVER (ORDER BY i.TypicalWeightPerUnit) WeightGroup
FROM Warehouse.StockItems i
--ORDER BY RnkByAlp
--ORDER BY CntAll
--ORDER BY CntByAlp
--ORDER BY NextId
--ORDER BY PrevId
--ORDER BY BackTwiceName
--ORDER BY WeightGroup
;

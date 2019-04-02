--2. Для всех клиентов с именем, в котором есть Tailspin Toys
--вывести все адреса, которые есть в таблице, в одной колонке
   
--Пример результатов
--CustomerName	AddressLine
--Tailspin Toys (Head Office)	Shop 38
--Tailspin Toys (Head Office)	1877 Mittal Road
--Tailspin Toys (Head Office)	PO Box 8975
--Tailspin Toys (Head Office)	Ribeiroville
--.....

SELECT
  CustomerName
, AddressLine
FROM
   (SELECT
      CustomerName
    , DeliveryAddressLine1
    , DeliveryAddressLine2
    , PostalAddressLine1
    , PostalAddressLine2
    FROM Sales.Customers
    WHERE CustomerName LIKE 'Tailspin Toys%'
   ) p
UNPIVOT
   (AddressLine FOR LineType IN (DeliveryAddressLine1, DeliveryAddressLine2, PostalAddressLine1, PostalAddressLine2)
   ) AS unpvt
;

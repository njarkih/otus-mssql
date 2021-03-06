--1. Требуется написать запрос, который в результате своего выполнения формирует таблицу следующего вида:
--Название клиента
--МесяцГод Количество покупок

--Клиентов взять с ID 2-6, это все подразделение Tailspin Toys
--имя клиента нужно поменять так чтобы осталось только уточнение 
--например исходное Tailspin Toys (Gasport, NY) - вы выводите в имени только Gasport,NY
--дата должна иметь формат dd.mm.yyyy например 25.12.2019

--Например, как должны выглядеть результаты:
--InvoiceMonth Peeples Valley, AZ Medicine Lodge, KS Gasport, NY Sylvanite, MT Jessie, ND
--01.01.2013 3 1 4 2 2
--01.02.2013 7 3 4 2 1

SELECT 
  CONVERT(NVARCHAR(10), InvoiceMnt, 104) InvoiceMonth
, [Peeples Valley, AZ]
, [Medicine Lodge, KS]
, [Gasport, NY]
, [Sylvanite, MT]
, [Jessie, ND]
FROM 
   (SELECT 
      i.OrderID
    , DATEADD(MM, DATEDIFF(MM, 0, i.InvoiceDate), 0) InvoiceMnt
    , REPLACE(REPLACE(c.CustomerName, 'Tailspin Toys (', ''), ')', '') AS TailspinToys
    FROM Sales.Invoices i
    JOIN Sales.Customers c ON i.CustomerID = c.CustomerID
      AND i.CustomerID BETWEEN 2 AND 6
   ) AS SourceTbl
PIVOT 
   (COUNT(OrderID) FOR TailspinToys IN ([Peeples Valley, AZ], [Medicine Lodge, KS], [Gasport, NY], [Sylvanite, MT], [Jessie, ND])
   ) AS PivotTbl
ORDER BY InvoiceMnt
;
                                                                                                                     
-- вариант 2
DECLARE @SQL NVARCHAR(4000);

WITH SelectSection AS (
  SELECT 
    STRING_AGG(TailspinToys, ', ') TailspinToysList
  FROM
     (SELECT DISTINCT 
        '[' + REPLACE(REPLACE(c.CustomerName, 'Tailspin Toys (', ''), ')', '') + ']' TailspinToys
      FROM Sales.Invoices i
      JOIN Sales.Customers c ON i.CustomerID = c.CustomerID AND i.CustomerID BETWEEN 2 AND 6
     ) t
)
SELECT @SQL = '
   SELECT CONVERT(NVARCHAR(10), InvoiceMnt, 104) InvoiceMonth, ' + (SELECT TailspinToysList FROM SelectSection)
+ '
   FROM 
      (SELECT 
         i.OrderID
       , DATEADD(MM, DATEDIFF(MM, 0, i.InvoiceDate), 0) InvoiceMnt
       , REPLACE(REPLACE(c.CustomerName, ''Tailspin Toys ('', ''''), '')'', '''') AS TailspinToys
       FROM Sales.Invoices i
       JOIN Sales.Customers c ON i.CustomerID = c.CustomerID
       AND i.CustomerID BETWEEN 2 AND 6
      ) AS SourceTbl
   PIVOT 
     (COUNT(OrderID) FOR TailspinToys IN ( ' + (SELECT TailspinToysList FROM SelectSection) + ')
     ) PivotTbl 
     ORDER BY InvoiceMnt ' 
;

print @SQL;

EXEC sys.sp_executesql @SQL;

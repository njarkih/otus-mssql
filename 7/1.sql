--1. Напишите запрос с временной таблицей и перепишите его с табличной переменной. Сравните планы. 

-- Логирование для посчёта времени выполнения
DECLARE @log TABLE (
  TheOrder INT IDENTITY(1,1)
, WhatHappened INT
, WhenItDid  DATETIME DEFAULT GETDATE()
);
 
INSERT @log (WhatHappened) 
SELECT 1
;

-- вариант с временной таблицей
IF OBJECT_ID('tempdb..#PreCalc') IS NOT NULL DROP TABLE #PreCalc;

SELECT 
  YEAR(si.InvoiceDate) tYear
, MONTH(si.InvoiceDate) tMonth
, SUM(st.TransactionAmount) MonthSum
, CONVERT(NUMERIC(18, 2), 0.00) RunningTotal
INTO #PreCalc
FROM Sales.Invoices si 
JOIN Sales.CustomerTransactions st ON si.InvoiceID = st.InvoiceID 
WHERE si.InvoiceDate >= '20150101' 
  AND si.InvoiceDate <= EOMONTH(si.InvoiceDate)
GROUP BY YEAR(si.InvoiceDate), MONTH(si.InvoiceDate)
;

UPDATE r
SET RunningTotal = (SELECT SUM(c.MonthSum) FROM #PreCalc c WHERE c.tYear <= r.tYear AND c.tMonth <= r.tMonth)
FROM #PreCalc r
;

SELECT
  i.OrderID
, c.CustomerName
, i.InvoiceDate
, t.TransactionAmount
, pc.RunningTotal
FROM Sales.Invoices i
JOIN Sales.CustomerTransactions t ON i.InvoiceID = t.InvoiceID
JOIN Sales.Customers c ON i.CustomerID = c.CustomerID
JOIN #PreCalc pc ON pc.tYear = YEAR(i.InvoiceDate) AND pc.tMonth = MONTH(i.InvoiceDate)
WHERE i.InvoiceDate >= '20150101'
ORDER BY i.InvoiceDate, c.CustomerName
;

INSERT @log (WhatHappened) 
SELECT 1
;

INSERT @log (WhatHappened) 
SELECT 2
;

-- вариант с табличной переменной
DECLARE @PreCalc TABLE (
  tMonth INT
, tYear  INT
, MonthSum     NUMERIC(18, 2)
, RunningTotal NUMERIC(18, 2)
);

INSERT @PreCalc (tYear, tMonth, MonthSum, RunningTotal)
SELECT 
  YEAR(si.InvoiceDate) tYear
, MONTH(si.InvoiceDate) tMonth
, SUM(st.TransactionAmount) MonthSum
, 0.00 RunningTotal
FROM Sales.Invoices si 
JOIN Sales.CustomerTransactions st ON si.InvoiceID = st.InvoiceID 
WHERE si.InvoiceDate >= '20150101' 
  AND si.InvoiceDate <= EOMONTH(si.InvoiceDate)
GROUP BY YEAR(si.InvoiceDate), MONTH(si.InvoiceDate)
;

UPDATE r
SET RunningTotal = (SELECT SUM(c.MonthSum) FROM @PreCalc c WHERE c.tYear <= r.tYear AND c.tMonth <= r.tMonth)
FROM @PreCalc r
;

SELECT
  i.OrderID
, c.CustomerName
, i.InvoiceDate
, t.TransactionAmount
, pc.RunningTotal
FROM Sales.Invoices i
JOIN Sales.CustomerTransactions t ON i.InvoiceID = t.InvoiceID
JOIN Sales.Customers c ON i.CustomerID = c.CustomerID
JOIN @PreCalc pc ON pc.tYear = YEAR(i.InvoiceDate) AND pc.tMonth = MONTH(i.InvoiceDate)
WHERE i.InvoiceDate >= '20150101'
ORDER BY i.InvoiceDate, c.CustomerName
;

INSERT @log (WhatHappened) 
SELECT 2
;

SELECT b.WhatHappened, DATEDIFF(MS, b.WhenItDid, e.WhenItDid) ElapsedTime
FROM @log b
JOIN @log e ON b.WhatHappened = e.WhatHappened AND e.TheOrder > b.TheOrder
;

-- ИТОГИ

-- при первом прогоне (временная таблица ранее не создавалась)
-- временная таблица 3860
-- табличная переменная 2410

-- при повторных
-- временная таблица 1123
-- табличная переменная 2267

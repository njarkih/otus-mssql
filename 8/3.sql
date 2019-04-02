-- 3. В таблице стран есть поля с кодом страны цифровым и буквенным
-- сделайте выборку ИД страны, название, код - чтобы в поле был либо цифровой либо буквенный код
-- Пример выдачи
-- 
-- CountryId	CountryName	Code
-- 1	Afghanistan	AFG
-- 1	Afghanistan	4
-- 3	Albania	ALB
-- 3	Albania	8

SELECT 
  CountryId
, CountryName
, Code
FROM
   (SELECT 
      CountryId
	, CountryName
	, CONVERT(NVARCHAR(6), IsoAlpha3Code) IsoAlpha3Code -- в базе у IsoAlpha3Code тип NVARCHAR(6), тогда почему без этого CONVERT запрос не работает? 
	, CONVERT(NVARCHAR(6), IsoNumericCode) IsoNumericCode
    FROM Application.Countries
   ) p
UNPIVOT
   (Code FOR CodeType IN (IsoAlpha3Code, IsoNumericCode)
   ) AS unpvt
;

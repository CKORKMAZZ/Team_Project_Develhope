--DATA ENGINEERING --
--To Assign Random Value For Each Duplicated Values

with duplicated AS (
SELECT 
	CustomerID 
FROM 
	Orders o
GROUP BY
	1
HAVING 
	COUNT(CustomerID) > 1
ORDER BY
	CustomerID ASC),
duplicated_rank AS (
SELECT 
	ROW_NUMBER() OVER (PARTITION BY o2.CustomerID ORDER BY o2.CustomerID ASC) AS row_number_func,
	o2.CustomerID as CustomerID
FROM 
	duplicated d JOIN
	Orders o2 ON d.CustomerID = o2.CustomerID 
)

UPDATE duplicated_rank
SET CustomerID = CustomerID || (SELECT (ABS(RANDOM() % (20))))
WHERE row_number_func > 1


--To Check Identification For Each CustomerID

with wrong_identified as (
SELECT 
	CustomerID
FROM 
	Orders o
WHERE 
 	UPPER(SUBSTRING(ShipName,1,3) || LTRIM(SUBSTRING(ShipName,INSTR(ShipName,' '),3))) || '1' != CustomerID 
)	

UPDATE Orders 
SET CustomerID = UPPER(SUBSTRING(ShipName,1,3) || LTRIM(SUBSTRING(ShipName,INSTR(ShipName,' '),3)))



ROLLBACK


-- DATA ANALYSIS --
--1--
--To Find Where (cities) Are Sold The Products Supplied By Our Top Supplier?
with rank_of_units AS (
SELECT 
	s.SupplierID,
	COUNT(p.UnitsInStock),
	DENSE_RANK() OVER (ORDER BY COUNT(p.UnitsInStock) DESC) AS rank_of_units_in_stock
FROM 
	Suppliers s
	JOIN Products p
	ON s.SupplierID = p.SupplierID 
GROUP BY 
	s.SupplierID
ORDER BY 
	2 DESC
	
)
SELECT 
	o.ShipCity AS City
FROM 
	Suppliers s 
	JOIN rank_of_units ru  
	ON s.SupplierID = ru.SupplierID
	JOIN Products p 
	ON s.SupplierID = p.SupplierID 
	JOIN "Order Details" od 
	ON p.ProductID = od.ProductID 
	JOIN Orders o 
	ON od.OrderID = o.OrderID 
	AND ru.rank_of_units_in_stock = 1
GROUP BY 
	1;
	
--2--
--To Find Which Providers Are Able To Provide What Category?
SELECT
	DISTINCT c.CategoryName,
	s.SupplierID,
	CASE 
	WHEN s.SupplierID IS NOT NULL THEN "Can provide"
	ELSE "Can't be provided by any supplier!"
	END AS Status
FROM 
	Categories c 
	JOIN Products p
	ON p.CategoryID = c.CategoryID
	LEFT JOIN Suppliers s 
	ON s.SupplierID = p.SupplierID
ORDER BY 
	2 ASC;

	
	

--DATA ENGINEERING --
--To Assign Consequent Values For Each Duplicated Values

with new_customer_ids AS(
SELECT
	CustomerID || ROW_NUMBER() OVER (PARTITION BY o.CustomerID ORDER BY o.CustomerID ASC) AS new_customer_id,
	SUBSTRING((CustomerID || ROW_NUMBER() OVER (PARTITION BY o.CustomerID ORDER BY o.CustomerID ASC)),-1,1) AS last_character
FROM 
	Orders o
)

SELECT
	CASE
	WHEN last_character = "1" THEN SUBSTRING(new_customer_id,1,LENGTH(new_customer_id)-1)
	ELSE new_customer_id
	END,
	last_character
FROM
	new_customer_ids




--To Check Identification For Each CustomerID

with wrong_identified as (
SELECT 
	CustomerID,
	ShipName 
FROM 
	Orders o
WHERE 
 	UPPER(SUBSTRING(ShipName,1,3) || LTRIM(SUBSTRING(ShipName,INSTR(ShipName,' '),3))) != CustomerID 
)	

UPDATE Orders 
SET CustomerID = UPPER(SUBSTRING(ShipName,1,3) || LTRIM(SUBSTRING(ShipName,INSTR(ShipName,' '),3)))



-- DATA ANALYSIS --
--1--
--To Find Where (cities) Are Sold The Products Supplied By Our Top Supplier?
with rank_of_units AS (
SELECT 
	s.SupplierID,
	SUM(p.UnitsInStock),
	DENSE_RANK() OVER (ORDER BY SUM(p.UnitsInStock) DESC) AS rank_of_units_in_stock
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



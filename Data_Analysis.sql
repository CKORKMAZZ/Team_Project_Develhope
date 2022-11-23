--First Task, Top Supplier Confections

SELECT
C.CategoryName,
SUM(P.UnitsInStock) AS Stock,
S.CompanyName

FROM
Products P
LEFT JOIN Categories C ON C.CategoryID=P.CategoryID
LEFT JOIN Suppliers S ON S.SupplierID=P.SupplierID
WHERE C.CategoryName="Confections"

GROUP BY
C.CategoryName,
S.CompanyName

ORDER BY
SUM(P.UnitsInStock) DESC


--To Find Which Is The Most Popular (Purchased) Product In Berlin?

WITH first_total_quantity AS (
SELECT
	SUM(od.Quantity) AS sum_of_the_quantities,
	ProductID,
	DENSE_RANK() over (ORDER BY SUM(od.Quantity) DESC) AS purchased_rank
FROM 
	"Order Details" od JOIN Orders o 
    ON o.OrderID = od.OrderID
    AND o.ShipCity = 'Berlin'
GROUP BY 
	ProductID   
)
SELECT  
	p.ProductName AS NameofProduct, 
	o.ShipCity  AS City,
	p.UnitCost AS UnitCost,
	ftq.sum_of_the_quantities AS Quantity
FROM 
	"Order Details" od 
	JOIN first_total_quantity ftq
	ON od.ProductID = ftq.productID
	JOIN Products p 
	ON p.ProductID = od.ProductID 
	JOIN Orders o 
	ON o.OrderID = od.OrderID 
	AND o.ShipCity = 'Berlin'
	AND ftq.purchased_rank = 1



--To Find What are the telephone numbers of the shippers that carried the products?
	
SELECT 
	c.CustomerID,
	c.CompanyName,
	o.OrderID,
	s.ShipperID,
	s.Phone
FROM 
	Customers c 
	JOIN Orders o
	ON c.CustomerID = o.CustomerID 
	JOIN Shippers s
	ON o.ShipVia = s.ShipperID
	AND c.CompanyName = 'Maison Dewey';


	

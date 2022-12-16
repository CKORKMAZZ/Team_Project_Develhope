#1
#This function takes the name of the objective city we want to start operating in and will output the name of the closest city!

DELIMITER //
CREATE PROCEDURE Geospatial (IN city_name VARCHAR(255), OUT v_city VARCHAR(255))
BEGIN
DECLARE v_latitude , v_longitude , v_latitude_2 , v_longitude_2 , v_geo , v_geo_min DOUBLE;
DECLARE v_min , v_max INT;

SET v_min = 1 , v_geo_min = ~0;

SELECT latitudes , longitudes INTO v_latitude_2 , v_longitude_2 FROM cities WHERE city = city_name;

with cities AS (
SELECT City FROM customers WHERE City IS NOT NULL GROUP BY 1
)
SELECT COUNT(c.City) INTO v_max FROM cities c;

while v_min <= v_max DO
	SELECT DISTINCT ci.latitudes , ci.longitudes INTO v_latitude , v_longitude FROM customers c JOIN cities ci
    ON c.City = ci.city LIMIT v_min,1;
    
    SET v_geo = (6371 * acos( 
                cos( radians(v_latitude_2) ) 
              * cos( radians( v_latitude ) ) 
              * cos( radians(v_longitude_2 - v_longitude) ) 
              + sin( radians(v_latitude_2) ) 
              * sin( radians( v_latitude ))));
	
	IF v_geo < v_geo_min THEN
		SET v_geo_min = v_geo;
        IF v_geo_min < 10 THEN
			SELECT "ALREADY OPENED" INTO v_city;
		ELSE 
			SELECT DISTINCT ci.city INTO v_city FROM customers c JOIN cities ci
			ON c.City = ci.city 
            LIMIT v_min,1;
		END IF;
	END IF;
    SET v_min = v_min + 1;    
END WHILE;
	IF v_city != "ALREADY OPENED" THEN
		SELECT
			v_city as ClosestCity,
			p.ProductName,
			SUM(od.Quantity) as QuantitySum
		FROM
			customers c
			JOIN orders o
			ON c.CustomerID = o.CustomerID
			JOIN order_details od
			ON o.OrderID = od.OrderID
			JOIN products p
			ON od.ProductID = p.ProductID
			AND c.City = v_city
		GROUP BY
			1,2
		ORDER BY
			3 desc
		LIMIT
			1,3;
	ELSE
		SELECT
			city_name as City,
			p.ProductName,
			SUM(od.Quantity) as QuantitySum
		FROM
			customers c
			JOIN orders o
			ON c.CustomerID = o.CustomerID
			JOIN order_details od
			ON o.OrderID = od.OrderID
			JOIN products p
			ON od.ProductID = p.ProductID
			AND c.City = city_name
		GROUP BY    
			1,2
		ORDER BY
			3 desc
		LIMIT
			1,3;
    END IF;   
END //

CALL Geospatial('Berlin',@v_city);






#2
#If the date of the transaction is no more than 30 days from the inputted date, refundable will be set to 1, otherwise it will be set to 0!   
DELIMITER //
CREATE PROCEDURE Customer_Service (IN customerName VARCHAR(255) , IN orderid INT, IN date_v DATE)
BEGIN
	SELECT s.SupplierID, s.CompanyName , s.Phone,
    CASE 
    WHEN ABS(DATEDIFF(date_v , o.ShippedDate )) <= 30 THEN 1 
    ELSE 0
	END AS Refundable
	FROM northwind.suppliers s
	JOIN northwind.products p ON p.SupplierID = s.SupplierID
	JOIN northwind.order_details od ON p.ProductID = od.ProductID
	JOIN northwind.orders o ON od.OrderID = o.OrderID
	JOIN northwind.customers c ON o.CustomerID = c.CustomerID
    AND c.ContactName = customerName
    AND o.orderID = orderid;

END //

--A New Column Is Added To Ensure That Previous IDs Are Stored
ALTER TABLE Products
ADD COLUMN Old_CategoryID
INTEGER;

--Previous Category IDs Are Assigned To A New Created Column
UPDATE
Products
SET Old_CategoryID=CategoryID;

--To Observe What We Have
SELECT
CategoryID
FROM
Products
GROUP BY
CategoryID

--CategoryID's Are Assigned NewCategoryID's As Expected
UPDATE Products
SET CategoryID=
CASE
WHEN CategoryID='bakery' THEN 5
WHEN CategoryID='dairy' THEN 4
WHEN CategoryID='fruit' THEN 'No Category, New ID=1'
WHEN CategoryID='meat' THEN 6
WHEN CategoryID='vegan' THEN 'No Category, New ID=9'
WHEN CategoryID='vegetable' THEN 'No Category, New ID=1'
ELSE CategoryID
END 

--CategoryID's Are Assigned NewCategoryID's As Expected
UPDATE  Products
SET
CategoryID=
CASE
WHEN CategoryID=1 THEN 2
WHEN CategoryID=2 THEN 3
WHEN CategoryID=3 THEN 0
WHEN CategoryID=4 THEN 5
WHEN CategoryID=5 THEN 6
WHEN CategoryID=6 THEN 7
WHEN CategoryID=7 THEN 8
WHEN CategoryID=8 THEN 4
WHEN CategoryID='No Category, New ID=1' THEN 1
WHEN CategoryID='No Category, New ID=9' THEN 9
ELSE 'ERROR'
END

--CATEGORY

--A New Column Is Added To Ensure That Previous IDs Are Stored
ALTER TABLE Categories
ADD COLUMN Old_CategoryID INTEGER;

--New Categories Are Added
INSERT INTO Categories (CategoryID,CategoryName,Description) VALUES
(9,'Vegan','Does not contain any animal or animal-derived ...');

INSERT INTO Categories (CategoryID,CategoryName,Description) VALUES
(0,'Vegetables/Fruits','Raw or prepared vegetables and fruits');


--Previous Category IDs Are Assigned To A New Created Column
UPDATE Categories
SET Old_CategoryID = CategoryID

--Category Names Are Updated
UPDATE Categories
SET CategoryName = 'Produce Dried'
WHERE CategoryID = 7;

UPDATE Categories
SET CategoryName = 'Seafood/Seaweed'
WHERE CategoryID = 8;


--CategoryID's Are Assigned NewCategoryID's As Expected
UPDATE Categories
SET CategoryID =
(CASE
WHEN (Old_CategoryID = 0) THEN 1
WHEN (Old_CategoryID = 1) THEN 2
WHEN (Old_CategoryID = 2) THEN 3
WHEN (Old_CategoryID = 3) THEN 0
WHEN (Old_CategoryID = 4) THEN 5
WHEN (Old_CategoryID = 5) THEN 6
WHEN (Old_CategoryID = 6) THEN 7
WHEN (Old_CategoryID = 7) THEN 8
WHEN (Old_CategoryID = 8) THEN 4
WHEN (Old_CategoryID = 9) THEN 9
ELSE Old_CategoryID
END);



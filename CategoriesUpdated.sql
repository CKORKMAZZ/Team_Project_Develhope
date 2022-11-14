--New Categories Are Added
INSERT INTO Categories (CategoryID,CategoryName,Description) VALUES
(9,'Vegan','Does not contain any animal or animal-derived ...');

INSERT INTO Categories (CategoryID,CategoryName,Description) VALUES
(0,'Vegetables/Fruits','Raw or prepared vegetables and fruits');

--A New Column Is Added
ALTER TABLE Categories
ADD COLUMN NewCategoryID INTEGER;

--Category Names Are Updated
UPDATE Categories
SET CategoryName = 'Produce Dried'
WHERE CategoryID = 7;

UPDATE Categories
SET CategoryName = 'Seafood/Seaweed'
WHERE CategoryID = 8;

--CategoryID's Is Assigned NewCategoryID's As Expected
UPDATE Categories
SET NewCategoryID =
(CASE
WHEN (CategoryID = 0) THEN 1
WHEN (CategoryID = 1) THEN 2
WHEN (CategoryID = 2) THEN 3
WHEN (CategoryID = 3) THEN 0
WHEN (CategoryID = 4) THEN 5
WHEN (CategoryID = 5) THEN 6
WHEN (CategoryID = 6) THEN 7
WHEN (CategoryID = 7) THEN 8
WHEN (CategoryID = 8) THEN 4
WHEN (CategoryID = 9) THEN 9
ELSE CategoryID
END)
WHERE CategoryID IS NOT NULL;



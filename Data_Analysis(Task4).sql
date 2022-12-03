-- Creating new (Supplies) table with references.

CREATE TABLE "Supplies" (
    "SupplyOrderID"    INTEGER NOT NULL UNIQUE,
    "SupplierID"    INTEGER NOT NULL,
    "ProductID"    INTEGER NOT NULL,
    "SupplyOrderDate"    DATE,
    "SupplyRequiredDate"    DATE,
    "SupplyShippedDate"    DATE,
    "SupplyFreight"    FLOAT,
    "ShipperID"    INTEGER,
    "ShipRegion"    TEXT,
    "ShipCountry"    TEXT,
    "ShipCity"    TEXT,
    "ShipAddress"    TEXT,
    FOREIGN KEY("SupplierID") REFERENCES "Suppliers"("SupplierID"),
    FOREIGN KEY("ShipperID") REFERENCES "Shippers"("ShipperID"),
    FOREIGN KEY("ProductID") REFERENCES "Products"("ProductID"),
    PRIMARY KEY("SupplyOrderID" AUTOINCREMENT)
);

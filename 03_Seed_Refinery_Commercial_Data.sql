USE OmanOilGasDB;
GO

-- Helper seed values are generated using deterministic T-SQL expressions.
-- Each section inserts exactly 5,000 records per table.-- 15. RefineryBatches: 5,000 records
DECLARE @i INT = 1;
WHILE @i <= 5000
BEGIN
    DECLARE @start DATETIME2 = DATEADD(HOUR, -(@i % 4000), CAST('2026-06-30T08:00:00' AS DATETIME2));
    INSERT INTO dbo.RefineryBatches (UnitID, InputProductID, OutputProductID, BatchStart, BatchEnd, InputVolumeBBL, OutputVolumeBBL, EnergyConsumedMWh, Status)
    VALUES (
        ((@i * 43 - 1) % 5000) + 1,
        ((@i * 47 - 1) % 5000) + 1,
        ((@i * 53 - 1) % 5000) + 1,
        @start,
        CASE WHEN @i % 4 = 0 THEN NULL ELSE DATEADD(HOUR, 12 + (@i % 24), @start) END,
        CAST(5000 + (@i % 8000) * 1.5 AS DECIMAL(18,2)),
        CAST((5000 + (@i % 8000) * 1.5) * (0.82 + ((@i % 12) / 100.0)) AS DECIMAL(18,2)),
        CAST(100 + (@i % 900) * 2.5 AS DECIMAL(18,2)),
        CHOOSE((@i % 4) + 1, 'Running','Completed','Quality Hold','Cancelled')
    );
    SET @i += 1;
END;
GO

-- 16. InventoryTransactions: 5,000 records
DECLARE @i INT = 1;
WHILE @i <= 5000
BEGIN
    INSERT INTO dbo.InventoryTransactions (TransactionDate, SiteID, ProductID, TransactionType, Quantity, UnitOfMeasure, ReferenceDocument, CreatedByEmployeeID)
    VALUES (
        DATEADD(HOUR, -(@i % 6000), CAST('2026-06-30T08:00:00' AS DATETIME2)),
        ((@i * 59 - 1) % 5000) + 1,
        ((@i * 61 - 1) % 5000) + 1,
        CHOOSE((@i % 5) + 1, 'Receipt','Issue','Transfer In','Transfer Out','Adjustment'),
        CAST(50 + (@i % 2000) * 3.25 AS DECIMAL(18,3)),
        CHOOSE((@i % 5) + 1, 'BBL','MT','MMBTU','M3','Litre'),
        CONCAT('REF-DOC-', RIGHT('000000' + CAST(@i AS VARCHAR(6)),6)),
        ((@i * 67 - 1) % 5000) + 1
    );
    SET @i += 1;
END;
GO

-- 17. Shipments: 5,000 records
DECLARE @i INT = 1;
WHILE @i <= 5000
BEGIN
    INSERT INTO dbo.Shipments (ShipmentDate, CustomerID, ProductID, FromSiteID, TransportMode, Quantity, UnitPriceOMR, CurrencyCode, DeliveryStatus)
    VALUES (
        DATEADD(DAY, -(@i % 450), CAST('2026-06-30' AS DATE)),
        ((@i * 71 - 1) % 5000) + 1,
        ((@i * 73 - 1) % 5000) + 1,
        ((@i * 79 - 1) % 5000) + 1,
        CHOOSE((@i % 4) + 1, 'Pipeline','Road Tanker','Marine Vessel','Rail'),
        CAST(100 + (@i % 5000) * 2.8 AS DECIMAL(18,3)),
        CAST(20 + (@i % 120) * 0.75 AS DECIMAL(18,3)),
        CHOOSE((@i % 4) + 1, 'OMR','USD','AED','EUR'),
        CHOOSE((@i % 5) + 1, 'Planned','Dispatched','Delivered','Delayed','Cancelled')
    );
    SET @i += 1;
END;
GO

-- 18. PurchaseOrders: 5,000 records
DECLARE @i INT = 1;
WHILE @i <= 5000
BEGIN
    INSERT INTO dbo.PurchaseOrders (PODate, SupplierID, DepartmentID, BuyerEmployeeID, POStatus, TotalAmountOMR)
    VALUES (
        DATEADD(DAY, -(@i % 540), CAST('2026-06-30' AS DATE)),
        ((@i * 83 - 1) % 5000) + 1,
        ((@i * 89 - 1) % 5000) + 1,
        ((@i * 97 - 1) % 5000) + 1,
        CHOOSE((@i % 5) + 1, 'Draft','Approved','Partially Received','Closed','Cancelled'),
        CAST(500 + (@i % 2500) * 8.6 AS DECIMAL(18,3))
    );
    SET @i += 1;
END;
GO

-- 19. PurchaseOrderLines: 5,000 records
DECLARE @i INT = 1;
WHILE @i <= 5000
BEGIN
    INSERT INTO dbo.PurchaseOrderLines (PurchaseOrderID, LineNo, ItemDescription, Quantity, UnitPriceOMR, RequiredDate, ReceivedQuantity)
    VALUES (
        ((@i - 1) % 5000) + 1,
        1,
        CONCAT(CHOOSE((@i % 10) + 1, 'Valve spare kit','Pump seal','Compressor filter','Safety helmet','Chemical additive','Flow meter','Gasket set','Control module','Pipe fitting','Lab reagent'), ' - dummy line ', @i),
        CAST(1 + (@i % 100) AS DECIMAL(18,3)),
        CAST(5 + (@i % 500) * 1.25 AS DECIMAL(18,3)),
        DATEADD(DAY, (@i % 120), CAST('2026-06-30' AS DATE)),
        CAST(CASE WHEN @i % 4 = 0 THEN 0 ELSE 1 + (@i % 80) END AS DECIMAL(18,3))
    );
    SET @i += 1;
END;
GO
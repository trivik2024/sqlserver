USE OmanOilGasDB;
GO

-- Performance indexes for common reporting and operational queries
CREATE INDEX IX_ProductionDaily_Date_Well ON dbo.ProductionDaily (ProductionDate, WellID) INCLUDE (OilBarrels, GasMMscf, WaterBarrels, DowntimeHours);
CREATE INDEX IX_ProductionDaily_Site_Date ON dbo.ProductionDaily (SiteID, ProductionDate);
CREATE INDEX IX_WellMaintenance_Status_Date ON dbo.WellMaintenance (Status, PlannedStartDate) INCLUDE (CostOMR);
CREATE INDEX IX_HSEIncidents_Date_Severity ON dbo.HSEIncidents (IncidentDate, Severity, IncidentType);
CREATE INDEX IX_LabQualityTests_Product_Date ON dbo.LabQualityTests (ProductID, SampleDate) INCLUDE (ResultStatus, SulphurPercent, WaterContentPercent);
CREATE INDEX IX_RefineryBatches_Unit_Start ON dbo.RefineryBatches (UnitID, BatchStart) INCLUDE (InputVolumeBBL, OutputVolumeBBL, Status);
CREATE INDEX IX_InventoryTransactions_Product_Date ON dbo.InventoryTransactions (ProductID, TransactionDate) INCLUDE (Quantity, TransactionType);
CREATE INDEX IX_Shipments_Customer_Date ON dbo.Shipments (CustomerID, ShipmentDate) INCLUDE (Quantity, UnitPriceOMR, DeliveryStatus);
CREATE INDEX IX_PurchaseOrders_Supplier_Date ON dbo.PurchaseOrders (SupplierID, PODate) INCLUDE (POStatus, TotalAmountOMR);
GO

-- View: daily production summary by site
CREATE OR ALTER VIEW dbo.vw_DailyProductionBySite
AS
SELECT
    pd.ProductionDate,
    s.SiteID,
    s.SiteName,
    s.Governorate,
    COUNT(DISTINCT pd.WellID) AS ProducingWellCount,
    SUM(pd.OilBarrels) AS TotalOilBarrels,
    SUM(pd.GasMMscf) AS TotalGasMMscf,
    SUM(pd.WaterBarrels) AS TotalWaterBarrels,
    SUM(pd.DowntimeHours) AS TotalDowntimeHours
FROM dbo.ProductionDaily pd
INNER JOIN dbo.Sites s ON pd.SiteID = s.SiteID
GROUP BY pd.ProductionDate, s.SiteID, s.SiteName, s.Governorate;
GO

-- View: refinery yield by batch
CREATE OR ALTER VIEW dbo.vw_RefineryBatchYield
AS
SELECT
    rb.BatchID,
    rb.BatchNo,
    ru.UnitName,
    rb.BatchStart,
    rb.BatchEnd,
    ip.ProductName AS InputProduct,
    op.ProductName AS OutputProduct,
    rb.InputVolumeBBL,
    rb.OutputVolumeBBL,
    CAST((rb.OutputVolumeBBL / NULLIF(rb.InputVolumeBBL, 0)) * 100 AS DECIMAL(10,2)) AS YieldPercent,
    rb.EnergyConsumedMWh,
    rb.Status
FROM dbo.RefineryBatches rb
INNER JOIN dbo.RefineryUnits ru ON rb.UnitID = ru.UnitID
INNER JOIN dbo.Products ip ON rb.InputProductID = ip.ProductID
INNER JOIN dbo.Products op ON rb.OutputProductID = op.ProductID;
GO

-- View: open HSE incidents
CREATE OR ALTER VIEW dbo.vw_OpenHSEIncidents
AS
SELECT
    h.IncidentID,
    h.IncidentNo,
    h.IncidentDate,
    s.SiteName,
    d.DepartmentName,
    h.IncidentType,
    h.Severity,
    e.FullName AS ReportedBy,
    h.Description,
    h.CorrectiveAction,
    h.ClosureStatus
FROM dbo.HSEIncidents h
INNER JOIN dbo.Sites s ON h.SiteID = s.SiteID
INNER JOIN dbo.Departments d ON h.DepartmentID = d.DepartmentID
INNER JOIN dbo.Employees e ON h.ReportedByEmployeeID = e.EmployeeID
WHERE h.ClosureStatus <> 'Closed';
GO

-- Validation: expected 5,000 rows in every table
SELECT 'Sites' AS TableName, COUNT(*) AS RowCount FROM dbo.Sites UNION ALL
SELECT 'Departments', COUNT(*) FROM dbo.Departments UNION ALL
SELECT 'Employees', COUNT(*) FROM dbo.Employees UNION ALL
SELECT 'Equipment', COUNT(*) FROM dbo.Equipment UNION ALL
SELECT 'Wells', COUNT(*) FROM dbo.Wells UNION ALL
SELECT 'Pipelines', COUNT(*) FROM dbo.Pipelines UNION ALL
SELECT 'RefineryUnits', COUNT(*) FROM dbo.RefineryUnits UNION ALL
SELECT 'Products', COUNT(*) FROM dbo.Products UNION ALL
SELECT 'Suppliers', COUNT(*) FROM dbo.Suppliers UNION ALL
SELECT 'Customers', COUNT(*) FROM dbo.Customers UNION ALL
SELECT 'ProductionDaily', COUNT(*) FROM dbo.ProductionDaily UNION ALL
SELECT 'WellMaintenance', COUNT(*) FROM dbo.WellMaintenance UNION ALL
SELECT 'HSEIncidents', COUNT(*) FROM dbo.HSEIncidents UNION ALL
SELECT 'LabQualityTests', COUNT(*) FROM dbo.LabQualityTests UNION ALL
SELECT 'RefineryBatches', COUNT(*) FROM dbo.RefineryBatches UNION ALL
SELECT 'InventoryTransactions', COUNT(*) FROM dbo.InventoryTransactions UNION ALL
SELECT 'Shipments', COUNT(*) FROM dbo.Shipments UNION ALL
SELECT 'PurchaseOrders', COUNT(*) FROM dbo.PurchaseOrders UNION ALL
SELECT 'PurchaseOrderLines', COUNT(*) FROM dbo.PurchaseOrderLines;
GO
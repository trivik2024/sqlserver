USE OmanOilGasDB;
GO

-- Helper seed values are generated using deterministic T-SQL expressions.
-- Each section inserts exactly 5,000 records per table.-- 11. ProductionDaily: 5,000 records
DECLARE @i INT = 1;
WHILE @i <= 5000
BEGIN
    INSERT INTO dbo.ProductionDaily (ProductionDate, WellID, SiteID, OilBarrels, GasMMscf, WaterBarrels, DowntimeHours, OperatorEmployeeID, Remarks)
    VALUES (
        DATEADD(DAY, -(@i % 365), CAST('2026-06-30' AS DATE)),
        ((@i * 3 - 1) % 5000) + 1,
        ((@i * 5 - 1) % 5000) + 1,
        CAST(100 + (@i % 2500) * 1.37 AS DECIMAL(18,2)),
        CAST(0.5 + (@i % 400) * 0.08 AS DECIMAL(18,3)),
        CAST(20 + (@i % 1200) * 0.55 AS DECIMAL(18,2)),
        CAST((@i % 12) * 0.5 AS DECIMAL(6,2)),
        ((@i * 7 - 1) % 5000) + 1,
        CONCAT('Daily production record generated for operational testing batch ', @i)
    );
    SET @i += 1;
END;
GO

-- 12. WellMaintenance: 5,000 records
DECLARE @i INT = 1;
WHILE @i <= 5000
BEGIN
    INSERT INTO dbo.WellMaintenance (WellID, EquipmentID, MaintenanceType, PlannedStartDate, ActualCompletionDate, CostOMR, SupervisorEmployeeID, Status)
    VALUES (
        ((@i * 11 - 1) % 5000) + 1,
        ((@i * 13 - 1) % 5000) + 1,
        CHOOSE((@i % 5) + 1, 'Preventive','Corrective','Inspection','Calibration','Workover'),
        DATEADD(DAY, -(@i % 500), CAST('2026-06-30' AS DATE)),
        CASE WHEN @i % 5 IN (0,1,2) THEN DATEADD(DAY, -((@i % 500) - 3), CAST('2026-06-30' AS DATE)) ELSE NULL END,
        CAST(100 + (@i % 1000) * 12.75 AS DECIMAL(18,3)),
        ((@i * 17 - 1) % 5000) + 1,
        CHOOSE((@i % 5) + 1, 'Planned','In Progress','Completed','Deferred','Cancelled')
    );
    SET @i += 1;
END;
GO

-- 13. HSEIncidents: 5,000 records
DECLARE @i INT = 1;
WHILE @i <= 5000
BEGIN
    INSERT INTO dbo.HSEIncidents (IncidentDate, SiteID, DepartmentID, IncidentType, Severity, ReportedByEmployeeID, Description, CorrectiveAction, ClosureStatus)
    VALUES (
        DATEADD(DAY, -(@i % 900), CAST('2026-06-30' AS DATE)),
        ((@i * 19 - 1) % 5000) + 1,
        ((@i * 23 - 1) % 5000) + 1,
        CHOOSE((@i % 8) + 1, 'Near Miss','First Aid','Medical Treatment','Lost Time Injury','Spill','Fire','Vehicle','Gas Release'),
        CHOOSE((@i % 4) + 1, 'Low','Medium','High','Critical'),
        ((@i * 29 - 1) % 5000) + 1,
        CONCAT('Dummy HSE incident description for trend analysis and dashboard testing ', @i),
        CONCAT('Corrective action assigned and tracked for incident ', @i),
        CHOOSE((@i % 3) + 1, 'Open','Under Investigation','Closed')
    );
    SET @i += 1;
END;
GO

-- 14. LabQualityTests: 5,000 records
DECLARE @i INT = 1;
WHILE @i <= 5000
BEGIN
    INSERT INTO dbo.LabQualityTests (SampleDate, ProductID, SiteID, DensityKgM3, SulphurPercent, WaterContentPercent, FlashPointC, TestedByEmployeeID, ResultStatus)
    VALUES (
        DATEADD(DAY, -(@i % 365), CAST('2026-06-30' AS DATE)),
        ((@i * 31 - 1) % 5000) + 1,
        ((@i * 37 - 1) % 5000) + 1,
        CAST(650 + (@i % 450) * 0.77 AS DECIMAL(10,3)),
        CAST((@i % 600) / 1000.0 AS DECIMAL(8,4)),
        CAST((@i % 120) / 1000.0 AS DECIMAL(8,4)),
        CAST(35 + (@i % 120) * 0.5 AS DECIMAL(8,2)),
        ((@i * 41 - 1) % 5000) + 1,
        CHOOSE((@i % 3) + 1, 'Pass','Fail','Retest')
    );
    SET @i += 1;
END;
GO
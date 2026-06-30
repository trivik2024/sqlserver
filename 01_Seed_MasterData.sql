USE OmanOilGasDB;
GO

-- Helper seed values are generated using deterministic T-SQL expressions.
-- Each section inserts exactly 5,000 records per table.DECLARE @i INT;

-- 1. Sites: 5,000 records
SET @i = 1;
WHILE @i <= 5000
BEGIN
    INSERT INTO dbo.Sites (SiteName, SiteType, Wilayat, Governorate, Latitude, Longitude, CommissionedDate, IsActive)
    VALUES (
        CONCAT(CHOOSE((@i % 10) + 1, 'Nimr', 'Fahud', 'Marmul', 'Yibal', 'Sohar', 'Mina Al Fahal', 'Duqm', 'Rusayl', 'Qarn Alam', 'Khazzan'), ' Asset ', @i),
        CHOOSE((@i % 7) + 1, 'Field','Refinery','Terminal','Depot','Office','Port','Storage'),
        CHOOSE((@i % 10) + 1, 'Muscat','Sohar','Duqm','Nizwa','Salalah','Adam','Ibri','Sur','Buraimi','Haima'),
        CHOOSE((@i % 8) + 1, 'Muscat','Al Batinah North','Al Wusta','Ad Dakhiliyah','Dhofar','Ad Dhahirah','Ash Sharqiyah South','Al Buraimi'),
        CAST(16.50 + ((@i % 900) / 100.0) AS DECIMAL(9,6)),
        CAST(52.00 + ((@i % 700) / 100.0) AS DECIMAL(9,6)),
        DATEADD(DAY, -(@i % 7300), CAST('2026-06-30' AS DATE)),
        CASE WHEN @i % 17 = 0 THEN 0 ELSE 1 END
    );
    SET @i += 1;
END;
GO

-- 2. Departments: 5,000 records
DECLARE @i INT = 1;
WHILE @i <= 5000
BEGIN
    INSERT INTO dbo.Departments (DepartmentName, FunctionArea, SiteID, AnnualBudgetOMR, IsActive)
    VALUES (
        CONCAT(CHOOSE((@i % 10) + 1, 'Production','Refinery Operations','Maintenance','HSE','Finance','Supply Chain','Human Resources','Information Technology','Commercial','Projects'), ' Department ', @i),
        CHOOSE((@i % 10) + 1, 'Operations','Refinery','Maintenance','HSE','Finance','Supply Chain','HR','IT','Commercial','Projects'),
        ((@i - 1) % 5000) + 1,
        CAST(50000 + (@i * 137.25) AS DECIMAL(18,3)),
        CASE WHEN @i % 29 = 0 THEN 0 ELSE 1 END
    );
    SET @i += 1;
END;
GO

-- 3. Employees: 5,000 records
DECLARE @i INT = 1;
WHILE @i <= 5000
BEGIN
    INSERT INTO dbo.Employees (FullName, JobTitle, DepartmentID, SiteID, HireDate, ShiftPattern, Email, Phone, IsActive)
    VALUES (
        CONCAT(CHOOSE((@i % 12) + 1, 'Ahmed','Salim','Khalid','Fatma','Aisha','Mariam','Vivek','Rahul','Sarah','John','Omar','Noor'), ' ', CHOOSE((@i % 12) + 1, 'Al Harthy','Al Balushi','Al Rawahi','Al Siyabi','Al Hinai','Trivedi','Sharma','Khan','Thomas','Wilson','Al Ajmi','Patel'), ' ', @i),
        CHOOSE((@i % 12) + 1, 'Production Operator','Control Room Operator','Maintenance Technician','Process Engineer','HSE Officer','Lab Analyst','Planner','Buyer','Pipeline Technician','Refinery Supervisor','Inventory Controller','Finance Analyst'),
        ((@i - 1) % 5000) + 1,
        ((@i * 3 - 1) % 5000) + 1,
        DATEADD(DAY, -(@i % 6000), CAST('2026-06-30' AS DATE)),
        CHOOSE((@i % 4) + 1, 'Day','Night','Rotational','Office'),
        CONCAT('employee', @i, '@oman-oil-demo.local'),
        CONCAT('+968-9', RIGHT('0000000' + CAST(@i AS VARCHAR(7)), 7)),
        CASE WHEN @i % 23 = 0 THEN 0 ELSE 1 END
    );
    SET @i += 1;
END;
GO

-- 4. Equipment: 5,000 records
DECLARE @i INT = 1;
WHILE @i <= 5000
BEGIN
    INSERT INTO dbo.Equipment (EquipmentName, EquipmentType, SiteID, Manufacturer, InstalledDate, Criticality, Status)
    VALUES (
        CONCAT(CHOOSE((@i % 10) + 1, 'Main','Auxiliary','Emergency','Booster','Transfer','Feed','Cooling','Gas','Crude','Utility'), ' ', CHOOSE((@i % 10) + 1, 'Pump','Compressor','Separator','Turbine','Heat Exchanger','Tank','Valve','Generator','Meter','Control System'), ' ', @i),
        CHOOSE((@i % 10) + 1, 'Pump','Compressor','Separator','Turbine','Heat Exchanger','Tank','Valve','Generator','Meter','Control System'),
        ((@i * 5 - 1) % 5000) + 1,
        CHOOSE((@i % 8) + 1, 'Siemens','ABB','Schneider','Honeywell','Emerson','GE','Yokogawa','Flowserve'),
        DATEADD(DAY, -(@i % 5000), CAST('2026-06-30' AS DATE)),
        CHOOSE((@i % 4) + 1, 'Low','Medium','High','Safety Critical'),
        CHOOSE((@i % 4) + 1, 'Running','Standby','Maintenance','Out of Service')
    );
    SET @i += 1;
END;
GO

-- 5. Wells: 5,000 records
DECLARE @i INT = 1;
WHILE @i <= 5000
BEGIN
    INSERT INTO dbo.Wells (WellName, FieldSiteID, WellType, SpudDate, DepthMeters, Status, Reservoir)
    VALUES (
        CONCAT(CHOOSE((@i % 8) + 1, 'Nimr','Fahud','Marmul','Yibal','Qarn Alam','Lekhwair','Daleel','Khazzan'), '-W-', RIGHT('00000' + CAST(@i AS VARCHAR(5)),5)),
        ((@i * 7 - 1) % 5000) + 1,
        CHOOSE((@i % 5) + 1, 'Oil Producer','Gas Producer','Water Injector','Gas Injector','Exploration'),
        DATEADD(DAY, -(@i % 8000), CAST('2026-06-30' AS DATE)),
        CAST(1200 + (@i % 4200) AS DECIMAL(10,2)),
        CHOOSE((@i % 5) + 1, 'Producing','Shut-in','Drilling','Suspended','Abandoned'),
        CHOOSE((@i % 8) + 1, 'Shuaiba','Natih','Gharif','Haima','Amin','Khuff','Ara','Mishrif')
    );
    SET @i += 1;
END;
GO

-- 6. Pipelines: 5,000 records
DECLARE @i INT = 1;
WHILE @i <= 5000
BEGIN
    INSERT INTO dbo.Pipelines (PipelineName, FromSiteID, ToSiteID, ProductCategory, LengthKM, DiameterInches, MaxPressureBar, Status)
    VALUES (
        CONCAT('Pipeline Corridor ', @i),
        ((@i * 11 - 1) % 5000) + 1,
        ((@i * 13 - 1) % 5000) + 1,
        CHOOSE((@i % 5) + 1, 'Crude Oil','Natural Gas','Condensate','Refined Product','Water'),
        CAST(2 + (@i % 450) * 0.75 AS DECIMAL(10,2)),
        CAST(CHOOSE((@i % 6) + 1, 8, 12, 16, 24, 30, 36) AS DECIMAL(10,2)),
        CAST(15 + (@i % 160) AS DECIMAL(10,2)),
        CHOOSE((@i % 4) + 1, 'Active','Maintenance','Idle','Decommissioned')
    );
    SET @i += 1;
END;
GO

-- 7. RefineryUnits: 5,000 records
DECLARE @i INT = 1;
WHILE @i <= 5000
BEGIN
    INSERT INTO dbo.RefineryUnits (UnitName, RefinerySiteID, UnitType, CapacityBarrelsPerDay, CommissionedDate, Status)
    VALUES (
        CONCAT(CHOOSE((@i % 8) + 1, 'CDU','Hydrocracker','Reformer','HDS','Blending','Utilities','Tank Farm','Wastewater'), ' Unit ', @i),
        ((@i * 17 - 1) % 5000) + 1,
        CHOOSE((@i % 8) + 1, 'Crude Distillation','Hydrocracker','Reformer','Desulphurisation','Blending','Utilities','Storage','Wastewater'),
        CAST(10000 + (@i % 240) * 500 AS DECIMAL(18,2)),
        DATEADD(DAY, -(@i % 9000), CAST('2026-06-30' AS DATE)),
        CHOOSE((@i % 4) + 1, 'Running','Planned Shutdown','Maintenance','Standby')
    );
    SET @i += 1;
END;
GO

-- 8. Products: 5,000 records
DECLARE @i INT = 1;
WHILE @i <= 5000
BEGIN
    INSERT INTO dbo.Products (ProductName, ProductCategory, UnitOfMeasure, StandardDensityKgM3, IsHazardous)
    VALUES (
        CONCAT(CHOOSE((@i % 10) + 1, 'Oman Export Blend','Lean Gas','LPG Mix','Light Naphtha','Diesel 10ppm','Jet A1','Gasoline 95','Fuel Oil','Sulphur Granules','Bitumen'), ' Grade ', @i),
        CHOOSE((@i % 10) + 1, 'Crude Oil','Natural Gas','LPG','Naphtha','Diesel','Jet Fuel','Gasoline','Fuel Oil','Sulphur','Bitumen'),
        CHOOSE((@i % 5) + 1, 'BBL','MT','MMBTU','M3','Litre'),
        CAST(650 + (@i % 450) * 0.8 AS DECIMAL(10,3)),
        CASE WHEN @i % 3 = 0 THEN 1 ELSE 0 END
    );
    SET @i += 1;
END;
GO

-- 9. Suppliers: 5,000 records
DECLARE @i INT = 1;
WHILE @i <= 5000
BEGIN
    INSERT INTO dbo.Suppliers (SupplierName, SupplierCategory, Country, ContactEmail, Phone, ApprovedVendor, RiskRating)
    VALUES (
        CONCAT(CHOOSE((@i % 10) + 1, 'Gulf','Oman','Global','Arabian','Muscat','Sohar','Duqm','Energy','Petro','Industrial'), ' Supplier ', @i),
        CHOOSE((@i % 8) + 1, 'Chemicals','Equipment','Maintenance Services','Logistics','IT Services','Safety Supplies','Engineering','Catering'),
        CHOOSE((@i % 9) + 1, 'Oman','UAE','Saudi Arabia','Qatar','India','United Kingdom','Germany','USA','Singapore'),
        CONCAT('supplier', @i, '@vendor-demo.local'),
        CONCAT('+968-2', RIGHT('0000000' + CAST(@i AS VARCHAR(7)), 7)),
        CASE WHEN @i % 19 = 0 THEN 0 ELSE 1 END,
        CHOOSE((@i % 3) + 1, 'Low','Medium','High')
    );
    SET @i += 1;
END;
GO

-- 10. Customers: 5,000 records
DECLARE @i INT = 1;
WHILE @i <= 5000
BEGIN
    INSERT INTO dbo.Customers (CustomerName, CustomerType, Country, ContactEmail, CreditLimitOMR, IsActive)
    VALUES (
        CONCAT(CHOOSE((@i % 10) + 1, 'National','Gulf','Asian','European','Energy','Marine','Industrial','Retail','Government','Global'), ' Customer ', @i),
        CHOOSE((@i % 5) + 1, 'Domestic','Export','Government','Industrial','Retail Distributor'),
        CHOOSE((@i % 10) + 1, 'Oman','UAE','Saudi Arabia','India','China','Japan','South Korea','Singapore','Netherlands','United Kingdom'),
        CONCAT('customer', @i, '@customer-demo.local'),
        CAST(25000 + (@i * 250.75) AS DECIMAL(18,3)),
        CASE WHEN @i % 31 = 0 THEN 0 ELSE 1 END
    );
    SET @i += 1;
END;
GO
# Oman Oil & Natural Gas SQL Server Database Scripts

This zip contains a SQL Server database design for an oil and natural gas company operating in Oman.

## Contents

1. `00_CreateDatabaseAndSchema.sql`  
   Creates database `OmanOilGasDB`, master tables, operations tables, refinery tables, commercial tables and relationships.

2. `01_Seed_MasterData.sql`  
   Inserts 5,000 dummy records into each master table:
   - Sites
   - Departments
   - Employees
   - Equipment
   - Wells
   - Pipelines
   - RefineryUnits
   - Products
   - Suppliers
   - Customers

3. `02_Seed_OperationsData.sql`  
   Inserts 5,000 dummy records into each operations table:
   - ProductionDaily
   - WellMaintenance
   - HSEIncidents
   - LabQualityTests

4. `03_Seed_Refinery_Commercial_Data.sql`  
   Inserts 5,000 dummy records into each refinery, inventory, shipment and procurement table:
   - RefineryBatches
   - InventoryTransactions
   - Shipments
   - PurchaseOrders
   - PurchaseOrderLines

5. `04_Indexes_Views_Validation.sql`  
   Adds useful indexes, creates reporting views and validates row counts.

## How to run

Run the scripts in numeric order in SQL Server Management Studio or Azure Data Studio.

## Design notes

- All data is dummy/synthetic and safe for demos or training.
- The scripts use deterministic T-SQL loops to create 5,000 rows per table.
- Foreign keys are included, so run the scripts in the provided order.
- The design covers upstream production, wells, pipelines, refinery units, production volumes, maintenance, HSE incidents, lab quality, inventory, shipments, customers, suppliers and purchase orders.

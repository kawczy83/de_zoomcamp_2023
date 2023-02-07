create or replace external table `trans-aurora-376318.dezoomcamp.fhv_2019ExternalTable`
options (
  format = 'CSV',
  uris = ['gs://dtc_data_lake_trans-aurora-376318/data/FHV_2019*']
);


--question 1, results = ~43,244,696 rows
select count(*)
from `trans-aurora-376318.dezoomcamp.fhv_2019table`;

--question 2
CREATE OR REPLACE TABLE trans-aurora-376318.dezoomcamp.fhv_2019non_partioned_table AS
SELECT * FROM trans-aurora-376318.dezoomcamp.fhv_2019ExternalTable;

-- Create a partitioned table from external table
CREATE OR REPLACE TABLE trans-aurora-376318.dezoomcamp.fhv_2019partioned_table
PARTITION BY
  DATE(pickup_datetime) AS
SELECT * FROM trans-aurora-376318.dezoomcamp.fhv_2019ExternalTable;

-- Impact of partition
-- Scanning 318 MB of data
SELECT DISTINCT(Affiliated_base_number)
FROM trans-aurora-376318.dezoomcamp.fhv_2019non_partioned_table;

-- Impact of partition
-- Scanning 318 MB of data
SELECT DISTINCT(Affiliated_base_number)
FROM trans-aurora-376318.dezoomcamp.fhv_2019partioned_table;

SELECT DISTINCT(Affiliated_base_number)
FROM trans-aurora-376318.dezoomcamp.fhv_2019ExternalTable;

--question 3 results = 717,748 rows
select count(*)
from trans-aurora-376318.dezoomcamp.fhv_2019ExternalTable
where PUlocationID is null and DOlocationID is null;

--question 5 Write a query to retrieve the distinct affiliated_base_number between pickup_datetime 
--03/01/2019 and 03/31/2019 (inclusive)
CREATE OR REPLACE TABLE trans-aurora-376318.dezoomcamp.fhv_2019partioned_table
PARTITION BY
  DATE(pickup_datetime) 
  CLUSTER BY Affiliated_base_number
  AS
SELECT * FROM trans-aurora-376318.dezoomcamp.fhv_2019ExternalTable;

-- 23.05 MB
SELECT distinct affiliated_base_number
FROM trans-aurora-376318.dezoomcamp.fhv_2019partioned_table
WHERE DATE(pickup_datetime) BETWEEN '2019-03-01' AND '2019-03-31';

-- 647.87 MB
SELECT distinct affiliated_base_number
FROM trans-aurora-376318.dezoomcamp.fhv_2019non_partioned_table
WHERE DATE(pickup_datetime) BETWEEN '2019-03-01' AND '2019-03-31';

{{ config(materialized='view') }}

select  
    dispatching_base_num,

    cast(PUlocationID as INTEGER) as		pickup_locationid	,
    cast(DOlocationID as INTEGER) as		dropoff_locationid	,

    --timestamps
    cast(pickup_datetime as TIMESTAMP) as	pickup_datetime		,	
    cast(dropOff_datetime as TIMESTAMP) as	dropoff_datetime	,		

    -- trip info
    SR_Flag
    from {{ source('staging','fhv_2019non_partioned_table')}}
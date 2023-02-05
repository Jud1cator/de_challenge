--truncate table dds.dds_browser_type cascade;

INSERT INTO dds.dds_browser_type
    ("name")
    select distinct browser_name AS "name"
    FROM staging.stg_events
    where (staging.stg_events.event_timestamp::date = '{{ ds }}'::date) and 
    	browser_name not in (select "name" from  dds.dds_browser_type)
    	

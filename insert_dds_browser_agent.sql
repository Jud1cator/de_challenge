--truncate table dds.dds_browser_agent cascade;

INSERT INTO dds.dds_browser_agent
    ("user_agent","language")
    SELECT distinct 
    	browser_user_agent as user_agent, 
    	browser_language as "language"
    FROM staging.stg_events
    where (staging.stg_events.event_timestamp::date = '2022-09-30'::date) and 
    	browser_user_agent not in (select "user_agent" from dds.dds_browser_agent)
    	

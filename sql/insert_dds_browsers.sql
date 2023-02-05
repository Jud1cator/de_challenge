--truncate table dds.dds_browsers cascade;

INSERT INTO dds.dds_browsers
    (type_id, agent_id)
    with t0 as 
	    (SELECT distinct   	
	    	browser_name,
	    	browser_user_agent,
	    	browser_language
	    FROM staging.stg_events
	    where (staging.stg_events.event_timestamp::date = '2022-09-30'::date)
	    )
    select distinct 	
	    	t1.id as type_id,
	    	t2.id as agent_id
	from t0
	left join dds.dds_browser_type t1 
	    on t0.browser_name = t1."name"
	left join dds.dds_browser_agent  t2 
	    on (t0.browser_user_agent = t2.user_agent) 
	    and (t0.browser_language = t2."language")
 
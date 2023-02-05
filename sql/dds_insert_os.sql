insert into dds.dds_os (type, name)
select 
    distinct os as type, os_name as name
from 
    stg_events se
where
	staging.stg_events.event_timestamp::date = '{{ ds }}'::date
on conflict (type, name) do update set
	type = EXCLUDED.type,
	name = EXCLUDED.name;
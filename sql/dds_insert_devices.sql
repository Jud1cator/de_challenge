insert into dds.dds_devices (type, is_mobile, os_id)
select 
    distinct device_type, device_is_mobile::bool, do2.id
from 
    staging.stg_events se
    left join dds.dds_os do2 on se.os = do2."type"  and se.os_name = do2."name"
where
	staging.stg_events.event_timestamp::date = '{{ ds }}'::date
on conflict (type, os_id) do update set
	type = EXCLUDED.type,
	os_id = EXCLUDED.os_id;
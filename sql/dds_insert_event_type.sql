insert into dds.dds_event_types
(event_type_name)
(select distinct
event_type  as event_type_name
from staging.stg_events
where staging.stg_events.event_timestamp::date = '{{ ds }}'::date)
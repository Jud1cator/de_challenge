
truncate table dds.dds_event_types;
insert into dds.dds_event_types
(event_type_name)
(select distinct
event_type  as event_type_name
from staging.stg_events
where staging.stg_events.event_timestamp::date = '2022-09-30'::date)
on conflict event_type_name do nothing ;


truncate table dds.dds_referer ;
insert into dds.dds_referer
(url, url_scheme, url_port, medium)
(select distinct 
referer_url as url,
referer_url_scheme as url_scheme,
referer_url_port::int as url_port,
referer_medium as medium
from staging.stg_events
where staging.stg_events.event_timestamp::date = '2022-09-30'::date) 
on conflict (url, url_scheme, url_port,medium) do 
update set 
	url = excluded.url,
	url_scheme = excluded.url_scheme,
	url_port = excluded.url_port,
	medium = excluded.medium
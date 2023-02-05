insert into dds.dds_page
(url,url_path)
(select distinct 
page_url as url,
page_url_path as url_path
from staging.stg_events 
where staging.stg_events.event_timestamp::date = '{{ ds }}'::date)
on conflict (url,url_path) do 
update set 
	url = excluded.url,
	url_path = excluded.url_path;

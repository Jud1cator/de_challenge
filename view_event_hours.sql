drop view if exists cdm.events_hours ;
create view cdm.events_hours 
as select
de.event_timestamp::date as report_dt,
date_trunc('hour', de.event_timestamp),
replace(dp.url_path,'/','') as event_type ,
count (de.id) 
from dds.dds_events de 
left join dds.dds_page dp on de.page_url_id = dp.id 
group by de.event_timestamp::date ,date_trunc('hour', de.event_timestamp),replace(dp.url_path,'/','')
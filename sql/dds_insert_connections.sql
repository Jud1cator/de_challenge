insert into dds.dds_connection (
	browser_id,
    device_id,
    user_id,
    ip_address,
    zone_id
)
select
	distinct
	b.id,
	d.id,
	u.id,
	e.ip_address,
	z.id
from
	staging.stg_events e
	inner join dds_browser_type bt on e.browser_name = bt.name
	inner join dds_browser_agent ba on e.browser_user_agent = ba.user_agent and e.browser_language = ba."language" 
	inner join dds_browsers b on bt.id = b.type_id and ba.id = b.agent_id 
	inner join dds_os o on o."type" = e.os and o."name" = e.os_name 
	inner join dds_devices d on d."type" = e.device_type and d.os_id = o.id
	inner join dds_user u on u.custom_id = e.user_custom_id and u.domain_id = e.user_domain_id 
	inner join dds_zones z on z.timezone = e.geo_timezone and z.country = e.geo_country and z.region_name = e.geo_region_name
where
	e.event_timestamp::date = '{{ ds }}'::date
on conflict (browser_id, device_id, user_id, ip_address, zone_id) do update set
	browser_id = EXCLUDED.browser_id,
	device_id = EXCLUDED.device_id,
	user_id = EXCLUDED.user_id,
	ip_address = EXCLUDED.ip_address,
	zone_id = EXCLUDED.zone_id
;

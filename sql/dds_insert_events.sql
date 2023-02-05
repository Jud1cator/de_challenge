insert into dds.dds_events (
	event_timestamp,
	event_type_id,
	referer_id,
	utm_id,
	click_id,
	connection_id,
	page_url_id,
	geo_latitude,
	geo_longitude
)
select
	e.event_timestamp::timestamptz,
	et.id,
	r.id,
	u.id,
	e.click_id,
	c.id,
	p.id,
	e.geo_latitude::numeric(14,5),
	e.geo_longitude::numeric(14,5)
from
	staging.stg_events e
	left join dds.dds_event_types et on e.event_type = et.event_type_name 
	left join dds.dds_referer r on e.referer_url = r.url and e.referer_url_scheme = r.url_scheme and e.referer_url_port::int = r.url_port and e.referer_medium = r.medium 
	left join dds.dds_utm u on e.utm_medium = u.medium and e.utm_source = u."source" and e.utm_campaign = u.campaign and e.utm_content = u."content" 
	left join dds.dds_browser_type bt on e.browser_name = bt.name
	left join dds.dds_browser_agent ba on e.browser_user_agent = ba.user_agent and e.browser_language = ba."language" 
	left join dds.dds_browsers b on bt.id = b.type_id and ba.id = b.agent_id 
	left join dds.dds_os o on o."type" = e.os and o."name" = e.os_name 
	left join dds.dds_devices d on d."type" = e.device_type and d.os_id = o.id
	left join dds.dds_user us on us.custom_id = e.user_custom_id and us.domain_id = e.user_domain_id 
	left join dds.dds_zones z on z.timezone = e.geo_timezone and z.country = e.geo_country and z.region_name = e.geo_region_name
	left join dds.dds_connection c on c.browser_id = b.id and c.device_id = d.id and c.user_id = us.id and c.zone_id = z.id
	left join dds.dds_page p on e.page_url = p.url  and e.page_url_path = p.url_path
where
	e.event_timestamp::date = '{{ ds }}'::date
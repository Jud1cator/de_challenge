insert into dds.dds_zones(
	timezone,
	country,
	region_name
)
select
	distinct
	geo_timezone,
	geo_country,
	geo_region_name
from
	staging.stg_events
where
	staging.stg_events.event_timestamp::date = '{{ ds }}'::date
on conflict (timezone, country, region_name) do update set
	timezone = EXCLUDED.timezone,
	country = EXCLUDED.country,
	region_name = EXCLUDED.region_name
;

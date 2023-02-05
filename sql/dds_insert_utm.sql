insert into dds.dds_utm (medium, source, content, campaign)
select 
    distinct utm_medium as medium, utm_source as source, utm_content as content, utm_campaign as campaign
from 
    staging.stg_events se
where
	staging.stg_events.event_timestamp::date = '{{ ds }}'::date
on conflict (medium, source, content, campaign) do update set
	medium = EXCLUDED.medium,
    content = EXCLUDED.content,
    campaign = EXCLUDED.campaign,
	source = EXCLUDED.source;
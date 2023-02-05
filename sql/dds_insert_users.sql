insert into dds.dds_user(
	custom_id,
	domain_id
)
select
	distinct
	user_custom_id,
	user_domain_id
from
	staging.stg_events
where
	staging.stg_events.event_timestamp::date = '{{ ds }}'::date
on conflict (custom_id, domain_id) do update set
	custom_id = EXCLUDED.custom_id,
	domain_id = EXCLUDED.domain_id
;

-- CDM_2. Витрина "Количество купленных товаров в разрезе часа" --

drop view if exists cdm.purchased_products;
create view cdm.purchased_products as (

with e1 as (
	select 	
		e.event_timestamp,
		left(url_path,8) as url_path,
		c.user_id,
		row_number() over (partition by c.user_id
					order by e.event_timestamp desc)
						as "row_number"
	from dds.dds_events e 
	left join dds.dds_page p on e.page_url_id = p.id
	left join dds.dds_connection c on e.connection_id = c.id
	where url_path = '/confirmation' or left(url_path,8) = '/product'
	)
select 
		date_trunc('hour', event_timestamp) as "hour",
		(count("url_path")-1) as products_purchased
	from e1
	where ("row_number"=1 and url_path = '/confirmation')
		or left(url_path,8) = '/product'
	group by ("hour")
)

--where ("row_number"=1) and (url_path = '/confirmation')
--date_trunc('hour', e.event_timestamp) as "hour",

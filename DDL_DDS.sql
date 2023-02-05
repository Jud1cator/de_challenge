
-- Евгений
--ddl
drop table if exists dds.dds_events;
create table dds.dds_events 
(
id serial primary key ,
event_timestamp timestamp with time zone,
event_type_id int not null,
referer_id int not null,
utm_id int not null,
click_id text not null,
connection_id int not null,
page_url_id int not null

);

--references
alter table dds.dds_events add constraint f_key_dds_events_dds_events_types foreign key (event_type_id) references dds.dds_event_types (id) ON UPDATE cascade;
alter table dds.dds_events add constraint f_key_dds_events_dds_dds_referer foreign key (referer_id) references dds.dds_referer (id) ON UPDATE cascade;
alter table dds.dds_events add constraint f_key_dds_events_dds_dds_utm foreign key (utm_id) references dds.dds_utm (id) ON UPDATE cascade;
alter table dds.dds_events add constraint f_key_dds_events_dds_connection foreign key (connection_id) references dds.dds_connection (id) ON UPDATE cascade;

drop table if exists dds.dds_event_types ;
create table  dds.dds_event_types 
(
id serial primary key,
event_type_name text not null,
constraint event_type_name_unique unique (event_type_name)
);

drop table if exists dds.dds_referer ;
create table  dds.dds_referer
(
id serial primary key,
url text not null,
url_scheme text not null,
url_port int not null,
medium text not null,
constraint dds_referer_unique unique (url,url_scheme,url_port,medium)
);

drop table if exists dds.dds_utm ;
create table dds.dds_utm
(
id serial primary key,
medium  text not null,
source text  not null,
content text not null,
campaign text not null
);

drop table if exists dds.dds_page ;
create table dds.dds_page
(
id serial not null,
url text not null,
url_path text not null)
;


-- Владимир
DROP table if exists dds.dds_connection;
DROP table if exists dds.dds_devices;
DROP table if exists dds.dds_browsers;
DROP table if exists dds.dds_os;
DROP table if exists dds.dds_user;
DROP table if exists dds.dds_zones;
DROP table if exists dds.dds_browser_type;
DROP table if exists dds.dds_browser_agent;


CREATE table if not exists dds.dds_browser_type(
    id   SERIAL,
    "name"  varchar(30),
    PRIMARY KEY (id)
    );
   
CREATE table if not exists dds.dds_browser_agent(
    id   SERIAL,
    user_agent  TEXT,
    language varchar(10),
    PRIMARY KEY (id)
    );
   
CREATE table if not exists dds.dds_browsers(
    id SERIAL,
    type_id bigint,
    agent_id bigint,
    PRIMARY KEY (id),
    FOREIGN KEY (type_id) REFERENCES dds_browser_type(id) ON UPDATE cascade,
    FOREIGN KEY (agent_id) REFERENCES dds_browser_agent(id) ON UPDATE CASCADE
    );   
   
CREATE table if not exists dds.dds_os(
    id   SERIAL,
    "type" varchar(30),
    "name"  varchar(30),
    PRIMARY KEY (id)
    );
   
CREATE table if not exists dds.dds_user(
    id   SERIAL,
    custom_id text,
    domain_id text,
    constraint unique_user unique (custom_id, domain_id),
    PRIMARY KEY (id)
);
   
CREATE table if not exists dds.dds_zones(
    id   SERIAL,
    timezone text,
    country text,
    region_name text,
    constraint unique_zone unique (timezone, country, region_name),
    PRIMARY KEY (id)
);
   
CREATE table if not exists dds.dds_devices(
    id   SERIAL,
    "type" varchar(30),
    is_mobile boolean,
    os_id int8,
    PRIMARY KEY (id),
    FOREIGN KEY (os_id) REFERENCES dds_os(id) ON UPDATE CASCADE
    );
   
CREATE table if not exists dds.dds_connection(
    id   SERIAL,
    browser_id int8,
    device_id int8,
    user_id int8,
    ip_address varchar(15),
    geo_latitude numeric(14,5),
    geo_longtitude numeric(14,5),
    zone_id int8,
    PRIMARY KEY (id),
    FOREIGN KEY (browser_id) REFERENCES dds_browsers(id) ON UPDATE cascade,
    FOREIGN KEY (device_id) REFERENCES dds_devices(id) ON UPDATE cascade,
    FOREIGN KEY (user_id) REFERENCES dds_user(id) ON UPDATE cascade,
    FOREIGN KEY (zone_id) REFERENCES dds_zones(id) ON UPDATE cascade
    );











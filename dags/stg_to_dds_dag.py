from airflow.decorators import dag
from airflow.models import Variable
from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.providers.postgres.operators.postgres import PostgresOperator

import pendulum


@dag(
    schedule_interval="@daily",
    start_date=pendulum.datetime(2023, 2, 4, tz="Europe/Moscow"),
    tags=["de_challenge"],
    is_paused_upon_creation=True,
)
def stg_to_dds():
    # pg_hook = PostgresHook(postgres_conn_id='postgres_conn')

    dds_event_type_op = PostgresOperator(
        task_id='dds_load_event_types',
        postgres_conn_id='postgres_conn',
        database='de',
        sql='sql/dds_insert_event_type.sql'
    )

    dds_referrer_op = PostgresOperator(
        task_id='dds_load_referrer',
        postgres_conn_id='postgres_conn',
        database='de',
        sql='sql/dds_insert_referrer.sql'
    )

    dds_utm_op = PostgresOperator(
        task_id='dds_load_utm',
        postgres_conn_id='postgres_conn',
        database='de',
        sql='sql/dds_insert_utm.sql'
    )

    dds_browser_type_op = PostgresOperator(
        task_id='dds_load_browser_type',
        postgres_conn_id='postgres_conn',
        database='de',
        sql='sql/insert_dds_browser_type.sql'
    )

    dds_browser_agent_op = PostgresOperator(
        task_id='dds_load_browser_agent',
        postgres_conn_id='postgres_conn',
        database='de',
        sql='sql/insert_dds_browser_agent.sql'
    )

    dds_browser_op = PostgresOperator(
        task_id='dds_load_browser',
        postgres_conn_id='postgres_conn',
        database='de',
        sql='sql/insert_dds_browsers.sql'
    )

    dds_os_op = PostgresOperator(
        task_id='dds_load_os',
        postgres_conn_id='postgres_conn',
        database='de',
        sql='sql/dds_insert_os.sql'
    )

    dds_devices_op = PostgresOperator(
        task_id='dds_load_devices',
        postgres_conn_id='postgres_conn',
        database='de',
        sql='sql/dds_insert_devices.sql'
    )

    dds_user_op = PostgresOperator(
        task_id='dds_load_user',
        postgres_conn_id='postgres_conn',
        database='de',
        sql='sql/dds_insert_users.sql'
    )

    dds_zones_op = PostgresOperator(
        task_id='dds_load_zones',
        postgres_conn_id='postgres_conn',
        database='de',
        sql='sql/dds_insert_zones.sql'
    )

    dds_connection_op = PostgresOperator(
        task_id='dds_load_connections',
        postgres_conn_id='postgres_conn',
        database='de',
        sql='sql/dds_insert_connections.sql'
    )

    dds_page_op = PostgresOperator(
        task_id='dds_load_pages',
        postgres_conn_id='postgres_conn',
        database='de',
        sql='sql/dds_insert_page.sql'
    )

    dds_event_op = PostgresOperator(
        task_id='dds_load_events',
        postgres_conn_id='postgres_conn',
        database='de',
        sql='sql/dds_insert_events.sql'
    )

    dds_event_op.set_upstream(
        [
            dds_event_type_op,
            dds_referrer_op,
            dds_utm_op,
            dds_connection_op,
            dds_page_op
        ]
    )

    dds_connection_op.set_upstream(
        [
            dds_browser_op,
            dds_devices_op,
            dds_user_op,
            dds_zones_op
        ]
    )

    dds_browser_op.set_upstream(
        [
            dds_browser_type_op,
            dds_browser_agent_op
        ]
    )

    dds_devices_op.set_upstream(
        [
            dds_os_op
        ]
    )


stg_to_dds_dag = stg_to_dds()

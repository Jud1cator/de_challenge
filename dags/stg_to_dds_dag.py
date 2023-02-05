from airflow.decorators import dag
from airflow.models import Variable
from airflow.providers.ssh.hooks.ssh import SSHHook
from airflow.providers.ssh.operators.ssh import SSHOperator
import pendulum


@dag(
    schedule_interval="@daily",
    start_date=pendulum.datetime(2023, 2, 4, tz="Europe/Moscow"),
    tags=["de_challenge"],
    is_paused_upon_creation=True,
)
def stg_to_dds_dag():

    # Initializing ssh hook to connect to Spark master node
    ssh_hook = SSHHook(
        remote_host=Variable.get("SPARK_MASTER_NODE_IP"),
        username=Variable.get("SPARK_MASTER_NODE_USER"),
        key_file=Variable.get("SPARK_MASTER_NODE_SSH_KEY_FILE")
    )

    # Initializing ssh operator to run spark-submit on master node
    SSHOperator(
        task_id="test_task",
        ssh_hook=ssh_hook,
        command="touch i_was_here"
    )


stg_to_dds_dag_instance = stg_to_dds_dag()

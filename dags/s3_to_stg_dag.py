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
def s3_to_staging():

    # Initializing ssh hook to connect to Spark master node
    ssh_hook = SSHHook(
        remote_host=Variable.get("SPARK_MASTER_NODE_IP"),
        username=Variable.get("SPARK_MASTER_NODE_USER"),
        key_file=Variable.get("SPARK_MASTER_NODE_SSH_KEY_FILE")
    )

    # Initializing ssh operator to run spark-submit on master node
    download = SSHOperator(
        task_id="download_file",
        ssh_hook=ssh_hook,
        command="wget https://storage.yandexcloud.net/hackathon/events-2022-Sep-30-2134.json.zip"
    )

    unzip = SSHOperator(
        task_id="unzip_archive",
        ssh_hook=ssh_hook,
        command="unzip events-2022-Sep-30-2134.json.zip"
    )

    put_to_hdfs = SSHOperator(
        task_id="put_to_hadoop",
        ssh_hook=ssh_hook,
        command="hdfs dfs -put events-2022-Sep-30-2134.json /user/ubuntu/events"
    )

    upload_stg = SSHOperator(
        task_id="upload_stg",
        ssh_hook=ssh_hook,
        imeout=60,
        command="spark-submit --master yarn --name upload_staging de_challenge/jobs/spark_upload_data_to_staging.py"
    )

    download >> unzip >> put_to_hdfs >> upload_stg

s3_to_staging_dag = s3_to_staging()

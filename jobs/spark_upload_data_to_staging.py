import findspark
findspark.init()

import pyspark
import pyspark.sql.functions as F
from pyspark.sql import SparkSession
from pyspark.sql.window import Window


spark = (
    SparkSession.builder 
                .master("yarn")
                .config("spark.jars.packages", "org.postgresql:postgresql:42.4.0")
                .config("spark.driver.cores", "2") 
                .config("spark.driver.memory", "5g") 
                .appName("hackathon_staging") 
                .getOrCreate()
)


def hdfs_file_to_staging(spark: SparkSession):
    df = spark.read.json("/user/ubuntu/events/events-2022-Sep-30-2134.json")

    # write to postgresql
    (
        df
        .write
        .mode("append")
        .jdbc(
            "jdbc:postgresql://158.160.51.203:5432/de",
            "staging.stg_events",
            properties={
                "user": "jovyan",
                "password": "jovyan",
                "driver": "org.postgresql.Driver"
            }
        )
    )

if __name__ == "__main__":
    hdfs_file_to_staging(spark)
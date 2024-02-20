from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from airflow.providers.airbyte.operators.airbyte import AirbyteTriggerSyncOperator
from airflow.operators.dummy_operator import DummyOperator
from airflow.utils.dates import days_ago
import sys
sys.path.insert(0,"/root/airflow/dags/")
import from_sql_transaction as t

membership_conn_id = '6a7b4562-2876-41e3-9644-ac65a9b52367' #replace with Airbyte Connection ID
log_conn_id = '56e2abf1-9b02-4371-b94f-e2bf3353ce77'        #replace with Airbyte Connection ID

with DAG (
    dag_id='Extract_Load_DAG',
    default_args={'owner': 'airflow'},
    schedule=None,
    start_date=days_ago(1)
    ) as dag:
    
    start_operator = DummyOperator(
        task_id='start_excecution',
        dag=dag,
    )
    
    membership_sync = AirbyteTriggerSyncOperator(
        task_id='membership_sync',
        airbyte_conn_id='call-airbyte',
        connection_id=membership_conn_id,
        asynchronous=True
    )

    log_sync = AirbyteTriggerSyncOperator(
        task_id='log_sync',
        airbyte_conn_id='call-airbyte',
        connection_id=log_conn_id,
        asynchronous=True
    )
    
    ingest_transaction = PythonOperator(
        task_id='Extract_and_Load_transaction',
        python_callable=t.main,  
        dag=dag,
    )
    
    end_operator = DummyOperator(
        task_id='end_execution',
        dag=dag,
    )

start_operator >> membership_sync >> log_sync >> ingest_transaction >> end_operator

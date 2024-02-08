from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from airflow.providers.airbyte.operators.airbyte import AirbyteTriggerSyncOperator
from airflow.operators.dummy_operator import DummyOperator
from airflow.utils.dates import days_ago
import sys
sys.path.insert(0,"/root/airflow/dags/")
import from_sql_transaction as t

membership_conn_id = 'bc9c8605-e941-43b7-9a90-3f89510d8825' #ganti dengan connection ID pada airbyte
log_conn_id = '96238542-972f-41e4-9fc4-8c343ad9ad09' #ganti dengan connection ID pada airbyte

with DAG (
    dag_id='sync_dag',
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

from airflow import DAG
from airflow.utils.dates import days_ago
from airflow.operators.python_operator import PythonOperator
from airflow.operators.dummy_operator import DummyOperator
import sys
sys.path.insert(0,"/root/airflow/dags/")
import from_csv_membership as m
import from_json_membership_log as ml
import from_sql_transaction as t

# Define default arguments for the DAG
default_args = { 
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': days_ago(1),
}
# Define the DAG
dag = DAG(
    'ELT_dag',
    default_args=default_args,
    description='ELT DAG to run many task',
    schedule_interval=None,
)
# Define Task
start_operator = DummyOperator(
    task_id='start_excecution',
    dag=dag,
)

ingest_membership = PythonOperator(
    task_id='Extract_and_Load_membership',
    python_callable=m.main,  
    dag=dag,
)

ingest_membership_log = PythonOperator(
    task_id='Extract_and_Load_membership_log',
    python_callable=ml.main,  
    dag=dag,
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
# Create Task Dependencies
start_operator >> ingest_membership >> [ingest_membership_log, ingest_transaction] >> end_operator
from airflow.hooks.postgres_hook import PostgresHook
import pandas as pd

#  Main function that orchestrates the Extract and Load process, so this scripts can be callabe
def main():
    load_data_to_postgres()

def load_data_to_postgres():
    # Get postgres connection from airflow
    pg_hook = PostgresHook(postgres_conn_id='pg_conn')
    
    # Define SQL script to create table in postgres
    create_table_query = '''
    CREATE TABLE IF NOT EXISTS membership_transactions (
        transaction_id SERIAL PRIMARY KEY,
        charge_amount FLOAT,
        currency TEXT,
        membership_id INT REFERENCES membership(membership_id),
        description_event TEXT,
        discount INT,
        status TEXT,
        message TEXT,
        transaction_date TEXT,
        triggered_by TEXT,
        payment_method TEXT
    )
    '''
    # Execute SQL scripts
    path = 'dataset/membership_transactions.sql'
    pg_hook.run(path)
    pg_hook.run(create_table_query)

    #close connection
    pg_hook.get_conn().commit()
    pg_hook.get_conn().close()
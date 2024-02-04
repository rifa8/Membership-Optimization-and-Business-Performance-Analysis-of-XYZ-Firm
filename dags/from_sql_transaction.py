from airflow.hooks.postgres_hook import PostgresHook
import pandas as pd

#  Main function that orchestrates the Extract and Load process, so this scripts can be callabe
def main():
    read_data()
    load_data_to_postgres()

def read_data():
    file_path = 'dataset/membership_transactions.sql'
    with open(file_path, 'r', encoding='utf-8-sig') as file:
        data = file.read()
        queries = data.replace('`', '')
    return queries

def load_data_to_postgres():
    # Get postgres connection from airflow
    pg_hook = PostgresHook(postgres_conn_id='pg_conn')
    
    # Define SQL script to create table in postgres
    create_table_query = '''
    CREATE TABLE IF NOT EXISTS membership_transactions (
        transaction_id SERIAL PRIMARY KEY,
        charge_amount TEXT,
        currency TEXT,
        membership_id INT,
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
    pg_hook.run(create_table_query)
    pg_hook.get_conn().commit()

    # Insert data with one query
    insert_data_query = read_data() 
    pg_hook.run(insert_data_query)
    pg_hook.get_conn().commit()
    
    #close connection
    pg_hook.get_conn().close()
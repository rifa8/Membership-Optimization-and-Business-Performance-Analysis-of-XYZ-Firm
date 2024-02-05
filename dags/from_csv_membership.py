from airflow.hooks.postgres_hook import PostgresHook
import pandas as pd

#  Main function that orchestrates the Extract and Load process, so this scripts can be callabe
def main():
    read_data()
    load_data_to_postgres()

def read_data():
    file_path = '/opt/airflow/dataset/membership.csv'
    data = pd.read_csv(file_path)
    return data

def load_data_to_postgres():
    # Get postgres connection from airflow
    pg_hook = PostgresHook(postgres_conn_id='pg_conn')
    
    # Define SQL script to create table in postgres
    create_table_query = '''
    CREATE TABLE IF NOT EXISTS membership (
        membership_id INT PRIMARY KEY,
        membership_amount INT,
        currency TEXT,
        renewal_cycle INT,
        membership_plan INT,
        creation_date TEXT,
        email TEXT,
        company TEXT,
        billing_address TEXT,
        key_account_manager TEXT,
        animation_team TEXT
    )
    '''
    # Execute SQL scripts
    pg_hook.run(create_table_query)
    pg_hook.get_conn().commit()
    
    data = read_data()

    # Specify the columns to be used as the primary key
    index_columns = ['membership_id']


    # Use the to_sql method to insert data into PostgreSQL
    data.to_sql('membership', con=pg_hook.get_sqlalchemy_engine(), index=False, if_exists='replace', method='multi', chunksize=1000)

    #close connection
    pg_hook.get_conn().commit()
    pg_hook.get_conn().close()
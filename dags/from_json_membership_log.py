from airflow.hooks.postgres_hook import PostgresHook
import pandas as pd
import json

def extract():
    path = 'dataset/membership_log.json'

    with open(path, 'r', encoding='utf-8-sig') as datafile:
        data = json.load(datafile)

    df = pd.DataFrame(data)
    return df

def load_data_to_postgres():
    # Get postgres connection from airflow
    pg_hook = PostgresHook(postgres_conn_id='pg_conn')
    
    # Define SQL script to create table in postgres
    create_table_query = '''
    CREATE TABLE IF NOT EXISTS membership_log (
        log_id serial PRIMARY KEY,
        event_name TEXT,
        upsell_date TEXT,
        new_renewal_cycle INT,
        membership_id INT REFERENCES membership(membership_id),
        membership_amount INT,
        currency INT,
        renews_at TEXT,
        new_plan TEXT,
        churn_date TEXT,
        cancellation_date TEXT,
        log_creation_time TEXT
    )
    '''
    # Execute SQL scripts
    pg_hook.run(create_table_query)

    data = extract()

    # Specify the columns to be used as the primary key
    index_columns = ['log_id']

    # Use the to_sql method to insert data into PostgreSQL
    data.to_sql('membership_log', con=pg_hook.get_sqlalchemy_engine(), index=False, if_exists='replace', method='multi', chunksize=1000)

    #close connection
    pg_hook.get_conn().commit()
    pg_hook.get_conn().close()
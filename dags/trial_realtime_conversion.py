from airflow.hooks.postgres_hook import PostgresHook
import pandas as pd
from forex_python.converter import CurrencyRates

def main():
    read_data()
    load_data_to_postgres()

def read_data():
    file_path = '/opt/airflow/dataset/membership.csv'
    data = pd.read_csv(file_path)
    return data

def convert_to_usd(row):
    currency_rates = CurrencyRates()
    amount_usd = currency_rates.convert(row['currency'], 'USD', row['membership_amount'])
    return amount_usd

def load_data_to_postgres():
    pg_hook = PostgresHook(postgres_conn_id='pg_conn')
    
    create_table_query = '''
    CREATE TABLE IF NOT EXISTS membership (
        membership_id INT PRIMARY KEY,
        membership_amount_usd FLOAT,
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
    pg_hook.run(create_table_query)
    pg_hook.get_conn().commit()
    
    data = read_data()
    
    # Convert currency to USD
    data['membership_amount_usd'] = data.apply(convert_to_usd, axis=1)
    
    index_columns = ['membership_id']
    
    data.to_sql('membership', con=pg_hook.get_sqlalchemy_engine(), index=False, if_exists='replace', method='multi', chunksize=1000)
    
    pg_hook.get_conn().commit()
    pg_hook.get_conn().close()

if __name__ == "__main__":
    main()

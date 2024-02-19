# XYZ Firm Project
This repo is a demonstration of ELT process and data visualization.

# About The Project

PT. XYZ specializes in providing video animation consultation services to its predominantly international client base. They offer membership services and maintain comprehensive data on affiliate businesses and membership statuses. This analysis specifically targets multinational clients headquartered in the United States between 2019 and 2022.

#  Objectives

1. Ensure accurate tracking of PT. XYZ's membership growth and historical data annually from 2019 to 2022. 
2. Calculate the churn rate to find out the annual number of memberships discontinuing their subscriptions to PT. XYZ.
3. Converting and consolidating all payment transactions into revenue calculations in a single currency (USD).
4. Visualize the distribution of memberships based on state, key account manager, and membership plan.

# 🖥️ Tools and Tech

<img alt="Python" src="https://img.shields.io/badge/Python-14354C.svg?logo=python&logoColor=white"></a>
<img alt="Dbeaver" src="https://custom-icon-badges.demolab.com/badge/-Dbeaver-372923?logo=dbeaver-mono&logoColor=white"></a>
<img alt="PostgreSQL" src ="https://img.shields.io/badge/PostgreSQL-316192.svg?logo=postgresql&logoColor=white"></a>
<img alt="DBT" src ="https://img.shields.io/badge/dbt-FF694B.svg?logo=dbt&logoColor=white"></a>
<img alt="Airflow" src ="https://img.shields.io/badge/Airflow-017CEE.svg?logo=Apache-Airflow&logoColor=white">
<img alt="Github" src ="https://img.shields.io/badge/GitHub-181717.svg?logo=GitHub&logoColor=white">
<img alt="Docker" src ="https://img.shields.io/badge/Docker-2496ED.svg?logo=Docker&logoColor=white">
<img alt="Metabase" src ="https://img.shields.io/badge/Metabase-509EE3.svg?logo=Metabase&logoColor=white">
<img alt ="Discord" src ="https://img.shields.io/badge/Discord-5865F2.svg?logo=Discord&logoColor=white">

# 🚀 ELT Process

# 📍 ERD

# 🏃 Run Locally

Clone the project
```
git clone https://github.com/CharisChakim/Membership-Optimization-and-Business-Performance-Analysis-of-XYZ-Firm.git
```

Run docker compose
```
docker compose up -d
```

You can access airflow at `localhost:8080`

After logging in, you can set the PostgreSQL connection in the admin tab and name it as 'pg_conn.' Configure it with settings similar to those in the existing configuration in [docker-compose.yaml](https://github.com/CharisChakim/Membership-Optimization-and-Business-Performance-Analysis-of-XYZ-Firm/blob/main/docker-compose.yaml)

You can run/trigger the Extract_Load_DAG first then dag_dbt after configure it well.

Next, you can access Metabase at localhost:3000. Configure the connection to the PostgreSQL data warehouse.
Unleash your imagination and creativity to visualize data using Metabase.


# 💻 Visualization Sample

# 🧔 Author

- Charis Chakim [![Github Badge](https://img.shields.io/badge/Github-black?logo=github)](https://github.com/CharisChakim)

- Muhammad Rifa [![Github Badge](https://img.shields.io/badge/Github-black?logo=github)](https://github.com/rifa8)

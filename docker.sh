#!/bin/bash
up() {
  echo "Starting Airbyte..."
  source airbyte/.env
  docker compose -f airbyte/docker-compose.yaml down -v
  docker compose -f airbyte/docker-compose.yaml up -d

  echo "Starting Airflow..."
  docker compose -f docker-compose.yaml down -v
  mkdir -p ./dags ./logs ./plugins
  echo -e "AIRFLOW_UID=$(id -u)\nAIRFLOW_GID=0" >> .env
  docker compose -f docker-compose.yaml up airflow-init
  docker compose -f docker-compose.yaml up -d

  echo "Access Airbyte at http://localhost:8000 and set up a connection."
  echo "Access Airflow at http://localhost:8080 to kick off your Airbyte sync DAG."
}

down() {
  echo "Stopping Airbyte..."
  docker compose -f airbyte/docker-compose.yaml down -v
  echo "Stopping Airflow..."
  docker compose -f docker-compose.yaml down -v
}

case $1 in
  up)
    up
    ;;
  down)
    down
    ;;
  *)
    echo "Usage: $0 {up|down}"
    ;;
esac

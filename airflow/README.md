# Airflow Pipeline

.ENV IS INSIDE DAGS FOLDER!!!

- Do checkout the modified dockerfile and docker-compose file in the airflow folder.
- Do rmb to put in credentials folder

```
# Move to the airflow directory.
cd airflow

# Make expected directories and environment variables
mkdir -p ./logs ./plugins
sudo chmod 777 ./logs ./plugins

# It will be used by Airflow to identify your user.
echo -e "AIRFLOW_UID=$(id -u)" > .env
# This shows where the project root directory is located.
echo "ML_PIPELINE_ROOT_DIR=/opt/airflow/dags" >> .env

# Go to the ./airflow directory.
cd ./airflow

# Initialize the Airflow database
docker compose up airflow-init

# Start up all services
# Note: You should set up the private PyPi server credentials before running this command.
docker compose --env-file .env up --build -d
```
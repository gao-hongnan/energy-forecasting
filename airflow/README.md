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
cd dags
echo -e "AIRFLOW_UID=$(id -u)" > .env
# This shows where the project root directory is located.
echo "ML_PIPELINE_ROOT_DIR=/opt/airflow/dags" >> .env

# Go to the ./airflow directory.
cd ..
cp dags/.env . # copy .env to the current directory

# Initialize the Airflow database
docker compose up airflow-init

# Start up all services
# Note: You should set up the private PyPi server credentials before running this command.
docker compose --env-file .env up --build -d
```

# GCP STEPS

gcloud compute firewall-rules create energy-forecasting-expose-ports \
    --allow tcp:8501,tcp:8502,tcp:8001,tcp:8000,tcp:8080,tcp:5000 \
    --target-tags=energy-forecasting-expose-ports \
    --description="Firewall rule to expose ports for energy forecasting" \
    --project=gao-hongnan

gcloud compute firewall-rules create iap-tcp-tunneling \
    --allow tcp:22 \
    --target-service-accounts=gcp-storage-service-account@gao-hongnan.iam.gserviceaccount.com \
    --source-ranges=35.235.240.0/20 \
    --description="Firewall rule to allow IAP TCP tunneling" \
    --project=gao-hongnan

vm_create --instance-name gaohn-energy-forecast \
    --machine-type e2-standard-2 \
    --zone us-west2-a \
    --boot-disk-size 20GB \
    --image ubuntu-1804-bionic-v20230510 \
    --image-project ubuntu-os-cloud \
    --project gao-hongnan \
    --service-account gcp-storage-service-account@gao-hongnan.iam.gserviceaccount.com \
    --scopes https://www.googleapis.com/auth/cloud-platform \
    --description "Energy Consumption VM instance" \
    --additional-flags --tags=http-server,https-server,energy-forecasting-expose-ports,iap-tcp-tunneling

- SSH into VM

  ```bash
    gcloud compute ssh \
        gaohn-energy-forecast \
        --project=gao-hongnan \
        --zone=us-west2-a \
        --tunnel-through-iap \
        --quiet
    ```

- Setup docker in VM

```bash
git clone https://github.com/gao-hongnan/common-utils.git
cd common-utils/scripts/containerization/docker
bash docker_setup.sh
```

- Git clone repo

    ```bash
    git clone https://github.com/gao-hongnan/energy-forecasting.git
    cd energy-forecasting
    git checkout dev
    ```

- mkdir credentials if not exist

    ```bash
    mkdir -p airflow/dags/credentials/gcp/energy_consumption
    ```

- send gcp json to vm

    ```bash
    gcloud compute scp --recurse \
        --zone us-west2-a \
        --quiet \
        --tunnel-through-iap \
        --project gao-hongnan \
        /Users/gaohn/gcp-storage-service-account.json \
        gaohn-energy-forecast:~/energy-forecasting/airflow/dags/credentials/gcp/energy_consumption/
    ```

    ```bash
    # from airflow/
    gcloud compute scp --recurse \
        --zone us-west2-a \
        --quiet \
        --tunnel-through-iap \
        --project gao-hongnan \
        .env \
        gaohn-energy-forecast:~/energy-forecasting/airflow/.env

    gcloud compute scp --recurse \
        --zone us-west2-a \
        --quiet \
        --tunnel-through-iap \
        --project gao-hongnan \
        ./dags/.env \
        gaohn-energy-forecast:~/energy-forecasting/airflow/dags/.env
    ```

- sudo usermod -aG docker $USER
- run Airflow Pipeline above

```
# Initialize the Airflow database
docker compose up airflow-init

# Start up all services
# Note: You should set up the private PyPi server credentials before running this command.
docker compose --env-file .env up --build -d
```

- This means Airflow UI is accessible at http://34.102.22.6:8080
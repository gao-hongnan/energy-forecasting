# Feature Pipeline

Check out this
[Medium article](https://medium.com/towards-data-science/a-framework-for-building-a-production-ready-feature-engineering-pipeline-f0b29609b20f)
for more details about this module.

## Install for Development

Create virtual environment:

```shell
~/energy-forecasting                  $ cd feature-pipeline && rm poetry.lock
~/energy-forecasting/feature-pipeline $ bash ../scripts/devops/virtual_environment/poetry_install_feature_pipeline.sh
~/energy-forecasting/feature-pipeline $ source .venv/bin/activate
```

1. We first change the directory to the `feature-pipeline` folder and remove the
   `poetry.lock` file. This is necessary if we were to add new dependencies to
    the `pyproject.toml` file.
2. Call the `poetry_install_feature_pipeline.sh` script to create the virtual
   environment and install the dependencies.
3. Activate the virtual environment.

Check the
[Set Up Additional Tools](https://github.com/iusztinpaul/energy-forecasting#-set-up-additional-tools-)
and [Usage](https://github.com/iusztinpaul/energy-forecasting#usage) sections to
see **how to set up** the **additional tools** and **credentials** you need to
run this project.

## Create Environment File

```shell
~/energy-forecasting/feature-pipeline $ cp .env.default .env
```

## Set Up the ML_PIPELINE_ROOT_DIR Variable

```shell
~/energy-forecasting/feature-pipeline $ export ML_PIPELINE_ROOT_DIR=$(pwd)
```

## Usage for Development

To start the ETL pipeline run:

```shell
python -m feature_pipeline.pipeline
```

To create a new feature view run:

```shell
python -m feature_pipeline.feature_view
```

**NOTE:** Be careful to set the `ML_PIPELINE_ROOT_DIR` variable as explained in
this
[section](https://github.com/iusztinpaul/energy-forecasting#set-up-the-ml_pipeline_root_dir-variable).

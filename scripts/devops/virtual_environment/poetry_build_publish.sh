#!/bin/bash

# Build and publish the feature-pipeline, training-pipeline, and batch-prediction-pipeline packages.
# This is done so that the pipelines can be run from the CLI.
# The pipelines are executed in the feature-pipeline, training-pipeline, and batch-prediction-pipeline
# directories, so we must change directories before building and publishing the packages.
# The my-pypi repository must be defined in the project's poetry.toml file.

# https://www.digitalocean.com/community/tutorials/how-to-publish-python-packages-to-pypi-using-poetry-on-ubuntu-22-04
#!/bin/bash

# Ensure the API token is passed
if [ -z "$1" ]; then
    echo "Error: API token is required."
    echo "Usage: ./publish.sh <API_TOKEN>"
    exit 1
fi

API_TOKEN=$1

# Configure poetry
poetry config pypi-token.pypi $API_TOKEN

# List of directories to process
declare -a dirs=("feature-pipeline" "training-pipeline" "batch-prediction-pipeline")

# Loop over them
for dir in "${dirs[@]}"; do
    cd $dir
    poetry publish --build
    cd ..
done

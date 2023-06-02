#!/bin/bash

# Fetch the utils.sh script from a URL and source it
UTILS_SCRIPT=$(curl -s https://raw.githubusercontent.com/gao-hongnan/common-utils/main/scripts/utils.sh)
source /dev/stdin <<<"$UTILS_SCRIPT"
logger "INFO" "Fetched the utils.sh script from a URL and sourced it"

resolve_hopswork() {
  # Install librdkafka
  brew install librdkafka

  # Get the version of librdkafka installed
  VERSION=$(ls /opt/homebrew/Cellar/librdkafka | tail -n 1)

  # Export necessary environment variables
  export C_INCLUDE_PATH=/opt/homebrew/Cellar/librdkafka/$VERSION/include
  export LIBRARY_PATH=/opt/homebrew/Cellar/librdkafka/$VERSION/lib
}

custom_install_hopswork_if_arm64() {
    # Check if on macOS with M1 or ARM chip
    if [[ "$(uname -m)" == "arm64" ]]; then
    logger "INFO" "Installing librdkafka for M1 chip"
    resolve_hopswork
    fi
}

main() {
    custom_install_hopswork_if_arm64

    # Set poetry to create virtual environments in the project's directory
    logger "INFO" "Setting poetry to create virtual environments in the project's directory"
    poetry config virtualenvs.in-project true

    # Activate the poetry environment and install dependencies
    logger "INFO" "Activating the poetry environment and installing dependencies"
    poetry shell
    poetry install
}

main
#!/bin/bash

# Fetch the utils.sh script from a URL and source it
UTILS_SCRIPT=$(curl -s https://raw.githubusercontent.com/gao-hongnan/common-utils/main/scripts/utils.sh)
source /dev/stdin <<<"$UTILS_SCRIPT"
logger "INFO" "Fetched the utils.sh script from a URL and sourced it"

resolve_hopswork() {
  # Install librdkafka
  # brew install librdkafka
  # see https://community.hopsworks.ai/t/ssl-handshake-failed-on-macos-hopsworks-serverless/886/3
  curl -O https://raw.githubusercontent.com/Homebrew/homebrew-core/f7d0f40bbc4075177ecf16812fd95951a723a996/Formula/librdkafka.rb
  brew install --build-from-source librdkafka.rb
  rm librdkafka.rb

  # Get the version of librdkafka installed
  VERSION=$(ls /opt/homebrew/Cellar/librdkafka | tail -n 1)

  # Export necessary environment variables
  export C_INCLUDE_PATH=/opt/homebrew/Cellar/librdkafka/$VERSION/include
  export LIBRARY_PATH=/opt/homebrew/Cellar/librdkafka/$VERSION/lib
}

resolve_lightgbm() {
  # see https://stackoverflow.com/questions/74566704/cannot-install-lightgbm-3-3-3-on-apple-silicon
  brew install cmake libomp
}

custom_install_hopswork_if_arm64() {
    # Check if on macOS with M1 or ARM chip
    if [[ "$(uname -m)" == "arm64" ]]; then
        logger "INFO" "Installing librdkafka for M1 chip"
        resolve_hopswork
        resolve_lightgbm
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
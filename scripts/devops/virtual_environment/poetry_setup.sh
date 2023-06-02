#!/bin/bash

# Fetch the utils.sh script from a URL and source it
UTILS_SCRIPT=$(curl -s https://raw.githubusercontent.com/gao-hongnan/common-utils/main/scripts/utils.sh)
source /dev/stdin <<<"$UTILS_SCRIPT"
logger "INFO" "Fetched the utils.sh script from a URL and sourced it"

detect_profile() {
    if [ "${SHELL#*bash}" != "$SHELL" ]; then
        if [ -f "$HOME/.bashrc" ]; then
            DETECTED_PROFILE="$HOME/.bashrc"
        elif [ -f "$HOME/.bash_profile" ]; then
            DETECTED_PROFILE="$HOME/.bash_profile"
        fi
    elif [ "${SHELL#*zsh}" != "$SHELL" ]; then
        if [ -f "$HOME/.zshrc" ]; then
            DETECTED_PROFILE="$HOME/.zshrc"
        fi
    fi

    if [ -z "${DETECTED_PROFILE}" ]; then
        logger "ERROR" "Cannot install! This scripts only works if you are using one of these profiles: ~/.bashrc, ~/.bash_profile or ~/.zshrc"
        exit 1
    else
        logger "INFO" "Poetry will be added to ${DETECTED_PROFILE}"
    fi
}

# Function to install Poetry
install_poetry() {
    curl -sSL https://install.python-poetry.org | python3 -
    logger "INFO" "Installed Poetry"
}

# Function to add Poetry to PATH
add_poetry_to_path() {
    # Check the various possible paths for the poetry executable, invoking all
    # possible paths from https://python-poetry.org/docs/.
    if [ -d "$HOME/.poetry/bin" ]; then
        echo 'export PATH="$HOME/.poetry/bin:$PATH"' >> ${DETECTED_PROFILE}
    elif [ -d "$HOME/.local/bin" ]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ${DETECTED_PROFILE}
    elif [ -d "~/Library/Application Support/pypoetry/venv/bin" ]; then
        echo 'export PATH="~/Library/Application Support/pypoetry/venv/bin:$PATH"' >> ${DETECTED_PROFILE}
    elif [ -n "$POETRY_HOME" ]; then
        echo 'export PATH="$POETRY_HOME/bin:$PATH"' >> ${DETECTED_PROFILE}
    else
        logger "ERROR" "Poetry executable not found in the expected directories"
        exit 1
    fi

    source ${DETECTED_PROFILE}
    logger "INFO" "Added Poetry to PATH in ${DETECTED_PROFILE}"
    logger "INFO" "Poetry version: $(poetry --version)"
}

# Main function to call the other functions
setup_poetry() {
    detect_profile
    install_poetry
    add_poetry_to_path
    logger "INFO" "Poetry setup completed"
}

# Call the main function
setup_poetry

#!/bin/bash

function check_command_available() {
    command_to_test=$1
    if ! command -v ${command_to_test} &> /dev/null; then
        echo -e "\033[1;31m${command_to_test}\033[0;31m could not be found!\033[0m"
        echo "Please install ${command_to_test}"
        exit 1;
    else
        echo -e "\033[0;32m${command_to_test} is available\033[0m"
    fi
}

function env_var_set() {
  if [[ -z `printenv $1` ]]; then
    echo -e "\033[0;31mYou have to set your \033[1;31m$1\033[0;31m environment variable!\033[0m"
    exit 1;
  else
    echo -e "\033[0;32m$1 is available\033[0m"
  fi
}

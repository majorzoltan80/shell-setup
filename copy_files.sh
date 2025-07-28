#!/bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

operation_system=$(uname -s)

if [ "${operation_system}" = "Darwin" ]; then
  cp -v ./shell-init/mac/.zprofile ~/.zprofile
  cp -v ./shell-init/mac/.zshrc ~/.zshrc
else
  cp -v ./shell-init/linux/.bash_profile ~/.bash_profile
  cp -v ./shell-init/.bashrc ~/profile
  cp -v ./shell-init/.bash_profile ~/profile
fi

rsync -avu --delete "${SCRIPT_DIR}/shell-init/common/profile" "${HOME}"
rsync -avu --delete "${SCRIPT_DIR}/scripts" "${HOME}"

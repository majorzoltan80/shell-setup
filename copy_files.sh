#!/bin/bash -e

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

operation_system=$(uname -s)

if [ "${operation_system}" = "Darwin" ]; then
  cp ./shell-init/mac/.zprofile ~/.zprofile
else
  cp ./shell-init/linux/.bash_profile ~/.bash_profile
  cp ./shell-init/.bashrc ~/profile
  cp ./shell-init/.bash_profile ~/profile
fi

rsync -avu --delete "${SCRIPT_DIR}/shell-init/common/profile" "${HOME}"
rsync -avu --delete "${SCRIPT_DIR}/scripts" "${HOME}"

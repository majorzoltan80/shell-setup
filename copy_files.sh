#!/bin/bash -e

operation_system=$(uname -s)

if [ "${operation_system}" = "Darwin" ]; then
  cp ./shell-init/mac/.zprofile ~/.zprofile
else
  cp ./shell-init/linux/.bash_profile ~/.bash_profile
  cp ./shell-init/.bashrc ~/profile
  cp ./shell-init/.bash_profile ~/profile
fi


cp -rf ./shell-init/common/profile ~/profile
cp -rf scripts ~/

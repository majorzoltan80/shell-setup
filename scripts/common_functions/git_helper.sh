#!/bin/bash

source ${HOME}/scripts/common_functions/jira.sh

git_reset_to_base() {
    base=$1
    target=$2

    : "${base:=develop}"
    echo "base: ${base}"
    : "${target:=$(git branch --show-current)}"
    echo target: ${target}
    echo "git reset $(git merge ${base} ${target})"
    git reset $(git merge-base ${base} ${target})

}

function standardize_branchname() {
  # Converts the string by
  #  - Removing all non-alphanumeric characters by replacing with dashes
  #  - removing multiple dashes to only remain one between each word
  #  - converting to lowercase
  #  - if the branchname contains the jira ticket already it will convert the seon substring to uppercased SEON
  #  - Limit length to 100
  #  - Will not end with dash
  # example: "Task/SeOn-12345_String to 'Convert': small.HIGH " -> "task/SEON-12345-string-to-convert-small-high"

  input_string=$1
  # Removing all non-alphanumeric characters by replacing with dashes
  standardized_branchname=$(echo "${input_string//[^a-zA-Z0-9]/-}")

  # Remove duplicate dashes
  standardized_branchname=$(echo ${standardized_branchname} | sed -r "s/-+/-/g")

  # convert to lowercase
  standardized_branchname=$(echo ${standardized_branchname} | tr '[:upper:]' '[:lower:]')

  # Convert seon to SEON
  standardized_branchname=$(echo ${standardized_branchname} | sed "s|-seon-|/SEON-|g")

  # Limit length to 100 characters
  standardized_branchname=$(echo "${standardized_branchname:0:100}")

  # Remove training dash if present
  standardized_branchname=$(echo "${standardized_branchname%-}")

  echo "${standardized_branchname}"
}

function smart_checkout() {
  branch_name=$1

  git checkout "${branch_name}" 2>/dev/null
  if [ $? -eq 0 ]; then
    echo "Checked out branch ${branch_name}"
    return 0
  else
    echo "Could not check out branch ${branch_name}."
    echo "Trying to look for a matching branch."
  fi

  ticket_number=$(get_ticket_number "${branch_name}")
  echo "ticket_number: ${ticket_number}"
  if [ -z "${ticket_number}" ]; then
    echo "Could not extract ticket number from input: ${branch_name}"
    return 1
  fi

  latest_matching_branch=$(git branch | grep "${ticket_number}" | tail -n 1 | tr -d '[:space:]')
  if [ -z "${latest_matching_branch}" ]; then
    echo "Could not find a matching branch for ticket number: ${ticket_number}"
    echo "Available branches:"
    git branch
    return 1
  fi

  git checkout "${latest_matching_branch}"
}

#!/bin/bash

function get_ticket_number() {
  # Tries to extract the Jira ticket number from the input string
  # The ticket number will be the first numeric group found in the string, so it sould get the correct ticket number
  # for the most used usecases:
  #   - 12345 -> 12345
  #   - SEON-12345 -> 12345
  #   - https://seonteam.atlassian.net/browse/SEON-12345 -> 12345
  echo "Extracting ticket number from: $1" 1>&2
  jira_string=$1
  pattern='([0-9]+)'
  ticket_number=$(echo "$jira_string" | grep -oE "${pattern}")
  if [ -n "${ticket_number}" ]; then
    echo "${ticket_number}"
  fi
}

function get_work_item() {
  # Tries to extract the work item identifier from the input string
  jira_string=$1
  pattern='([A-Z]+-[0-9]+)'
  work_item=$(echo "${jira_string}" | grep -oE "${pattern}")
  if [ -z "${work_item}" ]; then
    ticket_number=$(get_ticket_number "${jira_string}")
    work_item="DAEN-${ticket_number}"
  fi
  echo "${work_item}"
}

function get_jira_work_item() {
  WORK_ITEM=$1
  ticket_details=$(curl -s \
  --request GET \
  --url "https://seonteam.atlassian.net/rest/api/3/issue/${WORK_ITEM}" \
  --user "${JIRA_API_USER}:${JIRA_API_KEY}" \
  --header 'Accept: application/json')

  echo "${ticket_details}"
}

function get_summary() {
  WORK_ITEM=$1
  ticket_details=$(get_jira_work_item "${WORK_ITEM}")

  SUMMARY=$(echo "${ticket_details}" | jq -r .fields.summary)
  echo "${SUMMARY}"
}

function get_type() {
  WORK_ITEM=$1
  ticket_details=$(get_jira_work_item "${WORK_ITEM}")

  TYPE=$(echo "${ticket_details}" | jq -r .fields.issuetype.name)
  echo "${TYPE}"
}

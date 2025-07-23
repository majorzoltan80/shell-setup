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
  [[ $jira_string =~ $pattern ]]
  echo "${BASH_REMATCH[1]}"
}

function get_work_item() {
  # Tries to extract the work item identifier from the input string
  # Try to get the
  jira_string=$1
  pattern='([A-Z]+-[0-9]+)'
  [[ $jira_string =~ $pattern ]]
  work_item="${BASH_REMATCH[1]}"
  if [ -z "${work_item}" ]; then
    ticket_number=$(get_ticket_number "${jira_string}")
    work_item="DAEN-${ticket_number}"
  fi
  echo "${work_item}"
}

function get_jira_work_item() {
  TICKET=$1
  ticket_details=$(curl -s \
  --request GET \
  --url "https://seonteam.atlassian.net/rest/api/3/issue/${TICKET}" \
  --user "${JIRA_API_USER}:${JIRA_API_KEY}" \
  --header 'Accept: application/json')

  echo "${ticket_details}"
}

function get_summary() {
  TICKET=$1
  ticket_details=$(get_jira_work_item "${TICKET}")

  SUMMARY=$(echo "${ticket_details}" | jq -r .fields.summary)
  echo "${SUMMARY}"
}

function get_type() {
  TICKET=$1
  ticket_details=$(get_jira_work_item "${TICKET}")

  TYPE=$(echo "${ticket_details}" | jq -r .fields.issuetype.name)
  echo "${TYPE}"
}

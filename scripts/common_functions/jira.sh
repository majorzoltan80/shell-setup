#!/bin/bash

function get_project() {
  jira_string=$1
  pattern='([A-Z]+-[0-9]+)'
  [[ $jira_string =~ $pattern ]]
  echo "${BASH_REMATCH[1]}"
}

function get_ticket_number() {
  # Tries to extract the Jira ticket number from the input string
  # The ticket number will be the first numeric group found in the string, so it sould get the correct ticket number
  # for the most used usecases:
  #   - 12345 -> 12345
  #   - SEON-12345 -> 12345
  #   - https://seonteam.atlassian.net/browse/SEON-12345 -> 12345

  jira_string=$1
  pattern='([0-9]+)'
  [[ $jira_string =~ $pattern ]]
  echo "${BASH_REMATCH[1]}"
}

function set_type_and_summary() {
  TICKET=$1
  ticket_details=$(curl -s \
  --request GET \
  --url "https://seonteam.atlassian.net/rest/api/3/issue/${TICKET}" \
  --user "${JIRA_API_USER}:${JIRA_API_KEY}" \
  --header 'Accept: application/json')

  error_message=$(echo ${ticket_details} | jq ".errorMessages")

  if [ "${error_message}" != "null" ];then
    echo "Error in Jira API call, stopping. Error message: ${error_message}"
    exit 100
  fi

  SUMMARY=$(echo "${ticket_details}" | jq -r .fields.summary)
  TYPE=$(echo "${ticket_details}" | jq -r .fields.issuetype.name)
}

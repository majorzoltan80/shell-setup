#!/bin/bash

REGION=eu-west-1
PROFILE=development

SSO_START_URL=https://seon-aws.awsapps.com/start
SSO_REGION=eu-west-1
SSO_ACCOUNT_ID=739917862298
SSO_ROLE_NAME=administrator

function authenticate_to_aws() {
    check_if_aws_development_profile_is_available
    if [ "$(is_aws_session_active)" = "false" ]; then
        echo "AWS session is not active. Starting authentication."
        aws sso login --profile="${PROFILE}"
        wait
        echo "Authentication to AWS was successful"
    else
        echo "AWS session is active. No need for authentication."
    fi
    
}

function is_aws_session_active() {
    profile=development
    is_aws_session_active="false"
    aws sts get-caller-identity --query "Account" --profile "${PROFILE}" &> /dev/null
    EXIT_CODE="$?"
    if [ "${EXIT_CODE}" = "0" ]; then
        is_aws_session_active="true"
    fi
    echo "${is_aws_session_active}"
}


function check_if_aws_development_profile_is_available() {
    if ! aws configure list-profiles | grep -q "^${PROFILE}\$"; then
        echo -e "ERROR: Missing aws profile (${PROFILE}) configuration!\n\nPlease add the following snippet to your ~/.aws/config file:\n\n"

        echo "
        [profile ${PROFILE}]
        sso_start_url = ${SSO_START_URL}
        sso_region = ${SSO_REGION}
        sso_account_id = ${SSO_ACCOUNT_ID}
        sso_role_name = ${SSO_ROLE_NAME}
        region = ${REGION}
        "

        exit 100
    else
        echo "AWS development profile is set."
    fi
}
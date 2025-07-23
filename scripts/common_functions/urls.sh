#!/bin/bash
# These functions are used to determine the information that can be derived from the url.
# Like: short name (automation, dragon, etc.), 
#       ebEnvName (adminpanel-react-dev-automation, restservice-dev-dragon.eu-west-1.elasticbeanstalk.com, etc.), 
#       application group (admin, restservice, etc.)

function sanitize_url() {
    # get http://, https:// and trailing slash removed
    # Transformation example

    url=$1
    
    prefix_https="https://"
    prefix_http="http://"
    suffix_slash="/"
    url=${url#"$prefix_https"}
    url=${url#"$prefix_http"}
    url=${url%"$suffix_slash"}
    
    echo "${url}"
}

function get_short_name_by_url() {
    # Tries to determine the unique name from the url by stripping the common parts.
    # First it strips the http:// and training slash, then tries to guess what the short name is
    # Input-output examples:
    # https://admin.seondev.space -> admin
    # https://admin-automation.seondev.space/ -> automation
    # admin-jericho.seondev.space -> jericho
    # restservice-dev-dragon.eu-west-1.elasticbeanstalk.com -> dragon

    url=$(sanitize_url "$1")

    case ${url} in
        admin.seondev.space) short_name="admin";;
        restservice-dev*) 
            prefix="restservice-dev-"
            suffix=".eu-west-1.elasticbeanstalk.com"
            short_name=${url#"$prefix"}
            short_name=${short_name%"$suffix"}
            ;;             

        *) 
            prefix="admin-"
            suffix=".seondev.space"
            short_name=${url#"$prefix"}
            short_name=${short_name%"$suffix"}
            ;;             
    esac

    : "${short_name:?CouldNotDetermineShortNameError: Could not determine short name (like automation, dragon) from URL=${url}}"

    echo "${short_name}"
}

function get_ebEnvName_by_url() {
    # Tries to determine the ebeEvName (AWS elastcic beanstalk environment name) based on the url given
    # For now only react development ebEnvName is returned back for admin
    # And development restservice ebEnvName is returned for restservice
    # Input-output examples:
    # https://admin.seondev.space -> adminpanel-react-dev-shared-green
    # https://admin-automation.seondev.space/ -> adminpanel-react-dev-automation
    # admin-jericho.seondev.space -> adminpanel-react-dev-jericho
    # restservice-dev-dragon.eu-west-1.elasticbeanstalk.com -> restservice-dev-dragon 

    url=$(sanitize_url "$1")
    
    short_name=$(get_short_name_by_url $url)

    case ${url} in
        admin.seondev.space) ebEnvName="adminpanel-react-dev-shared-green";;
        admin-*) ebEnvName="adminpanel-react-dev-${short_name}";;
        restservice-*) ebEnvName="restservice-dev-${short_name}";;
    esac

    : "${ebEnvName:?CouldNotDetermineEbEnvNameError: Could not determine ebEnvName from URL=${url}}"
    echo "${ebEnvName}"
}

function determine_application_group_by_url() {
    # Tries to determine which application group is behind the url, like admin, or restservice.
    # One applciation group represent a collection of ebAppNames (AWS elastic beanstalk Application Name)
    url=$(sanitize_url "$1")

    case ${url} in
        admin*) application_group="admin";;
        restservice*) application_group="restservice";;        
    esac

    : "${application_group:?CouldNotDetermineApplicationGroupError: Could not determine application group (like admin, restservice) from URL=${url}}"
    
    echo "${application_group}"
}

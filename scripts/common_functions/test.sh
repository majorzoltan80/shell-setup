SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${SCRIPT_DIR}/jira.sh

get_summary "$(get_work_item 1234)"
get_type "$(get_work_item 1234)"

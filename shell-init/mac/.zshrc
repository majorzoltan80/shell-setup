
. "$HOME/.local/bin/env"


parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}


echo Set prompt to '%n %1~ $(parse_git_branch) %#'
export PS1="%n %1~ $(parse_git_branch) %#"

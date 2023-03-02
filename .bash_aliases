# Function which adds an alias to the current shell and to
# the ~/.bash_aliases file.
add-alias ()
{
   local name=$1 value="$2"
   echo alias $name=\'$value\' >>~/.bash_aliases
   eval alias $name=\'$value\'
   alias $name
}

# "repeat" command.  Like:
#
#	repeat 10 echo foo
repeat ()
{ 
    local count="$1" i;
    shift;
    for i in $(_seq 1 "$count");
    do
        eval "$@";
    done
}

# Subfunction needed by `repeat'.
_seq ()
{ 
    local lower upper output;
    lower=$1 upper=$2;

    if [ $lower -ge $upper ]; then return; fi
    while [ $lower -lt $upper ];
    do
	echo -n "$lower "
        lower=$(($lower + 1))
    done
    echo "$lower"
}



stop_vpn () {
  sessions=$(openvpn3 sessions-list | grep Path | awk '{print $2}')
  echo "Sessions: [${sessions}]"
  if [ "${sessions}" = "" ];then
    echo "No vpn sessions present."
  else
    openvpn3 session-manage --session-path ${sessions} --disconnect
  fi
}

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


# add-alias alias :)

alias aa='add-alias'

# git aliases

alias gs='git status'
alias gp='git pull'
alias gc='git checkout'
alias gd='git diff --staged'
alias gb='git branch'
alias gr='git_reset_to_base'


# change directory shortcuts

alias cdar='cd ~/dev/seon-admin-react/selenium-tests'
alias cdssc='cd ~/dev/seon-selenium-common'
alias stv='source venv/bin/activate'
alias ga='git add .'
alias pc='pre-commit'
alias gl='git log'
alias h='history'
alias gd=git diff=''
alias gd='git diff'
alias cdd='cd ~/dev'


export PATH=${HOME}/chromedrivers:${HOME}/dev/seon-admin-react/bin:${PATH}
export NODE_OPTIONS="--max_old_space_size=4096"

export JIRA_API_USER=zoltan.major@seon.io
export JIRA_API_KEY=bhfeOHE3GsouPAzWzTsp35BB

alias cda='cd ~/dev/admin/selenium-tests'
alias nb='nano ~/.bash_aliases'
alias cdssc='cd ~/dev/seon-selenium-common/'
alias gcd='git checkout develop'
alias cdsrc='cd ~/dev/seon-react-components'
alias gcb='new_task -p test'
alias reload='source ~/.bash_aliases'
alias gcma='git checkout master'
alias gcm='git commit -m '
alias gpu='git push -u'
alias gpf='git push --force'
alias gbd='git branch -d '
alias cdauth='cd ~/dev/authentication-service'
alias show_vpn='openvpn3 sessions-list'
alias start_vpn='openvpn3 session-start --config ~/.vpn/client.ovpn'
alias server='npm run server:dev'
alias client='npm run client:start'
alias gds='git diff --staged'
alias gpuf='git push --force'

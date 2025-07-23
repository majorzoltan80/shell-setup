if [ -f ~/profile/alias ]; then
	echo "Loading aliases"
	source ~/profile/alias
fi

if [ -f ~/profile/jira.env ]; then
    echo "Loading jira env"
	source ~/profile/jira.env
fi

if [ -f ~/profile/env ]; then
    echo "Loading env vars"
	source ~/profile/env
fi

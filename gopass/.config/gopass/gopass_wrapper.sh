#!/bin/sh

if [ -f ~/.gpg-agent-info ] && [ -n "$(pgrep gpg-agent)" ]; then
	. ~/.gpg-agent-info
	export GPG_AGENT_INFO
else
	eval "$(gpg-agent --daemon)"
fi

GPG_TTY="$(tty)"
export GPG_TTY

/usr/local/bin/gopass jsonapi listen

exit $?

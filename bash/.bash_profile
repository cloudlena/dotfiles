# System settings before starting X
. $HOME/.bashrc

PATH=$HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/usr/local/lib:/usr/local/sbin

PATH=$PATH:$GOPATH/bin

export PATH

# set up alsa
/usr/bin/amixer sset Master Mono 90% unmute  &> /dev/null
/usr/bin/amixer sset Master 90% unmute  &> /dev/null
/usr/bin/amixer sset PCM 90% unmute &> /dev/null

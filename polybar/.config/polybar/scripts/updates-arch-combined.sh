#!/bin/sh

if ! update_count_pacman=$(checkupdates | wc -l ); then
    update_count_pacman=0
fi

if ! update_count_aur=$(yay -Qum 2> /dev/null | wc -l); then
    update_count_aur=0
fi

update_count=$(("$update_count_pacman" + "$update_count_aur"))

suffix=''
if [ "$update_count" -gt 1 ]; then
    suffix='s'
fi

if [ "$update_count" -gt 0 ]; then
    echo "${update_count} update${suffix} available"
else
    echo ''
fi

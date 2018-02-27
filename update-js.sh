#!/bin/bash

set -u

source ~/dotfiles/bash/.functions

js_dir="${HOME}/js"

if [ -d "${js_dir}" ]; then
    cd "${js_dir}" || exit
    for d in */ ; do
        ( cd "$d" && git pull && depu )
    done
fi

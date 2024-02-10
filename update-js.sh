#!/bin/sh

set -u

. ~/dotfiles/zsh/.zsh.d/functions.zsh

readonly js_dir="${HOME}/js"

if [ -d "${js_dir}" ]; then
    cd "${js_dir}" || exit
    for d in */ ; do
        ( cd "$d" && git pull ; depu )
    done
fi

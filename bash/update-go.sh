#!/bin/bash

set -u

if [ -x "$(command -v go)" ]; then
    if [ ! -x "$(command -v binstale)" ]; then
        go get -u github.com/shurcooL/binstale
    fi

    lines=$(binstale | grep 'stale: ')

    while read -r line; do
        if [ ! -z "${line}" ]; then
            uri=$(echo "${line}" | awk -F ' ' '{print $2}')
            echo "Updating Go binary ${uri}"
            go get -u "${uri}"
        fi
    done < <(echo "${lines}")
fi

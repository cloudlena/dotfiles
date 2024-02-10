#!/bin/bash

set -u

js_dir="${HOME}/js"

if [ -d "${js_dir}" ]; then
    cd "${js_dir}" || exit
    for d in */ ; do
        ( cd "$d" && git pull && npm update && npm prune && npm dedupe && npm outdated )
    done
fi

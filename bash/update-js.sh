#!/bin/sh

js_dir="${HOME}/js"

if [ -d "${js_dir}" ]; then
    cd "${js_dir}"
    for d in */ ; do
        ( cd "$d" && git pull && npm update && npm prune && npm outdated )
    done
fi

#!/bin/sh

set -u

js_dir="${HOME}/js"

cd "${js_dir}" || exit
for d in */ ; do
    ( cd "$d" && git pull && npm update && npm prune && npm outdated )
done

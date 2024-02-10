#!/bin/bash

if [ -x "$(command -v binstale)" ]; then
    for d in $(binstale | grep 'build ID mismatch'); do
        ( if [[ $d == *'/'* ]]; then go get -u "$d"; fi )
    done
fi

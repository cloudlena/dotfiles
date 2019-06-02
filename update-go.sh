#!/bin/sh

set -u

export GO111MODULE=off

if [ -x "$(command -v go)" ]; then
    if [ ! -x "$(command -v gobin)" ]; then
        go get -u github.com/rjeczalik/bin/cmd/gobin
    fi

    gobin -u
fi

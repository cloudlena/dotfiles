#!/bin/sh

if ! failed_count=$(systemctl --failed | grep 'failed' | wc -l); then
    failed_count=0
fi

if [ "$failed_count" -gt 0 ]; then
    echo "$failed_count"
else
    echo ''
fi

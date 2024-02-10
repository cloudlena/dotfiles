#!/bin/sh

set -u

if [ ! -x "$(command -v podman)" ]; then
	exit 1
fi

running_container_count=$(podman ps --noheading | wc -l)

if [ "$running_container_count" -eq 0 ]; then
	echo ''
	exit 0
fi

suffix=""
if [ "$running_container_count" -gt 1 ]; then
	suffix="s"
fi

echo "{\"text\": \"󰡨\", \"tooltip\": \"${running_container_count} container${suffix} running\"}"

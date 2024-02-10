#!/bin/sh

set -u

if [ ! -x "$(command -v task)" ]; then
	exit 1
fi

active_task=$(task rc.verbose=nothing rc.report.activedesc.filter=+ACTIVE rc.report.activedesc.columns:description rc.report.activedesc.sort:urgency- rc.report.activedesc.columns:description activedesc limit:1 | head -n 1)
if [ -n "$active_task" ]; then
	echo "󰐌 $active_task"
	exit 0
fi

ready_task=$(task rc.verbose=nothing rc.report.readydesc.filter=+READY rc.report.readydesc.columns:description rc.report.readydesc.sort:urgency- rc.report.readydesc.columns:description readydesc limit:1 | head -n 1)
if [ -z "$ready_task" ]; then
	echo ""
	exit 0
fi

echo "󰳟 $ready_task"

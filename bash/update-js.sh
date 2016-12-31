#!/bin/sh

cd ~/js

for d in */ ; do
	( cd "$d" && git pull && npm update && npm prune && npm outdated )
done


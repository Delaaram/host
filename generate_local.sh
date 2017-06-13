#!/bin/bash
set -e

if [ -e output ]; then
	rm -rf output
fi
mkdir output
node generate.js hosts.yml $(git show -s --format=%cd --date=short) output


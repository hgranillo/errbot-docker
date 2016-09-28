#!/bin/bash

set -o nounset
set -o errexit

usage() {
	echo "Usage:" 2>&1
	echo "" 2>&1
	echo "  shell       -- Start an interactive user shell" 2>&1
	echo "  rootshell   -- Start an interactive root shell" 2>&1
	echo "  err         -- Start Err" 2>&1
}

if [[ $# -lt 1 ]]; then
	usage
	exit 1
fi

cmd=$1
shift

case $cmd in
	"shell")
		cd /err
		chown err:err /err/data
		gosu err /bin/bash "$@"
		;;
	"rootshell")
		gosu root /bin/bash "$@"
		;;
	"err")
		cd /err
                chown err:err /err/data
		gosu err /err/virtualenv/bin/errbot "$@"
		;;
	*)
		usage
		exit 1
		;;
esac

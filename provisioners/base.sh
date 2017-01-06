#!/bin/bash

set -o nounset
set -o errexit
set -o xtrace

APTINSTALL="apk add --no-cache"

echo LC_ALL="en_US.utf8" >> /etc/environment
echo DEBIAN_FRONTEND="noninteractive" >> /etc/environment
#locale-gen en_US.UTF-8
. /etc/environment

#PYTHON_PACKAGES="python3 python3-dev"

# Do a dist-upgrade because docker has not always updated their
# images in a timely manner after security updates were released.
apk upgrade --no-cache

# Python and related packages itself (some dev libs for building C extensions)
$APTINSTALL build-base openssl-dev libffi-dev

if [[ $ERR_PYTHON_VERSION == "2" ]]; then
	PYTHON_PACKAGES="python python-dev py-virtualenv gdbm py-gdbm"
elif [[ $ERR_PYTHON_VERSION == "3" ]]; then
	PYTHON_PACKAGES="python3 python3-dev"
else
	echo "Unsupported Python version requested through ERR_PYTHON_VERSION"
	exit 1
fi

$APTINSTALL $PYTHON_PACKAGES

# TLS certs and sudo are needed, curl and vim are tremendously useful when entering
# a container for debugging (while barely increasing image size)
# Git and openssh-client are needed to install nearly all plugins
$APTINSTALL ca-certificates sudo curl git openssh-client

# Automatically add unknown host keys, users have no way to answer yes
# when using 'ask'.
echo '    StrictHostKeyChecking no' >> /etc/ssh/ssh_config

#!/bin/bash

set -o nounset
set -o errexit
set -o xtrace

# Create user account with uid 2000 to guarantee it won't change in the
# future (because the default user id 1000 might already be taken).
addgroup -g 2000 err && adduser -u 2000 -S -G err err
# Allow people to provide SSH keys to pull from private repositories.
mkdir -p /err/.ssh/
chown err:err /err/.ssh/

# Setup Errbot configuration folders
mkdir -p /err/data /err/virtualenv
chown err:err /err/data /err/virtualenv

# Install dependencies
if [[ $ERR_PYTHON_VERSION == "2" ]]; then
	gosu err virtualenv --python /usr/bin/python /err/virtualenv
elif [[ $ERR_PYTHON_VERSION == "3" ]]; then
	gosu err python3 -m venv /err/virtualenv
else
	echo "Unsupported Python version requested through ERR_PYTHON_VERSION"
	exit 1
fi

# Install Err itself
if [[ $ERR_PYTHON_VERSION == "2" ]]; then
	gosu err /err/virtualenv/bin/pip install errbot==4.2.2
elif [[ $ERR_PYTHON_VERSION == "3" ]]; then
	gosu err /err/virtualenv/bin/pip install $ERR_PACKAGE
else
	echo "Unsupported Python version requested through ERR_PYTHON_VERSION"
	exit 1
fi
# XMPP back-end dependencies
gosu err /err/virtualenv/bin/pip install sleekxmpp pyasn1 pyasn1-modules
# IRC back-end dependencies
gosu err /err/virtualenv/bin/pip install irc
# HypChat back-end dependencies
gosu err /err/virtualenv/bin/pip install hypchat
# Slack back-end dependencies.
# Python2 install should use slackclient 1.0.2
# https://github.com/errbotio/errbot/pull/936
if [[ $ERR_PYTHON_VERSION == "2" ]]; then
	gosu err /err/virtualenv/bin/pip install slackclient==1.0.2
elif [[ $ERR_PYTHON_VERSION == "3" ]]; then
	gosu err /err/virtualenv/bin/pip install slackclient
else
	echo "Unsupported Python version requested through ERR_PYTHON_VERSION"
	exit 1
fi
# Telegram back-end dependencies
gosu err /err/virtualenv/bin/pip install python-telegram-bot

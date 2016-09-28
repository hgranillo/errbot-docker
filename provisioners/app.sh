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

mkdir -p /err/data /err/virtualenv
chown err:err /err/data /err/virtualenv

gosu err python3 -m venv /err/virtualenv

# Install Err itself
gosu err /err/virtualenv/bin/pip install $ERR_PACKAGE
# XMPP back-end dependencies
gosu err /err/virtualenv/bin/pip install sleekxmpp pyasn1 pyasn1-modules
# IRC back-end dependencies
gosu err /err/virtualenv/bin/pip install irc
# HypChat back-end dependencies
gosu err /err/virtualenv/bin/pip install hypchat
# Slack back-end dependencies. Note: Installing from master because PyPI
# release is broken at this time.
gosu err /err/virtualenv/bin/pip install https://github.com/slackhq/python-slackclient/archive/master.zip
# Telegram back-end dependencies
gosu err /err/virtualenv/bin/pip install python-telegram-bot

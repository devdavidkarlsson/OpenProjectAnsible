#!/bin/bash
# setting up version of node:

export NODENV_ROOT="/opt/nodenv"
export PATH="$NODENV_ROOT/bin:$PATH"

if which nodenv > /dev/null; then eval "$(nodenv init -)"; fi

export PYENV_VERSION=system
(nodenv versions | grep "$1") || nodenv install "$1"
nodenv rehash
(nodenv versions | grep "$1") || nodenv global "$1"

echo "0.12.7" > /opt/nodenv/version
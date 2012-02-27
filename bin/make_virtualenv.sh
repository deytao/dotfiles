#!/usr/bin/env bash
# Create Python virtualenv
# usage: make_virtualenv.sh <version> <virtualenv_name>

set -e
set -x


# Create virtualenvs root directory

if [ "$WORKON_HOME" == "" ]
then
    WORKON_HOME=~/.virtualenvs
fi

mkdir -p $WORKON_HOME


# Create new virtualenv with specified name and Python version

VERSION=$1
PYTHON=/opt/python-$VERSION/bin/python${VERSION::3}
VIRTUALENV=/opt/python-$VERSION/bin/virtualenv

VIRTUALENV_NAME=$2

$VIRTUALENV --python=$PYTHON --no-site-packages $WORKON_HOME/$VIRTUALENV_NAME


# Install virtualenvwrapper for this virtualenv so that it doesn't break using tmux

source $WORKON_HOME/$VIRTUALENV_NAME/bin/activate
pip install virtualenvwrapper
deactivate


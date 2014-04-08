#!/usr/bin/env bash
# Install cPython interpreter from source
# usage: install_python.sh <version>

set -e
set -x

VERSION=$1


mkdir -p /usr/src/python-$VERSION
cd /usr/src/python-$VERSION


# Install prerequisite libraries

DEPENDENCIES="libreadline6-dev libsqlite3-dev libxslt1-dev libxml2-dev zlib1g-dev libbz2-dev"
command -v apt-get && sudo apt-get install $DEPENDENCIES


# Get Python sources

FILENAME=Python-$VERSION.tgz
if [ ! -f $FILENAME ]
then
    curl https://www.python.org/ftp/python/$VERSION/Python-$VERSION.tgz > $FILENAME
    #echo 'aa27bc25725137ba155910bd8e5ddc4f  Python-$VERSION.tgz' | md5sum --check -
fi

DIRNAME=Python-$VERSION
if [ ! -d $DIRNAME ]
then
    tar xvzf Python-$VERSION.tgz
fi


# Compile and install Python interpreter

cd $DIRNAME
./configure --prefix=/opt/python-$VERSION/
sudo make install
cd ..

PYTHON=/opt/python-$VERSION/bin/python${VERSION::3}


# Bootstrap distribute package (required by pip)

wget --no-check-certificate --no-clobber http://python-distribute.org/distribute_setup.py
sudo $PYTHON distribute_setup.py


# Install pip package installer

wget --no-check-certificate --no-clobber https://github.com/pypa/pip/raw/master/contrib/get-pip.py
sudo $PYTHON get-pip.py


# Install virtualenv

sudo /opt/python-$VERSION/bin/pip${VERSION::3} install virtualenv


# Install system-wide virtualenvwrapper

command -v apt-get && sudo apt-get install python-setuptools
sudo easy_install --upgrade virtualenvwrapper

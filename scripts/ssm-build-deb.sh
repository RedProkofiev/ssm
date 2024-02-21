#!/bin/bash

# Execute the following as root to install lintian, pip, and fpm:
# apt-get install lintian ruby ruby-dev build-essential python-pip
# gem install --no-ri --no-rdoc fpm

# Then run this file, as any user, altering the
# version number in the TAG variable.
# This file will create two versions of the deb file:
# - apel-ssm_<tag>_all.deb contains all the files necessary to run a
#   the SSM as a sender.
# - apel-ssm-service_<tag>_all.deb will install service daemon files
#   necessary to run the SSM as a receiver as a service.
# After building apel-ssm_<tag>_all.deb, this script will run it
# against lintian to highlight potential issues to the builder.

set -eu

TAG=3.4.0-1

SOURCE_DIR=~/debbuild/source
BUILD_DIR=~/debbuild/build

# Where to install the python lib files
PYTHON_INSTALL_LIB=/usr/lib/python2.7/dist-packages

# Split the tag into version and package number
# so they can be passed to fpm separately.
# This will work with tags of the form <version_number>-<iteration>
VERSION=$(echo "$TAG" | cut -d - -f 1)
ITERATION=$(echo "$TAG" | cut -d - -f 2)

# Create SSM and DEB dir (if not present)
mkdir -p $SOURCE_DIR
mkdir -p $BUILD_DIR

# Clean up any previous build
rm -rf $SOURCE_DIR/*
rm -rf $BUILD_DIR/*

# Get and extract the source
TAR_FILE=${TAG}.tar.gz
TAR_URL=https://github.com/apel/ssm/archive/$TAR_FILE
wget --no-check-certificate $TAR_URL -O $TAR_FILE
tar xvf $TAR_FILE -C $SOURCE_DIR
rm -f $TAR_FILE

fpm -s python -t deb \
-n apel-ssm \
-v $VERSION \
--iteration $ITERATION \
-m "Apel Administrators <apel-admins@stfc.ac.uk>" \
--description "Secure Stomp Messenger (SSM)." \
--no-auto-depends \
--depends python2.7 \
--depends python-pip \
--depends 'python-stomp < 5.0.0' \
--depends python-ldap \
--depends libssl-dev \
--depends libsasl2-dev \
--depends openssl \
--deb-changelog $SOURCE_DIR/ssm-$TAG/CHANGELOG \
--python-install-bin /usr/bin \
--python-install-lib $PYTHON_INSTALL_LIB \
--exclude *.pyc \
--package $BUILD_DIR \
$SOURCE_DIR/ssm-$TAG/setup.py

fpm -s pleaserun -t deb \
-n apel-ssm-service \
-v $VERSION \
--iteration $ITERATION \
-m "Apel Administrators <apel-admins@stfc.ac.uk>" \
--description "Secure Stomp Messenger (SSM) Service Daemon files." \
--architecture all \
--no-auto-depends \
--depends apel-ssm \
--package $BUILD_DIR \
/usr/bin/ssmreceive

# Clean up files generated by script
rm -rf apel_ssm.egg-info/ build/

# Check the resultant debs for 'lint'
echo "Possible Issues to Fix:"
lintian $BUILD_DIR/apel-ssm_${TAG}_all.deb
lintian $BUILD_DIR/apel-ssm-service_${TAG}_all.deb

#!/bin/bash

# Apel-SSM Build Script 2.0: FPM edition
# Adapted from the Debian only build script, now with RPM!
# @Author: Nicholas Whyatt (RedProkofiev@github.com)

set -e
# set -eu

usage() { 
    echo "Usage: $0 (deb | rpm) <version> <iteration> [options]"
    echo -e "Build script for Apel-SSM.\n"
    echo "  -h                    Displays help."
    echo "  -p <python_path>      Path to python folder you want to use.  No argument uses path default, attempts Python3."
    echo "  -s <source_dir>       Directory of source files.  Defaults to /debbuild/source or SOME RPM DIR." 
    echo -e "  -b <build_dir>        Directory of build files.  Defaults to /debbuild/build or SOME RPM DIR.\n" 1>&2;
    exit 1; 
}

PACK_TYPE=$1 | tr '[:upper:]' '[:lower:]'
VERSION=$2
ITERATION=$3

# TODO: Replace rpm directories with their sensible equivalents
if [$PACK_TYPE = "deb"]; then 
    SOURCE_DIR=~/debbuild/source
    BUILD_DIR=~/debbuild/build
elif [$PACK_TYPE = "rpm"]; then
    SOURCE_DIR=~/something/rpm
    BUILD_DIR=~/somethingalso/rpm
else
    echo "$0 currently only supports 'deb' and 'rpm' packages."
    usage;
fi

while getopts "h:p:s:b" o; do
    case "${o}" in
        h)  usage;
            ;;
        p)  p=${OPTARG}
            ;;
        s)  s=${OPTARG}
            SOURCE_DIR=~/something/rpm
            ;;
        b)  b=${OPTARG}
            BUILD_DIR=~/something/rpm
            ;;
        *)  usage;
            ;;
    esac
done
shift $((OPTIND-1))

# if [ -z "${s}" ] || [ -z "${p}" ]; then
#     usage
# fi

# VERSION=$1
# ITERATION=$2
# PYTHON_VERSION=$3

# # Create SSM and DEB dir (if not present)
# mkdir -p $SOURCE_DIR
# mkdir -p $BUILD_DIR

# # Clean up any previous build
# rm -rf $SOURCE_DIR/*
# rm -rf $BUILD_DIR/*

# # Get and extract the source
# TAR_FILE=${TAG}.tar.gz
# TAR_URL=https://github.com/apel/ssm/archive/$TAR_FILE
# wget --no-check-certificate $TAR_URL -O $TAR_FILE
# tar xvf $TAR_FILE -C $SOURCE_DIR
# rm -f $TAR_FILE
#!/usr/bin/env bash
set -e
export NAME=$1
export VERSION=$2
export RELEASE=gcb01
export TYPE=Core

cd helmod
git pull
module purge
source ./setup.sh

cd "$FASRCSW_DEV"/rpmbuild/SPECS
make
make install
make sync

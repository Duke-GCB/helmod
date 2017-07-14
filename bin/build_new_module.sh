#!/usr/bin/env bash
# Builds a module for a spec file that was added to the repo
# Assumes that whatever SOURCE is required(if any) is already present locally
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

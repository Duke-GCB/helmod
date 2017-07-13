# Module Building

## Overview
We build modules on a rpm build server.

_A new user will need to clone this repo and create `hemlod/rpmbuild/BUILD`._

This guide assumes the user is in the top level directory of this repo.
To build a new module:
1. Download the source code(a compressed archive) into the `rpmbuild/SOURCES/` directory.
2. Copy the `rpmbuild/SPECS/template.spec` to `rpmbuild/SPECS/<name>-<version>-gcb<release>.spec`
3. Customize the new spec file for where the software has non-standard configure/make settings.
4. Setup building environment `source ./setup.sh`
5. Set environments that specify which module to build
```
export NAME=<module-name>
export VERSION=<module-version>
export RELEASE=gcb<release-num>
export TYPE=Core
```
6. build and install module
```
cd "$FASRCSW_DEV"/rpmbuild/SPECS
make
make install
make post
```
7. rsync any servers that have a copy. In particular our HARDAC xfer node will need this done for users to see the module.

After following these steps a user will be able to load and use the module on the rpmbuild server.
Example:
```
module load <module-name>
... use module
```

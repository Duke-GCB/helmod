HeLmod (Harvard Extensions for Lmod deployment) is a software management system where:

* apps are built, packaged, and installed using [RPM](http://www.rpm.org/)
* each app is installed under its own relocatable prefix
* software environments are managed with [Lmod](http://www.tacc.utexas.edu/tacc-projects/lmod)
* it's easy to manage entire software environments for multiple compiler and MPI implementations

See the `doc` directory for more information, specifically:

* [INSTALL](doc/INSTALL.md) for initial installation and setup
* [HOWTO](doc/HOWTO.md) for day-to-day usage instructions (or [HOWTO-short](doc/HOWTO-short.md) for experienced users)
* [FAQ](doc/FAQ.md) for answers to common questions and other details

HeLmod captures all the details and hacks that go into building any given software package as shell snippets in RPM spec files.
See the [rpmbuild/SPECS](rpmbuild/SPECS) directory for a bunch of real examples (see [this FAQ item](doc/FAQ.md#how-do-i-diff-a-spec-file-with-the-relevant-version-of-the-template-spec-file) for diffing them from the template for the interesting bits).

## GCB Specific Instructions
Modules are built on the rpmbuild server. 
New users will need to clone this repo and create a `BUILD` directory in `helmod/rpmbuild`.

High Level Process
- Setup environment variables for the module you want to build
- Download the compressed source used to build the software into `rpmbuild/SOURCES/`
- Copy the template.spec to a <modulename>-<version>-gcb<release>.spec file in `rpmbuild/SPECS`
- run `make`/`make install` in `rpmbuild/SPECS` editing the spec file as necessary
- run `make post` which stores the output files in `/nfs/software/helmod/` on rpmbuild server and commits the source code. `make sync` can be run to just store the output files in the global location.

When running `make` for building modules you are running the the helmod Makefile. The rpm spec file contains commands that will configure and make your source code. If you do not wish to See the [HOWTO-short](doc/HOWTO-short.md) instructions for further details.

__NOTE__
One additinal step that must be manually done is to sync the modules to our HARDAC cluster. This is done by running this command on the HARDAC xfer server: 
```
rsync -rlptoDvi --progress -e ssh /nfs/oit_software/helmod /data/itlab
```


# One-time setup

Clone the repo in some personal location, preferably on network storage, e.g. somewhere in your home directory:

	git clone git@github.com:/fasrc/fasrcsw.git ~/fasrcsw

Customize `setup.sh`, particularly `$FASRCSW_PROD`, for your environment.


# Workflow

## Intro

The following is an example of building a simple GNU autotools style software package, i.e. something that uses `configure`/`make`/`make install` with standard options.
This specifically uses the automake hello-world example, `amhello-1.0.tar.gz`, distributed with automake.
The basic workflow is:

* get the source
* create and partially complete a spec file, starting with a template
* do a preliminary build of the software to see what it creates, in order to know what to put in the module file
* complete the spec file and build the final rpm
* commit changes and move packages to production locations
* install the rpm

This starts by building it as a *Core* app -- one that does not depend upon compiler or MPI implementation.

## Prep

* make sure you're logged into the build host
* make sure you're logged into your normal user account, *not* root
* `cd` to your personal fasrcsw clone and setup the environment:

	source ./setup.sh

There will now be two environment variables defined that are used in the instructions below --
`$FASRCSW_DEV` is the location of your personal clone, and
`$FASRCSW_PROD` is the one, central location for your organizations's software.

In order to be able to copy-n-paste commands below, set the `NAME`, `VERSION`, and `RELEASE` variables particular to the app your installing (these variables are only used by this doc, not fasrcsw).
`NAME` and `VERSION` are whatever the app claims (the some adjustements may be required, e.g. `-` is not allowed in `VERSION`).
`RELEASE` is used to track the build under the fasrcsw system.
If this is the first fasrcsw-style build, use `fasrc01`; otherwise increment the number used in the previous spec file for the app.

## Get the source code

By whatever means necessary, get a copy of the package source archive into the location for the sources:

	cd "$FASRCSW_DEV"/rpmbuild/SOURCES
	wget --no-clobber http://...

E.g. for `amhello`, which is a bit complicated because it's a tarball within another tarball:
	
	#amhello example ONLY
	curl http://ftp.gnu.org/gnu/automake/automake-1.14.tar.xz \
	  | tar --strip-components=2 -xvJf - automake-1.14/doc/amhello-1.0.tar.gz

## Create a preliminary spec file

Change to the directory of spec files:

	cd "$FASRCSW_DEV"/rpmbuild/SPECS

Create a spec file for the app based upon the template:

	cp -ai template.spec "$NAME-$VERSION-$RELEASE".spec

Now edit the spec file and address things with the word **`FIXME`** in them.
For some things, the default will be fine.
Eventually all need to be addressed, but for now, just complete everything up to where `modulefile.lua` is created.
The next step will provide the necessary guidance on what to put in the modulefile.

## Build the software and examine its output

The result of the above will be enough of a spec file to build the sofware.
However, you have to build it before filling in the details of the modulefile also installed by the rpm.
The template spec has a section that, if the macro `inspect` is defined, will quit the rpmbuild during the `%install` step and use the `tree` command to dump out what was built and will be installed:

	rpmbuild --eval '%define inspect yes' -ba "$NAME-$VERSION-$RELEASE".spec

and the output will show something like this near the end:

	*************** fasrcsw -- STOPPING due to %define inspect yes ****************

	Look at the tree output below to decide how to finish off the spec file.  (`Bad
	exit status' is expected in this case, it's just a way to stop NOW.)


	/home/me/rpmbuild/BUILDROOT/amhello-1.0-fasrc01.x86_64//n/sw/fasrcsw/apps/Core/amhello/1.0-fasrc01
	|-- README
	|-- bin
	|   `-- hello
	`-- share
		`-- doc
			`-- amhello
				`-- README

	4 directories, 3 files


	******************************************************************************


	error: Bad exit status from /var/tmp/rpm-tmp.B5l2ZA (%install)


	RPM build errors:
		Bad exit status from /var/tmp/rpm-tmp.B5l2ZA (%install)

The `Bad exit status` is expected in this case.
(The `README` and other docs in the root of the installation is something manually done by fasrcsw just out of personal preference.)

## Finish the spec file

Re-open the spec file for editing and, based upon the output in the previous step, write what goes in `modulefile.lua`.
Some common things are already there as comments (`--` delimits a comment in lua).

## Build the rpm

Now the package can be fully built:

	rpmbuild -ba "$NAME-$VERSION-$RELEASE".spec

Look it over with the following:

	rpm -qilp --scripts ../RPMS/x86_64/"$NAME-$VERSION-$RELEASE"*.x86_64.rpm

Make sure:

* all the metadata looks good
* all files are under the an app-specific prefix under `$FASRCSW_PROD`. 
* the modulefile symlink (second ln arg in postinstall scriptlet) is good

## Install the rpm

Now install the rpm, testing first if you like:

	$ sudo rpm -ivh --test ../RPMS/x86_64/"$NAME-$VERSION-$RELEASE".x86_64.rpm
	$ sudo rpm -ivh        ../RPMS/x86_64/"$NAME-$VERSION-$RELEASE".x86_64.rpm

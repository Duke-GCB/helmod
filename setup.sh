#--- basic config -- adjust as needed

#the location of production fasrcsw clone
export FASRCSW_PROD=/nfs/software/helmod

#default compilers and mpi stacks
#update these as versions increase.
#this assumes each FASRCSW_MPIS has been built with each FASRCSW_COMPS
#export FASRCSW_COMPS="intel/15.0.0-fasrc01 gcc/4.8.2-fasrc01"
export FASRCSW_COMPS="gcc/4.8.2-fasrc01"
#export FASRCSW_MPIS="openmpi/1.8.3-fasrc02 mvapich2/2.0-fasrc03"
export FASRCSW_MPIS="openmpi/1.10.3-fasrc01 mvapich2/2.2rc1-fasrc01"

#the build host
export FASRCSW_BUILD_HOST=rpmbuild-centos6
test "$(hostname -s)" != "$FASRCSW_BUILD_HOST" && echo "WARNING: the current host is not the canonical build host, $FASRCSW_BUILD_HOST" >&2

#rpm packager credits
<<<<<<< HEAD
export FASRCSW_AUTHOR="$(getent passwd $USER | cut -d: -f5), Duke Center for Genomic and Computational Biology <gcb-help@duke.edu>"
=======
export FASRCSW_AUTHOR="$(getent passwd $USER | cut -d: -f5), Duke Center for Genomics and Computational Biology <gcb-help@duke.edu>"
>>>>>>> 8b43e6b03fc79f0363cb9a333ffdf28fe0e09d0d


#--- environment setup

#set the location of this clone
if [ -z "$BASH_SOURCE" ]; then
	echo "*** ERROR *** your bash is too old -- there's no BASH_SOURCE in the environment" >&2
	return 1
fi
export FASRCSW_DEV="$(dirname "$(readlink -e "$BASH_SOURCE")")"  #(the abs path of the dir containing this setup.sh)

export PATH="$FASRCSW_DEV/bin:$PATH"

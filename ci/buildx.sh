#!/bin/sh
#
# Script to build the Open Watcom tools on Travis
# using the host platform's native C/C++ compiler.
#
# Expects 
#   - POSIX tools
#   - correct setup for all OW build environment variables
#

bootutil_proc()
{
    #
    # build new verison of wmake for host system
    #
    if [ ! -d $OWBINDIR ]; then mkdir $OWBINDIR; fi
    #
    cd $OWSRCDIR/wmake
    mkdir $OWOBJDIR
    cd $OWOBJDIR
    rm -f $OWBINDIR/wmake
    case `uname` in
        Darwin)
            make -f ../posmake clean
            make -f ../posmake TARGETDEF=-D__OSX__
            ;;
        *)
            make -f ../posmake clean
            make -f ../posmake TARGETDEF=-D__LINUX__
            ;;
    esac
    RC=$?
    if [ $RC -eq 0 ]; then
        #
        # build new verison of builder for host system
        #
        cd $OWSRCDIR/builder
        mkdir $OWOBJDIR
        cd $OWOBJDIR
        rm -f $OWBINDIR/builder
        $OWBINDIR/wmake -f ../binmake clean
        $OWBINDIR/wmake -f ../binmake bootstrap=1 builder.exe
        RC=$?
    fi
}

build_proc()
{
    RC=0
    export OWDOSBOX=dosbox
    export SDL_VIDEODRIVER=dummy
    export SDL_AUDIODRIVER=disk
    export SDL_DISKAUDIOFILE=/dev/null
    export OWGHOSTSCRIPTPATH=:
    . ./cmnvars.sh
    cd $OWSRCDIR
    case "$OWBUILD_STAGE" in
        "boot")
            bootutil_proc
            if [ $RC -eq 0 ]; then
                cd $OWSRCDIR
                builder boot
                RC=$?
            fi
            ;;
        "build")
            builder rel
            RC=$?
            ;;
        "docs")
            export OWVERBOSE=1
            builder docs $OWDOCTARGET
            RC=$?
            ;;
        "inst")
            export OWVERBOSE=1
            builder install
            RC=$?
            ;;
        *)
            ;;
    esac
    cd $OWROOT
    return $RC
}

build_proc $*

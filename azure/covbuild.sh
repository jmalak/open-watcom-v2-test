#!/bin/sh
#
# Script to build the Open Watcom tools
# using the host platform's native C/C++ compiler or OW tools.
#
# Expects POSIX tools.

mkdir $OWBINDIR

cd $OWSRCDIR/wmake
mkdir $OWOBJDIR
cd $OWOBJDIR
if [ "$OWTOOLS" = "WATCOM" ]; then
    wmake -f ../wmake
else
    case `uname` in
        FreeBSD)
            make -f ../posmake TARGETDEF=-D__BSD__
            ;;
        Darwin)
            make -f ../posmake TARGETDEF=-D__OSX__
            ;;
        Haiku)
            make -f ../posmake TARGETDEF=-D__HAIKU__
            ;;
#        Linux)
        *)
            make -f ../posmake TARGETDEF=-D__LINUX__
            ;;
    esac
fi
RC=$?
if [ $RC -ne 0 ]; then
    echo "wmake bootstrap build error"
else
    cd $OWSRCDIR/builder
    mkdir $OWOBJDIR
    cd $OWOBJDIR
    $OWBINDIR/wmake -f ../binmake bootstrap=1 builder.exe
        cd $OWSRCDIR
        builder boot
        RC=$?
        if [ $RC -ne 0 ]; then
            echo "builder bootstrap build error"
        else
            builder build cpu_x64 .and
            RC=$?
        fi
fi
cd $TRAVIS_BUILD_DIR
exit $RC

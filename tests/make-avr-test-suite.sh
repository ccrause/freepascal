#!/bin/sh
set -x

TestFPCSource=~/fpc/cc
#DriverCompiler uses global fpc.cfg so make sure everything is updated, compiled and installed before using it
DriverCompiler=~/fpc/installs/lib/fpc/3.2.0/ppcx64
#DriverCompiler=/home/christo/fpc/cc/compiler/ppcx64

DriverFpcMake=$(TestFPCSource)/utils/fpcm/bin/x86_64-linux/fpcmake
# or call export in terminal: export FPCFPMAKE=~/fpc/cc/utils/fpcm/bin/x86_64-linux/fpcmake 

DriverOptions="-vewhi"
TestCompiler=~/fpc/cc/compiler/avr/pp
TestSubArch=avr5
# TestController=atmega328p
TestOptions="-n @~/fpc/cc/fpc.cfg -XPavr- -Wpavrsim -vewhi"

cd $TestFPCSource/tests

export FPCFPMAKE=$(DriverFpcMake)

make distclean TEST_DELTEMP=1 FPC=$DriverCompiler TEST_FPC=$TestCompiler V=1 TEST_SUBARCH=$TestSubArch TEST_OPT= TEST_VERBOSE=1 #FPCFPMAKE=$DriverFpcMake

# include TEST_VERBOSE below to print compiler command line and test build options during test run

make alltest TEST_DELTEMP=1 FPC=$DriverCompiler TEST_FPC=$TestCompiler TEST_SUBARCH=$TestSubArch TEST_OPT="$TestOptions" TEST_CPU_TARGET=avr TEST_OS_TARGET=embedded FPCMAKE=$TestFpcMake EMULATOR=/home/christo/LazProjs/fp-avrsim-cc/avrsim TEST_TIMEOUT=1 CHUNKS=20

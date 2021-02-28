#!/bin/sh
set -x

TestFPCSource=~/fpc/cc
#DriverCompiler uses global fpc.cfg so make sure everything is updated, compiled and installed before using it
DriverCompiler=~/fpc/installs/lib/fpc/3.2.0/ppcx64
#DriverCompiler=/home/christo/fpc/cc/compiler/ppcx64
DriverFpcMake=~/fpc/installs/bin/fpcmake
DriverOptions="-vewhi"
TestCompiler=~/fpc/cc/compiler/avr/pp
TestSubArch=avr5
# TestController=atmega328p
TestOptions="-n @/home/christo/fpc/cc/fpc.cfg -XPavr- -Wpavrsim -vewhi -gw3"
#TestOptions="-XPavr- -vt"

cd $TestFPCSource/tests

#make distclean TEST_DELTEMP=1 FPC=$DriverCompiler TEST_FPC=$TestCompiler V=1 TEST_SUBARCH=$TestSubArch TEST_OPT= TEST_VERBOSE=1 FPCMAKE=$TestFpcMake

make alltest TEST_DELTEMP=1 FPC=$DriverCompiler TEST_FPC=$TestCompiler V=1 TEST_SUBARCH=$TestSubArch TEST_OPT="$TestOptions" TEST_VERBOSE=1 TEST_CPU_TARGET=avr TEST_OS_TARGET=embedded FPCMAKE=$TestFpcMake EMULATOR=/home/christo/LazProjs/fp-avrsim-cc/avrsim TEST_TIMEOUT=1 CHUNKS=20

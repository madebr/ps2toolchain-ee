#!/bin/bash
# 001-binutils.sh by Francisco Javier Trujillo Mata (fjtrujy@gmail.com)

## Download the source code.
BRANCH_NAME="ee-toolchain-gcc9"
if test ! -d "binutils/.git"; then
	git clone -b $BRANCH_NAME https://gitlab.com/ps2max/toolchain/binutils.git && cd binutils || exit 1
else
	cd binutils && git fetch origin && git reset --hard origin/${BRANCH_NAME} || exit 1
fi

TARGET_ALIAS="ee" 
TARGET="mips64r5900el-ps2-elf"
TARG_XTRA_OPTS=""

## Determine the maximum number of processes that Make can work with.
PROC_NR=$(getconf _NPROCESSORS_ONLN)

## Create and enter the toolchain/build directory
mkdir build-$TARGET && cd build-$TARGET || { exit 1; }

## Configure the build.
../configure \
  --quiet \
  --prefix="$PS2DEV/$TARGET_ALIAS" \
  --target="$TARGET" \
  $TARG_XTRA_OPTS || { exit 1; }

## Compile and install.
make --quiet -j $PROC_NR clean   || { exit 1; }
make --quiet -j $PROC_NR CFLAGS="$CFLAGS -D_FORTIFY_SOURCE=0" || { exit 1; }
make --quiet -j $PROC_NR install || { exit 1; }
make --quiet -j $PROC_NR clean   || { exit 1; }

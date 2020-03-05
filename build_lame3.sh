#!/bin/bash

ARCH=$1
source config.sh $ARCH
LIBS_DIR=$(cd `dirname $0`; pwd)/libs/lame3.1
echo "LIBS_DIR="$LIBS_DIR

cd lame-3.100/
PREFIX=$LIBS_DIR/$AOSP_ABI
NDK_HOME=$ANDROID_NDK_ROOT
ANDROID_API=$AOSP_API
SYSROOT=$NDK_HOME/platforms/$ANDROID_API/$AOSP_ARCH
ANDROID_BIN=$NDK_HOME/toolchains/$TOOLNAME_BASE-4.9/prebuilt/linux-x86_64/bin/
CROSS_COMPILE=${ANDROID_BIN}/$TOOLNAME_BASE-
export PATH=$PATH:$ANDROID_SDK/tools:$ANDROID_SDK/platform-tools
 
 ARM_INC=$SYSROOT/usr/include
 ARM_LIB=$SYSROOT/usr/lib
  
  LDFLAGS=" -nostdlib -Bdynamic -Wl,--whole-archive -Wl,--no-undefined -Wl,-z,noexecstack  -Wl,-z,nocopyreloc -Wl,-soname,/system/lib/libz.so -Wl,-rpath-link=$ARM_LIB,-dynamic-linker=/system/bin/linker -L$NDK_HOME/sources/cxx-stl/gnu-libstdc++/libs/armeabi -L$NDK_HOME/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86_64/arm-linux-androideabi/lib -L$ARM_LIB  -lc -lgcc -lm -ldl  "
   
   FLAGS="--host=$HOST --enable-static --disable-shared"
    
	export CXX="${CROSS_COMPILE}g++ --sysroot=${SYSROOT}"
	export LDFLAGS="$LDFLAGS"
	export CC="${CROSS_COMPILE}gcc --sysroot=${SYSROOT}"
	 
	 ./configure $FLAGS \
	 --prefix=$PREFIX

	 make clean
	 make -j4
	 make install

	 cd ..

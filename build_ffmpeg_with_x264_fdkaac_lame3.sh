ARCHS=$1

source config.sh $ARCHS
NOW_DIR=$(cd `dirname $0`; pwd)
LIBS_DIR=$NOW_DIR/libs
echo "LIBS_DIR="$LIBS_DIR

cd ffmpeg-3.3.9

PLATFORM=$ANDROID_NDK_ROOT/platforms/$AOSP_API/$AOSP_ARCH
TOOLCHAIN=$ANDROID_NDK_ROOT/toolchains/$TOOLCHAIN_BASE-$AOSP_TOOLCHAIN_SUFFIX/prebuilt/linux-x86_64

PREFIX=$LIBS_DIR/ffmpeg-x264-fdkaac-merge/$AOSP_ABI

FDK_INCLUDE=$LIBS_DIR/libfdk-aac/$AOSP_ABI/include
FDK_LIB=$LIBS_DIR/libfdk-aac/$AOSP_ABI/lib
X264_INCLUDE=$LIBS_DIR/libx264/$AOSP_ABI/include
X264_LIB=$LIBS_DIR/libx264/$AOSP_ABI/lib
LAM3_INCLUDE=$LIBS_DIR/lame3.1/$AOSP_ABI/include
LAM3_LIB=$LIBS_DIR/lame3.1/$AOSP_ABI/lib




./configure \
--prefix=$PREFIX \
--enable-cross-compile \
--disable-runtime-cpudetect \
--disable-asm \
--arch=$AOSP_ABI \
--target-os=android \
--cc=$TOOLCHAIN/bin/$TOOLNAME_BASE-gcc \
--cross-prefix=$TOOLCHAIN/bin/$TOOLNAME_BASE- \
--disable-stripping \
--nm=$TOOLCHAIN/bin/$TOOLNAME_BASE-nm \
--sysroot=$PLATFORM \
--extra-cflags="-I$X264_INCLUDE  -I$FDK_INCLUDE  -I$LAM3_INCLUDE" \
--extra-ldflags="-L$FDK_LIB -L$X264_LIB" \
--extra-ldflags="-L$FDK_LIB -L$X264_LIB -L$LAM3_LIB" \
--enable-gpl \
--enable-nonfree \
--disable-shared \
--enable-static \
--enable-version3 \
--enable-pthreads \
--enable-small \
--disable-vda \
--disable-iconv \
--enable-libx264 \
--enable-libmp3lame \
--enable-neon \
--enable-yasm \
--enable-libfdk_aac \
--disable-encoders \
--enable-encoder=libx264 \
--enable-encoder=libmp3lame \
--enable-encoder=mpeg4 \
--enable-encoder=libfdk_aac \
--enable-encoder=mjpeg \
--enable-encoder=png \
--enable-encoder=gif \
--enable-nonfree \
--enable-muxers \
--enable-muxer=mov \
--enable-muxer=mp4 \
--enable-muxer=h264 \
--enable-muxer=avi \
--disable-decoders \
--enable-decoder=aac \
--enable-decoder=aac_latm \
--enable-decoder=h264 \
--enable-decoder=mp3 \
--enable-decoder=mpeg4 \
--enable-decoder=mjpeg \
--enable-decoder=png \
--disable-demuxers \
--enable-demuxer=image2 \
--enable-demuxer=h264 \
--enable-demuxer=aac \
--enable-demuxer=mp3 \
--enable-demuxer=avi \
--enable-demuxer=mpc \
--enable-demuxer=mpegts \
--enable-demuxer=mov \
--disable-parsers \
--enable-parser=aac \
--enable-parser=ac3 \
--enable-parser=h264 \
--enable-parser=mp3 \
--enable-protocols \
--enable-zlib \
--enable-avfilter \
--enable-avresample \
--enable-postproc \
--enable-avdevice \
--arch=$ARCH \
--disable-outdevs \
--disable-ffprobe \
--disable-ffplay \
--disable-ffmpeg \
--disable-ffserver \
--disable-debug \
--disable-symver \
--disable-stripping \
--extra-cflags="$FF_EXTRA_CFLAGS  $FF_CFLAGS" \
--extra-ldflags="  "

make clean
make -j8
make install



$TOOLCHAIN/bin/$TOOLNAME_BASE-ld -rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -L$PREFIX/lib -soname libffmpeg.so -shared -nostdlib -Bsymbolic --whole-archive --no-undefined -o $PREFIX/libffmpeg.so \
    $FDK_LIB/libfdk-aac.a \
	    $X264_LIB/libx264.a \
		$LAM3_LIB/libmp3lame.a \
		    libavcodec/libavcodec.a \
			    libavfilter/libavfilter.a \
				    libavresample/libavresample.a \
					    libswresample/libswresample.a \
						    libavformat/libavformat.a \
							    libavutil/libavutil.a \
								    libswscale/libswscale.a \
									    libpostproc/libpostproc.a \
										    libavdevice/libavdevice.a \
											    -lc -lm -lz -ldl -llog --dynamic-linker=/system/bin/linker $TOOLCHAIN/lib/gcc/$TOOLNAME_BASE/4.9.x/libgcc.a

												cd ..


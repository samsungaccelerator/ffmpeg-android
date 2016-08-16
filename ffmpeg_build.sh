#!/bin/bash

. abi_settings.sh $1 $2 $3

pushd ffmpeg

case $1 in
  armeabi-v7a | armeabi-v7a-neon)
    CPU='cortex-a8'
  ;;
  x86)
    CPU='i686'
  ;;
esac

make clean

./configure \
--target-os="$TARGET_OS" \
--cross-prefix="$CROSS_PREFIX" \
--arch="$NDK_ABI" \
--cpu="$CPU" \
--sysroot="$NDK_SYSROOT" \
--disable-everything \
--enable-runtime-cpudetect \
--enable-pic \
--enable-pthreads \
--enable-version3 \
--enable-yasm \
--enable-decoder=aac,h264,mpeg2video,mpeg4,mp3,mjpeg,jpeg2000,libopenjpeg \
--enable-encoder=aac,libx264,mp3,mpeg4,image2,mjpeg,jpeg2000,libopenjpeg \
--enable-demuxer=aac,avi,h264,image2,matroska,pcm_s16le,mjpeg,mov,mp3,m4v,rawvideo,wav \
--enable-filters \
--enable-filter=anullsrc \
--enable-indev=lavfi \
--enable-muxer=h264,mp4,mjpeg,mp3 \
--enable-parser=aac,h264,mjpeg,mpeg4video,mpegaudio,mpegvideo \
--enable-gpl \
--enable-static \
--enable-libx264 \
--enable-protocol=concat,file \
--pkg-config="${2}/ffmpeg-pkg-config" \
--prefix="${2}/build/${1}" \
--extra-cflags="-I${TOOLCHAIN_PREFIX}/include $CFLAGS" \
--extra-ldflags="-L${TOOLCHAIN_PREFIX}/lib $LDFLAGS" \
--extra-cxxflags="$CXX_FLAGS" || exit 1

make -j${NUMBER_OF_CORES} && make install || exit 1

popd

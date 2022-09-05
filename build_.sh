#!/bin/bash

## 依赖安装
#sudo apt-get install git ccache automake flex lzop bison gperf build-essential zip curl zlib1g-dev zlib1g-dev:i386 g++-multilib libxml2-utils bzip2 libbz2-dev libbz2-1.0 libghc-bzlib-dev squashfs-tools pngcrush schedtool dpkg-dev liblz4-tool make optipng maven libssl-dev pwgen libswitch-perl policycoreutils minicom libxml-sax-base-perl libxml-simple-perl bc libc6-dev-i386 lib32ncurses-dev libx11-dev lib32z1-dev libgl1-mesa-dev xsltproc unzip device-tree-compiler


## 清理残留
#make clean && make mrproper


## 配置环境
BUILD_CROSS_COMPILE=/media/grandthief/Ubuntu/Kernel/CrossComplie/aarch64-linux-android-4.9/bin/aarch64-linux-android-
CROSS_COMPILE_ARM32=/media/grandthief/Ubuntu/Kernel/CrossComplie/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-
CLANG_PATH=/media/grandthief/Ubuntu/Kernel/CrossComplie/clang-12.0.5/bin
CLANG_TRIPLE=aarch64-linux-gnu-
export ARCH=arm64
export PATH=${CLANG_PATH}:${PATH}
export LD=$CLANG_PATH/ld.lld

## 配置文件
make -j$(nproc --all) -C $(pwd) O=$(pwd)/out CROSS_COMPILE=$BUILD_CROSS_COMPILE CLANG_TRIPLE=$CLANG_TRIPLE CROSS_COMPILE_ARM32=$CROSS_COMPILE_ARM32 \
    CC=clang \
    ovaltine_defconfig


## 编译内核
A=$(date +%s)
make -j$(nproc --all) -C $(pwd) O=$(pwd)/out CROSS_COMPILE=$BUILD_CROSS_COMPILE CLANG_TRIPLE=$CLANG_TRIPLE CROSS_COMPILE_ARM32=$CROSS_COMPILE_ARM32 \
    CC=clang LD=$LD \
    -Werror \
    Image.gz \
    2>&1 | tee build.txt


## 编译时间
B=$(date +%s)
C=$(expr $B - $A)
echo "kernel finish" $(expr $C / 60)" min "$(expr $C % 60)" s"


## 剪切文件
#cp out/arch/arm64/boot/Image.gz $(pwd)/../Image.gz

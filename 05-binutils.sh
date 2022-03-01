#!/bin/bash
# QQ群：111601117、钉钉群：35948877

source `dirname ${BASH_SOURCE[0]}`/lfs.sh

pushd $LFS/sources/$(getConf LFS_VERSION)
    [ "$CLEAN" ] && rm -rf $(find . -maxdepth 1 -type d -name "binutils-*")
    tar --keep-newer-files -xf $(find . -maxdepth 1 -type f -name binutils-*.tar.*) 2>/dev/null
    cd $(find . -maxdepth 1 -type d -name "binutils-*")
    [ ! $DONT_CONFIG ] && [ -f PATCHED ] && patch -p1 -R < $(find .. -maxdepth 1 -type f -name binutils-*.patch)
    [ ! $DONT_CONFIG ] && patch -p1 < $(find .. -maxdepth 1 -type f -name binutils-*.patch)
    [ ! $DONT_CONFIG ] && touch PATCHED
    [ ! $DONT_CONFIG ] && sleep 3
    mkdir -v build
    cd build
    [ ! $DONT_CONFIG ] && ../configure  \
        --prefix=$LFS/tools             \
        --with-sysroot=$LFS             \
        --target=$LFS_TGT               \
        --disable-nls                   \
        --disable-werror
    make -j $LFS_BUILD_PROC
    make install -j 1
popd

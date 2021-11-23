#!/bin/bash
# 维护：Yuchen Deng QQ群：19346666、111601117

source `dirname ${BASH_SOURCE[0]}`/lfs.sh

pushd $LFS/sources/$(getConf LFS_VERSION)

    if false; then

    # M4
    echo M4... && sleep 2
    [ "$CLEAN" ] && rm -rf $(find . -maxdepth 1 -type d -name "m4-*")
    [ ! $DONT_CONFIG ] && tar --keep-newer-files -xf $(find . -maxdepth 1 -type f -name m4-*.tar.*) 2>/dev/null
    build_dir=$(find . -maxdepth 1 -type d -name "m4-*")/build
    mkdir -v $build_dir
    pushd $build_dir
        [ ! $DONT_CONFIG ] && ../configure  \
            --prefix=/usr                   \
            --host=$LFS_TGT                 \
            --build=$(../build-aux/config.guess)
        make -j $LFS_BUILD_PROC
        make DESTDIR=$LFS install -j 1
        read -p "M4 编译结束，任意键继续..." -n 1
    popd

    # Ncurses
    echo Ncurses... && sleep 2
    [ "$CLEAN" ] && rm -rf $(find . -maxdepth 1 -type d -name "ncurses-*")
    [ ! $DONT_CONFIG ] && tar --keep-newer-files -xf $(find . -maxdepth 1 -type f -name ncurses-*.tar.*) 2>/dev/null
    pushd $(find . -maxdepth 1 -type d -name "ncurses-*")
        sed -i s/mawk// configure
        mkdir -v build_tic
        pushd build_tic
            ../configure
            make -C include
            make -C progs tic
        popd

        mkdir -v build
        pushd build
            [ ! $DONT_CONFIG ] && ../configure  \
                --prefix=/usr                   \
                --host=$LFS_TGT                 \
                --build=$(../config.guess)      \
                --mandir=/usr/share/man         \
                --with-manpage-format=normal    \
                --with-shared                   \
                --without-debug                 \
                --without-ada                   \
                --without-normal                \
                --enable-widec
            make -j $LFS_BUILD_PROC
            make DESTDIR=$LFS TIC_PATH=$(pwd)/../build_tic/progs/tic install
            echo "INPUT(-lncursesw)" > $LFS/usr/lib/libncurses.so
            read -p "Ncurses 编译结束，任意键继续..." -n 1
        popd
    popd

    # Bash
    echo Bash... && sleep 2
    [ "$CLEAN" ] && rm -rf $(find . -maxdepth 1 -type d -name "bash-*")
    [ ! $DONT_CONFIG ] && tar --keep-newer-files -xf $(find . -maxdepth 1 -type f -name bash-*.tar.*) 2>/dev/null
    build_dir=$(find . -maxdepth 1 -type d -name "bash-*")/build
    mkdir -v $build_dir
    pushd $build_dir
        [ ! $DONT_CONFIG ] && ../configure      \
            --prefix=/usr                       \
            --build=$(../support/config.guess)  \
            --host=$LFS_TGT                     \
            --without-bash-malloc
        make -j $LFS_BUILD_PROC
        make DESTDIR=$LFS install -j 1
        ln -sfv bash $LFS/bin/sh
        read -p "Bash 编译结束，任意键继续..." -n 1
    popd

    # Coreutils
    echo Coreutils... && sleep 2
    [ "$CLEAN" ] && rm -rf $(find . -maxdepth 1 -type d -name "coreutils-*")
    [ ! $DONT_CONFIG ] && tar --keep-newer-files -xf $(find . -maxdepth 1 -type f -name coreutils-*.tar.*) 2>/dev/null
    cd $(find . -maxdepth 1 -type d -name "coreutils-*")
    [ ! $DONT_CONFIG ] && [ -f PATCHED ] && patch -p1 -R < $(find .. -maxdepth 1 -type f -name coreutils-*.patch)
    [ ! $DONT_CONFIG ] && patch -p1 < $(find .. -maxdepth 1 -type f -name coreutils-*.patch)
    [ ! $DONT_CONFIG ] && touch PATCHED
    [ ! $DONT_CONFIG ] && sleep 3

    mkdir -v build
    cd build
    [ ! $DONT_CONFIG ] && ../configure          \
        --prefix=/usr                           \
        --host=$LFS_TGT                         \
        --build=$(../build-aux/config.guess)    \
        --enable-install-program=hostname       \
        --enable-no-install-program=kill,uptime
    make -j $LFS_BUILD_PROC
    make DESTDIR=$LFS install -j 1
    mv -v $LFS/usr/bin/chroot $LFS/usr/sbin
    mkdir -pv $LFS/usr/share/man/man8
    mv -v $LFS/usr/share/man/man1/chroot.1 $LFS/usr/share/man/man8/chroot.8
    sed -i 's/"1"/"8"/' $LFS/usr/share/man/man8/chroot.8
    read -p "Coreutils 编译结束，任意键继续..." -n 1

    # Diffutils
    echo Diffutils... && sleep 2
    [ "$CLEAN" ] && rm -rf $(find . -maxdepth 1 -type d -name "diffutils-*")
    [ ! $DONT_CONFIG ] && tar --keep-newer-files -xf $(find . -maxdepth 1 -type f -name diffutils-*.tar.*) 2>/dev/null
    cd $(find . -maxdepth 1 -type d -name "diffutils-*")

    mkdir -v build
    cd build
    [ ! $DONT_CONFIG ] && ../configure  \
        --prefix=/usr                   \
        --host=$LFS_TGT
    make -j $LFS_BUILD_PROC
    make DESTDIR=$LFS install -j 1
    read -p "Diffutils 编译结束，任意键继续..." -n 1

    # File
    echo File... && sleep 2
    [ "$CLEAN" ] && rm -rf $(find . -maxdepth 1 -type d -name "file-*")
    [ ! $DONT_CONFIG ] && tar --keep-newer-files -xf $(find . -maxdepth 1 -type f -name file-*.tar.*) 2>/dev/null
    cd $(find . -maxdepth 1 -type d -name "file-*")
    mkdir -v host_build
    pushd host_build
        [ ! $DONT_CONFIG ] && ../configure  \
            --disable-bzlib                 \
            --disable-libseccomp            \
            --disable-xzlib                 \
            --disable-zlib
        make -j $LFS_BUILD_PROC
    popd
    [ ! $DONT_CONFIG ] && sleep 3
    mkdir -v build
    cd build
    [ ! $DONT_CONFIG ] && ../configure  \
        --prefix=/usr                   \
        --host=$LFS_TGT                 \
        --build=$(./config.guess)
    make FILE_COMPILE=$(pwd)/../host_build/src/file
    make DESTDIR=$LFS install -j 1
    read -p "File 编译结束，任意键继续..." -n 1

    # Findutils
    echo Findutils... && sleep 2
    [ "$CLEAN" ] && rm -rf $(find . -maxdepth 1 -type d -name "findutils-*")
    [ ! $DONT_CONFIG ] && tar --keep-newer-files -xf $(find . -maxdepth 1 -type f -name findutils-*.tar.*) 2>/dev/null
    cd $(find . -maxdepth 1 -type d -name "findutils-*")

    mkdir -v build
    cd build
    [ ! $DONT_CONFIG ] && ../configure  \
        --prefix=/usr                   \
        --localstatedir=/var/lib/locate \
        --host=$LFS_TGT                 \
        --build=$(../build-aux/config.guess)
    make -j $LFS_BUILD_PROC
    make DESTDIR=$LFS install -j 1
    read -p "Findutils 编译结束，任意键继续..." -n 1

    else

    # Gawk
    echo Gawk... && sleep 2
    [ "$CLEAN" ] && rm -rf $(find . -maxdepth 1 -type d -name "gawk-*")
    [ ! $DONT_CONFIG ] && tar --keep-newer-files -xf $(find . -maxdepth 1 -type f -name gawk-*.tar.*) 2>/dev/null
    cd $(find . -maxdepth 1 -type d -name "gawk-*")
    sed -i 's/extras//' Makefile.in

    mkdir -v build
    cd build

    [ ! $DONT_CONFIG ] && ../configure  \
        --prefix=/usr                   \
        --host=$LFS_TGT                 \
        --build=$(../config.guess)
    make -j $LFS_BUILD_PROC
    make DESTDIR=$LFS install -j 1
    read -p "Gawk 编译结束，任意键继续..." -n 1

    fi
popd

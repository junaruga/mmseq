#!/bin/bash

set -ex

pushd src
# In case of Fedora environment
if [ -f /usr/lib64/atlas/libatlas.a ]; then
    sed -i 's|-latlas|/usr/lib64/atlas/libatlas.a|' Makefile
fi
# Test with the samtools latest stable version.
git clone -b 1.9 https://github.com/samtools/samtools.git
if [ -f /etc/fedora-release ]; then
    pushd samtools
    autoheader
    autoconf
    ./configure
    make
    ls -1 *.a
    mkdir include
    cp -p *.h include/
    popd
    # sed -i '/#include "sam.h"/d' bam2hits.cpp
    sed -i '/^LIBS =/ s|$| samtools/libbam.a|' Makefile
    sed -i 's|#include "sam.h"|#include "samtools/include/sam.h"|' bam2hits.cpp
else
    sed -i 's|#include "sam.h"|#include "samtools/sam.h"|' bam2hits.cpp
fi

make clean
make
popd

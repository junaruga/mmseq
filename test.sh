#!/bin/bash

set -ex

pushd src
# In case of Fedora environment
if [ -f /usr/lib64/atlas/libatlas.a ]; then
    sed -i 's|-latlas|/usr/lib64/atlas/libatlas.a|' Makefile
fi
# Test with the samtools latest stable version.
git clone -b 1.9 https://github.com/samtools/samtools.git
sed -i 's|#include "sam.h"|#include "samtools/sam.h"|' bam2hits.cpp

make clean
make
popd

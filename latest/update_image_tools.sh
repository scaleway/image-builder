#!/bin/bash

SRC_FILE=https://github.com/scaleway/image-tools/archive/master.tar.gz
DST_DIR=/src/
DST_FILE=/tmp/image-tools.tar.gz

mkdir -p $DST_DIR || exit 1

curl -fL# -o $DST_FILE $SRC_FILE
tar -xzf $DST_FILE --directory  $DST_DIR
mv $DST_DIR/image-tools-master/ $DST_DIR/image_tools/

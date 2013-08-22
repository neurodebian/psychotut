#!/bin/bash
# we want to convert all images to grayscale

# directory where images are stored
IMGDIR="$HOME/git/psychotut/shell/images"
# directory where to store converted images
GRAYDIR="$IMGDIR/gray"

# create the converted images directory if it does not exists
mkdir -p "$GRAYDIR"

for img in $(ls "$IMGDIR"); do
    echo "Working on $img..."
    convert "$IMGDIR/$img" -colorspace gray "$GRAYDIR/$img"
    echo "Done!"
done

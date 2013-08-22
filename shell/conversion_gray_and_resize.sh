#!/bin/bash
# we want to convert all images to grayscale
# and rescale them to the specified size!
SIZE="$1"

if [ -z "$SIZE" ]; then
    echo "You have to specifiy a size! For example:"
    echo "$0 400x300"
    exit 1
fi

# directory where images are stored
IMGDIR="$HOME/git/psychotut/shell/images"
# directory where to store converted images
RESDIR="$IMGDIR/rescaled"

# create the converted images directory if it does not exists
mkdir -p "$RESDIR"

for img in $(ls "$IMGDIR"); do
    echo "Working on $img..."
    convert "$IMGDIR/$img" -colorspace gray -resize "$SIZE!" "$RESDIR/$img"
    echo "Done!"
done

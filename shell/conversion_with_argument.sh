#!/bin/bash
IMG="$1"
echo "Working on file: $1..."
convert $1 -colorspace gray gray/$1
echo "Done!"

#!/bin/bash
for img in $(ls); do
    echo "Working on $img..."
    convert $img -colorspace gray gray/$img
    echo "Done!"
done

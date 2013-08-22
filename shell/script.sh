#!/bin/bash
# Best Practices and Essential Tools
#
# During this quick bricolage (Basteln ;-) session we are going to explore two
# essential tools that will help us to *automatize* repetitive task in our
# daily routine of programming scientists. Automatizing repetitive tasks is 
# *the* golden way to make our work more reliable reusable efficient. In other
# words automatizing makes our life easier!
# Every time you find your self clicking the same sequence of buttons over
# and over again, or cut&past-ing the same commands from one file to another,
# this is the time you should ask yourself: isn't this what computers are good
# at doing? Why am I doing it manually? There must be a way to do that 
# automatically!
# 
# Let start with such a task: We have a set of around 1000 files containing
# images of houses, that are to be presented as stimuli to participants in a
# psychophysics experiment.
# 
# We want to convert images to greyscale, as our experiment only deals with
# brightness perception ;-)
# 
# First of all download the images database http://is.gd/ecvp_tut and extract it
# somewhere.
# 
# The manual way
# --------------
# - open file manager: thunar
# - navigate to right directory: git/psychotut/shell/images
# - open first image with gimp
# - navigate gimp menus to find out how to convert to greyscale
# - maybe Colors menu?
# - no, it is the Image/Mode menu!
# - save with a different name (or in a different directory?)
# - repeat with next image, 1000 times! No way.
# 
# The Unix shell and my first script
# ----------------------------------
# - open a terminal
# - change directory:
    cd git/psychotut/shell/images
# - list the content of the directory
    ls
# - output is too long, just *pipe* it through a pager
    ls | less
# - we want to see more details about the images
    ls -l | less
# - let see size in a human readable format
    ls -l -h | less
# - how many things can I ask ls to show me about files?
    man ls
# - let's create a directory where to store (hopefully soon ;-) 
#   our converted files
    mkdir gray
# - find out that there is indeed a command called "convert", that manipulates
#   images:
    man convert
# - it belongs to the ImageMagick suite
    man imagemagick
# - the functionality is so complex that the full documentation, including
#   examples, can be find online: http://imagemagick.org
#   note that this is an exception: in general UNIX commands have quite
#   complete man pages and you don't need to be online to read docs!
# - by reading the manual and googling around, we find out that
#   colormap conversion can be done with
    convert input-image.jpg -colorspace gray output-image.jpg
# - let's try it on one image:
    convert ybUcqTty9C.jpg -colorspace gray gray/ybUcqTty9C.jpg
# - visualize original and converted image with eog
    eog ybUcqTty9C.jpg gray/ybUcqTty9C.jpg
# - every sequence of commands can be stored in to a file and 
#   executed afterwards: 
    vim conversion.sh # cut and paste the convert command above
    chmod u+x conversion.sh
    ./conversion.sh
# - this is our first shell “program”: a shell *script*! 
#   now you are officially a programming scientist, congratulations!
# - our first program is a bit limited, wouldn't be nice if we could run it
#   on *all* images?
# - OK, so first save our first running version:
    cp conversion.sh conversion_somewhat_limited.sh
# - ehm, maybe it is better to move the "program" to a different place, so that
#   it is not "mixed" with the images. Always separate data and code: code is
#   reusable and "independent" of the data (at least this is our goal ;-)
    mv conversion.sh conversion_somewhat_limited.sh ../
# - now edit conversion.sh so that it takes an argument (the image file name)
    vim ../conversion.sh
    #!/bin/bash
    IMG="$1"
    echo "Working on file: $1..."
    convert $1 -colorspace gray gray/$1
    echo "Done!"
# - it works! so now, let us loop through all images ;-)
    for img in $(ls); do echo "Working on $img...";done
# - we are now listing all images in a loop. Let us put the loop in the script
    cd ..
    cp conversion.sh conversion_with_argument.sh
    vim conversion.sh
    #!/bin/bash
    for img in $(ls); do
        echo "Working on $img..."
        convert $img -colorspace gray gray/$img
        echo "Done!"
    done
# - Kill it with Control+C
# - variables are cool, let's use more of them! it makes the script reusable!
    cp conversion.sh conversion_loop.sh
    vim conversion.sh
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
# - As usual, kill it with Control+C
# - now we can get creative, image we want to convert to grayscale *and* 
#   rescale the images so that they all have the same size:
    cp conversion.sh conversion_variables.sh
    vim conversion.sh
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
# - test and see what happens if we don't specify the size!
    cp conversion.sh conversion_gray_and_resize.sh
# - here is an another version of the script, which additionally converts the
#   images to a common format (PNG). Note that now we have to extract the
#   file extension...
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
    
    count=1
    total=$(find "$IMGDIR" -type f | wc -l)
    
    for img in $(ls "$IMGDIR"); do
        NAME=$(echo $img | cut -d . -f 1)
        echo "Converting $img ($count/$total)..." 
        convert "$IMGDIR/$img" -colorspace gray -resize "$SIZE!" "$RESDIR/$NAME.png"
        count=$(( $count + 1 ))
    done
# - have a look at the script and try to understand how it works.
# - Would you be able to adapt the script to rename the converted images so that
#   their file name is the file modification time?
#   For example file YX9nWUgaQP.gif, last modified 1981-08-24 18:42:29, should become
#   19810824184229.png
# - Tips:
# - look at the command "stat"
    stat YX9nWUgaQP.gif
    File: ‘YX9nWUgaQP.gif’
    Size: 136850          Blocks: 272        IO Block: 4096   regular file
    Device: fe02h/65026d    Inode: 4728546     Links: 1
    Access: (0644/-rw-r--r--)  Uid: ( 1002/ tiziano)   Gid: (  100/   users)
    Access: 2013-08-13 12:17:11.028852661 +0200
    Modify: 1981-08-24 18:42:29.000000000 +0200
    Change: 2013-08-13 13:33:53.092921716 +0200
# - look at what this command does: 
    stat --format=%Y YX9nWUgaQP.gif
    367519349
# - see how you can use this to get the right output format with
    date --date="@367519349" +%Y%m%d%H%M%S
# - now re-use conversion.sh, set some variables, change a couple of lines...

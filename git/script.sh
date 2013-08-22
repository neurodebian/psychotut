#!/bin/bash
# What if we come back in two months and look at all the 
# versions of our conversion script. Which one are we suppose to use?
# And what if we give a copy to a collegue and she modifies it? And what if
# we find a bug in the current version but we want to use an older version
# (for example the version that does not rescale but only converts to 
# grayscale)? Should we manually look for all the copies of the script we have
# and cut&paste the same fix everywhere? What if we forget some versions?
# And what if after another two months we find out the our bug fix is no good
# and we would prefer the old version back?
# 
# There is an answer to all this questions: Version Control!
# 
# It boils down to one very simple concept: keep track of all changes you make
# to files (it can be code, but it can be a paper you are writing, or the 
# results of some data analysis), with the ability to attach comments to each
# change and to rollback unwanted changes.
#

TG=$HOME/ecvp/git
SR=/home/tiziano/git/psychotut/shell

mkdir $TG
cd $TG

git init
git config --global user.name "Otto Fritz"
git config --global user.email "otto.fritz@nsa.gov"

# copy conversion
cp $SR/conversion_somewhat_limited.sh conversion.sh
git add conversion.sh
git status
git commit -m 'first version of conversion'
git log
gitg&

# next version
cp $SR/conversion_with_argument.sh conversion.sh
git status
git diff
git add conversion.sh
git status
git commit -m 'take the image as argument'

# next version
cp $SR/conversion_loop.sh conversion.sh
git status
git diff
git add conversion.sh
git status
git commit -m 'loop through all images'

# next version
cp $SR/conversion_variables.sh conversion.sh
git status
git diff
git add conversion.sh
git status
git commit -m 'use variables instead of hard-coded paths'

# next version
cp $SR/conversion_gray_and_resize.sh conversion.sh
git status
git diff
git add conversion.sh
git status
git commit -m 'resize images too!'
# let us tag this commit: we just submitted to nature!
git tag submission_to_nature

# last version
cp $SR/conversion.sh conversion.sh
git status
git diff
git add conversion.sh
git status
git commit -m 'change format to PNG and fancy progress report'

# - Where is everything stored?
cd .git
ls
# - Important: 
# - You can add and commit changes to multuple files simultaneously:
#   git stores them together in one single object
# - Exercise: go on working with conversion.sh, improve it, maybe add
#   additional files and use git to keep track of the changes.


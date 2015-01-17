#!/usr/bin/env bash
#
# Sort automatically-uploaded Dropbox photographs and videos into correct 
# folders after removing crud like gifs and screenshots:
# 
# 1. A dated folder (e.g. 1970-01-01 for an image taken on January, 1970) for 
#    non-square (non-Instagram) images.
# 2. My dump folder for square Instagram images.
# 
# Blame Mark (mark@bhalash.com) for this. 
# 

# Debug 
# set -x

uploads_folder=$HOME'/Dropbox/Camera Uploads/'
instagram_folder=$HOME'/Dropbox/Photos/Instagram/'
IFS='
'

if [[ $UID == 0 ]]; then
    exit 1
elif [[ ! -d "$uploads_folder" ]] || [[ ! -d "$instagram_folder" ]]; then
    exit 2
fi

function trim_spaces() {
    # Safely remove spaces in the file name.
    new_name=$(echo "$1" | sed -e 's/ /_/g')
    mv "$1" $new_name && echo $new_name
}

function test_aspect_ratio() {
    # Test whether the aspect ratio of image $1 == $2:1
    x=$(identify -format '%w' $1)
    y=$(identify -format '%h' $1)


    if [[ ! $file =~ \.jpg$ ]]; then
        echo 1
        return 1
    fi

    if [[ $x -ge $y ]]; then
        x=$(echo "scale=0; $x * $2" | bc -l)
    elif [[ $y -ge $x ]]; then
        y=$(echo "scale=0; $y * $2" | bc -l)
    fi

    if [[ $x -eq $y ]]; then
        echo 0
    else
        echo 1
    fi
}

function make_dated_directory() {
    # Creates a dated folder and moves the image into it. 
    directory_name=$(echo "$1" | cut -c1-10)

    if [[ ! -d $directory_name ]]; then
        mkdir $directory_name
    fi

    mv $1 $directory_name
}

cd "$uploads_folder"
find . -maxdepth 1 -type f -name ".*png" -o -name "*.gif" -exec rm {} \;

for file in $(find . -maxdepth 1 -type f -name "* *.jpg" -o -name "* *.mov"); do
    file=$(trim_spaces "$file")

    if [[ $(test_aspect_ratio $file 1) -eq 0 ]]; then
        mv $file "$instagram_folder"
    else 
        make_dated_directory $file
    fi
done

exit 0
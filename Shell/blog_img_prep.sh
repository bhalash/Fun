#!/usr/bin/env bash
# mark@bhalash.com

# Debug
# set -x 

# Path to public Dropbox folder.
dropbox="$HOME/Dropbox/Public/content"
# Dropbox UUID.
uuid="4144919"
# Name of thumbnails folder.
medium_folder="m"
# Size and quality of full image.
large_size=1700
large_quality=100
# Size and quality of medium image.
medium_quality=70
medium_size=1000
# Thumbnail folder.
temp="/tmp/prep"

add_line() {
    # Add a line to the eventual HTML code. 
    # $1 = Dropbox UUID
    # $2 = Unique folder name.
    # $3 = File name.
    # $4 = Temp folder. 
    txt="CHANGE ME"
    echo "<a title=\"$txt\" href=\"https://dl.dropboxusercontent.com/u/$1/content/$2/$3\"><img src=\"https://dl.dropboxusercontent.com/u/$1/content/$2/m/$3\" alt=\"$txt\" /></a>" >> $4
}

resize_image() {
    # First size, second file. The \> prevents the file from being upscaled. 
    # $1 = Desired x size.
    # $2 = file to be resized.
    mogrify -verbose -quality "$1" -format jpg -resize "$2"x\> "$3"
}

if [[ ! -d $1 ]]; then
    # Create the directory.
    mkdir -p $1/$medium_folder
fi

if [[ -d $dropbox/$1 ]]; then
    # So we can overwrite the existing directory.
    rm -r $dropbox/$1
fi

src=$1
shift
count=1

for n in "$@"; do
    if [[ -e "$1" ]]; then
        cp "$1" $src/$count.jpg
        cp "$1" $src/$medium_folder/$count.jpg
        let count++
        shift
    fi
done

cd $src

if [[ $(ls -1 *.jpg 2> /dev/null | wc -l) -eq 0 ]]; then
    echo "No images selected!"
    rm -r $(pwd)
    exit 1
fi

for n in *.jpg; do
    resize_image $large_quality $large_size $n
    resize_image $medium_quality $medium_size "$medium_folder"/$n
    add_line $uuid $src $n $temp
done

if [[ $(uname) == 'Darwin' ]]; then
    pbcopy < $temp
else if [[ $(uname) == 'Linux' ]]; then
    cat $temp | xclip -sel clip
else if [[ ${$(uname):0:6} == 'CYGWIN' ]]; then
    putclip < $temp
fi

rm $temp
mv $(pwd) $dropbox
exit 0
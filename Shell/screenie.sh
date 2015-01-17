#!/bin/bash

timestamp="$(date +%Y%m%d%H%M%S)"
bit_key="BITLY_KEY_HERE"
bit_user="BITLY_USERNAME_HERE"
db_user="DROPBOX_UID_HERE"
db_pub="$HOME/Dropbox/Public/screenshots"

check_dependencies() {
    # Takes screenshot.
    dep[1]="scrot"
    # Parses the URL.
    dep[2]="curl"
    # Preferred method to store files.
    dep[3]="dropbox"
    # Copies content to the clipboard.
    dep[4]="xclip" 

    for n in $(seq ${#dep[@]}); do
        command -v ${dep[$n]} > /dev/null 2>&1

        if [ $? == 1 ]; then
            echo "ERROR: Command '${dep[$n]}' not found"
            dep_missing=1
        fi
    done

    if [[ $dep_missing == 1 ]]; then
        exit 1
    fi
}

encode_url() {
    # Replace colons, slashes and periods.
    echo $1 | sed 's,:,%3A,g;s,/,%2F,g;s,\.,%2E,g'
}

bit_url() {
    # Parse the URL with bit.ly's old API.
    log="login=$1"
    key="apiKey=$2"
    url="longUrl=$(encode_url $3)"
    fmt="format=txt"

    curl -S -s "http://api.bit.ly/v3/shorten?$log&$key&$url&$fmt"
}

if [[ ! -d "$db_pub" ]]; then
    mkdir -p "$db_pub"
fi

cd "$db_pub"
scrot -d 0 -q 100 $timestamp.jpg
bit_url $bit_user $bit_key $(dropbox puburl $(ls -1t . | head -n 1)) \
| xclip -sel clipboard

exit 0

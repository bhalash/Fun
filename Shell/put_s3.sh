#!/bin/bash
# Call with command <bucket> <director{y,ies}>
# Email mark@bhalash.com for help. 

print_time() {
    # Appends timestamp to start of next line.
    echo -n "$(date +%H:%M:%S) "
}

check_deps() {
    # Check for missing dependencies and exit if they aren't found.
    dep[1]="/usr/bin/s3cmd"

    dep_missing=0
    for n in $(seq ${#dep[@]}); do
        if [ ! -x ${dep[$n]} ]; then
            print_time
            echo "ERROR: '${dep[$n]}' not found"
            dep_missing=1
        fi
    done

    if [[ $dep_missing == 1 ]]; then
        exit 1
    fi
}

check_bucket_exists() {
    # Test for the existence of the given bucket, and exit if it isn't found.
    s3cmd ls | grep "$1"
    
    if [[ $? == 1 ]]; then
        print_time
        echo "ERROR: Bucket '$1' not found"
        exit 1
    fi
}

s3put() {
    # Test for the existence of $file in the remote bucket, and upload it if it
    # doesn't exist. s3cmd's sync/put command continued to upload 
    # already-existing files. 
    temp="/tmp/s3_$(date +%Y%m%d%H%M%S%N)"

    cd "$1" && cur_dir=$(basename -a $PWD)
    s3cmd ls -r $2/$cur_dir | sed -e 's/^.*  //g' > $temp 
    
    for file in $(find . -type f -iname "*" | sed -e 's/^.\///g'); do
        grep "$file" < $temp > /dev/null 2>&1

        if [[ $? == 1 ]]; then
            print_time
            # s3cmd generates excessively verbose output, so I parse it.
            s3cmd --disable-multipart put "$file" $2/"$cur_dir"/"$file" 2<&1 \
            | grep -v "WARNING" | sed -e 's/ \[.*\]//g' 
        else
            print_time
            echo "File '$file' is already stored as '$2/$cur_dir/$file'"
        fi
    done

    rm $temp > /dev/null 2>&1
}

check_deps
check_bucket_exists $1
bucket=$1
shift

if [[ $# == 0 ]]; then
    print_time
    echo "ERROR: No directories provided"
    exit 1
fi

for file in "$@"; do
    if [ -d "$1" ]; then
        s3put "$1" $bucket 
    fi

    shift
done

exit 0
#!/bin/bash
# File is in format:
# id,event_name,description,location,event_date,start_time,end_time,active,deleted
# Desination file for output
output_file="output_$(date +%Y%m%d%H%M%S).csv"
# Regex for date-events take place on the 29,30,31 and 1
# If the line ONLY contains 29 OR 30 OR 31 OR 1 OR 2.
regex_date='^(28|29|30|31|1|2)$'
# Regex for the time of day. 24 hour system, no colon.
# If the line is ONLY 0000 TO 2359
regex_time='^([01]?[0-9]|2[0-3])[0-5][0-9]$'
# Data request strings.
request_string[1]='Event name: '
request_string[2]='Event description: '
request_string[3]='Event location: '
request_string[4]='Event date (28-31,1-2): '
request_string[5]='Enter start time (0000): '
request_string[6]='Enter end time (0000): '

IFS='
'

function write_line {
    # Write a line to the output file.
    # if $1 == 1 then echo a newline instead of a comma at the end of the string.
    string=$1

    if [[ $2 -eq 1 ]]; then
        echo $string >> $output_file
    else 
        add_comma $string >> $output_file 
    fi
}

function strip_commas {
    # Replace commas with a space.
    echo "$1" | sed -e 's/,/ /g'
}

function add_comma {
    # Add the trailing comma to a string.
    echo -n "$1,"
}

function expand_time {
    # Add a colon to the given time.
    echo $1 | sed -r -e 's/^.{2}/&:/'
}

function expand_date {
    # Expand the date to add the year and month in ISO 8601 (YYYY-MM-DD) format.
    case $1 in 
        29) echo "2014-10-$1";;
        30) echo "2014-10-$1";;
        31) echo "2014-10-$1";;
         1) echo "2014-11-$1";;
         2) echo "2014-11-$1";;
    esac
}

function get_field_data {
    read -r -p "${request_string[$1]}" field_data 

    if [ $1 -ge 1 ] && [ $1 -le 3 ]; then
        # Parse name, description or location.
        # Only care that there isn't a comma. 
        input=$(strip_commas $input)
    elif [ $1 -eq 4 ]; then

        # Parse and validate date.
        if [[ $field_data =~ $regex_date ]]; then
            field_data=$(expand_date $field_data)
        else 
            echo 'Invalid date.'
            get_field_data $1
        fi

    elif [ $1 -eq 5 ] || [ $1 -eq 6 ]; then

        # Validate and parse time.
        if [[ $field_data =~ $regex_time ]]; then
            field_data=$(expand_time $field_data)
        else
            echo 'Invalid time.'
            get_field_data $1
        fi

    fi

    write_line $field_data
}

# Clear the terminal.
clear

if [ ! -f $output_file ]; then
    # Create the output file if it doesn't exist.
    touch $output_file
fi

# First record number.
row=1

# while [ true ]; do 
while [ $row -le 7 ]; do
    echo -e "Row #$row:\n----------"

    # main loop
    for column in $(seq 0 1 8); do 
        if [ $column -eq 0 ]; then
            # Column 0
            # Record number
            write_line $row
        elif [ $column -gt 0 ] && [ $column -le 6 ]; then
            get_field_data $column
        elif [ $column -eq 7 ]; then
            # Column 7
            write_line '1'
        elif [ $column -eq 8 ]; then
            # Column 8
            write_line '0' 1
        fi
    done 

    # Pause and give the script a chance to exit.
    echo; read -p "Hit Ctrl + C to exit or [RETURN] to continue " -n 1 -s key
    echo; echo

    let row++
done

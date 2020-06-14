#!/usr/bin/env bash

timestamp=$(date +%s)

input_file="${HOME}/.mozilla/firefox/ggn52gej.default/sessionstore.jsonlz4"

# Mozilla firefox creates the sessionstore.jsonlz4 file on closing browser.
# If the browser is open when you run this script, it should look at the sessionstore-backup directory
if [[ ! -f "$input_file" ]]; then
    input_file="${HOME}/.mozilla/firefox/ggn52gej.default/sessionstore-backups/recovery.jsonlz4"
fi

# Create the backup directory to store the json file with the wanted information
if [[ ! -d "./sessionstore_bkp" ]]; then
    mkdir ./sessionstore_bkp
fi

output_file="${HOME}/workspace/gztabs/script/sessionstore_bkp/${timestamp}_sessionstore.json"

# Decompress Mozilla-flavor LZ4 files
python3 mozlz4.py -d < $input_file > $output_file

# If the json file could not be created, exit the program
if [[ ! -f "$output_file" ]]; then
    echo "$output_file does not exist"
    exit
fi

# Create the target directory of the output HTML
if [[ ! -d "./assets" ]]; then
    mkdir ./assets
fi

# Read the json file and apply the template to generate an HTML lis of all opened tabs
python3 getTabs.py $output_file > "./assets/${timestamp}_list.html"

echo "Done!"

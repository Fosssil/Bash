#!/bin/bash

# Define the target directory
TARGET_DIR="/data/data/com.termux/files/home/storage/pictures/Instader"

# Check if there are any .webp files in the target directory
WEBP_FILES=$(ls "$TARGET_DIR"/*.webp 2>/dev/null)

# If no .webp files found, print a message and exit
if [ -z "$WEBP_FILES" ]; then
    echo -e "\033[31m-->No webp file found, No need to rename :)<---\033[0m"
    exit 0
fi

# Loop through each .webp file and rename it to .jpg
for FILE in $WEBP_FILES; do
    NEW_NAME="${FILE%.webp}.jpg"
    mv "$FILE" "$NEW_NAME"
done
echo -e "\033[32m-->Rename successful<---\033[0m"
####################### Without error message ######################
## Define the directory containing the images
#TARGET_DIR="/data/data/com.termux/files/home/storage/pictures/Instader"
#
## Navigate to the target directory
#cd "$TARGET_DIR" || {
#    echo "Directory not found!"
#    exit 1
#}
#
## Loop through all .webp files in the directory
#for file in *.webp; do
#    # Check if the file exists (in case no .webp files are found)
#    [ -e "$file" ] || continue
#
#    # Rename the file by changing the extension to .jpg
#    mv -- "$file" "${file%.webp}.jpg"
#done
#echo -e "\033[32m--> Rename successfull\033[0m"

################################# FIND IN WHOLE OS (unedited) ##################################

#
## Find all .webp files in the entire filesystem (excluding system directories for safety)
## and rename them to .jpg
#find / -type f -name "*.webp" 2>/dev/null | while read -r file; do
#  # Define the new filename by replacing .webp with .jpg
#  new_file="${file%.webp}.jpg"
#
#  # Rename the file
#  mv "$file" "$new_file"
#done
#
#echo "Renaming complete."
#

#!/bin/bash
#-----> Sort the validator keys of metal servers according to their hostname <------#

# Define the input and output file paths
input_file="keys.txt"
output_file="sorted_keys.txt"

# Read keys from the input file, sort them by the last number, and write to the output file
sort -t '-' -k 4 -n "$input_file" >"$output_file"

# Print a confirmation message
echo "Sorted keys have been written to $output_file"

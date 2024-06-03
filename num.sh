#!/bin/bash
######---------> List the missing index of server from keys.txt <--------------------#########


# Define the input and output file paths
sorted_file="keys.txt"
missing_file="missing_numbers.txt"

# Initialize an array to hold the numbers extracted from the keys
numbers=()

# Read the sorted keys and extract the last numbers
while IFS= read -r line; do
    # Extract the number using awk, assuming the number is the last field separated by hyphens
    number=$(echo "$line" | awk -F'-' '{print $NF}')
    numbers+=("$number")
done < "$sorted_file"

# Find the minimum and maximum numbers to establish the range
min_number=${numbers[0]}
max_number=${numbers[${#numbers[@]}-1]}

# Initialize an array to hold the missing numbers
missing_numbers=()

# Find the missing numbers
for (( i=min_number; i<=max_number; i++ )); do
    if ! [[ " ${numbers[@]} " =~ " $i " ]]; then
        missing_numbers+=("$i")
    fi
done

# Write the missing numbers to the output file
printf "%s\n" "${missing_numbers[@]}" > "$missing_file"

# Print a confirmation message
echo "Missing numbers have been written to $missing_file"


#!/bin/bash

# Define your source directory
SOURCE_DIR="/Users/gopal/Work/My Personal Projects/Learning/Essential Developer/Execute/essential_developer/iOS Lead Essentials/essential-feed-case-study"

# Total LOC
total_loc=$(find "$SOURCE_DIR" -name '*.swift' -exec wc -l '{}' \; | awk '{print $1}' | paste -sd+ - | bc)

# Swift file count
swift_file_count=$(find "$SOURCE_DIR" -name '*.swift' | wc -l)

# Average LOC per file
average_loc=$((total_loc / swift_file_count))

# TODO comment count
todo_count=$(grep -r "TODO:" "$SOURCE_DIR" | wc -l)

# FIX comment count
fix_count=$(grep -r "FIX:" "$SOURCE_DIR" | wc -l)

# Optional force unwrap (!) count
# This pattern is very basic and might not perfectly reflect the actual count.
force_unwrap_count=$(grep -r "\!" "$SOURCE_DIR" | wc -l)

# unowned reference count
unowned_count=$(grep -r "unowned" "$SOURCE_DIR" | wc -l)

# Max indentation level
# This is a placeholder for the actual command needed to calculate max indentation
# You'll need to replace it with the appropriate command
max_indent="N/A"

# Assignable var declaration count
var_declaration_count=$(grep -rns 'var [a-zA-Z]' "$SOURCE_DIR" | wc -l)

# Output results in a table format
echo "Indicators                                  Now     Desired"
echo "-----------------------------------------   ---     -------"
printf "Total LOC                                   %d      N/A\n" $total_loc
printf "Swift file count                            %d      N/A\n" $swift_file_count
printf "Average LOC per file                        %d      <100\n" $average_loc
printf "TODO comment count                          %d      %d\n" $todo_count 0
printf "FIX comment count                           %d      %d\n" $fix_count 0
printf "Optional force unwrap (!) count             %d      %d\n" $force_unwrap_count 0
printf "unowned reference count                     %d      %d\n" $unowned_count 0
printf "Max indentation level                       %s      <=5\n" "$max_indent"
printf "Assignable var declaration count            %d      %d\n" $var_declaration_count 0


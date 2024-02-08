#!/bin/bash

# Function to calculate max indentation in a file
calculate_max_indent() {
    local max_indent=0
    while IFS= read -r line; do
        # Remove leading spaces and calculate length difference
        local trimmed="${line#"${line%%[! ]*}"}"
        local indent=$(( (${#line} - ${#trimmed}) / 4 ))

        # Update max indentation levels
        if (( indent > max_indent )); then
            max_indent=$indent
        fi
    done < "$1"

    echo $max_indent
}

# Main script to find the file with the maximum indentation
max_global_indent=0
while IFS= read -r -d '' file; do
    file_max=$(calculate_max_indent "$file")
    if (( file_max > max_global_indent )); then
        max_global_indent=$file_max
    fi
done < <(find . -name '*.swift' -print0)

echo "Maximum indentation level found: $max_global_indent"

#!/bin/bash

# Define a pattern that matches common force unwrap cases
# Adjust the pattern as needed to better match your codebase's practices
pattern='\)!|\.!|\?!'

# Find all .swift files and use grep to count occurrences of the pattern
# This command aggregates counts across all files
find . -name '*.swift' -exec grep -oE "$pattern" '{}' \; | wc -l


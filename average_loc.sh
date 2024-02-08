# Calculate total LOC in Swift files
total_loc=$(find . -name '*.swift' -exec wc -l '{}' \; | awk '{print $1}' | paste -sd+ - | bc)

# Calculate total number of Swift files
file_count=$(find . -name '*.swift' | wc -l)

# Calculate average LOC per Swift file
if [ "$file_count" -gt 0 ]; then
  average_loc=$(echo "scale=2; $total_loc / $file_count" | bc)
  echo "Average LOC per Swift file: $average_loc"
else
  echo "No Swift files found."
fi


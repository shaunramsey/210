#!/bin/zsh
set -e
# exit if anything fails

# Define the file containing the number
file_path="assets/version.txt"

# Check if the file exists and contains a valid number
if [[ -f "$file_path" && -s "$file_path" ]]; then
    current_value=$(<"$file_path") # Read the content of the file
    if [[ "$current_value" =~ ^[0-9]+$ ]]; then # Check if it's a number
        new_value=$((current_value + 1)) # Increment the value
    else
        echo "Error: File contains non-numeric data. Initializing to 1."
        new_value=1
    fi
else
    echo "File not found or empty. Initializing to 1."
    new_value=1
fi

# Write the new value back to the file
echo "$new_value" > "$file_path"

echo "Build/Deploy in '$file_path' updated to version: $new_value"

echo "Acquiring git log history"
git log --pretty=format:"%cn -- %cd%n%h: %s"> assets/gitlog.txt

flutter build web --release
firebase deploy --only hosting
echo "-------- Build/Deploy/Hosted Version: $new_value"
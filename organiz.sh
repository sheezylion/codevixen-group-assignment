#!/bin/bash

# Script to organize files in a directory by extension

# Define the target directory
TARGET_DIR="$1"

# Check if the target directory is provided
if [ -z "$TARGET_DIR" ]; then
  echo "Usage: $0 <please specify target directory>"
  exit 1
fi

# Check if the target directory exists
if [ ! -d "$TARGET_DIR" ]; then
  echo "Error: Target directory '$TARGET_DIR' does not exist."
  exit 1
fi

# Create a directory if it doesn't exist
create_directory() {
  local dir_name="$1"
  if [ ! -d "$dir_name" ]; then
    mkdir "$dir_name"
    echo "Created directory: $dir_name"
  fi
}

# Move files to their respective directories
organize_files() {
  local moved_files_count=0 # Counter for moved files

  # Use a for loop to avoid subshell issues
  for file in "$TARGET_DIR"/*; do
    if [ -f "$file" ]; then
      extension="${file##*.}"
      if [ "$extension" = "$file" ]; then
        continue # Skip files without extension
      fi

      # Determine directory name based on extension
      case "$extension" in
        txt)
          dir_name="TextFiles"
          ;;
        jpg|jpeg|png|gif)
          dir_name="Images"
          ;;
        pdf)
          dir_name="PDFs"
          ;;
        *)
          dir_name="OtherFiles"
          ;;
      esac

      # Create the directory if it doesn't exist
      create_directory "$TARGET_DIR/$dir_name"

      # Move the file and increment the counter
      if mv "$file" "$TARGET_DIR/$dir_name/"; then
        echo "Moved '$file' to '$TARGET_DIR/$dir_name/'"
        ((moved_files_count++)) # Increment the counter for each moved file
      else
        echo "Error moving '$file' to '$TARGET_DIR/$dir_name/'"
      fi
    fi
  done

  # Provide feedback on how many files were moved
  echo "Total files moved: $moved_files_count"
}

# Main script logic
echo "Starting file organization in '$TARGET_DIR'..."
organize_files

echo "File organization complete."
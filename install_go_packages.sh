#!/bin/bash

# Default path to the .goinstall file
GO_INSTALL_FILE=".goinstall"

# Function to display usage
usage() {
  echo "Usage: $0 [-f <file_path>]"
  echo "  -f <file_path>    Path to the .goinstall file (default: .goinstall)"
  exit 1
}

# Parse command-line options
while getopts "f:" opt; do
  case "$opt" in
    f) GO_INSTALL_FILE="$OPTARG" ;;  # Set custom file path
    *) usage ;;  # Show usage for invalid options
  esac
done

# Check if the .goinstall file exists
if [[ ! -f "$GO_INSTALL_FILE" ]]; then
  echo "Error: $GO_INSTALL_FILE not found!"
  exit 1
fi

# Loop over each line in the .goinstall file and run go install
while IFS= read -r package || [ -n "$package" ]; do
  # Skip empty lines or comments
  if [[ -z "$package" || "$package" =~ ^\s*# ]]; then
    continue
  fi

  # Run go install for the current package
  echo "Installing $package..."
  go install "$package"
  
  # Check if the installation was successful
  if [[ $? -eq 0 ]]; then
    echo "$package installed successfully."
  else
    echo "Failed to install $package."
  fi
done < "$GO_INSTALL_FILE"

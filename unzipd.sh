#!/bin/bash
#
# This script extracts the contents of a zip archive in a user-friendly way, 
# whether the archive has a single root file/directory or multiple files at the 
# root level.
#   * If the archive contains just one root file or directory, the script 
#     extracts it directly.
#   * If the archive contains multiple files at the root level, the script 
#     creates a subdirectory named after the archive and extracts all files into
#     this subdirectory.
# 
# Benefits:
# * No need to manually check the archive’s structure.
# * Avoids double nested directories.
# * Prevents accidental extraction of multiple files into the current directory.
#
# Implementation:
# The script extracts the archive into a temporary directory at first. Then it
# checks if there's a single root element or multiple root elements. If there's
# a single root element, it copies that root element to the current directory.
# If there are multiple root elements, it moves the whole temporary directory to
# the current directory.

set -e

# Validate input parameters
zippath="$1"
if [ -z "$zippath" ]
then
  echo "Missing mandatory parameter zippath."
  echo "Usage: unzipd.sh <zippath>"
  echo "Example: unzipd.sh ""~Downloads/my.zip"""
  exit 1
fi

# Validate dependencies
if ! command -v unzip > /dev/null; then
  echo "Error: unzip command not found. Please install unzip."
  exit 1
fi

# Unzip into temporary directory
tmpdir=$(mktemp -d) || { echo "Failed to create temporary directory"; exit 1; }
/usr/bin/unzip -d "$tmpdir" "$zippath"

# Check the number of root files in the archive
numrootfiles=$(ls -1 "$tmpdir" | wc -l)

if [ "$numrootfiles" -eq 1 ]; then
  # If the archive contains a single root file, move this file to the current 
  # directory
  rootfile=$(ls -1 "$tmpdir")

  if [ ! -e "$rootfile" ]
  then
    mv "$tmpdir/$rootfile" $rootfile
    rm -r "$tmpdir"
  else
    echo "Target directory $rootfile already exists. Aborting."
    rm -r "$tmpdir"
    exit 1;
  fi
else
  # If the archives contains multiple root files, move the temporary directory 
  # to the current directory (renaming to the archives basename)
  zipfilename=${zippath##*/}
  zipbasename=${zipfilename%%.*}

  if [ ! -e "$zipbasename" ]
  then
    mv "$tmpdir" "$zipbasename"
  else
    echo "Target directory $zipbasename already exists. Aborting."
    rm -r "$tmpdir"
    exit 1;
  fi 
fi

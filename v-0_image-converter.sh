#!/bin/bash

# Set the "strict mode"
set -eu
set -o pipefail
set -o errexit
  # -e |=> Exit if any command has a non-zero exit status (except loops/ifs/lists/...).
  # -u |=> Exit on references to undefined variables.
  # -o pipeline |=> Return err-code of the first-failed command as an err-code of a whole pipeline.
  # -o errexit |=> Exit script in case of err.

IFS=$'\n\t'
# Set Internal Field Separator for filenames.

THIS_NAME=${0}
ID_LEN="${1:-8}"
INIT_ID="${2:-0}"
THIS_DIR="${3:-$PWD}"

if [ "${THIS_DIR: -1}" != "/" ]; then THIS_DIR="$THIS_DIR/"; fi
# Make sure THIS_DIR ends with a slash.


if [ ! -d "$THIS_DIR" ]; then
  echo "Given path is not valid directory. Please check."
  exit 1;
fi

# Check if ID-... args are adeqate ints.
if [ "$ID_LEN" -gt 50 ] || [ "$ID_LEN" -eq 0 ]; then
  echo "Given id-args are not supported. Please use numbers in range [1, 50]."
  exit 1;
fi

cd ${THIS_DIR}

for f in $(ls); do
  [ -f "$f" ] || continue

    if [ $(file -ib "$f" | grep image) ]; then
      echo "$f"
      echo $(stat -c %y "$f")
      convert "$f" "converted/${f%.*}.jpg";
    fi

done

# ToDo
# ! -- stats 
# ! -- Add script to clean up the converted directory.
# * -- Alternative convert. -- convert "$f" "${THIS_DIR}converted/${f%.*}.jpg";

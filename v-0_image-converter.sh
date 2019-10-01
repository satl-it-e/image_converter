#!/bin/bash

# Set the "strict mode"
# -e => Exit if any command has a non-zero exit status.
# -u => Exit on references to undefined variables.
# -o pipeline => Return err-code of the first-failed command as an err-code of a whole pipeline.
# -o errexit => Exit script in case of err.
set -euo pipefail errexit
# Set Internal Field Separator for filenames.
IFS=$'\n\t'

ID_LEN=${1:-8}
INIT_ID=${2:-0}
THIS_DIR=${3:-$PWD}


# Make sure THIS_DIR ends with slash
if [ "${THIS_DIR: -1}" != "/" ]; then THIS_DIR="${THIS_DIR}/"; fi

# Check THIS_DIR arg.
if [ ! -d ${THIS_DIR} ]; then
  echo "Given path is not valid directory. Please check."
  exit 1;
fi

# Check ID-... args.
if [ $ID_LEN -gt 50 -o $ID_LEN -eq 0 ]; then
  echo "Given id-length is not supported. Please use numbers in range [1, 50]."
  exit 1;
fi

cd ${THIS_DIR}

for f in ${THIS_DIR}*; do
  [ -f "$f" ] || continue

    if [ $(file -ib ${f} | grep image) ]; then  # CHECK BITMAPS
      echo stats: $(stat -c %y ${f})
      convert "$f" "${f%.*}.jpg";
    fi

done





# ToDo
# 1:
# alternative img-type check
  # if (echo "$set"  | fgrep -q "$WORD")
  # built-in img-recognizing command

# 2:
# check on bitmaps! else:
# if [ $("$f" | grep -qE 'image|bitmap') ]; then
# if [[ $(file -b ${f} | awk '{print $1}') =~ ^(PNG|JPG|GIF|BMP)$ ]]; then
#   echo ---${f};
# fi
# SUPPORTED_IMG_EXTS=[]

# 3:
# convert "$f" "${THIS_DIR}converted/${f%.*}.jpg";

#!/bin/bash

set -o errexit -o nounset -o pipefail -o noclobber
# errexit == -e |=> Exit if any command has a error status (except loops/ifs/lists/...).
# nounset == -u |=> Exit on references to undefined variables.
# pipefail |=> Return err-code of the first-failed command as an err-code of a whole pipeline.
# noclobber == -C |=> Prevent overwriting files by redirection (may be overridden by >|).

# set -o xtrace

IFS=$'\n\t'
# Set Internal Field Separator for filenames.

THIS_NAME=${0}
ID_LEN="${1:-8}"
INIT_ID="${2:-0}"
THIS_DIR="${3:-$PWD}"

echo $ID_LEN
echo $INIT_ID
echo $THIS_DIR

# Make sure THIS_DIR ends with a slash.
if [ "${THIS_DIR: -1}"!="/" ]; then THIS_DIR="$THIS_DIR/"; fi


if [ ! -d "$THIS_DIR" ]; then
  echo "Given path is not valid directory. Please check."
  exit 1;
fi


if [ "$ID_LEN" -gt 50 ] || [ "$ID_LEN" -eq 0 ]; then
  echo "Given id-args are not supported. Please use numbers in range [1, 50]."
  exit 1;
fi


if [ ${#INIT_ID} -ne ${ID_LEN} ]; then
  echo "Given init-id is not equal to the given id-len."
  exit 1;
fi

# ACTUAL CONVERTER.

cd "${THIS_DIR}"

F_ID="${INIT_ID}"

for f in $(ls); do
  [ -f "$f" ] || continue

    if [ $(file -ib "$f" | grep image) ]; then
      IFS=$' '; read -a STATS_LIST <<< "$(stat -c %y "$f")"; IFS=$'\n\t'

      F_DATE="${STATS_LIST[0]}"
      F_TIME="${STATS_LIST[1]//[:]/-}"
      F_TIME="${F_TIME%.*}"

      F_NAME="${F_DATE}-${F_TIME}-${F_ID}"
      convert "$f" "converted/${F_NAME}.jpg";

      F_ID=$(("${F_ID}"+1))

    fi

done

# ToDo
# ! -- Add script to clean up the converted directory.
# * -- plan B: . -- convert "$f" "${THIS_DIR}converted/${f%.*}.jpg";

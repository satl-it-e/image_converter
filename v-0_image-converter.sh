#!/bin/bash

ID_LEN=${1:-8}
INIT_ID=${2:-0}
THIS_DIR=${3:-$PWD}

echo ${THIS_DIR}

# Make sure CURR_DIR ends with slash
if [ "${THIS_DIR: -1}" != "/" ]; then THIS_DIR="${THIS_DIR}/"; fi

# Error checking.
if [ ! -d ${THIS_DIR} ]; then
  echo "Given path is not valid directory. Please check."
  exit 1;
fi

if [ $ID_LEN -gt 50 -o $ID_LEN -eq 0 ]; then
  echo "Given id-length is not supported. Please use numbers in range [1, 50]."
  exit 1;
fi

echo dir: ${THIS_DIR}

cd ${THIS_DIR}
for f in *; do
    echo $f;
    [ -f "$f" ] || continue
    if file "$f" |grep -qE 'image|bitmap'; then
      # convert "$f" "${THIS_DIR}converted/${f%.*}.jpg";
      convert "$f" "${f%.*}.jpg";
    fi
done



# echo ${ID_LEN}

# echo --${CURR_DIR}--
# echo ${CURR_DIR:7}

# CURR_DIR=${1:'/home/anastasiia/CS_UCU/'}
#
# cd ${CURR_DIR}
# ls

# for f in $(ls -R)
#   do
#     echo "${f}"
# done

# function_recursive_ls () {
#   if [ $( ls -d */ |  wc -l) -eq 0 ]; then
#     cd ..
#   else
#     for sub_dir in $(ls -d */)
#       do
#         function_recursive_ls ${sub_dir}
#     done
#   fi
# }
#
# function_recursive_ls ${CURR_DIR}

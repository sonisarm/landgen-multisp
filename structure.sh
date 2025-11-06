#!/bin/bash

K=$1
REP=$2

NAME="CteydisTF"
OUTNAME="${NAME}_K${K}_${REP}"

echo "Running: K=${K} REP=${REP} -> ${OUTNAME}"

structure -K "${K}" \
          -o "${OUTNAME}" \
          -i "${NAME}" \
          -m mainparams.txt \
          -e extraparams.txt

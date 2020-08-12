#!/bin/bash

Q=$(dirname "$(readlink -f "$0")")

# echo compiling $Q

ELEMENTS_DIR=$Q $Q/ codemusic

# ../codemusic/compile.sh



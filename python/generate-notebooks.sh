#!/bin/bash

# Copyright 2022 Ankur Sinha
# Author: Ankur Sinha <sanjay DOT ankur AT gmail DOT com> 
# File : 
#

if ! command -v p2j > /dev/null
then
    echo "p2j not found. Please install it from pypi"
else
    echo "Generate notebooks from Python source files using p2j"
    find . -name "*.py" -execdir p2j '{}' -o \;
fi

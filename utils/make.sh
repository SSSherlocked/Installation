#! /bin/bash

# Use all CPU cores to compile
function makeit() {
    local target="$1"
    local flag=1
    if [ -z "${target}" ]; then
        flag=0
    fi

    if [ "$(uname)" == 'Darwin' ]; then
        if [ $flag -eq 0 ]; then
            make -j $(sysctl -n hw.ncpu)
        else
            make -j $(sysctl -n hw.ncpu) "$target"
        fi
    else
        if [ $flag -eq 0 ]; then
            make -j $(nproc)
        else
            make -j $(nproc) "$target"
        fi
    fi
}

makeit "$1"
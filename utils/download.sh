#！/bin/bash

function check() {
    if [ $? -ne 0 ]; then
        echo ">> Installation failed!"
        exit
    fi
}

# Auto download required packages
function download() {
    local download_url=$1
    local pack_name=$2
    local type=$3
    mkdir -p packages
    if [ ! -f ${pack_name}${type} ];then
        wget ${download_url}${type} -O ${pack_name}${type}
        check
    else
        echo "File ${pack_name}${type} already exist!"
    fi
}

download $1 $2 $3
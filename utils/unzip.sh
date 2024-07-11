#！/bin/bash

function check() {
    if [ $? -ne 0 ]; then
        echo ">> Installation failed!"
        exit
    fi
}

# Unzip
function unzip() {
    local pack_name=$1
    local unzip_dir=$2
    local type=$3
    mkdir -p ${unzip_dir}
    tar -zxvf ${pack_name}${type} -C ${unzip_dir}
    check
}

unzip $1 $2 $3
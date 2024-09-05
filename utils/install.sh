#！/bin/bash

function check() {
    if [ $? -ne 0 ]; then
        echo ">> Installation failed!"
        exit
    fi
}

# Auto download required packages
function install() {
    local unzip_dir=$1
    local install_dir=$2
    local install_flag=$3
    cd "${unzip_dir}" || ! echo -e "\e[31m>> Fail to enter ${unzip_dir}!\e[0m" || exit

    if [ "$(uname)" == 'Darwin' ]; then
        alias makeit="make -j $(sysctl -n hw.ncpu)"
    else
        alias makeit="make -j $(nproc)"
    fi

    echo ">> Configuring ..."
    ./configure --prefix="${install_dir}" ${install_flag}
    check

    echo ">> Compiling ..."
    makeit
    check

    echo ">> Installing ..."
    makeit install
    check

    unalias makeit
}

install $1 $2 $3
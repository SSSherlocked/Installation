#！/bin/bash

function check() {
    if [ $? -ne 0 ]; then
        echo ">> Installation failed!"
        exit
    fi
}

# Use all CPU cores to compile
function makeit() {
    local target=$1
    if [ "$(uname)" == 'Darwin' ]; then
        make -j $(sysctl -n hw.ncpu) "$target"
    else
        make -j $(nproc) "$target"
    fi
}

# Auto download required packages
function install() {
    local unzip_dir=$1
    local install_dir=$2
    local install_flag=$3
    cd "${unzip_dir}" || ! echo -e "\e[31m>> Fail to enter ${unzip_dir}!\e[0m" || exit

    echo ">> Configuring ..."
    ./configure --prefix="${install_dir}" ${install_flag}
    check

    echo ">> Compiling ..."
    makeit
    check

    echo ">> Installing ..."
    makeit install
    check
}

install $1 $2 $3
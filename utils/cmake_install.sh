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

    mkdir -p build
    cd build || ! echo -e "\e[31m>> Fail to enter build!\e[0m" || exit

    echo ">> Configuring ..."
    cmake .. -DCMAKE_INSTALL_PREFIX="${install_dir}" ${install_flag}
    check

    echo ">> Compiling and installing ..."
    if [ "$(uname)" == 'Darwin' ]; then
        cmake --build . --target install -j $(sysctl -n hw.ncpu)
    else
        cmake --build . --target install -j $(nproc)
    fi
    check
}

install $1 $2 $3
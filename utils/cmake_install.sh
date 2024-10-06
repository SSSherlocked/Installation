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
    local build_dir="${unzip_dir}/build"

    echo ">> CMake configuring ..."
    cmake -S ${unzip_dir} \
          -B ${build_dir} \
          -DCMAKE_INSTALL_PREFIX="${install_dir}" \
          ${install_flag}
    check

    echo ">> Compiling and installing ..."
    if [ "$(uname)" == 'Darwin' ]; then
        cmake --build ${build_dir} --target install -j $(sysctl -n hw.ncpu)
    else
        cmake --build ${build_dir} --target install -j $(nproc)
    fi
    check
}

install $1 $2 $3
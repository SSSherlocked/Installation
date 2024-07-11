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
    cd ${unzip_dir}
    check
    echo ">> Configuring ..."
    ./configure --prefix=${install_dir} ${install_flag}
    check
    echo ">> Compiling ..."
    make
    check
    echo ">> Installing ..."
    make install
    check
}

install $1 $2 $3
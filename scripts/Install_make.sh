#！/bin/bash

function settings() {
    software="make"
    software_download_url="https://ftp.gnu.org/gnu/make/"
    software_version="make-4.4.1"

    home_dir=$(pwd)
    package_dir="${home_dir}/packages"
    tmp_dir="/opt/tmp/${software}"
    install_dir="/opt/${software}/${software_version}"

    ## profile in MacOS
    # profile_name="~/.zshrc"
}

function check() {
    if [ $? -ne 0 ]; then
        echo -e "\e[31m>> Installation failed. \e[0m"
        exit
    fi
}

# Auto download required packages
function download() {
    local pack_dir=$1
    local pack_name=$2
    local download_url=$3
    mkdir -p packages
    if [ ! -f ${pack_dir}/${pack_name}.tar.gz ];then
        wget -P ${pack_dir} ${download_url}${pack_name}.tar.gz
        check
        else
            echo "File ${pack_name}.tar.gz already exist!"
    fi
}

# Unzip
function unzip() {
    local pack_dir=$1
    local pack_name=$2
    local unzip_dir=$3
    mkdir -p ${unzip_dir}
    tar -zxvf ${pack_dir}/${pack_name}.tar.gz -C ${unzip_dir}
    check
}

# Install
function install() {
    local unzip_dir=$1
    cd ${unzip_dir}
    check
    echo -e "\e[32m>> Configuring ... \e[0m"
    ./configure --prefix=${install_dir}
    check
    echo -e "\e[32m>> Compiling ... \e[0m"
    make
    check
    echo -e "\e[32m>> Installing ... \e[0m"
    make install
    check
}

# Set environment variables
function set_env() {
    echo -e "\e[32m>> Setting environment variables ... \e[0m"
    echo "# GNU make Path" >> ${profile_name}
    echo "export PATH=\"${install_dir}/bin:\$PATH\"" >> ${profile_name}
    source ${profile_name}
    check
}

settings
download    ${package_dir} ${software_version} ${software_download_url}
unzip       ${package_dir} ${software_version} ${tmp_dir}
install     ${tmp_dir}/${software_version}
#set_env
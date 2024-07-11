#！/bin/bash

function settings() {
    software="hypre"
    software_download_url="https://github.com/hypre-space/hypre/archive/refs/tags/v2.31.0"
    software_version="hypre-2.31.0"

    MPI_DIR="/opt/openmpi/openmpi-5.0.3"
    MPI_INCLUDE_DIR="${MPI_DIR}/include"
    MPI_LIB_DIR="${MPI_DIR}/lib"
    MPI_LIB="mpi mpi_cxx mpifort"

    your_home_dir=$(cd && pwd)
    home_dir=$(pwd)
    package_dir="${home_dir}/packages"
    tmp_dir="${your_home_dir}/opt/tmp/${software}"
    install_dir="${your_home_dir}/opt/${software}/${software_version}"
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
        ## modified download link
        wget -P ${pack_dir} ${download_url}.tar.gz -O ${pack_dir}/${pack_name}.tar.gz
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

# Compile
function install() {
    local unzip_dir=$1
    cd ${unzip_dir} && cd src
    check
    echo -e "\e[32m>> Configuring ... \e[0m"
    ./configure --prefix=${install_dir}                 \
                --with-MPI-include=${MPI_INCLUDE_DIR}   \
                --with-MPI-libs=${MPI_LIB}              \
                --with-MPI-lib-dirs=${MPI_LIB_DIR}
    check
    echo -e "\e[32m>> Compiling ... \e[0m"
    make
    check
    echo -e "\e[32m>> Installing ... \e[0m"
    make install
    check
}

settings
download    ${package_dir}      ${software_version}     ${software_download_url}
unzip       ${package_dir}      ${software_version}     ${tmp_dir}
install     ${tmp_dir}/${software_version}
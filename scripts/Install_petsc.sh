#！/bin/bash

function settings() {
    software="petsc"
    software_download_url="https://web.cels.anl.gov/projects/petsc/download/release-snapshots/"
    software_version="petsc-3.21.3"

    ## To enable blaslapack, using '--download-fblaslapack=' when Fortran compiler is present,
    fblaslapack_url="https://bitbucket.org/petsc/pkg-fblaslapack/get/v3.4.2-p3"
    fblaslapack_name="fblaslapack-3.4.2-p3"
    ## or using '--download-f2cblaslapack' when configuring without a Fortran compiler
    f2cblaslapack_url="https://web.cels.anl.gov/projects/petsc/download/externalpackages/"
    f2cblaslapack_name="f2cblaslapack-3.8.0.q2"

    hypre_url="https://github.com/hypre-space/hypre/archive/refs/tags/v2.31.0"
    hypre_name="hypre-2.31.0"

    mpi_support=1

    home_dir=$(pwd)
    package_dir="${home_dir}/packages"
    tmp_dir="/opt/tmp/${software}"
    install_dir="/opt/${software}/${software_version}"

#    profile_name=/etc/profile
}

function check() {
    if [ $? -ne 0 ]; then
        echo -e "\e[31m>> Installation failed. \e[0m"
        exit
    fi
}

function set_compiler() {
    system_type=$(uname)
    local mpi_support=$1
    if [[ ${system_type} == 'Linux' ]]; then
        if [ ${mpi_support} -eq 1 ]; then
            cc_compiler=mpicc
            cxx_compiler=mpicxx
            f_compiler=mpifort
            mpi_flag=""
        else
            cc_compiler=gcc
            cxx_compiler=g++
            f_compiler=gfortran
            mpi_flag="--with-mpi=0"
        fi
        arch='arch-linux-c-debug'
    elif [[ ${system_type} == 'Darwin' ]]; then
        if [ ${mpi_support} -eq 1 ]; then
            cc_compiler=mpicc
            cxx_compiler=mpicxx
            f_compiler=mpifort
            mpi_flag=""
        else
            cc_compiler=clang
            cxx_compiler=clang++
            f_compiler=gfortran
            mpi_flag="--with-mpi=0"
        fi
        arch='arch-darwin-c-debug'
    elif shopt -s nocasematch && [[ ${system_type} =~ ^cygwin.* ]]; then
        if [ ${mpi_support} -eq 1 ]; then
            cc_compiler=mpicc
            cxx_compiler=mpicxx
            f_compiler=mpifort
            mpi_flag=""
        else
            cc_compiler=gcc
            cxx_compiler=g++
            f_compiler=gfortran
            mpi_flag="--with-mpi=0"
        fi
        arch='arch-mswin-c-debug'
    else
        echo -e "\e[31m>> Cannot specify the system type! \e[0m"
        exit
    fi
    echo "PETSC_ARCH: ${arch}"
}

# Auto download required packages
function download() {
    local pack_dir=$1
    local pack_name=$2
    local download_url=$3
    mkdir -p packages
    if [ ! -f ${pack_dir}/${pack_name}.tar.gz ];then
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

# Install
function install() {
    local pack_dir=$1
    local unzip_dir=$2
    cd ${unzip_dir}
    check
    echo -e "\e[32m>> Configuring ... \e[0m"

    ./configure --prefix=${install_dir}     \
                --with-cc=${cc_compiler}    \
                --with-cxx=${cxx_compiler}  \
                --with-fc=${f_compiler}     \
                --download-hypre=${pack_dir}/${hypre_name}.tar.gz               \
                --download-fblaslapack=${pack_dir}/${fblaslapack_name}.tar.gz   \
                COPTFLAGS='-O2' CXXOPTFLAGS='-O2' FOPTFLAGS='-O2'               \
                ${mpi_flag}

    check
    echo -e "\e[32m>> Compiling ... \e[0m"
    make PETSC_DIR=${unzip_dir}     PETSC_ARCH=${arch}  all
    check
    echo -e "\e[32m>> Installing ... \e[0m"
    make PETSC_DIR=${unzip_dir}     PETSC_ARCH=${arch}  install
    check
    echo -e "\e[32m>> Testing ... \e[0m"
    make PETSC_DIR=${install_dir}   PETSC_ARCH=""       check
    check
}

# Set environment variables
function set_env() {
    echo -e "\e[32m>> Setting environment variables ... \e[0m"
    echo "export PETSC_DIR=${install_dir}" >> ${profile_name}
    echo "export PETSC_ARCH=${arch}" >> ${profile_name}
    echo "export LD_LIBRARY_PATH=${install_dir}/lib:\$LD_LIBRARY_PATH" >> ${profile_name}
    echo "export LIBRARY_PATH=${install_dir}/lib:\$LIBRARY_PATH" >> ${profile_name}
    echo "export CPATH=${install_dir}/include:\$CPATH" >> ${profile_name}
    source ${profile_name}
}

settings
set_compiler    ${mpi_support}
download        ${package_dir}      ${software_version}             ${software_download_url}${software_version}
download        ${package_dir}      ${fblaslapack_name}             ${fblaslapack_url}
#download        ${package_dir}      ${f2cblaslapack_name}           ${f2cblaslapack_url}${f2cblaslapack_name}
download        ${package_dir}      ${hypre_name}                   ${hypre_url}
unzip           ${package_dir}      ${software_version}             ${tmp_dir}
install         ${package_dir}      ${tmp_dir}/${software_version}
#set_env
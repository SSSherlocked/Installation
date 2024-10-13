#！/bin/bash
export script_path="$(cd $(dirname $0);pwd)/utils"


software="petsc"
software_download_url="https://web.cels.anl.gov/projects/petsc/download/release-snapshots"
software_version="petsc-3.21.4"

## To enable blaslapack, using '--download-fblaslapack=' when Fortran compiler is present,
fblaslapack_url="https://bitbucket.org/petsc/pkg-fblaslapack/get/v3.4.2-p3"
fblaslapack_name="fblaslapack-3.4.2-p3"
## or using '--download-f2cblaslapack' when configuring without a Fortran compiler
f2cblaslapack_url="https://web.cels.anl.gov/projects/petsc/download/externalpackages"
f2cblaslapack_name="f2cblaslapack-3.8.0.q2"

## hypre
hypre_url="https://codeload.github.com/hypre-space/hypre/tar.gz/refs/tags/v2.31.0"
hypre_name="hypre-2.31.0"

download_mpi_type="mpich"
## mpich
mpich_url="https://www.mpich.org/static/downloads/4.2.2"
mpich_name="mpich-4.2.2"
## openmpi
openmpi_url="https://download.open-mpi.org/release/open-mpi/v5.0"
openmpi_name="openmpi-5.0.5"


function check() {
    if [ $? -ne 0 ]; then
        echo ">> Installation failed."
        exit
    fi
}

# Use all CPU cores to compile
function makeit() {
    local target="$1"
    source "${script_path}/make.sh" "$target"
}

function set_compiler() {
    local pack_dir="$1"

    local mpi_exist_flag=1
    command -v mpicc    > /dev/null 2>&1 || { mpi_exist_flag=0; }
    command -v mpicxx   > /dev/null 2>&1 || { mpi_exist_flag=0; }
    command -v mpifort  > /dev/null 2>&1 || { mpi_exist_flag=0; }
    if [[ ${mpi_exist_flag} -ne 0 ]]; then
        cc_compiler=mpicc
        cxx_compiler=mpicxx
        f_compiler=mpifort
        mpi_flag=""
    else
        local gcc_exist_flag=1
        command -v gcc      > /dev/null 2>&1 || { gcc_exist_flag=0; }
        command -v g++      > /dev/null 2>&1 || { gcc_exist_flag=0; }
        command -v gfortran > /dev/null 2>&1 || { gcc_exist_flag=0; }
        if [[ ${gcc_exist_flag} -ne 0 ]]; then
            cc_compiler=gcc
            cxx_compiler=g++
            f_compiler=gfortran
            if [[ ${download_mpi_type} == 'mpich' ]]; then
                mpi_flag="--download-mpich=${pack_dir}/${mpich_name}.tar.gz"
            elif [[ ${download_mpi_type} == 'openmpi' ]]; then
                mpi_flag="--download-openmpi=${pack_dir}/${openmpi_name}.tar.gz"
            else
                echo ">> Cannot specify the MPI type!"
                exit
            fi
        else
            echo ">> Cannot specify the compiler!"
            echo ">> Please install the compiler first (gcc or mpi)."
            exit 1
        fi
    fi

    system_type=$(uname)
    if [[ ${system_type} == 'Linux' ]]; then
        arch='arch-linux-c-debug'
    elif [[ ${system_type} == 'Darwin' ]]; then
        arch='arch-darwin-c-debug'
    else
        echo ">> Cannot specify the system type!"
        exit
    fi
    echo "PETSC_ARCH: ${arch}"
}

# Install
function install() {
    local pack_dir="$1"
    local unzip_dir="$2"
    cd "${unzip_dir}" || exit
    check
    echo ">> Configuring ..."

    ## avoid potential errors related to environment variable settings
    PETSC_DIR=${unzip_dir}
    echo "PETSC_DIR: ${PETSC_DIR}"
    echo "C       compiler: ${cc_compiler}"
    echo "C++     compiler: ${cxx_compiler}"
    echo "Fortran compiler: ${f_compiler}"

    ./configure --prefix="${install_dir}"     \
                --with-cc=${cc_compiler}    \
                --with-cxx=${cxx_compiler}  \
                --with-fc=${f_compiler}     \
                --download-fblaslapack="${pack_dir}/${fblaslapack_name}.tar.gz"   \
                --download-hypre="${pack_dir}/${hypre_name}.tar.gz"               \
                "${mpi_flag}"

    check
    echo ">> Compiling ..."
    makeit "PETSC_DIR=${unzip_dir}     PETSC_ARCH=${arch}   all"
    check
    echo ">> Installing ..."
    makeit "PETSC_DIR=${unzip_dir}     PETSC_ARCH=${arch}   install"
    check
    echo ">> Testing ..."
    makeit "PETSC_DIR=${install_dir}   PETSC_ARCH=""        check"
    check
}


source "${script_path}/DirSetting.sh"   "${software}" \
                                        "${software_version}"
set_compiler                            "${package_dir}"
source "${script_path}/Download.sh"     "${software_download_url}/${software_version}" \
                                        "${package_dir}/${software_version}" \
                                        ".tar.gz"
source "${script_path}/Download.sh"     "${fblaslapack_url}" \
                                        "${package_dir}/${fblaslapack_name}" \
                                        ".tar.gz"
source "${script_path}/Download.sh"     "${hypre_url}/${hypre_name}" \
                                        "${package_dir}/${hypre_name}" \
                                        ".tar.gz"
source "${script_path}/Download.sh"     "${mpich_url}/${mpich_name}" \
                                        "${package_dir}/${mpich_name}" \
                                        ".tar.gz"
source "${script_path}/Download.sh"     "${openmpi_url}/${openmpi_name}" \
                                        "${package_dir}/${openmpi_name}" \
                                        ".tar.gz"
source "${script_path}/Unzip.sh"        "${package_dir}/${software_version}" \
                                        "${tmp_dir}" \
                                        ".tar.gz"
install                                 "${package_dir}" \
                                        "${tmp_dir}/${software_version}"

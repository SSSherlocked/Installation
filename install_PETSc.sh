#！/bin/bash
export script_path="$(cd $(dirname $0);pwd)/utils"

## PETSc Official Download Server
PETSc_PackageDownload_URL="https://web.cels.anl.gov/projects/petsc/download"


## If you want to update PETSc version,
## please check the version of the dependency packages to make sure they are compatible.
## EDIPIC_2D are NOT compatible with PETSc 3.22.1 or later.
software="petsc"
software_download_url="${PETSc_PackageDownload_URL}/release-snapshots"
software_version="petsc-3.21.4"


## MPICH
mpich_flag=1
force_download_mpi_flag=1   # avoid intel oneAPI interruption
mpich_url="${PETSc_PackageDownload_URL}/externalpackages"
mpich_name="mpich-4.2.2"
mpi_dependency=""
## Additional download url for MPICH
## https://www.mpich.org/static/downloads/4.2.2/mpich-4.2.2.tar.gz (MPICH official website)

## OpenMPI
## >> Not used at the moment <<
openmpi_flag=0
openmpi_url="${PETSc_PackageDownload_URL}/externalpackages"
openmpi_name="openmpi-5.0.5"
## Additional download url for OpenMPI
## https://download.open-mpi.org/release/open-mpi/v5.0/openmpi-5.0.5.tar.gz (OpenMPI official website)


## BlasLapack
## To enable blaslapack, using '--download-fblaslapack=' when Fortran compiler is present,
## or using '--download-f2cblaslapack' when configuring without a Fortran compiler
## fBlasLapack
fblaslapack_flag=1
fblaslapack_url="https://bitbucket.org/petsc/pkg-fblaslapack/get/v3.4.2-p3"
fblaslapack_name="fblaslapack-3.4.2-p3"
fblaslapack_dependency=""


## f2cBlasLapack
## >> Not used at the moment <<
f2cblaslapack_flag=0
f2cblaslapack_url="${PETSc_PackageDownload_URL}/externalpackages"
f2cblaslapack_name="f2cblaslapack-3.8.0.q2"
f2cblaslapack_dependency=""


## hypre
hypre_flag=1
hypre_url="https://github.com/hypre-space/hypre/archive/refs/tags/v2.31.0"
hypre_name="hypre-2.31.0"
hypre_dependency=""
## Additional download url for hypre
## https://web.cels.anl.gov/projects/petsc/download/externalpackages/hypre-2.10.0b-p4.tar.gz (PETSc official website)


## HDF5
hdf5_flag=1
hdf5_url="${PETSc_PackageDownload_URL}/externalpackages"
hdf5_name="hdf5-1.14.3-p1"
hdf5_dependency=""
## Additional download url for HDF5
## https://hdf-wordpress-1.s3.amazonaws.com/wp-content/uploads/manual/HDF5/HDF5_1_14_3/src/hdf5-1.14.3.tar.gz (HDF5 official website)


## ScaLapack (required by MUMPS)
scalapack_flag=0
scalapack_url="https://github.com/Reference-ScaLAPACK/scalapack/archive/refs/tags/v2.2.0"
scalapack_name="scalapack-2.2.0"
scalapack_dependency=""
## Additional download url for ScaLapack
## https://web.cels.anl.gov/projects/petsc/download/externalpackages/scalapack-2.0.2.tgz (PETSc official website)


## MUMPS
mumps_flag=0
mumps_url="${PETSc_PackageDownload_URL}/externalpackages"
mumps_name="MUMPS_5.7.3"
mumps_dependency=""
## Additional download url for MUMPS
## https://github.com/scivision/mumps/archive/refs/tags/v5.7.3.1.tar.gz (Github)


## MeTis (required by ParMeTis)
## >> This package cannot be installed offline <<
## >> The --download-metis argument is required <<
metis_flag=0
metis_url="https://bitbucket.org/petsc"
metis_name="pkg-metis"
metis_dependency=""
## Additional download url for MeTis
## https://web.cels.anl.gov/projects/petsc/download/externalpackages/metis-5.1.0-p3.tar.gz (PETSc official website)
## https://bitbucket.org/petsc/pkg-metis.git (PETSc auto-download website)
## https://github.com/KarypisLab/METIS.git (Github)


## ParMeTis
## >> This package cannot be installed offline <<
## >> The --download-parmetis argument is required <<
parmetis_flag=0
parmetis_url="https://bitbucket.org/petsc"
parmetis_name="pkg-parmetis"
parmetis_dependency=""
## Additional download url for ParMeTis
## https://web.cels.anl.gov/projects/petsc/download/externalpackages/parmetis-4.0.3-p3.tar.gz (PETSc official website)
## https://bitbucket.org/petsc/pkg-parmetis.git (PETSc auto-download website)
## https://github.com/KarypisLab/ParMETIS.git (Github)


function check() {
    if [ $? -ne 0 ]; then
        echo ">> Installation failed."
        exit
    fi
}

## check compiler existence
function set_compiler() {
    local pack_dir="$1"

    local mpi_exist_flag
    if [[ ${force_download_mpi_flag} -eq 1 ]]; then
        mpi_exist_flag=0
    else
        mpi_exist_flag=1
    fi
    command -v mpicc    > /dev/null 2>&1 || { mpi_exist_flag=0; }
    command -v mpicxx   > /dev/null 2>&1 || { mpi_exist_flag=0; }
    command -v mpifort  > /dev/null 2>&1 || { mpi_exist_flag=0; }
    if [[ ${mpi_exist_flag} -ne 0 ]]; then
        cc_compiler=mpicc
        cxx_compiler=mpicxx
        f_compiler=mpifort
    else
        local gcc_exist_flag=1
        command -v gcc      > /dev/null 2>&1 || { gcc_exist_flag=0; }
        command -v g++      > /dev/null 2>&1 || { gcc_exist_flag=0; }
        command -v gfortran > /dev/null 2>&1 || { gcc_exist_flag=0; }
        if [[ ${gcc_exist_flag} -ne 0 ]]; then
            cc_compiler=gcc
            cxx_compiler=g++
            f_compiler=gfortran
            mpi_dependency="--download-mpich=${pack_dir}/${mpich_name}.tar.gz"
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

## dependency check
function check_dependency() {
    local pack_dir="$1"

    if [ ${fblaslapack_flag} -ne 0 ]; then
        fblaslapack_dependency="--download-fblaslapack=${pack_dir}/${fblaslapack_name}.tar.gz"
    fi

    if [ ${f2cblaslapack_flag} -ne 0 ]; then
        f2cblaslapack_dependency="--download-f2cblaslapack=${pack_dir}/${f2cblaslapack_name}.tar.gz"
    fi

    if [ ${hypre_flag} -ne 0 ]; then
        hypre_dependency="--download-hypre=${pack_dir}/${hypre_name}.tar.gz"
    fi

    if [ ${hdf5_flag} -ne 0 ]; then
        hdf5_dependency="--download-hdf5=${pack_dir}/${hdf5_name}.tar.bz2"
    fi

    if [ ${scalapack_flag} -ne 0 ]; then
        scalapack_dependency="--download-scalapack=${pack_dir}/${scalapack_name}.tar.gz"
    fi

    if [ ${mumps_flag} -ne 0 ]; then
        mumps_dependency="--download-mumps=${pack_dir}/${mumps_name}.tar.gz"
    fi

    if [ ${metis_flag} -ne 0 ]; then
#        metis_dependency="--download-metis=${pack_dir}/${metis_name}.tar.gz"
#        metis_dependency="--with-packages-build-dir=${pack_dir}/${metis_name}"
        metis_dependency="--download-metis"
    fi

    if [ ${parmetis_flag} -ne 0 ]; then
#        parmetis_dependency="--download-parmetis=${pack_dir}/${parmetis_name}.tar.gz"
#        metis_dependency="--with-packages-build-dir=${pack_dir}/${metis_name}"
        parmetis_dependency="--download-parmetis"
    fi
}

## Install
function install() {
    local pack_dir="$1"
    local unzip_dir="$2"
    cd "${unzip_dir}" || ! echo -e "Fail to enter ${unzip_dir}!" || exit
    echo ">> Configuring ..."

    ## avoid potential errors related to environment variable settings
    PETSC_DIR=${unzip_dir}
    echo "PETSC_DIR: ${PETSC_DIR}"
    echo "C       compiler: ${cc_compiler}"
    echo "C++     compiler: ${cxx_compiler}"
    echo "Fortran compiler: ${f_compiler}"

    ./configure --prefix="${install_dir}"   \
                --with-cc=${cc_compiler}    \
                --with-cxx=${cxx_compiler}  \
                --with-fc=${f_compiler}     \
                "${fblaslapack_dependency}" \
                "${hypre_dependency}"       \
                "${hdf5_dependency}"        \
                "${scalapack_dependency}"   \
                "${mumps_dependency}"       \
                "${metis_dependency}"       \
                "${parmetis_dependency}"    \
                "${mpi_dependency}"

    check
    echo ">> Compiling ..."
    make    PETSC_DIR=${unzip_dir}     PETSC_ARCH=${arch}   all
    check
    echo ">> Installing ..."
    make    PETSC_DIR=${unzip_dir}     PETSC_ARCH=${arch}   install
    check
    echo ">> Testing ..."
    make    PETSC_DIR=${install_dir}   PETSC_ARCH=""        check
    check
}


source "${script_path}/DirSetting.sh"   "${software}" \
                                        "${software_version}"
set_compiler                            "${package_dir}"

## download petsc
source "${script_path}/Download.sh"     "${software_download_url}/${software_version}" \
                                        "${package_dir}/${software_version}" \
                                        ".tar.gz"
## download mpich
source "${script_path}/Download.sh"     "${mpich_url}/${mpich_name}" \
                                        "${package_dir}/${mpich_name}" \
                                        ".tar.gz" \
                                        "${mpich_flag}"
## download openmpi
source "${script_path}/Download.sh"     "${openmpi_url}/${openmpi_name}" \
                                        "${package_dir}/${openmpi_name}" \
                                        ".tar.gz" \
                                        "${openmpi_flag}"
## download fblaslapack
source "${script_path}/Download.sh"     "${fblaslapack_url}" \
                                        "${package_dir}/${fblaslapack_name}" \
                                        ".tar.gz" \
                                        "${fblaslapack_flag}"
## download f2cblaslapack
source "${script_path}/Download.sh"     "${f2cblaslapack_url}/${f2cblaslapack_name}" \
                                        "${package_dir}/${f2cblaslapack_name}" \
                                        ".tar.gz" \
                                        "${f2cblaslapack_flag}"
## download hypre
source "${script_path}/Download.sh"     "${hypre_url}" \
                                        "${package_dir}/${hypre_name}" \
                                        ".tar.gz" \
                                        "${hypre_flag}"
## download hdf5
source "${script_path}/Download.sh"     "${hdf5_url}/${hdf5_name}" \
                                        "${package_dir}/${hdf5_name}" \
                                        ".tar.bz2" \
                                        "${hdf5_flag}"
## download scalapack
source "${script_path}/Download.sh"     "${scalapack_url}" \
                                        "${package_dir}/${scalapack_name}" \
                                        ".tar.gz" \
                                        "${scalapack_flag}"
## download mumps
source "${script_path}/Download.sh"     "${mumps_url}/${mumps_name}" \
                                        "${package_dir}/${mumps_name}" \
                                        ".tar.gz" \
                                        "${mumps_flag}"
## download metis
source "${script_path}/GitClone.sh"     "${metis_url}/${metis_name}" \
                                        "${package_dir}/${metis_name}" \
                                        0 #"${metis_flag}"
## download parmetis
source "${script_path}/GitClone.sh"     "${parmetis_url}/${parmetis_name}" \
                                        "${package_dir}/${parmetis_name}" \
                                        0 #"${parmetis_flag}"

check_dependency                        "${package_dir}"
source "${script_path}/Unzip.sh"        "${package_dir}/${software_version}" \
                                        "${tmp_dir}" \
                                        ".tar.gz"
install                                 "${package_dir}" \
                                        "${tmp_dir}/${software_version}"

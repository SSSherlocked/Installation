#！/bin/bash

software="hypre"
software_download_url="https://github.com/hypre-space/hypre/archive/refs/tags/v2.31.0"
software_version="hypre-2.31.0"

MPI_DIR="/opt/openmpi/openmpi-5.0.3"
MPI_INCLUDE_DIR="${MPI_DIR}/include"
MPI_LIB_DIR="${MPI_DIR}/lib"
MPI_LIB="mpi mpi_cxx mpifort"

script_path="$(dirname "$(pwd)")/utils"

source ${script_path}/setting.sh    "" ""
source ${script_path}/download.sh   ${software_download_url}/${software_version} \
                                    ${package_dir}/${software_version} \
                                    ".tar.gz"
source ${script_path}/unzip.sh      ${package_dir}/${software_version} \
                                    ${tmp_dir} \
                                    ".tar.gz"
source ${script_path}/install.sh    ${tmp_dir}/${software_version} \
                                    ${install_dir}
                                    "--with-MPI-include=${MPI_INCLUDE_DIR} \
                                     --with-MPI-libs=${MPI_LIB}            \
                                     --with-MPI-lib-dirs=${MPI_LIB_DIR}"
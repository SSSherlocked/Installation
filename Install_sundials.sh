#！/bin/bash
export script_path="$(cd $(dirname $0);pwd)/utils"


software="sundials"
software_download_url="https://github.com/LLNL/sundials/releases/download/v7.1.1"
software_version="sundials-7.1.1"


install_flags="-D BUILD_FORTRAN_MODULE_INTERFACE=ON \
               -D EXAMPLES_ENABLE_C=ON \
               -D EXAMPLES_ENABLE_CXX=ON \
               -D ENABLE_CUDA=OFF \
               -D ENABLE_GINKGO=OFF \
               -D ENABLE_HIP=OFF \
               -D ENABLE_HYPRE=OFF \
               -D ENABLE_KLU=OFF \
               -D ENABLE_KOKKOS=OFF \
               -D ENABLE_KOKKOS_KERNELS=OFF \
               -D ENABLE_LAPACK=OFF \
               -D ENABLE_MAGMA=OFF \
               -D ENABLE_MPI=ON \
               -D ENABLE_ONEMKL=OFF \
               -D ENABLE_OPENMP=OFF \
               -D ENABLE_OPENMP_DEVICE=OFF \
               -D ENABLE_PETSC=OFF \
               -D ENABLE_PTHREAD=OFF \
               -D ENABLE_RAJA=OFF \
               -D ENABLE_SUPERLUDIST=OFF \
               -D ENABLE_SUPERLUMT=OFF \
               -D ENABLE_SYCL=OFF \
               -D ENABLE_TRILINOS=OFF \
               -D ENABLE_XBRAID=OFF"


source "${script_path}/DirSetting.sh"       "${software}" \
                                            "${software_version}"
source "${script_path}/Download.sh"         "${software_download_url}/${software_version}" \
                                            "${package_dir}/${software_version}" \
                                            ".tar.gz"
source "${script_path}/Unzip.sh"            "${package_dir}/${software_version}" \
                                            "${tmp_dir}" \
                                            ".tar.gz"
source "${script_path}/CMakeInstall.sh"     "${tmp_dir}/${software_version}" \
                                            "${install_dir}" \
                                            "${install_flags}"
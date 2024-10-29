#！/bin/bash
export script_path="$(cd $(dirname $0);pwd)/utils"


software="sundials"
software_download_url="https://github.com/LLNL/sundials/releases/download/v7.1.1"
software_version="sundials-7.1.1"


install_flags="-D ENABLE_MPI=ON \
               -D BUILD_FORTRAN_MODULE_INTERFACE=ON \
               -D EXAMPLES_ENABLE_C=ON \
               -D EXAMPLES_ENABLE_CXX=ON"


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
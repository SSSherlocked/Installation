#！/bin/bash
export script_path="$(cd $(dirname $0);pwd)/utils"


software="openmpi"
software_download_url="https://download.open-mpi.org/release/open-mpi/v5.0"
software_version="openmpi-5.0.3"


source "${script_path}/DirSetting.sh"       "${software}" \
                                            "${software_version}"
source "${script_path}/check_comp.sh"       "gcc" "g++" "gfortran"
source "${script_path}/Download.sh"         "${software_download_url}/${software_version}" \
                                            "${package_dir}/${software_version}" \
                                            ".tar.gz"
source "${script_path}/Unzip.sh"            "${package_dir}/${software_version}" \
                                            "${tmp_dir}" \
                                            ".tar.gz"
source "${script_path}/ConfigInstall.sh"    "${tmp_dir}/${software_version}" \
                                            "${install_dir}"
source "${script_path}/SetEnvVar.sh"        "${install_dir}" \
                                            "${software}"
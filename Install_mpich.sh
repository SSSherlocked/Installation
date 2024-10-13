#！/bin/bash
export script_path="$(cd $(dirname $0);pwd)/utils"


software="mpich"
software_download_url="https://www.mpich.org/static/downloads/4.2.2"
software_version="mpich-4.2.2"


install_flag="FFLAGS=-fallow-argument-mismatch \
              FCFLAGS=-fallow-argument-mismatch"


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
                                            "${install_dir}"  \
                                            "${install_flag}"
source "${script_path}/SetEnvVar.sh"        "${install_dir}" \
                                            "${software}"
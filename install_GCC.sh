#！/bin/bash
export script_path="$(cd $(dirname $0);pwd)/utils"


software="gcc"
software_download_url="https://ftp.gnu.org/gnu/gcc/gcc-14.2.0"
software_version="gcc-14.2.0"


source "${script_path}/DirSetting.sh"       "${software}" \
                                            "${software_version}"
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
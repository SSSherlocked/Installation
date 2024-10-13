#！/bin/bash
export script_path="$(cd $(dirname $0);pwd)/utils"


software="cmake"
software_download_url="https://cmake.org/files/v3.26"
software_version="cmake-3.26.6"


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

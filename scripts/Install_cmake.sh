#！/bin/bash

software="cmake"
software_download_url="https://cmake.org/files/v3.26"
software_version="cmake-3.26.6"

script_path="$(dirname "$(pwd)")/utils"

source ${script_path}/setting.sh    "$1" "$2"
source ${script_path}/download.sh   ${software_download_url}/${software_version} \
                                    ${package_dir}/${software_version} \
                                    ".tar.gz"
source ${script_path}/unzip.sh      ${package_dir}/${software_version} \
                                    ${tmp_dir} \
                                    ".tar.gz"
source ${script_path}/install.sh    ${tmp_dir}/${software_version} \
                                    ${install_dir}
source ${script_path}/variable.sh   ${profile_name} \
                                    ${install_dir}  \
                                    ${software}

#！/bin/bash

software="make"
software_download_url="https://ftp.gnu.org/gnu/make"
software_version="make-4.4.1"

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
source ${script_path}/variable.sh   ${profile_name} \
                                    ${install_dir}  \
                                    ${software}
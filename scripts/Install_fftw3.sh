#！/bin/bash

software="fftw3"
software_download_url="http://fftw.org"
software_version="fftw-3.3.10"

script_path="$(dirname "$(pwd)")/utils"

source ${script_path}/setting.sh    "" ""
source ${script_path}/download.sh   ${software_download_url}/${software_version} \
                                    ${package_dir}/${software_version} \
                                    ".tar.gz"
source ${script_path}/unzip.sh      ${package_dir}/${software_version} \
                                    ${tmp_dir} \
                                    ".tar.gz"
source ${script_path}/install.sh    ${tmp_dir}/${software_version} \
                                    ${install_dir} \
                                    ""
source ${script_path}/install.sh    ${tmp_dir}/${software_version} \
                                    ${install_dir} \
                                    "--enable-float"
source ${script_path}/install.sh    ${tmp_dir}/${software_version} \
                                    ${install_dir} \
                                    "--enable-long-double"

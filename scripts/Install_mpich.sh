#！/bin/bash

software="mpich"
software_download_url="https://www.mpich.org/static/downloads/4.2.1"
software_version="mpich-4.2.1"


script_path="$(dirname "$(pwd)")/utils"


source ${script_path}/setting.sh    ${software} ${software_version}
source ${script_path}/download.sh   ${software_download_url}/${software_version} \
                                    ${package_dir}/${software_version} \
                                    ".tar.gz"
source ${script_path}/unzip.sh      ${package_dir}/${software_version} \
                                    ${tmp_dir} \
                                    ".tar.gz"
source ${script_path}/install.sh    ${tmp_dir}/${software_version} \
                                    ${install_dir}  \
                                    "FFLAGS=-fallow-argument-mismatch \
                                     FCFLAGS=-fallow-argument-mismatch"
source ${script_path}/variable.sh   ${install_dir}  \
                                    ${software}
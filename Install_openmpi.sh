#！/bin/bash
export script_path="$(cd $(dirname $0);pwd)/utils"


software="openmpi"
software_download_url="https://download.open-mpi.org/release/open-mpi/v5.0"
software_version="openmpi-5.0.3"


source ${script_path}/setting.sh    ${software} \
                                    ${software_version}
source ${script_path}/check_comp.sh gcc g++ gfortran
source ${script_path}/download.sh   ${software_download_url}/${software_version} \
                                    ${package_dir}/${software_version} \
                                    ".tar.gz"
source ${script_path}/unzip.sh      ${package_dir}/${software_version} \
                                    ${tmp_dir} \
                                    ".tar.gz"
source ${script_path}/install.sh    ${tmp_dir}/${software_version} \
                                    ${install_dir}
source ${script_path}/variable.sh   ${install_dir}  \
                                    ${software}
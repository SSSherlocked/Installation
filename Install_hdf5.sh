#！/bin/bash
export script_path="$(cd $(dirname $0);pwd)/utils"


software="hdf5"
software_download_url="https://hdf-wordpress-1.s3.amazonaws.com/wp-content/uploads/manual/HDF5/HDF5_1_14_3/src"
software_version="hdf5-1.14.3"


source "${script_path}/setting.sh"      "${software}" \
                                        "${software_version}"
source "${script_path}/download.sh"     "${software_download_url}/${software_version}" \
                                        "${package_dir}/${software_version}" \
                                        ".tar.gz"
source "${script_path}/unzip.sh"        "${package_dir}/${software_version}" \
                                        "${tmp_dir}" \
                                        ".tar.gz"
source "${script_path}/install.sh"      "${tmp_dir}/${software_version}" \
                                        "${install_dir}"
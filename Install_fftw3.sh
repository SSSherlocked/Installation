#！/bin/bash
export script_path="$(cd $(dirname $0);pwd)/utils"


software="fftw3"
software_download_url="http://fftw.org"
software_version="fftw-3.3.10"

# To avoid the error:
# "relocation R_X86_64_32 against `.rodata' can not be used when making a shared object; recompile with -fPIC"
# we need to add the flag below to the CMakeLists.txt file at line 312 (valid for version 3.3.10).
function insert_compile_flag() {
    local unzip_dir=$1
    local target="${unzip_dir}/CMakeLists.txt"
    sed -i "312 i set_target_properties(${fftw3_lib} PROPERTIES POSITION_INDEPENDENT_CODE ON)" ${target}
}


source "${script_path}/setting.sh"          "${software}" \
                                            "${software_version}"
source "${script_path}/download.sh"         "${software_download_url}/${software_version}" \
                                            "${package_dir}/${software_version}" \
                                            ".tar.gz"
source "${script_path}/unzip.sh"            "${package_dir}/${software_version}" \
                                            "${tmp_dir}" \
                                            ".tar.gz"
insert_compile_flag                         "${tmp_dir}/${software_version}"
source "${script_path}/cmake_install.sh"    "${tmp_dir}/${software_version}" \
                                            "${install_dir}" \
                                            ""
source "${script_path}/cmake_install.sh"    "${tmp_dir}/${software_version}" \
                                            "${install_dir}" \
                                            "-D ENABLE_FLOAT=ON"
source "${script_path}/cmake_install.sh"    "${tmp_dir}/${software_version}" \
                                            "${install_dir}" \
                                            "-D ENABLE_LONG_DOUBLE=ON"


#source ${script_path}/install.sh            ${tmp_dir}/${software_version} \
#                                            ${install_dir} \
#                                            "--enable-mpi"
#source ${script_path}/install.sh            ${tmp_dir}/${software_version} \
#                                            ${install_dir} \
#                                            "--enable-float \
#                                            --enable-mpi"
#source ${script_path}/install.sh            ${tmp_dir}/${software_version} \
#                                            ${install_dir} \
#                                            "--enable-long-double \
#                                            --enable-mpi"

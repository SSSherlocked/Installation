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

## Optional flags
## BUILD_SHARED_LIBS                ON/OFF
## BUILD_TESTS                      ON/OFF
## CMAKE_BUILD_TYPE                 Debug/Release
## CMAKE_INSTALL_PREFIX             /prefix/path
## DISABLE_FORTRAN                  ON/OFF
## ENABLE_AVX                       ON/OFF
## ENABLE_AVX2                      ON/OFF
## ENABLE_FLOAT                     ON/OFF
## ENABLE_LONG_DOUBLE               ON/OFF
## ENABLE_OPENMP                    ON/OFF
## ENABLE_QUAD_PRECISION            ON/OFF
## ENABLE_SSE                       ON/OFF
## ENABLE_SSE2                      ON/OFF
## ENABLE_THREADS                   ON/OFF
## LIBM_LIBRARY                     /libm/path
## WITH_COMBINED_THREADS            ON/OFF

## Install static libraries
install_flag1="-D BUILD_SHARED_LIBS=OFF -D ENABLE_FLOAT=OFF  -D ENABLE_LONG_DOUBLE=OFF"
install_flag2="-D BUILD_SHARED_LIBS=OFF -D ENABLE_FLOAT=ON   -D ENABLE_LONG_DOUBLE=OFF"
install_flag3="-D BUILD_SHARED_LIBS=OFF -D ENABLE_FLOAT=OFF  -D ENABLE_LONG_DOUBLE=ON"

## Install shared libraries
install_flag11="-D BUILD_SHARED_LIBS=ON -D ENABLE_FLOAT=OFF  -D ENABLE_LONG_DOUBLE=OFF"
install_flag22="-D BUILD_SHARED_LIBS=ON -D ENABLE_FLOAT=ON   -D ENABLE_LONG_DOUBLE=OFF"
install_flag33="-D BUILD_SHARED_LIBS=ON -D ENABLE_FLOAT=OFF  -D ENABLE_LONG_DOUBLE=ON"


source "${script_path}/DirSetting.sh"       "${software}" \
                                            "${software_version}"
source "${script_path}/Download.sh"         "${software_download_url}/${software_version}" \
                                            "${package_dir}/${software_version}" \
                                            ".tar.gz"
source "${script_path}/Unzip.sh"            "${package_dir}/${software_version}" \
                                            "${tmp_dir}" \
                                            ".tar.gz"
insert_compile_flag                         "${tmp_dir}/${software_version}"
## Install static libraries
source "${script_path}/CMakeInstall.sh"     "${tmp_dir}/${software_version}" \
                                            "${install_dir}" \
                                            "${install_flag1}"
source "${script_path}/CMakeInstall.sh"     "${tmp_dir}/${software_version}" \
                                            "${install_dir}" \
                                            "${install_flag2}"
source "${script_path}/CMakeInstall.sh"     "${tmp_dir}/${software_version}" \
                                            "${install_dir}" \
                                            "${install_flag3}"
## Install shared libraries
source "${script_path}/CMakeInstall.sh"     "${tmp_dir}/${software_version}" \
                                            "${install_dir}" \
                                            "${install_flag11}"
source "${script_path}/CMakeInstall.sh"     "${tmp_dir}/${software_version}" \
                                            "${install_dir}" \
                                            "${install_flag22}"
source "${script_path}/CMakeInstall.sh"     "${tmp_dir}/${software_version}" \
                                            "${install_dir}" \
                                            "${install_flag33}"


#install_flag1=""
#install_flag2="--enable-float"
#install_flag3="--enable-long-double"
#
#
#source "${script_path}/DirSetting.sh"       "${software}" \
#                                            "${software_version}"
#source "${script_path}/Download.sh"         "${software_download_url}/${software_version}" \
#                                            "${package_dir}/${software_version}" \
#                                            ".tar.gz"
#source "${script_path}/Unzip.sh"            "${package_dir}/${software_version}" \
#                                            "${tmp_dir}" \
#                                            ".tar.gz"
#source "${script_path}/ConfigInstall.sh"    "${tmp_dir}/${software_version}" \
#                                            "${install_dir}" \
#                                            "${install_flag1}"
#source "${script_path}/ConfigInstall.sh"    "${tmp_dir}/${software_version}" \
#                                            "${install_dir}" \
#                                            "${install_flag2}"
#source "${script_path}/ConfigInstall.sh"    "${tmp_dir}/${software_version}" \
#                                            "${install_dir}" \
#                                            "${install_flag3}"
#source "${script_path}/SetEnvVar.sh"        "${install_dir}" \
#                                            "${software}"
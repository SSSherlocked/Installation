#！/bin/bash
export script_path="$(cd $(dirname $0);pwd)/utils"


software="miniforge3"
software_download_url="https://mirrors.tuna.tsinghua.edu.cn/github-release/conda-forge/miniforge/LatestRelease"
# software_version="Miniforge3-MacOSX-arm64"
software_version="Miniforge3-Linux-x86_64"


function check() {
    if [ $? -ne 0 ]; then
        echo ">> Installation failed!"
        exit
    fi
}

# Install
function install() {
    local pack_dir=$1
    local software_version=$2
    local install_dir=$3
    echo -e "\e[32m>> Installing ... \e[0m"
    bash "${pack_dir}/${software_version}.sh" -p "${install_dir}" -b -f
    check
}

# Initialize
function init() {
    echo -e "\e[32m>> Initializing ... \e[0m"
    "${install_dir}/bin/conda" init bash
    check
}

# Change the download source
function change_source() {
    local user
    user=$(whoami)
    if [ ${user} == "root" ]; then
        echo ">> Installing packages as root."
    else
        local conda_profile_name="${HOME}/.condarc"
        echo -e "\e[32m>> Changing source ... \e[0m"
        echo "channels:"                 >> "${conda_profile_name}"
        echo "  - defaults"              >> "${conda_profile_name}"
        echo "show_channel_urls: true"   >> "${conda_profile_name}"
        echo "default_channels:"         >> "${conda_profile_name}"
        echo "  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main"         >> "${conda_profile_name}"
        echo "  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r"            >> "${conda_profile_name}"
        echo "  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2"        >> "${conda_profile_name}"
        echo "custom_channels:"          >> "${conda_profile_name}"
        echo "  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud"  >> "${conda_profile_name}"
        echo "  msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud"        >> "${conda_profile_name}"
        echo "  bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud"     >> "${conda_profile_name}"
        echo "  menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud"        >> "${conda_profile_name}"
        echo "  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud"      >> "${conda_profile_name}"
        echo "  simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud"    >> "${conda_profile_name}"
    fi
    check
}

# Install packages
function install_packages() {
    echo -e "\e[32m>> Installing packages ... \e[0m"
    python Install_CondaPackages.py
}


source "${script_path}/DirSetting.sh"   "${software}" \
                                        "${software_version}"
source "${script_path}/Download.sh"     "${software_download_url}/${software_version}" \
                                        "${package_dir}/${software_version}" \
                                        ".sh"
install                                 "${package_dir}" \
                                        "${software_version}" \
                                        "${install_dir}"
source "${script_path}/SetEnvVar.sh"    "${install_dir}"  \
                                        "${software}"
change_source

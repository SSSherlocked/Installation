#！/bin/bash

software="miniforge3"
software_download_url="https://mirrors.tuna.tsinghua.edu.cn/github-release/conda-forge/miniforge/LatestRelease"
# software_version="Miniforge3-MacOSX-arm64"
software_version="Miniforge3-Linux-x86_64"


# Install
function install() {
    local pack_dir=$1
    local software_version=$2
    local install_dir=$3
    echo -e "\e[32m>> Installing ... \e[0m"
    bash ${pack_dir}/${software_version}.sh -p ${install_dir} -b -f
}

# Initialize
function init() {
    echo -e "\e[32m>> Initializing ... \e[0m"
    ${install_dir}/bin/conda init bash
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
        echo \
        "channels:
          - defaults
        show_channel_urls: true
        default_channels:
          - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
          - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
          - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
        custom_channels:
          conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
          msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
          bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
          menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
          pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
          simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud" \
        >> ${conda_profile_name}
    fi
}

# Install packages
function install_packages() {
    echo -e "\e[32m>> Installing packages ... \e[0m"
    python Install_CondaPackages.py
}


script_path="$(cd $(dirname $0);pwd)/utils"
source ${script_path}/setting.sh    ${software} ${software_version} ${script_path}
source ${script_path}/download.sh   ${software_download_url}/${software_version} \
                                    ${package_dir}/${software_version} \
                                    ".sh"
install ${package_dir} ${software_version} ${install_dir}
source ${script_path}/variable.sh   ${install_dir}  \
                                    ${software}
change_source
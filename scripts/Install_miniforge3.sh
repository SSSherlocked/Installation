#！/bin/bash

function settings() {
    software="miniforge3"
    software_download_url="https://mirrors.tuna.tsinghua.edu.cn/github-release/conda-forge/miniforge/LatestRelease/"
    software_version="Miniforge3-MacOSX-arm64.sh"
    # software_version="Miniforge3-Linux-x86_64.sh"

    your_home_dir=$(cd && pwd)
    home_dir=$(pwd)
    package_dir="${home_dir}/packages"
    install_dir="${your_home_dir}/opt/${software}"

    ## only available for non-root users
    # profile_name="${your_home_dir}/.zshrc"
    profile_name="${your_home_dir}/.bashrc"
    conda_profile_name="${your_home_dir}/.condarc"
}

function check() {
    if [ $? -ne 0 ]; then
        echo -e "\e[31m>> Installation failed. \e[0m"
        exit
    fi
}

# Auto download required packages
function download() {
    local pack_dir=$1
    local software_version=$2
    local download_url=$3
    mkdir -p packages
    if [ ! -f ${pack_dir}/${software_version} ];then
        wget -P ${pack_dir} ${download_url}${software_version}
        check
        else
            echo "File ${software_version} already exist!"
    fi
}

# Install
function install() {
    local pack_dir=$1
    local software_version=$2
    local install_dir=$3
    echo -e "\e[32m>> Installing ... \e[0m"
    bash ${pack_dir}/${software_version} -p ${install_dir} -b -f
    check
}

# Initialize
function init() {
    echo -e "\e[32m>> Initializing ... \e[0m"
    ${install_dir}/bin/conda init bash
    check
}

# Set environment variables
function set_env() {
    echo -e "\e[32m>> Setting environment variables ... \e[0m"
    echo "export PATH=${install_dir}/bin:\$PATH" >> ${profile_name}
    source ${profile_name}
    check
}

# Change the download source
function change_source() {
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
    check
}

# Install packages
function install_packages() {
    echo -e "\e[32m>> Installing packages ... \e[0m"
    python Install_CondaPackages.py
    check
}

settings
download    ${package_dir} ${software_version} ${software_download_url}
install     ${package_dir} ${software_version} ${install_dir}
#set_env
#change_source

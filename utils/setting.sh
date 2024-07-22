#! /bin/bash

function setting() {
    local user=$1
    local system=$2
    local your_home_dir
    local home_dir
    if [ ${user} == 'root' ]; then
        your_home_dir=""
        profile_name=""
    else
        your_home_dir=$(cd && pwd)
        if [ ${system} == 'macos' ]; then
            profile_name="${your_home_dir}/.zshrc"
        else
            profile_name="${your_home_dir}/.bashrc"
        fi
    fi
    home_dir=$(pwd)
    package_dir="${home_dir}/packages"
    tmp_dir="${your_home_dir}/opt/tmp/${software}"
    install_dir="${your_home_dir}/opt/${software}/${software_version}"
}

setting $1 $2

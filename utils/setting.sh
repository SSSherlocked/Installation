#! /bin/bash

function setting() {
    local software=$1
    local software_version=$2

    user=$(whoami)
    if [ "${user}" == 'root' ]; then
        echo ">> Running as root."
        tmp_dir="/opt/tmp/${software}"
        install_dir="/opt/${software}/${software_version}"
    else
        echo ">> Installing for ${user}."
        tmp_dir="${HOME}/opt/tmp/${software}"
        install_dir="${HOME}/opt/${software}/${software_version}"
    fi
    package_dir="$(pwd)/packages"
}

setting $1 $2

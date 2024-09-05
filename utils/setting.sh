#! /bin/bash

function setting() {
    local software=$1
    local software_version=$2
    local pack_path

    user=$(whoami)
    if [ "${user}" == 'root' ]; then
        echo ">> Running as root."
        export tmp_dir="/opt/tmp/${software}"
        export install_dir="/opt/${software}/${software_version}"
    else
        echo ">> Installing for ${user}."
        export tmp_dir="${HOME}/opt/tmp/${software}"
        export install_dir="${HOME}/opt/${software}/${software_version}"
    fi
    pack_path = $(dirname $(pwd))
    export package_dir="${pack_path}/packages"
}

setting $1 $2

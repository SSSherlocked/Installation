#！/bin/bash

# Set environment variables
function set_env() {
    local install_dir=$1
    local software=$2

    if [ "$(uname)" == 'Darwin' ]; then
        echo ">> Installing for MacOS."
        profile_name="${HOME}/.zshrc"
    elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
        echo ">> Installing for Linux."
        profile_name="${HOME}/.bashrc"
    else
        echo ">> Your system is not supported, installation failed."
        exit 1
    fi

    user=$(whoami)
    local profile_name
    if [ "${user}" == 'root' ]; then
        echo ">> Running as root, skip setting environment variables."
    elif [ -n "${profile_name}" ]; then
        echo ">> Setting environment variables ..."
        echo "## ${software} Path" >> "${profile_name}"
        echo "export PATH=\"${install_dir}/bin:\$PATH\"" >> "${profile_name}"
        source "${profile_name}"
    fi
}

set_env $1 $2
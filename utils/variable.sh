#！/bin/bash

# Set environment variables
function set_env() {
    local install_dir="$1"
    local software="$2"

    user=$(whoami)
    if [ "${user}" == 'root' ]; then
        echo ">> Running as root, skip setting environment variables."
    else
        if [ "$(uname)" == 'Darwin' ]; then
            profile_name="${HOME}/.zshrc"
        elif [ "$(uname)" == 'Linux' ]; then
            profile_name="${HOME}/.bashrc"
        else
            echo ">> Your system is not supported, installation failed."
            exit 1
        fi
        echo ">> Setting environment variables ..."
        echo "## ${software}_Path" >> "${profile_name}"
        echo "export PATH=\"${install_dir}/bin:\$PATH\"" >> "${profile_name}"
        source "${profile_name}"
    fi
}

set_env "$1" "$2"
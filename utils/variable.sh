#！/bin/bash

# Set environment variables
function set_env() {
    local profile_name=$1
    local install_dir=$2
    local pack_name=$3
    echo ">> Setting environment variables ..."
    echo "## ${pack_name} Path" >> "${profile_name}"
    echo "export PATH=\"${install_dir}/bin:\$PATH\"" >> "${profile_name}"
    source "${profile_name}"
}

set_env $1 $2 $3
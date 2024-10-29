#！/bin/bash

# Auto download required packages
function download() {
    local download_url="$1"
    local pack_name="$2"
    local type="$3"
    local flag="${4:-1}"  # Default flag to 1 if not provided
    mkdir -p packages
    if [ "${flag}" -ne 0 ]; then
        if [ ! -f "${pack_name}${type}" ]; then
            wget "${download_url}${type}" -O "${pack_name}${type}"
            if [ $? -ne 0 ]; then
                echo ">> Installation failed!"
                rm -rf "${pack_name}${type}"
                exit
            fi
        else
            echo "File ${pack_name}${type} already exist!"
        fi
    else
        echo "Download process for ${pack_name} is skipped."
    fi
}

download "$1" "$2" "$3" "$4"
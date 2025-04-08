#！/bin/bash

# Auto download required packages
function gitclone() {
    local download_url="$1"
    local pack_name="$2"
    local flag="${3:-1}"  # Default flag to 1 if not provided
    mkdir -p packages
    if [ "${flag}" -ne 0 ]; then
        if [ ! -d "${pack_name}" ]; then
            git clone "${download_url}.git" "${pack_name}"
            if [ $? -ne 0 ]; then
                echo ">> Installation failed!"
                rm -rf "${pack_name}"
                exit
            fi
        else
            echo "Folder ${pack_name} already exist. Download process skipped."
        fi
    else
        echo "Download process for ${pack_name} is skipped."
    fi
}

gitclone "$1" "$2" "$3"
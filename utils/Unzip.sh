#！/bin/bash

function check() {
    if [ $? -ne 0 ]; then
        echo ">> Installation failed!"
        exit
    fi
}

# Unzip
function unzip() {
    local pack_name="$1"
    local unzip_dir="$2"
    local type="$3"
    mkdir -p "${unzip_dir}"
    tar -zxf "${pack_name}${type}" -C "${unzip_dir}" --skip-old-files
    check
}

unzip "$1" "$2" "$3"
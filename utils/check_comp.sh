#！/bin/bash

## Check the compiler
## export compiler_exist_flag
function check_compiler() {
    local compiler_cc="$1"
    local compiler_cxx="$2"
    local compiler_f="$3"

    local cc_exist_flag=1
    local cxx_exist_flag=1
    local f_exist_flag=1
    command -v "${compiler_cc}"   > /dev/null 2>&1 || { cc_exist_flag=0;  }
    command -v "${compiler_cxx}"  > /dev/null 2>&1 || { cxx_exist_flag=0; }
    command -v "${compiler_f}"    > /dev/null 2>&1 || { f_exist_flag=0;   }
    if [[ ${cc_exist_flag} -eq 0 ]]; then
        echo ">> Cannot specify the compiler!"
        echo ">> Please install the compiler first (${compiler_cc})."
        exit 1
    fi
    if [[ ${cxx_exist_flag} -eq 0 ]]; then
        echo ">> Cannot specify the compiler!"
        echo ">> Please install the compiler first (${compiler_cxx})."
        exit 1
    fi
    if [[ ${f_exist_flag} -eq 0 ]]; then
        echo ">> Cannot specify the compiler!"
        echo ">> Please install the compiler first (${compiler_f})."
        exit 1
    fi
    if [[ ${cc_exist_flag} -ne 0 && ${cxx_exist_flag} -ne 0 && ${f_exist_flag} -ne 0 ]]; then
        echo ">> Compiler: ${compiler_cc}, ${compiler_cxx}, ${compiler_f}"
        export compiler_exist_flag=1
    fi
}

check_compiler "$1" "$2" "$3"
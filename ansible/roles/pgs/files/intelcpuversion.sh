#!/bin/bash

CPU_MODEL=$(lscpu | grep 'Intel(R)')

if [[ ${CPU_MODEL} =~ [iI][3579]-([0-9]{4,5}) ]]; then
    NUM=${BASH_REMATCH[1]}
    if [ ${#NUM} -eq 4 ]; then
        GEN=${NUM:0:1}
    elif [ ${#NUM} -eq 5 ]; then
        GEN=${NUM:0:2}
    fi
    echo "${GEN}"
elif [[ $CPU_MODEL =~ [Uu]ltra[[:space:]]+[3579][[:space:]]+1([0-9]{2}) ]]; then
    echo "14"
fi

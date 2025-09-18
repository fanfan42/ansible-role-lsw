#!/bin/bash

CPU_MODEL=$(lscpu | grep -oP 'Intel\(R\).*')

if [[ $CPU_MODEL =~ [iI][3579]-([6-9][0-9]{3}|10[0-9]{3}) ]]; then
    echo "10"
elif [[ $CPU_MODEL =~ [iI][3579]-11[0-9]{3} ]]; then
    echo "11"
else
    echo "12"
fi

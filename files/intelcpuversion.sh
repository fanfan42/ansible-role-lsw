#!/bin/bash

# On récupère le modèle de processeur
CPU_MODEL=$(lscpu | grep -oP 'Intel\(R\).*')

if [[ $CPU_MODEL =~ [iI][3579]-(6[0-9]{3}|[7-9][0-9]{3}|1[0]{4}) ]]; then
    NUM=${BASH_REMATCH[1]}
    GEN=${NUM:0:1}  # On prend le premier chiffre, qui est le numéro de génération
    echo "$GEN"  # Affiche la génération

elif [[ $CPU_MODEL =~ [iI][3579]-11[0-9]{3,4} ]]; then
    echo "11"  # Affiche la génération 11
else
    echo "12"
fi

#!/bin/bash
# Script: enviars3.sh
# Funcao: A partir de um aws cli configurado faz o envio do arquivo para o bucket
# Uso: enviars3.sh <-p nome_profile/-na> path/para/arquivo bucket/path/remoto

AWS=$(which aws)

validaArquivo(){
    if [ ! -f $1 ]
    then
        echo "Path do arquivo local informado é invalido"
        exit 1
    fi
}
existeBucket(){
    if [ $# -eq 1 ]
    then
        aws s3api head-bucket --bucket $1
    elif [ $# -eq 2 ]
    then
        aws --profile $2 s3api head-bucket --bucket $1
    fi
}

case "$1" in
    -h | --help)
        echo " Uso:
        enviars3.sh <-p nome_profile|-na> path/para/arquivo bucket/path/remoto
        -p nomedoprofile - Usa o profile do aws cli como em aws --profile nomedoprofile
        -na - Não apaga o arquivo local "
        exit 0
    ;;

    -na)
        if [  $# -ne 3 ]
            then
                echo "Não foi passada as opcoes todas as opcoes, ver -h"
                exit 1
        fi
        echo "teste na"
        echo "arquivo local $2 "
        echo "arquivoremovo $3 "
        exit 0
    ;;

    -p)
        if [  $# -ne 4 ]
            then
                echo "Não foi passada as opcoes todas as opcoes, ver -h"
                exit 1
        fi
        validaArquivo $1
        bucket=${}
        echo "nome do profile $2"
        echo "arquivo local $3 "
        echo "arquivoremovo $4 "
        exit 0
    ;;

    *)
        echo "arquivo local $1 "
        echo "arquivoremovo $2 "
        exit 0
    ;;

esac


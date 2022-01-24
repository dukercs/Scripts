#!/bin/env bash
# Função: Trocar o papel de parede aleatoriamente a cada ciclo (use anacron) sem repetir o anterior, necessário o DWALL - https://github.com/adi1090x/dynamic-wallpaper
# Autor: Rodolpho Costa Stach - dukercs(at)gmail(dot)com
# V. 0.9-Beta

# Mude aqui se e somente se seu diretório de imagens do DWALL for diferente do diretório padrão
DIRWALL=/usr/share/dynamic-wallpaper/images/


# Lista o conteudo do diretorio default do WALL em um array
itens=( $(ls ${DIRWALL-/usr/share/dynamic-wallpaper/images/}) )
#Pega o tamanho do array
tamanho=${#itens[@]}

# Gera um indice aleatorio para o array e guarda qual é o wall a ser utilizado
geraIndice(){
    indice=$(($RANDOM % $tamanho))
    WALL=${itens[$indice]}
}


geraIndice


# Criar e substituir o conteudo do arquivo guarda qual o wall estamos usando
if [ -f ${HOME-~}/.DWALL ]
then
    cp ${HOME-~}/.DWALL ${HOME-~}/.DWALL.lw
fi


if [ -f ${HOME-~}/.DWALL.lw ]
then
    lastw=$(cat ${HOME-~}/.DWALL.lw)
    while [[ $WALL == $lastw ]]
    do
        geraIndice
        sleep 1
    done
    echo $WALL > ${HOME-~}/.DWALL
fi




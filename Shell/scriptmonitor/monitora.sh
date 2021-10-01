#!/bin/bash
# Função: Monitorar retorno do site e reiniciar o wildfly caso tenha parado
# Autor:  Rodolpho Costa Stach
# 1.0 Usa while, if e curl para testar o site e se o site retornou http_code = 200
 
#Busca se tem a ferramenta cURL para acessar o site se não tiver sai com erro
if ! which curl > /dev/null
then
    echo Curl não encontrado instale-o antes de usar
    exit 2
fi
 
#localizacao do cURL
cURL=$(which curl)

# timeout do curl
ctempo=3

#id do grupo telegram
id= #GRUPO TELEGRAM

# quebra de linha
NL="
"
# token do bot
TOKEN= #TOKEN DO BOT DO TELEGRAM


function enviaTelegram(){
	$cURL --silent -X POST --data-urlencode "chat_id=${id}" --data-urlencode "text=${1}${NL}${NL}${2}" "https://api.telegram.org/bot${TOKEN}/sendMessage?disable_web_page_preview=true&parse_mode=html" | grep -q '"ok":true'

}


# site para monitorar
site=$1 
 
# iniciar contadores
teste=1
erro=0
 
while [ $teste -le 5 ] 
do
    retorno=$($cURL -m $ctempo -s -o /dev/null -w "%{http_code}" $site)
    datahora=$(date +%d-%m-%Y_%T)
    if [ $retorno -ne 200 ] 
    then
        let erro++
    fi
    if [ $erro -gt 3 ]
    then
        # echo ERRO FORA
        # echo reiniciando aguarde 
	enviaTelegram "ERRO AO ACESSAR" "ERRO AO ACESSAR SITE: $site ${NL}DATA: $datahora "
        exit 2
        fi
    let teste++
done

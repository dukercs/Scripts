#!/bin/bash
# Função: Monitorar retorno do site e reiniciar o wildfly caso tenha parado
# Autor:  Rodolpho Costa Stach
# 1.0 Usa curl para pentelhar a página de voucher da aws....
# Só ajustar ae o ID do grupo e o token do bot ambos do telegram...

#id do grupo telegram
id=-000000001

# token do bot
TOKEN="0000000000:AAAAAAAA_BBBBBBBB5BBBBBB4BBBB3BBB21"




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

# quebra de linha
NL="
"

function enviaTelegram(){
	$cURL --silent -X POST --data-urlencode "chat_id=${id}" --data-urlencode "text=${1}${NL}${NL}${2}" "https://api.telegram.org/bot${TOKEN}/sendMessage?disable_web_page_preview=true&parse_mode=html" | grep -q '"ok":true'

}


retorno=$(curl -s https://pages.awscloud.com/LATAM-launch-STR-aws-certification-disc-br-cp-2022-interest.html | egrep -i "esgotado|indispon" |wc -l) 

if [ $retorno -lt 1 ]
then
	enviaTelegram "LIBERADO AWS" "CORRE LA ${NL} https://pages.awscloud.com/LATAM-launch-STR-aws-certification-disc-br-cp-2022-interest.html"
fi

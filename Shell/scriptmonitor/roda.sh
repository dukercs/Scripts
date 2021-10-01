#!/bin/bash

id= #GRUPO TELEGRAM
TOKEN= #BOT TELEGRAM
NL="
"
ARQUIVOSITES=/opt/scriptmonitor/sites.txt

SCRIPTMONITORA=/opt/scriptmonitor/monitora.sh


if [ ! -f $ARQUIVOSITES ]
then
	echo Erro! Arquivo com sites não encontrado
	curl --silent -X POST --data-urlencode "chat_id=${id}" --data-urlencode "text=FALTA ARQUIVO${NL}${NL}Arquivo com sites para monitorar não encontrado!" "https://api.telegram.org/bot${TOKEN}/sendMessage?disable_web_page_preview=true&parse_mode=html" | grep -q '"ok":true'
	exit 2
fi



while read site 
do

	bash -x $SCRIPTMONITORA $site

done < $ARQUIVOSITES


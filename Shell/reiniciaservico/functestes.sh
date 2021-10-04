#!/bin/bash
# Arquivo de funcoes do script exec.sh


# Impede de ser executado
if [ "$0" == functestes.sh ]
then
	echo Rode o arquivo exec.sh
	exit 10
fi


# Esta funcao verifica o espaco usado no disco passado e alerta se o espaço usado for maior ou igual ao valor fixado
function espacoLivre(){

df -PTH $1 |egrep $1|awk '{ print $6 " " $7 }' | while read output;
do
  usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
  partition=$(echo $output | awk '{ print $2 }' )
  if [ $usep -gt 98 ]; then
	exit 3

  fi
done

}

# Esta funcao faz o start ou stop da aplicacao e verifica com o service $2 status o processo está rodando ou não e alerta se demorar mais de 60 ciclos com 1 segundo de sleep
# Update fiz mudanca do pgrep versao anterior para service status pois o serviço wildfly roda com processo java pgrep não pegou.
# Aqui com a variavel de ambiente $? pego a saida do status e coloco em outra variavel para testar (não era obrigatório mas achei mais legível).
# Variaveis eatualstart e eatualstop 
# 	Se a eatualstart for diferente de 0 quer dizer que o serviço ainda não iniciou aguarde e some a tempo.
#   Se a eatualstop for igual a zero quer dizer que o serviço ainda não parou, aguarde e soma o tempo.
function servicostatus(){
local SERV=$(which service)

${SERV:=/usr/sbin/service} $2 $1
tempo=1
while [ $tempo -gt 0 ] && [ $tempo -le 60 ]
do
	if [ "$1" == "start" ] 
	then
		${SERV:=/usr/sbin/service} $2 status > /dev/null 2>&1
		eatualstart=$?
		if [ $eatualstart -ne 0 ]
		then
			sleep 1 
			let tempo++
		else
			tempo=0
		fi
	else
		${SERV:=/usr/sbin/service} $2 status > /dev/null 2>&1
		eatualstop=$?
		if [ $eatualstop -eq 0 ] 
		then
			sleep 1 
			let tempo++
		else
			tempo=0
		fi

	fi

	if [ $tempo -ge 60 ]
	then
		exit 4
	fi
done
}

horariocomercial(){
semana=$(date '+%u')
hora=$(date '+%H')

if [ $semana -eq 6 ] || [ $semana -eq 7 ]
then
        echo 2
else
        if [ $hora -ge 18 ] || [ $hora -lt 9 ]
        then
                echo 3
        fi
fi
}


# funcao enviar mensagem telegram
# 
function enviaTelegram(){
	local NL="
"
	local sala=$3
	local bot=$4
	$cURL --silent -X POST --data-urlencode "chat_id=${id}" --data-urlencode "text=${1}${NL}${NL}${2}" "https://api.telegram.org/bot${TOKEN}/sendMessage?disable_web_page_preview=true&parse_mode=html" | grep -q '"ok":true'

}




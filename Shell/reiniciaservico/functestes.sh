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

#FIXME Pegar o processo pelo status pode não funcionar se a saida do status não tiver uma linha com a string pid 
pidantes=0
pidantes=$(${SERV:=/usr/sbin/service} $2 status |grep -i pid|grep -Pwo '[0-9]+\d+')

${SERV:=/usr/sbin/service} $2 $1
retornostartstop=$?
if [ $retornostartstop -ne 0 ]
then
	# echo 5
	return 5
fi




if [ $retornostartstop = 0 ] # Testo se o retorno do comando de start/stop foi sucesso 0 se não foi nem executo pois o return 5 já foi feito no if anterior
then
	tempo=1 # variavel em 1 para não sair do while onde o tempo tem que ser maior que 0 ou menor igual a 60 
	while [ $tempo -gt 0 ] && [ $tempo -le 60 ] 
	do
		if [ "$1" == "start" ] # testo se o pedido é para iniciar
		then
			${SERV:=/usr/sbin/service} $2 status > /dev/null 2>&1 
			eatualstart=$? # pego o retorno do status pra ver se está parado pois se estiver com erro ou parado ele retorna diferente de 0, sendo assim ainda não iniciou
			if [ $eatualstart -ne 0 ] # testo se é diferente de 0 se for aguardo 1 e acrescento o tempo pra timeout do start no while 
			then
				sleep 1 
				let tempo++
			else
				pidposstart=$(${SERV:=/usr/sbin/service} $2 status |grep -i pid|grep -Pwo '[0-9]+\d+') # pegando o processo após o start
				if [ -n $pidantes ] && [ -n $pidposstart ] # vendo se existem valores nas variaveis do pid antes e pid após o start $pidantes e $pidposstart 
				then
					if [ $pidantes -ne $pidposstart ] && [ -e /proc/$pidposstart ] # Testando se não são iguais e se o processo após start está em execucao se for ok tempo zera e pode sair do loop se não retorna 5
					then
						tempo=0
					else
						return 5
					fi
				elif [ -n $pidposstart ] && [ -e /proc/$pidposstart ] # Se a pidantes não tiver valor ainda preciso testar a pid após start $pidposstart tem e se está rodando se for verdadeiro zera o tempo e sai do loop se não for retorna 5
					then
					tempo=0
				else
					return 5
				fi
			fi
		else # aqui pego o stop ou qualquer outro valor #FIXME vou testar depois com case.
			${SERV:=/usr/sbin/service} $2 status > /dev/null 2>&1 # Vejo o estado atual
			eatualstop=$? #Guardo ele em uma variavel para o stop $eatualstop
			if [ $eatualstop -eq 0 ] # Testo se é 0 pois se for quer dizer que mandei parar e ainda não parou # ja foi testado o retorno do comando para parar
			then
				sleep 1 
				let tempo++
			else
				tempo=0
			fi
		fi
		# Timeout se o tempo chegar a maior que 60 ele faz o exit antes do próximo while 
		if [ $tempo -ge 60 ]
		then
			return 4
		fi
	done
fi
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




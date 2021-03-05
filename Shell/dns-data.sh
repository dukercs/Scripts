#!/bin/bash
# Script dnsvpn.sh
# Autor Rodolpho Costa Stach
# Funcao Reiniciar o serviço systemd-resolved pois não está atualizando na ordem correta o resolv.conf 
# Script a ser usado na pasta dispatcher.d do NetworkManager o NetworkManager envia 2 parametros o primeiro nome da conexão e o segundo é a ação
# Necessário que seja passado 1 parametro

if [ $UID -ne 0 ]
then
	echo -e Erro: \\nApenas usuário root
	exit 1
fi

 
# Variavel global
redeempresa=10.0

# Verificar se a conexão é a vpn ppp0
if [ "$1" = "ppp0" ]
then
# Inicia variavel para loop
	saida=0
# loop para ler o arquivo
	while [ $saida -eq 0 ] 
	do
# Vejo se é ao conectar (up)
		if echo $2 | grep up > /dev/null 2>&1
		then
		sleep 1
# Guarda a primeira ocorrencia iniciando por nameserver para testar
		nameserver=$(cat /etc/resolv.conf | grep -m1 ^nameserver|awk '{ print $NF }')
# Testa se o DNS é da rede da empresa se for muda para 1 a variável e sai do loop
			if echo $nameserver | grep $redeempresa > /dev/null 2>&1
			then
				saida=1
				exit 0
			fi
		else
			sleep 5
			saida=1
		fi
# Seguranca espera antes de reiniciar o serviço
	sleep 2
# Reinicia o servico	
	systemctl restart systemd-resolved.service > /tmp/dns-datash.log 2>&1
	done
fi

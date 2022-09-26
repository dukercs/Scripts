#!/bin/env bash
semana=$(date +%u)
hora=$(date +%H)
#COMANDOS ENTRE ASPAS DUPLAS E SEPARADOS POR ESPACO COLOQUE O CAMINHO COMPLETO OU UM QUE ESTEJA NO SEU PATH
comandos="/usr/bin/openfortigui /usr/bin/teams /usr/bin/microsoft-edge-stable"


if [ $semana -le 5 ]
then 
	if [ $hora -ge 8 -a $hora -le 19 ]
	then
	 for i in $comandos
	 do
		 $i &
	 done
	fi
fi

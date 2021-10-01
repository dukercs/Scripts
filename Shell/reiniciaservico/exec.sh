#!/bin/bash
# script para reiniciar servico e verificar se tem espaco em disco e se o servico iniciou ou parou corretamente emitindo alertas
# Autor: Rodolpho Costa Stach
# e-mail: rodolpho.stach@provider-it.com.br
# Codigos de erro: 
# 2 para usuario que não seja o root, 
# 3 para disco sem espaco
# 4 para problema ao iniciar ou parar
# 5 para arquivo de funcoes nao encontrado
# 6 servico nao existe


# Mensagem para caso tente executar em horário comercial

hrcomercial="Horario comercial faca a execucao manualmente"

# fonte de funcoes
if [ ! -f /opt/reiniciaservico/functestes.sh ]
then
	echo ERRO NAO ENCONTREI O ARQUIVO DE FUNCOES
	exit 5
fi

source /opt/reiniciaservico/functestes.sh


# Recebe o serviço a ser reiniciado por parametro posicionado na posicao 1
servico=$1




# Verifica se esta fora do horario comercial
retorno=$(horariocomercial)

if [ ${retorno:=0} -eq 0 ]
then 
	echo $hrcomercial
	exit 7
fi


# testa se servico existe
SERVT=$(which service)
${SERVT:=/usr/sbin/service} $servico status > /dev/null 2>&1

if [ $? -ne 0 ]
then
	echo Erro: O servico $servico nao existe
	exit 6
fi

# Apenas root pode rodar
if [ $UID -ne 0 ]
then
	echo apenas root
	exit 2
fi


# Valida se tem espaco livre no /dados

espacoLivre /dados
if [ $? -eq 3 ];
then
	exit $?
fi


# Valida se tem espaco livre na particao raíz /
espacoLivre /
if [ $? -eq 3 ];
then
	exit $?
fi

# Para o serviço com testes
servicostatus stop $servico

# Inicia o serviço com testes
servicostatus start $servico
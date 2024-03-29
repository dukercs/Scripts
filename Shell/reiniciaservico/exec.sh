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

# Diretorio de instalação do reinicia deve conter o functestes.sh
instaladir=/opt/reiniciaservico

# lista com os pontos de montagem a serem verificados ajuste de acordo com a sua necessidade, é uma lista separada por espaço simples.
pontom=(/ /home)

# Mensagem para caso tente executar em horário comercial
hrcomercial="Horario comercial faca a execucao manualmente"














################################## FAVOR NÃO ALTERAR ABAIXO DESTA LINHA  FAÇA-O SOMENTE SE SOUBER O QUE ESTÁ FAZENDO  ###############################################################


# Ajuste no path para rodar pelo cron 
# Busca pelo arquivo com a variavel PATH em /etc/environment e se a linha PATH tem o sbin se for verdadeiro carrega mas se não existir adiciona um PATH fixo ao atual
#FIXME o /etc/enviroment pode estar em outro local ou não conter o PATH que precisa para o script rodar.
#


if [ -e /etc/environment ]
then
	if grep -i PATH /etc/environment > /dev/null 2>&1 && grep -i sbin /etc/environment > /dev/null 2>&1
	then
        . /etc/environment
	fi
else
        export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"
fi






# fonte de funcoes
if [ ! -f ${instaladir}/functestes.sh ]
then
	echo ERRO NAO ENCONTREI O ARQUIVO DE FUNCOES
	exit 5
fi

source ${instaladir}/functestes.sh


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

if [ $? -gt 3 ]
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




# Valida o espaço livre na lista ${pontom[@]}
for m in "${pontom[@]}"
do
	espacoLivre ${m:=/}
	if [ $? -eq 3 ];
	then
		exit $?
	fi
done


# Valida se tem espaco livre na particao raíz /
espacoLivre /
if [ $? -eq 3 ];
then
	exit $?
fi

# Para o serviço com testes
servicostatus stop $servico
saidastop=$?
timeout=0
while [ $saidastop -ne 0 -o $timeout -eq 50 ]
do
	sleep 1
 	servicostatus stop $servico
 	saidastop=$?
 	let timeout++
done



# Inicia o serviço com testes
servicostatus start $servico
saidastart=$?
timeout=0
while [ $saidastart -ne 0 ] && [ $timeout -le 50 ]
do
	sleep 1
	servicostatus start $servico
	saidastart=$?
	let timeout++
done


if [ $timeout -gt 50 ]
then
	exit 4
fi

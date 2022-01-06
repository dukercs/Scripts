#!/bin/env sh
# Nome: saudevalida.sh
# Autor: Rodolpho Costa Stach
# email: dukercs(at)gmail.com
# Função: Aguardar um tempo antes de iniciar a checagem pois o start_period não impede o script de executar antes da aplicação iniciar.
# v1.0: Buscar os executáveis e aguardar o tempo antes de rodar funções, usando tempo na opção -n ou -c devido a posição das opções não ter achado como processar primeiro a opção -t


f_debug(){
    set -x
}
# Variáveis globais
cURL=$(which curl)
NC=$(which nc)
tsistema=$(expr $(date +%s) - $(stat -c %Y /proc/uptime))



f_curl(){
    site=${1:-http://127.0.0.1/}

    while test $tsistema -lt ${espera:-300}
    do
        tsistema=$(expr $(date +%s) - $(stat -c %Y /proc/uptime))
    done

    $cURL -m 15 -s -o /dev/null -L -w "%{http_code}" $site > /tmp/saudevalida.txt 2>&1
    if test $? -ne 0 
    then
        kill -9 -1
    fi
    return 0
}

f_netcat(){

    while test $tsistema -lt ${espera:-300}
    do
        tsistema=$(expr $(date +%s) - $(stat -c %Y /proc/uptime))
    done
        
    ip=${1:-127.0.0.1}
    porta=${2:-80}
    $NC -z $ip $porta
    if test $? -ne 0
    then
        kill -9 -1
    fi
    return 0
}





# Pega as opções valida e envia para as funções
while test -n "$1"
do
    case "$1" in
        -c)
        shift
        url=$1
        espera=$2
        
        if test -z "$url"
        then
            echo "Falta a URL para a opção -c"
            exit 1
        fi
        f_curl $url
        ;;
        -n)
        shift
        ipad=$1
        portacom=$2
        espera=$3
        if test -z "$ipad" -o -z "$portacom"
        then
            echo "Falta parâmetros ip e porta para opção -n"
            exit 1
        fi
        f_netcat $ipad $portacom
        ;;
        -t) echo $tsistema ;;
        -d) f_debug ;;
    esac
shift
done

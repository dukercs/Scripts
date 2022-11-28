#! /bin/sh

### BEGIN INIT INFO
# Provides:          promtail
# Required-Start:    $network 
# Required-Stop:    
# Should-Start:      
# Default-Start:     2 3 4 5
# Default-Stop:      
# Short-Description: Promtail servico
# Description:       Servico promtail para grafana-loki  
#                    
#                   
### END INIT INFO

# /opt/promtail/promtail-linux-amd64 -config.file /opt/promtail/config-promtail.yml
set -e
test $UID -eq 0 || echo "Apenas root!" && exit 1
test -z "$1" && echo Use $0 start, stop, restart

RNUM=$1
DAEMON=/opt/promtail/promtail-linux-amd64
CONFIG_FILE=/opt/promtail/config-promtail.yml
LOG=/var/log/prom.log
PIDFILE=/opt/promtail/run.pid

test -x $DAEMON || exit 2
test -f $CONFIG_FILE || exit 3

export PATH="${PATH:+$PATH:}/usr/sbin:/sbin"

star(){
    $DAEMON -config.file $CONFIG_FILE >> $LOG 2&>1
    echo $! > $PIDFILE
}

stop(){
    PIDNOW=$(cat $PIDFILE)
    echo Pedindo educadamente para que o processo seja encerrado
    kill -15 $PIDNOW
    if test -z $(pgrep $PIDNOW)
    then
        echo Matando os processos que não querem sair
        kill -9 $PIDNOW
    fi
}
case $RNUM in
         "start") star;;
         "stop") stop;;
         "restart") stop && start;;
         "*") echo Use $0 start, stop, restart;;
esac

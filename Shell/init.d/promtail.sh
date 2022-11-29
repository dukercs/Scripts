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

set -e
# /etc/init.d/promtail: Inicia, para e mostra status do promtail para Init.d

# Carregar LSB 
. /lib/lsb/init-functions

# Variaveis globais
T_TERM=30 #Tempo esperando para o processo encerrar educadamente, sempre menor que kill
T_KILL=60 #Tempo para matar o processo
RNUM=$1
DAEMON=/opt/promtail/promtail-linux-amd64 #binário do promtail
CONFIG_FILE=/opt/promtail/config-promtail.yml # arquivo de config 
LOG=/var/log/prom.log # log
PIDFILE=/var/run/promtail.pid #pid 

test -x $DAEMON || exit 2
test -f $CONFIG_FILE || exit 3


run_by_init() {
    ([ "$previous" ] && [ "$runlevel" ]) || [ "$runlevel" = S ]
}

check_dev_null() {
    if [ ! -c /dev/null ]; then
	if [ "$1" = log_end_msg ]; then
	    log_end_msg 1 || true
	fi
	if ! run_by_init; then
	    log_action_msg "/dev/null Não é um dispositivo de caracteres!" || true
	fi
	exit 1
    fi
}

export PATH="${PATH:+$PATH:}/usr/sbin:/sbin" >> $LOG 2>&1

# Usando funções LSB 
# log_daemon_msg para mensagens no log do sistema 
#  Ex.: log_daemon_msg "Starting GNOME Login Manager" "gdm"
# start-stop-daemon para controlar o serviço (start stop status)

case "$1" in
  start)
	check_dev_null # Ver se o /dev/null é um dispositivo de caracteres
	log_daemon_msg "Iniciando o promtail..." "promtail" || true # usando o log_daemon
	if start-stop-daemon --start --quiet --oknodo --make-pidfile --pidfile $PIDFILE --background --startas /bin/bash -- -c "exec $DAEMON -config.file $CONFIG_FILE >> $LOG 2>&1"; then
	    log_end_msg 0 || true
	else
	    log_end_msg 1 || true
	fi
	;;
  stop)
	log_daemon_msg "Parando o promtail" "promtail" || true
	if start-stop-daemon --stop --quiet --oknodo --retry TERM/$T_TERM/KILL/$T_KILL --pidfile $PIDFILE; then
	    log_end_msg 0 || true
	else
	    log_end_msg 1 || true
	fi
	;;

  reload|force-reload|restart)
	log_daemon_msg "Reiniciando o promtail" "promtail" || true
	start-stop-daemon --stop --quiet --oknodo --retry TERM/$T_TERM/KILL/$T_KILL --pidfile $PIDFILE
	check_dev_null log_end_msg
	if start-stop-daemon --start --quiet --oknodo --make-pidfile --pidfile $PIDFILE --background --startas /bin/bash -- -c "exec $DAEMON -config.file $CONFIG_FILE >> $LOG 2>&1"; then
	    log_end_msg 0 || true
	else
	    log_end_msg 1 || true
	fi
	;;

  status)
	status_of_proc -p $PIDFILE $DAEMON promtail && exit 0 || exit $?
	;;

  *)
	log_action_msg "Uso: /etc/init.d/$0 {start|stop|reload|force-reload|restart|try-restart|status}" || true
	exit 1
esac
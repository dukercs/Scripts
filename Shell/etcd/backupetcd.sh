#!/bin/bash
# Tirar backup do etcd com o etcdctl do pacote etcd-client

export ETCDCTL_CERT=/etc/kubernetes/pki/apiserver-etcd-client.crt
export ETCDCTL_KEY=/etc/kubernetes/pki/apiserver-etcd-client.key
export ETCDCTL_CACERT=/etc/kubernetes/pki/etcd/ca.crt 
export ETCDCTL_API=3

data=$(date +%d-%m-%Y_%H%M%S)
nomebackup=etcd-${data}.backup
dirbackup=/opt/etcdbackup/dados
membro=https://127.0.0.1:2379

echo Membros
etcdctl member list --endpoints=${membro}
echo Backup
etcdctl snapshot save ${dirbackup}/${nomebackup}

echo verificando backup
ETCDCTL_API=3 etcdctl --write-out=table snapshot status ${dirbackup}/${nomebackup}

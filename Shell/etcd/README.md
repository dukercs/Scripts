## Script simples que usei durante o treinamento descomplicando o k8s da LinuxTips para backup do meu ambiente local
<br />
### Linha do crontab usado em teste: Use de acordo com sua necessidade olhe a var PATH do(s) node(s) master(s) onde roda o etcd ajuste seu diretório pode brincar as variáveis de certificado e o member list peguei do manifesto kube-apiserver.yaml ta tudo abaixo
```console
echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin

cat /etc/kubernetes/manifests/kube-apiserver.yaml|egrep -i etcd
#Retorno do comando acima:
    - --etcd-cafile=/etc/kubernetes/pki/etcd/ca.crt  # Var ETCDCTL_CACERT no script
    - --etcd-certfile=/etc/kubernetes/pki/apiserver-etcd-client.crt #var ETCDCTL_CERT no script
    - --etcd-keyfile=/etc/kubernetes/pki/apiserver-etcd-client.key #var ETCDCTL_KEY no script
    - --etcd-servers=https://127.0.0.1:2379 # var membro no script

# Linha do meu crontab de teste
45 15 * * * PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin && /opt/etcdbackup/script/backupetcd.sh 2>&1 > /tmp/log.backupetcd.sh
```
